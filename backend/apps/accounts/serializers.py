from __future__ import annotations

import re

from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError as DjangoValidationError
from django.db.models import Avg
from rest_framework import serializers
from rest_framework_simplejwt.tokens import RefreshToken

from .models import KycRecord, UserProfile, Vehicle
from .storage_utils import StorageConfigurationError, resolve_supabase_asset_url
from .verification import (
    has_completed_personal_information,
    has_verified_government_identification,
    has_verified_vehicle_identification,
    is_fully_verified_user,
)
from apps.mobility.models import TravelMatch

User = get_user_model()
NIGERIAN_PLATE_NUMBER_PATTERN = re.compile(r"^[A-Z]{3}-\d{3}[A-Z]{2}$")


class UserSerializer(serializers.ModelSerializer):
    full_name = serializers.SerializerMethodField()
    avatar_url = serializers.SerializerMethodField()
    home_away_label = serializers.SerializerMethodField()
    rating_count = serializers.SerializerMethodField()
    average_rating = serializers.SerializerMethodField()
    completed_jobs = serializers.SerializerMethodField()
    linked_socials = serializers.SerializerMethodField()
    personal_information_completed = serializers.SerializerMethodField()
    government_identification_completed = serializers.SerializerMethodField()
    vehicle_identification_completed = serializers.SerializerMethodField()
    is_fully_verified = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            "id",
            "email",
            "first_name",
            "last_name",
            "full_name",
            "avatar_url",
            "phone_number",
            "account_type",
            "auth_provider",
            "is_phone_verified",
            "is_email_verified",
            "home_city",
            "current_city",
            "home_away_label",
            "rating_count",
            "average_rating",
            "completed_jobs",
            "linked_socials",
            "personal_information_completed",
            "government_identification_completed",
            "vehicle_identification_completed",
            "is_fully_verified",
            "created_at",
        ]

    def get_full_name(self, obj):
        return obj.get_full_name() or obj.email

    def get_avatar_url(self, obj):
        profile = getattr(obj, "profile", None)
        avatar_url = getattr(profile, "avatar_url", "")
        try:
            return resolve_supabase_asset_url(
                avatar_url,
                bucket=settings.SUPABASE_AVATAR_BUCKET,
                public_access=settings.SUPABASE_STORAGE_AVATAR_PUBLIC,
                supabase_url=settings.SUPABASE_URL,
                service_role_key=settings.SUPABASE_SERVICE_ROLE_KEY,
                signed_url_ttl_seconds=settings.SUPABASE_STORAGE_SIGNED_URL_TTL_SECONDS,
            )
        except (StorageConfigurationError, ValueError):
            return avatar_url or ""

    def get_home_away_label(self, obj):
        if (
            obj.home_city
            and obj.current_city
            and obj.home_city.lower() != obj.current_city.lower()
        ):
            return "away"
        return "home"

    def get_rating_count(self, obj):
        return obj.received_reviews.count()

    def get_average_rating(self, obj):
        aggregate = obj.received_reviews.aggregate(value=Avg("rating"))
        return round(float(aggregate["value"] or 0), 1)

    def get_completed_jobs(self, obj):
        return TravelMatch.objects.filter(
            travel_plan__created_by=obj,
            status=TravelMatch.Status.COMPLETED,
        ).count()

    def get_linked_socials(self, obj):
        profile = getattr(obj, "profile", None)
        return profile.linked_socials if profile else {}

    def get_personal_information_completed(self, obj):
        return has_completed_personal_information(obj)

    def get_government_identification_completed(self, obj):
        return has_verified_government_identification(obj)

    def get_vehicle_identification_completed(self, obj):
        return has_verified_vehicle_identification(obj)

    def get_is_fully_verified(self, obj):
        return is_fully_verified_user(obj)


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = User
        fields = [
            "email",
            "password",
            "first_name",
            "last_name",
            "phone_number",
            "account_type",
        ]

    def create(self, validated_data):
        return User.objects.create_user(**validated_data)


class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, attrs):
        email = attrs["email"]
        password = attrs["password"]
        try:
            user = User.objects.get(email__iexact=email)
        except User.DoesNotExist as exc:
            raise serializers.ValidationError("Invalid credentials.") from exc

        if not user.check_password(password):
            raise serializers.ValidationError("Invalid credentials.")
        if not user.is_active:
            raise serializers.ValidationError("This account is inactive.")

        refresh = RefreshToken.for_user(user)
        attrs["user"] = user
        attrs["tokens"] = {
            "access": str(refresh.access_token),
            "refresh": str(refresh),
            "token_type": "Bearer",
        }
        return attrs


class ForgotPasswordSerializer(serializers.Serializer):
    email = serializers.EmailField()


class EmailVerificationRequestSerializer(serializers.Serializer):
    email = serializers.EmailField()


class EmailVerificationConfirmSerializer(serializers.Serializer):
    email = serializers.EmailField()
    code = serializers.CharField(min_length=6, max_length=6)


class ResetPasswordConfirmSerializer(serializers.Serializer):
    uid = serializers.CharField()
    token = serializers.CharField()
    new_password = serializers.CharField(write_only=True, min_length=8)
    confirm_password = serializers.CharField(write_only=True, min_length=8)

    def validate(self, attrs):
        if attrs["new_password"] != attrs["confirm_password"]:
            raise serializers.ValidationError(
                {"confirm_password": "Passwords do not match."}
            )
        try:
            validate_password(attrs["new_password"])
        except DjangoValidationError as exc:
            raise serializers.ValidationError(
                {"new_password": list(exc.messages)}
            ) from exc
        return attrs


class UserProfileSerializer(serializers.ModelSerializer):
    def to_representation(self, instance):
        data = super().to_representation(instance)
        avatar_url = data.get("avatar_url")
        try:
            data["avatar_url"] = resolve_supabase_asset_url(
                avatar_url,
                bucket=settings.SUPABASE_AVATAR_BUCKET,
                public_access=settings.SUPABASE_STORAGE_AVATAR_PUBLIC,
                supabase_url=settings.SUPABASE_URL,
                service_role_key=settings.SUPABASE_SERVICE_ROLE_KEY,
                signed_url_ttl_seconds=settings.SUPABASE_STORAGE_SIGNED_URL_TTL_SECONDS,
            )
        except (StorageConfigurationError, ValueError):
            data["avatar_url"] = avatar_url or ""
        return data

    class Meta:
        model = UserProfile
        fields = [
            "avatar_url",
            "date_of_birth",
            "gender",
            "emergency_contact_name",
            "emergency_contact_phone",
            "address",
            "bio",
            "linked_socials",
            "notification_preferences",
            "payment_preferences",
        ]


class VehicleSerializer(serializers.ModelSerializer):
    metadata = serializers.SerializerMethodField()
    review_status = serializers.SerializerMethodField()
    reviewer_notes = serializers.SerializerMethodField()

    def validate_plate_number(self, value):
        normalized_value = (value or "").strip().upper()
        if not NIGERIAN_PLATE_NUMBER_PATTERN.fullmatch(normalized_value):
            raise serializers.ValidationError(
                "Enter a valid Nigerian plate number in the format ABC-123DE."
            )
        return normalized_value

    def get_metadata(self, obj):
        raw_metadata = obj.metadata if isinstance(obj.metadata, dict) else {}
        resolved_metadata = {}
        for key, value in raw_metadata.items():
            if value is None:
                continue
            if str(key) in {"review_status", "reviewer_notes"}:
                continue
            try:
                resolved_metadata[str(key)] = resolve_supabase_asset_url(
                    str(value),
                    bucket=settings.SUPABASE_VEHICLE_BUCKET,
                    public_access=settings.SUPABASE_STORAGE_VEHICLE_PUBLIC,
                    supabase_url=settings.SUPABASE_URL,
                    service_role_key=settings.SUPABASE_SERVICE_ROLE_KEY,
                    signed_url_ttl_seconds=settings.SUPABASE_STORAGE_SIGNED_URL_TTL_SECONDS,
                )
            except (StorageConfigurationError, ValueError):
                resolved_metadata[str(key)] = str(value)
        return resolved_metadata

    def get_review_status(self, obj):
        metadata = obj.metadata if isinstance(obj.metadata, dict) else {}
        if obj.is_verified:
            return "verified"
        return str(metadata.get("review_status") or "pending")

    def get_reviewer_notes(self, obj):
        metadata = obj.metadata if isinstance(obj.metadata, dict) else {}
        return str(metadata.get("reviewer_notes") or "")

    class Meta:
        model = Vehicle
        fields = [
            "id",
            "vehicle_type",
            "make",
            "model",
            "color",
            "plate_number",
            "seats",
            "is_verified",
            "review_status",
            "reviewer_notes",
            "metadata",
            "created_at",
        ]
        read_only_fields = [
            "id",
            "is_verified",
            "review_status",
            "reviewer_notes",
            "created_at",
        ]


class KycRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = KycRecord
        fields = [
            "bvn",
            "nin",
            "id_document_url",
            "selfie_url",
            "status",
            "reviewer_notes",
            "submitted_at",
            "updated_at",
        ]
        read_only_fields = ["status", "reviewer_notes", "submitted_at", "updated_at"]


class AccountOverviewSerializer(serializers.Serializer):
    user = UserSerializer()
    profile = UserProfileSerializer(allow_null=True)
    vehicles = VehicleSerializer(many=True)
    kyc = KycRecordSerializer(allow_null=True)


class AccountProfileSerializer(serializers.Serializer):
    first_name = serializers.CharField(required=False, allow_blank=True)
    last_name = serializers.CharField(required=False, allow_blank=True)
    email = serializers.EmailField(read_only=True)
    phone_number = serializers.CharField(required=False, allow_blank=True)
    avatar_url = serializers.CharField(required=False, allow_blank=True)
    date_of_birth = serializers.DateField(required=False, allow_null=True)
    gender = serializers.CharField(required=False, allow_blank=True)
    emergency_contact_name = serializers.CharField(required=False, allow_blank=True)
    emergency_contact_phone = serializers.CharField(required=False, allow_blank=True)
    address = serializers.CharField(required=False, allow_blank=True)
    bio = serializers.CharField(required=False, allow_blank=True)
    linked_socials = serializers.JSONField(required=False)
    notification_preferences = serializers.JSONField(required=False)
    payment_preferences = serializers.JSONField(required=False)

    def to_representation(self, instance):
        data = super().to_representation(instance)
        avatar_url = data.get("avatar_url")
        try:
            data["avatar_url"] = resolve_supabase_asset_url(
                avatar_url,
                bucket=settings.SUPABASE_AVATAR_BUCKET,
                public_access=settings.SUPABASE_STORAGE_AVATAR_PUBLIC,
                supabase_url=settings.SUPABASE_URL,
                service_role_key=settings.SUPABASE_SERVICE_ROLE_KEY,
                signed_url_ttl_seconds=settings.SUPABASE_STORAGE_SIGNED_URL_TTL_SECONDS,
            )
        except (StorageConfigurationError, ValueError):
            data["avatar_url"] = avatar_url or ""
        return data

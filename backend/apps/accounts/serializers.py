from __future__ import annotations

from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError as DjangoValidationError
from django.db.models import Avg
from rest_framework import serializers
from rest_framework_simplejwt.tokens import RefreshToken

from .models import KycRecord, UserProfile, Vehicle
from apps.mobility.models import TravelMatch

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    full_name = serializers.SerializerMethodField()
    home_away_label = serializers.SerializerMethodField()
    rating_count = serializers.SerializerMethodField()
    average_rating = serializers.SerializerMethodField()
    completed_jobs = serializers.SerializerMethodField()
    linked_socials = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            "id",
            "email",
            "first_name",
            "last_name",
            "full_name",
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
            "created_at",
        ]

    def get_full_name(self, obj):
        return obj.get_full_name() or obj.email

    def get_home_away_label(self, obj):
        if obj.home_city and obj.current_city and obj.home_city.lower() != obj.current_city.lower():
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
            "metadata",
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

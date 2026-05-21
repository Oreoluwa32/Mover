from __future__ import annotations

import json
import html
from datetime import timedelta
from pathlib import Path
from urllib.parse import urlencode
from uuid import uuid4

from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.db import transaction
from django.http import HttpResponse
from django.utils import timezone
from django.utils.encoding import force_str
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from rest_framework import permissions, response, status, viewsets
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenRefreshView

from config.api_security import (
    SanitizedFormParser,
    SanitizedJSONParser,
    SanitizedMultiPartParser,
    sanitize_string,
)
from .emailing import (
    EmailVerificationError,
    PasswordResetEmailError,
    build_password_reset_url,
    generate_email_verification_code,
    send_email_verification_email,
    send_password_reset_email,
)
from .models import EmailVerificationCode, KycRecord, UserProfile, Vehicle
from .serializers import (
    AccountProfileSerializer,
    AccountOverviewSerializer,
    EmailVerificationConfirmSerializer,
    EmailVerificationRequestSerializer,
    ForgotPasswordSerializer,
    KycRecordSerializer,
    LoginSerializer,
    RegisterSerializer,
    ResetPasswordConfirmSerializer,
    UserProfileSerializer,
    UserSerializer,
    VehicleSerializer,
)
from .storage_utils import (
    StorageConfigurationError,
    build_storage_reference,
    extract_storage_object_path,
    upload_file_to_supabase,
)
from .verification import is_fully_verified_user

User = get_user_model()
MAX_AVATAR_UPLOAD_SIZE = 5 * 1024 * 1024
ALLOWED_AVATAR_EXTENSIONS = {"jpg", "jpeg", "png", "webp"}
MAX_VEHICLE_DOCUMENT_UPLOAD_SIZE = 8 * 1024 * 1024
ALLOWED_VEHICLE_DOCUMENT_EXTENSIONS = {"jpg", "jpeg", "png", "webp"}
VEHICLE_DOCUMENT_CONTENT_PREFIXES = ("image/",)
VEHICLE_DOCUMENT_FIELDS = (
    "vehicle_photo",
    "driver_license",
    "vehicle_report",
    "vehicle_insurance",
)


def _email_verification_required_response(email: str) -> response.Response:
    return response.Response(
        {
            "detail": "Verify your email to continue.",
            "code": "email_verification_required",
            "email_verification_required": True,
            "email": email,
        },
        status=status.HTTP_403_FORBIDDEN,
    )


def _dispatch_email_verification(user: User) -> None:
    ttl_minutes = max(
        1,
        int(getattr(settings, "MOVR_EMAIL_VERIFICATION_CODE_TTL_MINUTES", 15)),
    )
    verification_code = generate_email_verification_code()
    with transaction.atomic():
        user.email_verification_codes.filter(consumed_at__isnull=True).delete()
        EmailVerificationCode.objects.create(
            user=user,
            code=verification_code,
            expires_at=timezone.now() + timedelta(minutes=ttl_minutes),
        )

    recipient_name = user.get_full_name() or user.email
    send_email_verification_email(
        to_email=user.email,
        recipient_name=recipient_name,
        verification_code=verification_code,
    )


def _store_avatar_upload(request, profile: UserProfile, uploaded_file) -> str:
    extension = Path(uploaded_file.name or "").suffix.lower().lstrip(".")
    object_path = (
        f"{settings.SUPABASE_STORAGE_AVATAR_PREFIX.rstrip('/')}/"
        f"user-{request.user.pk}/{uuid4().hex}.{extension}"
    )
    avatar_url = upload_file_to_supabase(
        uploaded_file=uploaded_file,
        object_path=object_path,
        allowed_extensions=ALLOWED_AVATAR_EXTENSIONS,
        max_size=MAX_AVATAR_UPLOAD_SIZE,
        allowed_content_prefixes=("image/",),
        invalid_type_message="Upload a JPG, PNG, or WEBP image.",
        supabase_url=settings.SUPABASE_URL,
        service_role_key=settings.SUPABASE_SERVICE_ROLE_KEY,
        bucket=settings.SUPABASE_AVATAR_BUCKET,
        public_access=settings.SUPABASE_STORAGE_AVATAR_PUBLIC,
    )
    profile.avatar_url = avatar_url
    profile.save(update_fields=["avatar_url", "updated_at"])
    return avatar_url


def _normalize_vehicle_metadata(raw_metadata) -> dict[str, str]:
    if isinstance(raw_metadata, dict):
        return {
            str(key): _normalize_vehicle_metadata_value(str(value))
            for key, value in raw_metadata.items()
            if value is not None and str(value).strip()
        }
    if isinstance(raw_metadata, str) and raw_metadata.strip():
        try:
            parsed = json.loads(raw_metadata)
            if isinstance(parsed, dict):
                return {
                    str(key): _normalize_vehicle_metadata_value(str(value))
                    for key, value in parsed.items()
                    if value is not None and str(value).strip()
                }
        except json.JSONDecodeError:
            return {}
    return {}


def _normalize_vehicle_metadata_value(value: str) -> str:
    object_path = extract_storage_object_path(
        value,
        bucket=settings.SUPABASE_VEHICLE_BUCKET,
        supabase_url=settings.SUPABASE_URL,
    )
    if object_path:
        return build_storage_reference(settings.SUPABASE_VEHICLE_BUCKET, object_path)
    return value


def _store_vehicle_document_uploads(request, metadata: dict[str, str]) -> dict[str, str]:
    uploaded_metadata = dict(metadata)
    for field_name in VEHICLE_DOCUMENT_FIELDS:
        uploaded_file = request.FILES.get(field_name)
        if uploaded_file is None:
            continue

        extension = Path(uploaded_file.name or "").suffix.lower().lstrip(".")
        object_path = (
            f"{settings.SUPABASE_STORAGE_VEHICLE_PREFIX.rstrip('/')}/"
            f"user-{request.user.pk}/{field_name}/{uuid4().hex}.{extension}"
        )
        uploaded_metadata[field_name] = upload_file_to_supabase(
            uploaded_file=uploaded_file,
            object_path=object_path,
            allowed_extensions=ALLOWED_VEHICLE_DOCUMENT_EXTENSIONS,
            max_size=MAX_VEHICLE_DOCUMENT_UPLOAD_SIZE,
            allowed_content_prefixes=VEHICLE_DOCUMENT_CONTENT_PREFIXES,
            invalid_type_message="Upload a JPG, PNG, or WEBP image.",
            supabase_url=settings.SUPABASE_URL,
            service_role_key=settings.SUPABASE_SERVICE_ROLE_KEY,
            bucket=settings.SUPABASE_VEHICLE_BUCKET,
            public_access=settings.SUPABASE_STORAGE_VEHICLE_PUBLIC,
        )
    return uploaded_metadata


def _mark_vehicle_for_review(metadata: dict[str, str]) -> dict[str, str]:
    pending_metadata = dict(metadata)
    pending_metadata["review_status"] = "pending"
    pending_metadata["reviewer_notes"] = ""
    return pending_metadata


class RegisterView(APIView):
    permission_classes = [permissions.AllowAny]
    throttle_scope = "auth"

    def post(self, request):
        email = (request.data.get("email") or "").strip()
        existing_user = User.objects.filter(email__iexact=email).first() if email else None
        if existing_user:
            if existing_user.is_email_verified:
                return response.Response(
                    {"detail": "An account with this email already exists."},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            try:
                _dispatch_email_verification(existing_user)
            except EmailVerificationError as exc:
                return response.Response(
                    {"detail": str(exc)},
                    status=status.HTTP_503_SERVICE_UNAVAILABLE,
                )
            return response.Response(
                {
                    "detail": "Your email is not verified yet. We sent a new verification code.",
                    "email_verification_required": True,
                    "email": existing_user.email,
                },
                status=status.HTTP_202_ACCEPTED,
            )

        serializer = RegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        UserProfile.objects.get_or_create(user=user)
        try:
            _dispatch_email_verification(user)
        except EmailVerificationError as exc:
            user.delete()
            return response.Response(
                {"detail": str(exc)},
                status=status.HTTP_503_SERVICE_UNAVAILABLE,
            )
        return response.Response(
            {
                "detail": "Account created. Verify your email to continue.",
                "email_verification_required": True,
                "email": user.email,
            },
            status=status.HTTP_201_CREATED,
        )


class LoginView(APIView):
    permission_classes = [permissions.AllowAny]
    throttle_scope = "auth"

    def post(self, request):
        email = (request.data.get("email") or "").strip()
        password = request.data.get("password") or ""
        user = User.objects.filter(email__iexact=email).first() if email else None
        if user and user.check_password(password) and user.is_active and not user.is_email_verified:
            try:
                _dispatch_email_verification(user)
            except EmailVerificationError as exc:
                return response.Response(
                    {"detail": str(exc)},
                    status=status.HTTP_503_SERVICE_UNAVAILABLE,
                )
            return _email_verification_required_response(user.email)

        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        return response.Response(
            {
                "user": UserSerializer(serializer.validated_data["user"]).data,
                "tokens": serializer.validated_data["tokens"],
            }
        )


class ForgotPasswordView(APIView):
    permission_classes = [permissions.AllowAny]
    throttle_scope = "password_reset"

    def post(self, request):
        serializer = ForgotPasswordSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = serializer.validated_data["email"]
        user = User.objects.filter(email__iexact=email, is_active=True).first()

        if user:
            uid = urlsafe_base64_encode(str(user.pk).encode("utf-8"))
            token = PasswordResetTokenGenerator().make_token(user)
            reset_url = build_password_reset_url(uid=uid, token=token)
            reset_open_url = request.build_absolute_uri(
                f"/api/auth/password/reset/open/?{urlencode({'uid': uid, 'token': token})}"
            )
            recipient_name = user.get_full_name() or user.email
            try:
                send_password_reset_email(
                    to_email=user.email,
                    recipient_name=recipient_name,
                    reset_url=reset_url,
                    reset_open_url=reset_open_url,
                )
            except PasswordResetEmailError as exc:
                return response.Response(
                    {"detail": str(exc)},
                    status=status.HTTP_503_SERVICE_UNAVAILABLE,
                )

        return response.Response(
            {
                "detail": (
                    "If an account exists for that email, a password reset link has been sent."
                )
            }
        )


class EmailVerificationRequestView(APIView):
    permission_classes = [permissions.AllowAny]
    throttle_scope = "email_verification"

    def post(self, request):
        serializer = EmailVerificationRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = serializer.validated_data["email"]
        user = User.objects.filter(email__iexact=email, is_active=True).first()

        if user and not user.is_email_verified:
            try:
                _dispatch_email_verification(user)
            except EmailVerificationError as exc:
                return response.Response(
                    {"detail": str(exc)},
                    status=status.HTTP_503_SERVICE_UNAVAILABLE,
                )

        return response.Response(
            {
                "detail": (
                    "If an account exists and still needs verification, a code has been sent."
                )
            }
        )


class EmailVerificationConfirmView(APIView):
    permission_classes = [permissions.AllowAny]
    throttle_scope = "email_verification"

    def post(self, request):
        serializer = EmailVerificationConfirmSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = serializer.validated_data["email"]
        code = serializer.validated_data["code"].strip()

        user = User.objects.filter(email__iexact=email, is_active=True).first()
        if not user:
            return response.Response(
                {"detail": "Invalid or expired verification code."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        if user.is_email_verified:
            return response.Response({"detail": "Email already verified."})

        verification = user.email_verification_codes.filter(consumed_at__isnull=True).first()
        if not verification or verification.is_expired or verification.code != code:
            return response.Response(
                {"detail": "Invalid or expired verification code."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        verification.consumed_at = timezone.now()
        verification.save(update_fields=["consumed_at"])
        user.is_email_verified = True
        user.save(update_fields=["is_email_verified", "updated_at"])
        return response.Response({"detail": "Email verified successfully."})


class ResetPasswordConfirmView(APIView):
    permission_classes = [permissions.AllowAny]
    throttle_scope = "password_reset"

    def post(self, request):
        serializer = ResetPasswordConfirmSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        uid = serializer.validated_data["uid"]
        token = serializer.validated_data["token"]
        new_password = serializer.validated_data["new_password"]

        try:
            user_id = force_str(urlsafe_base64_decode(uid))
            user = User.objects.get(pk=user_id, is_active=True)
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            return response.Response(
                {"detail": "Invalid or expired reset link."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        if not PasswordResetTokenGenerator().check_token(user, token):
            return response.Response(
                {"detail": "Invalid or expired reset link."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        user.set_password(new_password)
        user.save()
        return response.Response({"detail": "Password reset successful."})


class PasswordResetOpenView(APIView):
    permission_classes = [permissions.AllowAny]
    throttle_scope = "password_reset"

    def get(self, request):
        uid = sanitize_string(request.query_params.get("uid") or "")
        token = sanitize_string(request.query_params.get("token") or "")
        deep_link = build_password_reset_url(uid=uid, token=token)
        escaped_deep_link = html.escape(deep_link, quote=True)

        html = f"""
        <!doctype html>
        <html lang="en">
          <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>Open Movr</title>
            <style>
              body {{
                margin: 0;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                background: #faf7ff;
                color: #1f2937;
                font-family: Arial, sans-serif;
              }}
              .card {{
                width: min(92vw, 420px);
                background: #fff;
                border-radius: 24px;
                padding: 32px 24px;
                text-align: center;
                box-shadow: 0 16px 40px rgba(109, 40, 217, 0.12);
              }}
              .button {{
                display: inline-block;
                margin-top: 20px;
                padding: 14px 22px;
                border-radius: 999px;
                background: #6d28d9;
                color: #fff;
                text-decoration: none;
                font-weight: 700;
              }}
              .link {{
                display: block;
                margin-top: 18px;
                color: #6d28d9;
                word-break: break-all;
              }}
            </style>
          </head>
          <body>
            <div class="card">
              <h1 style="margin:0 0 12px;">Open Movr</h1>
              <p style="margin:0 0 8px;">Your password reset is ready.</p>
              <p style="margin:0;color:#6b7280;">If the app does not open automatically, use the button below.</p>
              <a class="button" href="{escaped_deep_link}">Open in Movr</a>
              <a class="link" href="{escaped_deep_link}">{escaped_deep_link}</a>
            </div>
            <script>
              window.location.replace("{escaped_deep_link}");
              setTimeout(function () {{
                window.location.href = "{escaped_deep_link}";
              }}, 500);
            </script>
          </body>
        </html>
        """
        return HttpResponse(html)


class MeView(APIView):
    def get(self, request):
        profile, _ = UserProfile.objects.get_or_create(user=request.user)
        payload = {
            "user": request.user,
            "profile": profile,
            "vehicles": request.user.vehicles.all(),
            "kyc": getattr(request.user, "kyc_record", None),
            "is_fully_verified": is_fully_verified_user(request.user),
        }
        return response.Response(AccountOverviewSerializer(payload).data)


class ProfileView(APIView):
    parser_classes = (SanitizedJSONParser, SanitizedFormParser, SanitizedMultiPartParser)

    def get(self, request):
        profile, _ = UserProfile.objects.get_or_create(user=request.user)
        payload = {
            "first_name": request.user.first_name,
            "last_name": request.user.last_name,
            "email": request.user.email,
            "phone_number": request.user.phone_number,
            "avatar_url": profile.avatar_url,
            "date_of_birth": profile.date_of_birth,
            "gender": profile.gender,
            "emergency_contact_name": profile.emergency_contact_name,
            "emergency_contact_phone": profile.emergency_contact_phone,
            "address": profile.address,
            "bio": profile.bio,
            "linked_socials": profile.linked_socials,
            "notification_preferences": profile.notification_preferences,
            "payment_preferences": profile.payment_preferences,
        }
        return response.Response(AccountProfileSerializer(payload).data)

    def put(self, request):
        profile, _ = UserProfile.objects.get_or_create(user=request.user)
        serializer = AccountProfileSerializer(data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        request.user.first_name = data.get("first_name", request.user.first_name)
        request.user.last_name = data.get("last_name", request.user.last_name)
        request.user.phone_number = data.get("phone_number", request.user.phone_number)
        request.user.save(update_fields=["first_name", "last_name", "phone_number", "updated_at"])

        avatar_file = request.FILES.get("avatar")
        avatar_url = data.get("avatar_url")
        if avatar_file is not None:
            try:
                _store_avatar_upload(request, profile, avatar_file)
            except StorageConfigurationError as exc:
                return response.Response(
                    {"detail": str(exc)},
                    status=status.HTTP_503_SERVICE_UNAVAILABLE,
                )
            except ValueError as exc:
                return response.Response(
                    {"detail": str(exc)},
                    status=status.HTTP_400_BAD_REQUEST,
                )
        elif avatar_url is not None:
            profile.avatar_url = avatar_url
        profile.date_of_birth = data.get("date_of_birth", profile.date_of_birth)
        profile.gender = data.get("gender", profile.gender)
        profile.emergency_contact_name = data.get(
            "emergency_contact_name",
            profile.emergency_contact_name,
        )
        profile.emergency_contact_phone = data.get(
            "emergency_contact_phone",
            profile.emergency_contact_phone,
        )
        profile.address = data.get("address", profile.address)
        profile.bio = data.get("bio", profile.bio)
        profile.linked_socials = data.get("linked_socials", profile.linked_socials)
        profile.notification_preferences = data.get(
            "notification_preferences",
            profile.notification_preferences,
        )
        profile.payment_preferences = data.get(
            "payment_preferences",
            profile.payment_preferences,
        )
        profile.save()

        response_payload = {
            "first_name": request.user.first_name,
            "last_name": request.user.last_name,
            "email": request.user.email,
            "phone_number": request.user.phone_number,
            "avatar_url": profile.avatar_url,
            "date_of_birth": profile.date_of_birth,
            "gender": profile.gender,
            "emergency_contact_name": profile.emergency_contact_name,
            "emergency_contact_phone": profile.emergency_contact_phone,
            "address": profile.address,
            "bio": profile.bio,
            "linked_socials": profile.linked_socials,
            "notification_preferences": profile.notification_preferences,
            "payment_preferences": profile.payment_preferences,
        }
        return response.Response(AccountProfileSerializer(response_payload).data)


class VehicleViewSet(viewsets.ModelViewSet):
    serializer_class = VehicleSerializer
    parser_classes = (SanitizedJSONParser, SanitizedFormParser, SanitizedMultiPartParser)

    def get_queryset(self):
        return Vehicle.objects.filter(owner=self.request.user).order_by("-created_at")

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

    def _build_vehicle_payload(self, request, instance: Vehicle | None = None) -> dict[str, object]:
        payload: dict[str, object] = {}
        for key in (
            "vehicle_type",
            "make",
            "model",
            "color",
            "plate_number",
        ):
            value = request.data.get(key)
            if value is not None:
                payload[key] = value

        existing_metadata = (
            dict(instance.metadata)
            if instance is not None and isinstance(instance.metadata, dict)
            else {}
        )
        metadata = dict(existing_metadata)
        metadata.update(_normalize_vehicle_metadata(request.data.get("metadata")))
        metadata = _store_vehicle_document_uploads(request, metadata)
        payload["metadata"] = _mark_vehicle_for_review(metadata)
        payload["is_verified"] = False
        return payload

    def create(self, request, *args, **kwargs):
        try:
            serializer = self.get_serializer(data=self._build_vehicle_payload(request))
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
        except StorageConfigurationError as exc:
            return response.Response(
                {"detail": str(exc)},
                status=status.HTTP_503_SERVICE_UNAVAILABLE,
            )
        except ValueError as exc:
            return response.Response(
                {"detail": str(exc)},
                status=status.HTTP_400_BAD_REQUEST,
            )

        headers = self.get_success_headers(serializer.data)
        return response.Response(
            serializer.data,
            status=status.HTTP_201_CREATED,
            headers=headers,
        )

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop("partial", False)
        instance = self.get_object()

        try:
            serializer = self.get_serializer(
                instance,
                data=self._build_vehicle_payload(request, instance),
                partial=partial,
            )
            serializer.is_valid(raise_exception=True)
            self.perform_update(serializer)
        except StorageConfigurationError as exc:
            return response.Response(
                {"detail": str(exc)},
                status=status.HTTP_503_SERVICE_UNAVAILABLE,
            )
        except ValueError as exc:
            return response.Response(
                {"detail": str(exc)},
                status=status.HTTP_400_BAD_REQUEST,
            )

        return response.Response(serializer.data)


class KycRecordView(APIView):
    def get(self, request):
        kyc, _ = KycRecord.objects.get_or_create(user=request.user)
        return response.Response(KycRecordSerializer(kyc).data)

    def put(self, request):
        kyc, _ = KycRecord.objects.get_or_create(user=request.user)
        serializer = KycRecordSerializer(kyc, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save(status=KycRecord.Status.PENDING, reviewer_notes="")
        return response.Response(serializer.data)


class LiveStatusView(APIView):
    def get(self, request):
        active_plan = request.user.travel_plans.filter(is_live=True).order_by("-updated_at").first()
        return response.Response(
            {
                "status": True,
                "is_live": bool(active_plan),
                "travel_plan_id": str(active_plan.id) if active_plan else None,
            }
        )


class MovrTokenRefreshView(TokenRefreshView):
    permission_classes = [permissions.AllowAny]
    throttle_scope = "auth"

from __future__ import annotations

from datetime import timedelta

from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.db import transaction
from django.utils import timezone
from django.utils.encoding import force_str
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from rest_framework import permissions, response, status, viewsets
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenRefreshView

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

User = get_user_model()


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


class RegisterView(APIView):
    permission_classes = [permissions.AllowAny]

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

    def post(self, request):
        serializer = ForgotPasswordSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = serializer.validated_data["email"]
        user = User.objects.filter(email__iexact=email, is_active=True).first()

        if user:
            uid = urlsafe_base64_encode(str(user.pk).encode("utf-8"))
            token = PasswordResetTokenGenerator().make_token(user)
            reset_url = build_password_reset_url(uid=uid, token=token)
            recipient_name = user.get_full_name() or user.email
            try:
                send_password_reset_email(
                    to_email=user.email,
                    recipient_name=recipient_name,
                    reset_url=reset_url,
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


class MeView(APIView):
    def get(self, request):
        profile, _ = UserProfile.objects.get_or_create(user=request.user)
        payload = {
            "user": request.user,
            "profile": profile,
            "vehicles": request.user.vehicles.all(),
            "kyc": getattr(request.user, "kyc_record", None),
        }
        return response.Response(AccountOverviewSerializer(payload).data)


class ProfileView(APIView):
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

        profile.avatar_url = data.get("avatar_url", profile.avatar_url)
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

    def get_queryset(self):
        return Vehicle.objects.filter(owner=self.request.user).order_by("-created_at")

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)


class KycRecordView(APIView):
    def get(self, request):
        kyc, _ = KycRecord.objects.get_or_create(user=request.user)
        return response.Response(KycRecordSerializer(kyc).data)

    def put(self, request):
        kyc, _ = KycRecord.objects.get_or_create(user=request.user)
        serializer = KycRecordSerializer(kyc, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
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

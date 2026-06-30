from django.urls import include, path
from rest_framework.routers import DefaultRouter

from .views import (
    EmailVerificationConfirmView,
    EmailVerificationRequestView,
    ForgotPasswordView,
    GoogleSignInView,
    KycRecordView,
    LiveStatusView,
    LoginView,
    MeView,
    MovrTokenRefreshView,
    ProfileView,
    RegisterView,
    PasswordResetOpenView,
    ResetPasswordConfirmView,
    VehicleViewSet,
)

router = DefaultRouter()
router.register("vehicles", VehicleViewSet, basename="vehicle")

urlpatterns = [
    path("register/", RegisterView.as_view()),
    path("login/", LoginView.as_view()),
    path("google-signin/", GoogleSignInView.as_view()),
    path("email-verification/request/", EmailVerificationRequestView.as_view()),
    path("email-verification/confirm/", EmailVerificationConfirmView.as_view()),
    path("password/forgot/", ForgotPasswordView.as_view()),
    path("password/reset/open/", PasswordResetOpenView.as_view()),
    path("password/reset/", ResetPasswordConfirmView.as_view()),
    path("refresh/", MovrTokenRefreshView.as_view()),
    path("me/", MeView.as_view()),
    path("profile/", ProfileView.as_view()),
    path("kyc/", KycRecordView.as_view()),
    path("user/live-status", LiveStatusView.as_view()),
    path("", include(router.urls)),
]

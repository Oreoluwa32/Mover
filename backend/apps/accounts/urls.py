from django.urls import include, path
from rest_framework.routers import DefaultRouter

from .views import (
    KycRecordView,
    LiveStatusView,
    LoginView,
    MeView,
    MovrTokenRefreshView,
    ProfileView,
    RegisterView,
    VehicleViewSet,
)

router = DefaultRouter()
router.register("vehicles", VehicleViewSet, basename="vehicle")

urlpatterns = [
    path("register/", RegisterView.as_view()),
    path("login/", LoginView.as_view()),
    path("refresh/", MovrTokenRefreshView.as_view()),
    path("me/", MeView.as_view()),
    path("profile/", ProfileView.as_view()),
    path("kyc/", KycRecordView.as_view()),
    path("user/live-status", LiveStatusView.as_view()),
    path("", include(router.urls)),
]

from django.contrib import admin
from django.http import JsonResponse
from django.urls import include, path

from apps.accounts.views import LiveStatusView
from apps.mobility.views import LegacyToggleLiveStatusView
from apps.payments.views import (
    LegacyMonnifyInitializeView,
    LegacyMonnifyVerifyView,
    LegacyPaystackInitializeView,
    LegacyPaystackVerifyView,
    LegacyWalletView,
)


def healthcheck(_request):
    return JsonResponse({"status": "ok", "service": "movr-backend"})

urlpatterns = [
    path("admin/", admin.site.urls),
    path("health/", healthcheck),
    path("wallet/", LegacyWalletView.as_view()),
    path("toggle-is-live/<uuid:travel_plan_id>/", LegacyToggleLiveStatusView.as_view()),
    path("api/v1/user/live-status", LiveStatusView.as_view()),
    path("api/paystack/initialize-transaction", LegacyPaystackInitializeView.as_view()),
    path("api/paystack/verify-transaction/<str:reference>", LegacyPaystackVerifyView.as_view()),
    path("api/v1/merchant/transactions/init-transaction", LegacyMonnifyInitializeView.as_view()),
    path("api/v1/merchant/transactions/verify/<str:reference>", LegacyMonnifyVerifyView.as_view()),
    path("api/", include("config.api_urls")),
    path("api/v1/", include("config.api_urls")),
]

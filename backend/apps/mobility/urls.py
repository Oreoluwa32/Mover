from django.urls import include, path
from rest_framework.routers import DefaultRouter

from .views import (
    DeliveryRequestViewSet,
    EmergencyAlertViewSet,
    MobilityDashboardView,
    RideRequestViewSet,
    TrackingSessionViewSet,
    TravelMatchViewSet,
    TravelPlanViewSet,
)

router = DefaultRouter()
router.register("travel-plans", TravelPlanViewSet, basename="travel-plan")
router.register("ride-requests", RideRequestViewSet, basename="ride-request")
router.register(
    "delivery-requests", DeliveryRequestViewSet, basename="delivery-request"
)
router.register("matches", TravelMatchViewSet, basename="travel-match")
router.register(
    "tracking-sessions", TrackingSessionViewSet, basename="tracking-session"
)
router.register("emergency-alerts", EmergencyAlertViewSet, basename="emergency-alert")

urlpatterns = [
    path("dashboard/", MobilityDashboardView.as_view()),
    path("", include(router.urls)),
]

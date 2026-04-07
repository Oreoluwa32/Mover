from __future__ import annotations

from django.db.models import Q
from rest_framework import response, status, viewsets
from rest_framework.decorators import action
from rest_framework.views import APIView

from .models import DeliveryRequest, EmergencyAlert, RideRequest, TrackingEvent, TrackingSession, TravelMatch, TravelPlan
from .serializers import (
    DeliveryRequestSerializer,
    EmergencyAlertSerializer,
    RideRequestSerializer,
    TrackingEventSerializer,
    TrackingSessionSerializer,
    TravelMatchSerializer,
    TravelPlanSerializer,
)


def _find_matching_plan_for_ride(instance: RideRequest):
    return (
        TravelPlan.objects.filter(
            status__in=[TravelPlan.Status.PUBLISHED, TravelPlan.Status.IN_PROGRESS],
            plan_type__in=[TravelPlan.PlanType.RIDE, TravelPlan.PlanType.HYBRID],
            origin_name__icontains=instance.origin_name,
            destination_name__icontains=instance.destination_name,
            departure_time__date=instance.scheduled_time.date(),
        )
        .exclude(created_by=instance.requester)
        .order_by("departure_time")
        .first()
    )


def _find_matching_plan_for_delivery(instance: DeliveryRequest):
    return (
        TravelPlan.objects.filter(
            status__in=[TravelPlan.Status.PUBLISHED, TravelPlan.Status.IN_PROGRESS],
            plan_type__in=[TravelPlan.PlanType.DELIVERY, TravelPlan.PlanType.HYBRID],
            origin_name__icontains=instance.pickup_name,
            destination_name__icontains=instance.dropoff_name,
            departure_time__date=instance.scheduled_time.date(),
        )
        .exclude(created_by=instance.requester)
        .order_by("departure_time")
        .first()
    )


class TravelPlanViewSet(viewsets.ModelViewSet):
    serializer_class = TravelPlanSerializer

    def get_queryset(self):
        queryset = TravelPlan.objects.select_related("created_by").all().order_by("-departure_time")
        if self.request.query_params.get("mine") == "true":
            queryset = queryset.filter(created_by=self.request.user)
        else:
            queryset = queryset.exclude(created_by=self.request.user).filter(
                status__in=[TravelPlan.Status.PUBLISHED, TravelPlan.Status.IN_PROGRESS]
            )

        origin = self.request.query_params.get("origin")
        destination = self.request.query_params.get("destination")
        plan_type = self.request.query_params.get("plan_type")
        date = self.request.query_params.get("date")
        if origin:
            queryset = queryset.filter(origin_name__icontains=origin)
        if destination:
            queryset = queryset.filter(destination_name__icontains=destination)
        if plan_type:
            queryset = queryset.filter(plan_type=plan_type)
        if date:
            queryset = queryset.filter(departure_time__date=date)
        return queryset

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user, status=self.request.data.get("status", TravelPlan.Status.PUBLISHED))

    @action(detail=True, methods=["post"])
    def toggle_live(self, request, pk=None):
        travel_plan = self.get_object()
        is_live = bool(request.data.get("is_live", not travel_plan.is_live))
        travel_plan.is_live = is_live
        if is_live and travel_plan.status == TravelPlan.Status.PUBLISHED:
            travel_plan.status = TravelPlan.Status.IN_PROGRESS
        if not is_live and travel_plan.status == TravelPlan.Status.IN_PROGRESS:
            travel_plan.status = TravelPlan.Status.PUBLISHED
        travel_plan.save(update_fields=["is_live", "status", "updated_at"])
        TrackingSession.objects.get_or_create(travel_plan=travel_plan)
        return response.Response(
            {"status": True, "message": "Live tracking updated.", "is_live": travel_plan.is_live, "travel_plan_id": str(travel_plan.id)}
        )


class RideRequestViewSet(viewsets.ModelViewSet):
    serializer_class = RideRequestSerializer

    def get_queryset(self):
        queryset = RideRequest.objects.select_related("matched_plan", "requester").order_by("-created_at")
        if self.request.query_params.get("discover") == "true":
            return queryset.filter(status=RideRequest.Status.OPEN).exclude(requester=self.request.user)
        return queryset.filter(requester=self.request.user)

    def perform_create(self, serializer):
        instance = serializer.save(requester=self.request.user)
        matched_plan = _find_matching_plan_for_ride(instance)
        if matched_plan:
            instance.matched_plan = matched_plan
            instance.status = RideRequest.Status.MATCHED
            instance.save(update_fields=["matched_plan", "status", "updated_at"])
            TravelMatch.objects.create(
                travel_plan=matched_plan,
                ride_request=instance,
                match_type=TravelMatch.MatchType.RIDE,
                agreed_price=matched_plan.price_per_seat * instance.seats_requested,
                status=TravelMatch.Status.PROPOSED,
            )


class DeliveryRequestViewSet(viewsets.ModelViewSet):
    serializer_class = DeliveryRequestSerializer

    def get_queryset(self):
        queryset = DeliveryRequest.objects.select_related("matched_plan", "requester").order_by("-created_at")
        if self.request.query_params.get("discover") == "true":
            return queryset.filter(status=DeliveryRequest.Status.OPEN).exclude(requester=self.request.user)
        return queryset.filter(requester=self.request.user)

    def perform_create(self, serializer):
        instance = serializer.save(requester=self.request.user)
        matched_plan = _find_matching_plan_for_delivery(instance)
        if matched_plan:
            instance.matched_plan = matched_plan
            instance.status = DeliveryRequest.Status.MATCHED
            instance.save(update_fields=["matched_plan", "status", "updated_at"])
            TravelMatch.objects.create(
                travel_plan=matched_plan,
                delivery_request=instance,
                match_type=TravelMatch.MatchType.DELIVERY,
                agreed_price=max(matched_plan.price_per_seat, instance.insured_value * 0.01),
                status=TravelMatch.Status.PROPOSED,
            )


class TravelMatchViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = TravelMatchSerializer

    def get_queryset(self):
        return TravelMatch.objects.select_related("travel_plan", "ride_request", "delivery_request").filter(
            Q(travel_plan__created_by=self.request.user)
            | Q(ride_request__requester=self.request.user)
            | Q(delivery_request__requester=self.request.user)
        ).order_by("-created_at")


class TrackingSessionViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = TrackingSessionSerializer

    def get_queryset(self):
        return TrackingSession.objects.filter(
            Q(travel_plan__created_by=self.request.user)
            | Q(travel_plan__matches__ride_request__requester=self.request.user)
            | Q(travel_plan__matches__delivery_request__requester=self.request.user)
        ).distinct()

    @action(detail=True, methods=["post"])
    def events(self, request, pk=None):
        session = self.get_object()
        serializer = TrackingEventSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        event = TrackingEvent.objects.create(session=session, actor=request.user, **serializer.validated_data)
        return response.Response(TrackingEventSerializer(event).data, status=status.HTTP_201_CREATED)


class EmergencyAlertViewSet(viewsets.ModelViewSet):
    serializer_class = EmergencyAlertSerializer

    def get_queryset(self):
        return EmergencyAlert.objects.filter(user=self.request.user).order_by("-created_at")

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class MobilityDashboardView(APIView):
    def get(self, request):
        return response.Response(
            {
                "published_travel_plans": request.user.travel_plans.filter(status__in=[TravelPlan.Status.PUBLISHED, TravelPlan.Status.IN_PROGRESS]).count(),
                "ride_requests": request.user.ride_requests.count(),
                "delivery_requests": request.user.delivery_requests.count(),
                "active_matches": TravelMatch.objects.filter(
                    Q(travel_plan__created_by=request.user)
                    | Q(ride_request__requester=request.user)
                    | Q(delivery_request__requester=request.user),
                    status__in=[TravelMatch.Status.PROPOSED, TravelMatch.Status.ACCEPTED, TravelMatch.Status.ACTIVE],
                ).count(),
                "live_routes": request.user.travel_plans.filter(is_live=True).count(),
            }
        )


class LegacyToggleLiveStatusView(APIView):
    def post(self, request, travel_plan_id):
        travel_plan = TravelPlan.objects.filter(id=travel_plan_id, created_by=request.user).first()
        if not travel_plan:
            return response.Response({"status": False, "message": "Travel plan not found."}, status=status.HTTP_404_NOT_FOUND)

        is_live = bool(request.data.get("is_live", False))
        travel_plan.is_live = is_live
        if is_live and travel_plan.status == TravelPlan.Status.PUBLISHED:
            travel_plan.status = TravelPlan.Status.IN_PROGRESS
        if not is_live and travel_plan.status == TravelPlan.Status.IN_PROGRESS:
            travel_plan.status = TravelPlan.Status.PUBLISHED
        travel_plan.save(update_fields=["is_live", "status", "updated_at"])
        TrackingSession.objects.get_or_create(travel_plan=travel_plan)
        return response.Response({"status": True, "message": "Live status updated successfully.", "is_live": travel_plan.is_live})

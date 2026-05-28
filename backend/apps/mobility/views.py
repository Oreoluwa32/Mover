from __future__ import annotations

from datetime import timedelta

from django.core.cache import cache
from django.db import transaction
from django.db.models import Q
from django.utils import timezone
from rest_framework import response, status, viewsets
from rest_framework.decorators import action
from rest_framework.views import APIView

from config.api_security import sanitize_string
from apps.accounts.verification import is_fully_verified_user
from .models import (
    DeliveryRequest,
    EmergencyAlert,
    RideRequest,
    TaskIncidentReport,
    TaskMessage,
    TaskReview,
    TrackingEvent,
    TrackingSession,
    TravelMatch,
    TravelPlan,
)
from .serializers import (
    DeliveryRequestSerializer,
    EmergencyAlertSerializer,
    TaskIncidentReportSerializer,
    TaskMessageSerializer,
    RideRequestSerializer,
    TaskReviewSerializer,
    TrackingEventSerializer,
    TrackingSessionSerializer,
    TravelMatchSerializer,
    TravelPlanSerializer,
)

REQUEST_EXPIRY_WINDOW = timedelta(hours=3)
ACCEPTED_MATCH_EXPIRY_WINDOW = timedelta(hours=12)


def _filter_plans_for_fully_verified_creators(queryset):
    # is_fully_verified_user walks created_by.kyc_record (OneToOne reverse)
    # and created_by.vehicles (reverse FK). Without these select/prefetch
    # hints each plan row issues two extra queries per attribute access,
    # turning the matching helpers into an N+1 trap.
    materialized = queryset.select_related(
        "created_by", "created_by__kyc_record"
    ).prefetch_related("created_by__vehicles")
    eligible_plan_ids = [
        plan.id for plan in materialized if is_fully_verified_user(plan.created_by)
    ]
    return queryset.filter(id__in=eligible_plan_ids)


_EXPIRE_STALE_REQUESTS_TTL_SECONDS = 60


def _expire_stale_requests(request_model, *, match_field: str):
    # Debounce so the expiry sweep can't run on every list request and turn
    # into a per-call write storm. Best-effort cleanup; OK to skip when the
    # gate is held by another recent call.
    cache_key = f"mobility:expire_stale:{request_model._meta.model_name}"
    if cache.get(cache_key):
        return
    cache.set(cache_key, True, timeout=_EXPIRE_STALE_REQUESTS_TTL_SECONDS)

    expiry_cutoff = timezone.now() - REQUEST_EXPIRY_WINDOW
    stale_requests = request_model.objects.filter(
        status__in=[request_model.Status.OPEN, request_model.Status.MATCHED],
        scheduled_time__lte=expiry_cutoff,
    ).exclude(
        travelmatch__status__in=[TravelMatch.Status.ACCEPTED, TravelMatch.Status.ACTIVE]
    )

    request_ids = list(stale_requests.values_list("id", flat=True))
    if not request_ids:
        return

    stale_requests.update(
        status=request_model.Status.CANCELLED, updated_at=timezone.now()
    )
    TravelMatch.objects.filter(
        **{f"{match_field}_id__in": request_ids},
        status__in=[TravelMatch.Status.PROPOSED, TravelMatch.Status.REJECTED],
    ).update(status=TravelMatch.Status.CANCELLED)


def _reset_request_after_match_cancel(match: TravelMatch):
    if match.ride_request is not None:
        sibling_offer = (
            TravelMatch.objects.select_related("travel_plan")
            .filter(
                ride_request=match.ride_request,
                status=TravelMatch.Status.PROPOSED,
            )
            .order_by("-created_at")
            .first()
        )
        match.ride_request.matched_plan = (
            sibling_offer.travel_plan if sibling_offer else None
        )
        match.ride_request.status = (
            RideRequest.Status.MATCHED if sibling_offer else RideRequest.Status.OPEN
        )
        match.ride_request.save(update_fields=["matched_plan", "status", "updated_at"])
        return

    if match.delivery_request is not None:
        sibling_offer = (
            TravelMatch.objects.select_related("travel_plan")
            .filter(
                delivery_request=match.delivery_request,
                status=TravelMatch.Status.PROPOSED,
            )
            .order_by("-created_at")
            .first()
        )
        match.delivery_request.matched_plan = (
            sibling_offer.travel_plan if sibling_offer else None
        )
        match.delivery_request.status = (
            DeliveryRequest.Status.MATCHED
            if sibling_offer
            else DeliveryRequest.Status.OPEN
        )
        match.delivery_request.save(
            update_fields=["matched_plan", "status", "updated_at"]
        )


def _cancel_match(match: TravelMatch):
    match.status = TravelMatch.Status.CANCELLED
    match.save(update_fields=["status"])
    _reset_request_after_match_cancel(match)


def _record_match_cancellation(
    match: TravelMatch,
    *,
    actor,
    reason: str = "",
    notes: str = "",
):
    match.status = TravelMatch.Status.CANCELLED
    match.cancelled_by = actor
    match.cancelled_reason = reason
    match.cancelled_notes = notes
    match.cancelled_at = timezone.now()
    match.save(
        update_fields=[
            "status",
            "cancelled_by",
            "cancelled_reason",
            "cancelled_notes",
            "cancelled_at",
        ]
    )


def _cancel_request_and_siblings(
    *,
    request_instance,
    actor,
    reason: str = "",
    notes: str = "",
):
    request_instance.status = request_instance.Status.CANCELLED
    request_instance.matched_plan = None
    request_instance.cancelled_by = actor
    request_instance.cancelled_reason = reason
    request_instance.cancelled_notes = notes
    request_instance.cancelled_at = timezone.now()
    request_instance.save(
        update_fields=[
            "status",
            "matched_plan",
            "cancelled_by",
            "cancelled_reason",
            "cancelled_notes",
            "cancelled_at",
            "updated_at",
        ]
    )

    filter_kwargs = (
        {"ride_request": request_instance}
        if isinstance(request_instance, RideRequest)
        else {"delivery_request": request_instance}
    )
    sibling_matches = TravelMatch.objects.filter(**filter_kwargs).exclude(
        status=TravelMatch.Status.COMPLETED
    )
    for sibling in sibling_matches:
        _record_match_cancellation(
            sibling,
            actor=actor,
            reason=reason,
            notes=notes,
        )


def _expire_stale_accepted_matches():
    expiry_cutoff = timezone.now() - ACCEPTED_MATCH_EXPIRY_WINDOW
    stale_matches = (
        TravelMatch.objects.select_related(
            "ride_request",
            "delivery_request",
            "travel_plan",
        )
        .filter(
            status=TravelMatch.Status.ACCEPTED,
        )
        .filter(
            Q(ride_request__scheduled_time__lte=expiry_cutoff)
            | Q(delivery_request__scheduled_time__lte=expiry_cutoff)
        )
    )

    for stale_match in stale_matches:
        _cancel_match(stale_match)


def _find_matching_plan_for_ride(instance: RideRequest):
    queryset = _filter_plans_for_fully_verified_creators(
        TravelPlan.objects.filter(
            status__in=[TravelPlan.Status.PUBLISHED, TravelPlan.Status.IN_PROGRESS],
            plan_type__in=[TravelPlan.PlanType.RIDE, TravelPlan.PlanType.HYBRID],
            origin_name__icontains=instance.origin_name,
            destination_name__icontains=instance.destination_name,
            departure_time__date=instance.scheduled_time.date(),
        )
        .exclude(created_by=instance.requester)
        .order_by("departure_time")
    )
    return queryset.first()


def _find_matching_plan_for_delivery(instance: DeliveryRequest):
    queryset = _filter_plans_for_fully_verified_creators(
        TravelPlan.objects.filter(
            status__in=[TravelPlan.Status.PUBLISHED, TravelPlan.Status.IN_PROGRESS],
            plan_type__in=[TravelPlan.PlanType.DELIVERY, TravelPlan.PlanType.HYBRID],
            origin_name__icontains=instance.pickup_name,
            destination_name__icontains=instance.dropoff_name,
            departure_time__date=instance.scheduled_time.date(),
        )
        .exclude(created_by=instance.requester)
        .order_by("departure_time")
    )
    return queryset.first()


def _resolve_owner_travel_plan(user, provided_id: str | None, allowed_types: list[str]):
    if not is_fully_verified_user(user):
        return None

    queryset = TravelPlan.objects.filter(
        created_by=user,
        status__in=[TravelPlan.Status.PUBLISHED, TravelPlan.Status.IN_PROGRESS],
        plan_type__in=allowed_types,
    ).order_by("-departure_time")

    if provided_id:
        return queryset.filter(id=provided_id).first()

    return queryset.first()


def _build_request_pin(source_id: str) -> str:
    digits = "".join(char for char in source_id if char.isdigit())
    if len(digits) >= 6:
        return digits[:6]

    seed = sum(ord(char) for char in source_id)
    return str(100000 + (seed % 900000))


def _matches_verification_code(source_id: str, submitted_code: str | None) -> bool:
    if not submitted_code:
        return False

    normalized = submitted_code.strip()
    return normalized == source_id or normalized == _build_request_pin(source_id)


class TravelPlanViewSet(viewsets.ModelViewSet):
    serializer_class = TravelPlanSerializer

    def get_queryset(self):
        if self.action in {"destroy", "update", "partial_update", "toggle_live"}:
            return TravelPlan.objects.select_related("created_by").filter(
                created_by=self.request.user
            )

        queryset = (
            TravelPlan.objects.select_related("created_by")
            .all()
            .order_by("-departure_time")
        )
        if self.request.query_params.get("mine") == "true":
            queryset = queryset.filter(created_by=self.request.user)
        else:
            queryset = queryset.exclude(created_by=self.request.user).filter(
                status__in=[TravelPlan.Status.PUBLISHED, TravelPlan.Status.IN_PROGRESS]
            )
            queryset = _filter_plans_for_fully_verified_creators(queryset)

        origin = sanitize_string(self.request.query_params.get("origin") or "")
        destination = sanitize_string(
            self.request.query_params.get("destination") or ""
        )
        plan_type = sanitize_string(self.request.query_params.get("plan_type") or "")
        date = sanitize_string(self.request.query_params.get("date") or "")
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
        serializer.save(
            created_by=self.request.user,
            status=self.request.data.get("status", TravelPlan.Status.PUBLISHED),
        )

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
            {
                "status": True,
                "message": "Live tracking updated.",
                "is_live": travel_plan.is_live,
                "travel_plan_id": str(travel_plan.id),
            }
        )


class RideRequestViewSet(viewsets.ModelViewSet):
    serializer_class = RideRequestSerializer

    def get_queryset(self):
        _expire_stale_requests(RideRequest, match_field="ride_request")
        queryset = RideRequest.objects.select_related(
            "matched_plan", "requester"
        ).order_by("-created_at")
        if self.request.query_params.get("discover") == "true":
            if not is_fully_verified_user(self.request.user):
                return queryset.none()
            return (
                queryset.filter(
                    status__in=[RideRequest.Status.OPEN, RideRequest.Status.MATCHED]
                )
                .exclude(requester=self.request.user)
                .exclude(travelmatch__status=TravelMatch.Status.ACCEPTED)
                .distinct()
            )
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

    @action(detail=True, methods=["post"])
    def bid(self, request, pk=None):
        ride_request = (
            self.get_queryset()
            .model.objects.filter(id=pk)
            .exclude(requester=request.user)
            .first()
        )
        if not ride_request:
            return response.Response(
                {"detail": "Ride request not found."}, status=status.HTTP_404_NOT_FOUND
            )

        if ride_request.status == RideRequest.Status.CANCELLED:
            return response.Response(
                {"detail": "This ride request is no longer available."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        if TravelMatch.objects.filter(
            ride_request=ride_request,
            status=TravelMatch.Status.ACCEPTED,
        ).exists():
            return response.Response(
                {"detail": "A mover has already been selected for this ride request."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        travel_plan = _resolve_owner_travel_plan(
            request.user,
            request.data.get("travel_plan_id"),
            [TravelPlan.PlanType.RIDE, TravelPlan.PlanType.HYBRID],
        )
        if not travel_plan:
            return response.Response(
                {"detail": "Create or publish a ride route before bidding."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        agreed_price = (
            request.data.get("agreed_price")
            or travel_plan.price_per_seat * ride_request.seats_requested
        )
        travel_match, _ = TravelMatch.objects.update_or_create(
            travel_plan=travel_plan,
            ride_request=ride_request,
            defaults={
                "match_type": TravelMatch.MatchType.RIDE,
                "agreed_price": agreed_price,
                "status": TravelMatch.Status.PROPOSED,
            },
        )

        ride_request.matched_plan = travel_plan
        ride_request.status = RideRequest.Status.MATCHED
        ride_request.save(update_fields=["matched_plan", "status", "updated_at"])

        return response.Response(
            TravelMatchSerializer(travel_match).data,
            status=status.HTTP_201_CREATED,
        )


class DeliveryRequestViewSet(viewsets.ModelViewSet):
    serializer_class = DeliveryRequestSerializer

    def get_queryset(self):
        _expire_stale_requests(DeliveryRequest, match_field="delivery_request")
        queryset = DeliveryRequest.objects.select_related(
            "matched_plan", "requester"
        ).order_by("-created_at")
        if self.request.query_params.get("discover") == "true":
            if not is_fully_verified_user(self.request.user):
                return queryset.none()
            return (
                queryset.filter(
                    status__in=[
                        DeliveryRequest.Status.OPEN,
                        DeliveryRequest.Status.MATCHED,
                    ]
                )
                .exclude(requester=self.request.user)
                .exclude(travelmatch__status=TravelMatch.Status.ACCEPTED)
                .distinct()
            )
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
                agreed_price=max(
                    matched_plan.price_per_seat, instance.insured_value * 0.01
                ),
                status=TravelMatch.Status.PROPOSED,
            )

    @action(detail=True, methods=["post"])
    def bid(self, request, pk=None):
        delivery_request = (
            self.get_queryset()
            .model.objects.filter(id=pk)
            .exclude(requester=request.user)
            .first()
        )
        if not delivery_request:
            return response.Response(
                {"detail": "Delivery request not found."},
                status=status.HTTP_404_NOT_FOUND,
            )

        if delivery_request.status == DeliveryRequest.Status.CANCELLED:
            return response.Response(
                {"detail": "This delivery request is no longer available."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        if TravelMatch.objects.filter(
            delivery_request=delivery_request,
            status=TravelMatch.Status.ACCEPTED,
        ).exists():
            return response.Response(
                {
                    "detail": "A mover has already been selected for this delivery request."
                },
                status=status.HTTP_400_BAD_REQUEST,
            )

        travel_plan = _resolve_owner_travel_plan(
            request.user,
            request.data.get("travel_plan_id"),
            [TravelPlan.PlanType.DELIVERY, TravelPlan.PlanType.HYBRID],
        )
        if not travel_plan:
            return response.Response(
                {"detail": "Create or publish a delivery route before bidding."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        base_price = max(
            float(travel_plan.price_per_seat),
            float(delivery_request.insured_value) * 0.01,
        )
        agreed_price = request.data.get("agreed_price") or base_price
        travel_match, _ = TravelMatch.objects.update_or_create(
            travel_plan=travel_plan,
            delivery_request=delivery_request,
            defaults={
                "match_type": TravelMatch.MatchType.DELIVERY,
                "agreed_price": agreed_price,
                "status": TravelMatch.Status.PROPOSED,
            },
        )

        delivery_request.matched_plan = travel_plan
        delivery_request.status = DeliveryRequest.Status.MATCHED
        delivery_request.save(update_fields=["matched_plan", "status", "updated_at"])

        return response.Response(
            TravelMatchSerializer(travel_match).data,
            status=status.HTTP_201_CREATED,
        )


class TravelMatchViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = TravelMatchSerializer

    def get_queryset(self):
        _expire_stale_accepted_matches()
        return (
            TravelMatch.objects.select_related(
                "travel_plan",
                "travel_plan__created_by",
                "ride_request",
                "ride_request__requester",
                "delivery_request",
                "delivery_request__requester",
            )
            .filter(
                Q(travel_plan__created_by=self.request.user)
                | Q(ride_request__requester=self.request.user)
                | Q(delivery_request__requester=self.request.user)
            )
            .order_by("-created_at")
        )

    def _resolve_participants(self, match: TravelMatch):
        ride_request = match.ride_request
        delivery_request = match.delivery_request
        requester = (
            ride_request.requester
            if ride_request is not None
            else delivery_request.requester if delivery_request is not None else None
        )
        mover = match.travel_plan.created_by
        return requester, mover

    @action(detail=True, methods=["post"])
    def accept(self, request, pk=None):
        match = self.get_queryset().filter(pk=pk).first()
        if not match:
            return response.Response(
                {"detail": "Match not found."}, status=status.HTTP_404_NOT_FOUND
            )

        ride_request = match.ride_request
        delivery_request = match.delivery_request
        requester, _ = self._resolve_participants(match)
        if requester != request.user:
            return response.Response(
                {"detail": "Only the requester can accept this offer."},
                status=status.HTTP_403_FORBIDDEN,
            )

        if match.status == TravelMatch.Status.ACCEPTED:
            return response.Response(TravelMatchSerializer(match).data)

        if match.status in {
            TravelMatch.Status.REJECTED,
            TravelMatch.Status.CANCELLED,
            TravelMatch.Status.COMPLETED,
        }:
            return response.Response(
                {"detail": "This offer can no longer be accepted."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        sibling_matches = TravelMatch.objects.filter(match_type=match.match_type)
        if ride_request is not None:
            sibling_matches = sibling_matches.filter(ride_request=ride_request)
        elif delivery_request is not None:
            sibling_matches = sibling_matches.filter(delivery_request=delivery_request)

        if (
            sibling_matches.exclude(pk=match.pk)
            .filter(status=TravelMatch.Status.ACCEPTED)
            .exists()
        ):
            return response.Response(
                {"detail": "A mover has already been selected for this request."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        with transaction.atomic():
            sibling_matches.exclude(pk=match.pk).exclude(
                status__in=[
                    TravelMatch.Status.REJECTED,
                    TravelMatch.Status.CANCELLED,
                ]
            ).update(status=TravelMatch.Status.REJECTED)

            match.status = TravelMatch.Status.ACCEPTED
            match.save(update_fields=["status"])

            if ride_request is not None:
                ride_request.matched_plan = match.travel_plan
                ride_request.status = RideRequest.Status.MATCHED
                ride_request.save(
                    update_fields=["matched_plan", "status", "updated_at"]
                )

            if delivery_request is not None:
                delivery_request.matched_plan = match.travel_plan
                delivery_request.status = DeliveryRequest.Status.MATCHED
                delivery_request.save(
                    update_fields=["matched_plan", "status", "updated_at"]
                )

        match.refresh_from_db()
        return response.Response(TravelMatchSerializer(match).data)

    @action(detail=True, methods=["post"])
    def cancel(self, request, pk=None):
        match = self.get_queryset().filter(pk=pk).first()
        if not match:
            return response.Response(
                {"detail": "Match not found."}, status=status.HTTP_404_NOT_FOUND
            )

        ride_request = match.ride_request
        delivery_request = match.delivery_request
        requester, _ = self._resolve_participants(match)
        is_mover = match.travel_plan.created_by == request.user
        is_requester = requester == request.user

        if not is_mover and not is_requester:
            return response.Response(
                {
                    "detail": "Only the assigned mover or requester can cancel this task."
                },
                status=status.HTTP_403_FORBIDDEN,
            )

        if match.status in {
            TravelMatch.Status.CANCELLED,
            TravelMatch.Status.COMPLETED,
        }:
            return response.Response(
                {"detail": "This task can no longer be cancelled."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        reason = request.data.get("reason", "").strip()
        notes = request.data.get("details", "").strip()

        with transaction.atomic():
            if is_requester and requester is not None:
                if ride_request is not None:
                    _cancel_request_and_siblings(
                        request_instance=ride_request,
                        actor=request.user,
                        reason=reason,
                        notes=notes,
                    )
                elif delivery_request is not None:
                    _cancel_request_and_siblings(
                        request_instance=delivery_request,
                        actor=request.user,
                        reason=reason,
                        notes=notes,
                    )
            else:
                _record_match_cancellation(
                    match,
                    actor=request.user,
                    reason=reason,
                    notes=notes,
                )
                _reset_request_after_match_cancel(match)

        match.refresh_from_db()
        return response.Response(TravelMatchSerializer(match).data)

    @action(detail=True, methods=["post"])
    def confirm_pickup(self, request, pk=None):
        match = self.get_queryset().filter(pk=pk).first()
        if not match or match.delivery_request is None:
            return response.Response(
                {"detail": "Delivery match not found."},
                status=status.HTTP_404_NOT_FOUND,
            )

        if match.travel_plan.created_by != request.user:
            return response.Response(
                {"detail": "Only the assigned mover can confirm pickup."},
                status=status.HTTP_403_FORBIDDEN,
            )

        if match.status not in {TravelMatch.Status.ACCEPTED, TravelMatch.Status.ACTIVE}:
            return response.Response(
                {"detail": "This delivery is not ready for pickup confirmation."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        verification_code = request.data.get("verification_code")
        delivery_request = match.delivery_request
        if not _matches_verification_code(str(delivery_request.id), verification_code):
            return response.Response(
                {"detail": "Invalid pickup verification code."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        with transaction.atomic():
            match.status = TravelMatch.Status.ACTIVE
            match.save(update_fields=["status"])
            delivery_request.status = DeliveryRequest.Status.IN_TRANSIT
            delivery_request.save(update_fields=["status", "updated_at"])

        match.refresh_from_db()
        return response.Response(TravelMatchSerializer(match).data)

    @action(detail=True, methods=["post"])
    def confirm_delivery(self, request, pk=None):
        match = self.get_queryset().filter(pk=pk).first()
        if not match or match.delivery_request is None:
            return response.Response(
                {"detail": "Delivery match not found."},
                status=status.HTTP_404_NOT_FOUND,
            )

        if match.travel_plan.created_by != request.user:
            return response.Response(
                {"detail": "Only the assigned mover can confirm delivery."},
                status=status.HTTP_403_FORBIDDEN,
            )

        if match.status != TravelMatch.Status.ACTIVE:
            return response.Response(
                {"detail": "This delivery is not currently in transit."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        verification_code = request.data.get("verification_code")
        delivery_request = match.delivery_request
        expected_delivery_code = f"{delivery_request.id}-delivered"
        expected_delivery_pin = _build_request_pin(f"{delivery_request.id}-delivered")
        normalized = (verification_code or "").strip()
        if normalized not in {expected_delivery_code, expected_delivery_pin}:
            return response.Response(
                {"detail": "Invalid delivery confirmation code."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        with transaction.atomic():
            match.status = TravelMatch.Status.COMPLETED
            match.save(update_fields=["status"])
            delivery_request.status = DeliveryRequest.Status.DELIVERED
            delivery_request.save(update_fields=["status", "updated_at"])

        match.refresh_from_db()
        return response.Response(TravelMatchSerializer(match).data)

    @action(detail=True, methods=["post"])
    def start_ride(self, request, pk=None):
        match = self.get_queryset().filter(pk=pk).first()
        if not match or match.ride_request is None:
            return response.Response(
                {"detail": "Ride match not found."}, status=status.HTTP_404_NOT_FOUND
            )

        if match.travel_plan.created_by != request.user:
            return response.Response(
                {"detail": "Only the assigned mover can start this trip."},
                status=status.HTTP_403_FORBIDDEN,
            )

        if match.status not in {TravelMatch.Status.ACCEPTED, TravelMatch.Status.ACTIVE}:
            return response.Response(
                {"detail": "This ride is not ready to start."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        with transaction.atomic():
            match.status = TravelMatch.Status.ACTIVE
            match.save(update_fields=["status"])
            ride_request = match.ride_request
            ride_request.status = RideRequest.Status.PICKED_UP
            ride_request.save(update_fields=["status", "updated_at"])

        match.refresh_from_db()
        return response.Response(TravelMatchSerializer(match).data)

    @action(detail=True, methods=["post"])
    def end_ride(self, request, pk=None):
        match = self.get_queryset().filter(pk=pk).first()
        if not match or match.ride_request is None:
            return response.Response(
                {"detail": "Ride match not found."}, status=status.HTTP_404_NOT_FOUND
            )

        if match.travel_plan.created_by != request.user:
            return response.Response(
                {"detail": "Only the assigned mover can end this trip."},
                status=status.HTTP_403_FORBIDDEN,
            )

        if match.status != TravelMatch.Status.ACTIVE:
            return response.Response(
                {"detail": "This ride has not started yet."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        with transaction.atomic():
            match.status = TravelMatch.Status.COMPLETED
            match.save(update_fields=["status"])
            ride_request = match.ride_request
            ride_request.status = RideRequest.Status.COMPLETED
            ride_request.save(update_fields=["status", "updated_at"])

        match.refresh_from_db()
        return response.Response(TravelMatchSerializer(match).data)

    @action(detail=True, methods=["post"])
    def review(self, request, pk=None):
        match = self.get_queryset().filter(pk=pk).first()
        if not match:
            return response.Response(
                {"detail": "Match not found."}, status=status.HTTP_404_NOT_FOUND
            )

        if match.status != TravelMatch.Status.COMPLETED:
            return response.Response(
                {"detail": "Reviews can only be submitted after a task is completed."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        requester, mover = self._resolve_participants(match)

        if request.user == mover and requester is not None:
            reviewee = requester
        elif request.user == requester:
            reviewee = mover
        else:
            return response.Response(
                {"detail": "Only participants in this task can submit a review."},
                status=status.HTTP_403_FORBIDDEN,
            )

        rating = int(request.data.get("rating") or 0)
        if rating < 1 or rating > 5:
            return response.Response(
                {"detail": "Rating must be between 1 and 5."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        review, _ = TaskReview.objects.update_or_create(
            match=match,
            reviewer=request.user,
            defaults={
                "review_type": match.match_type,
                "reviewee": reviewee,
                "rating": rating,
                "comment": request.data.get("comment", "").strip(),
                "tags": request.data.get("tags", []),
            },
        )
        return response.Response(TaskReviewSerializer(review).data)

    @action(detail=True, methods=["get", "post"])
    def messages(self, request, pk=None):
        match = self.get_queryset().filter(pk=pk).first()
        if not match:
            return response.Response(
                {"detail": "Match not found."}, status=status.HTTP_404_NOT_FOUND
            )

        requester, mover = self._resolve_participants(match)
        if request.user not in {requester, mover}:
            return response.Response(
                {"detail": "Only participants in this task can access messages."},
                status=status.HTTP_403_FORBIDDEN,
            )

        if request.method.lower() == "get":
            messages = match.messages.select_related("sender").order_by("-created_at")
            page = self.paginate_queryset(messages)
            if page is not None:
                serializer = TaskMessageSerializer(page, many=True)
                return self.get_paginated_response(serializer.data)
            return response.Response(TaskMessageSerializer(messages, many=True).data)

        body = (request.data.get("body") or "").strip()
        if not body:
            return response.Response(
                {"detail": "Message body cannot be empty."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        message = TaskMessage.objects.create(
            match=match,
            sender=request.user,
            body=body,
        )
        return response.Response(
            TaskMessageSerializer(message).data,
            status=status.HTTP_201_CREATED,
        )

    @action(detail=True, methods=["post"])
    def report(self, request, pk=None):
        match = self.get_queryset().filter(pk=pk).first()
        if not match:
            return response.Response(
                {"detail": "Match not found."}, status=status.HTTP_404_NOT_FOUND
            )

        requester, mover = self._resolve_participants(match)
        if request.user not in {requester, mover}:
            return response.Response(
                {"detail": "Only participants in this task can submit a report."},
                status=status.HTTP_403_FORBIDDEN,
            )

        reason = (request.data.get("reason") or "").strip()
        details = (request.data.get("details") or "").strip()
        if not reason:
            return response.Response(
                {"detail": "Please choose a reason first."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        report = TaskIncidentReport.objects.create(
            match=match,
            reporter=request.user,
            reason=reason,
            details=details,
        )
        return response.Response(
            TaskIncidentReportSerializer(report).data,
            status=status.HTTP_201_CREATED,
        )


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
        event = TrackingEvent.objects.create(
            session=session, actor=request.user, **serializer.validated_data
        )
        return response.Response(
            TrackingEventSerializer(event).data, status=status.HTTP_201_CREATED
        )


class EmergencyAlertViewSet(viewsets.ModelViewSet):
    serializer_class = EmergencyAlertSerializer

    def get_queryset(self):
        return EmergencyAlert.objects.filter(user=self.request.user).order_by(
            "-created_at"
        )

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class MobilityDashboardView(APIView):
    def get(self, request):
        return response.Response(
            {
                "published_travel_plans": request.user.travel_plans.filter(
                    status__in=[
                        TravelPlan.Status.PUBLISHED,
                        TravelPlan.Status.IN_PROGRESS,
                    ]
                ).count(),
                "ride_requests": request.user.ride_requests.count(),
                "delivery_requests": request.user.delivery_requests.count(),
                "active_matches": TravelMatch.objects.filter(
                    Q(travel_plan__created_by=request.user)
                    | Q(ride_request__requester=request.user)
                    | Q(delivery_request__requester=request.user),
                    status__in=[
                        TravelMatch.Status.PROPOSED,
                        TravelMatch.Status.ACCEPTED,
                        TravelMatch.Status.ACTIVE,
                    ],
                ).count(),
                "live_routes": request.user.travel_plans.filter(is_live=True).count(),
            }
        )


class LegacyToggleLiveStatusView(APIView):
    def post(self, request, travel_plan_id):
        travel_plan = TravelPlan.objects.filter(
            id=travel_plan_id, created_by=request.user
        ).first()
        if not travel_plan:
            return response.Response(
                {"status": False, "message": "Travel plan not found."},
                status=status.HTTP_404_NOT_FOUND,
            )

        is_live = bool(request.data.get("is_live", False))
        travel_plan.is_live = is_live
        if is_live and travel_plan.status == TravelPlan.Status.PUBLISHED:
            travel_plan.status = TravelPlan.Status.IN_PROGRESS
        if not is_live and travel_plan.status == TravelPlan.Status.IN_PROGRESS:
            travel_plan.status = TravelPlan.Status.PUBLISHED
        travel_plan.save(update_fields=["is_live", "status", "updated_at"])
        TrackingSession.objects.get_or_create(travel_plan=travel_plan)
        return response.Response(
            {
                "status": True,
                "message": "Live status updated successfully.",
                "is_live": travel_plan.is_live,
            }
        )

from __future__ import annotations

import uuid

from django.conf import settings
from django.db import models


class TravelPlan(models.Model):
    class PlanType(models.TextChoices):
        RIDE = "ride", "Ride"
        DELIVERY = "delivery", "Delivery"
        HYBRID = "hybrid", "Hybrid"

    class Status(models.TextChoices):
        DRAFT = "draft", "Draft"
        PUBLISHED = "published", "Published"
        IN_PROGRESS = "in_progress", "In progress"
        COMPLETED = "completed", "Completed"
        CANCELLED = "cancelled", "Cancelled"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="travel_plans"
    )
    title = models.CharField(max_length=140)
    plan_type = models.CharField(
        max_length=16, choices=PlanType.choices, default=PlanType.HYBRID
    )
    status = models.CharField(
        max_length=16, choices=Status.choices, default=Status.DRAFT, db_index=True
    )
    origin_name = models.CharField(max_length=255)
    origin_latitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    origin_longitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    destination_name = models.CharField(max_length=255)
    destination_latitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    destination_longitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    departure_time = models.DateTimeField(db_index=True)
    arrival_time = models.DateTimeField(null=True, blank=True)
    vehicle_type = models.CharField(max_length=32, blank=True)
    seats_available = models.PositiveSmallIntegerField(default=1)
    price_per_seat = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    package_capacity_kg = models.DecimalField(
        max_digits=10, decimal_places=2, default=0
    )
    is_live = models.BooleanField(default=False)
    metadata = models.JSONField(default=dict, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


class RideRequest(models.Model):
    class Status(models.TextChoices):
        OPEN = "open", "Open"
        MATCHED = "matched", "Matched"
        PICKED_UP = "picked_up", "Picked up"
        COMPLETED = "completed", "Completed"
        CANCELLED = "cancelled", "Cancelled"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    requester = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="ride_requests"
    )
    matched_plan = models.ForeignKey(
        TravelPlan,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="matched_ride_requests",
    )
    origin_name = models.CharField(max_length=255)
    destination_name = models.CharField(max_length=255)
    origin_latitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    origin_longitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    destination_latitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    destination_longitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    scheduled_time = models.DateTimeField()
    seats_requested = models.PositiveSmallIntegerField(default=1)
    note = models.TextField(blank=True)
    status = models.CharField(
        max_length=16, choices=Status.choices, default=Status.OPEN, db_index=True
    )
    cancelled_reason = models.CharField(max_length=255, blank=True)
    cancelled_notes = models.TextField(blank=True)
    cancelled_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="cancelled_ride_requests",
    )
    cancelled_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


class DeliveryRequest(models.Model):
    class Status(models.TextChoices):
        OPEN = "open", "Open"
        MATCHED = "matched", "Matched"
        IN_TRANSIT = "in_transit", "In transit"
        DELIVERED = "delivered", "Delivered"
        DAMAGED = "damaged", "Damaged"
        CANCELLED = "cancelled", "Cancelled"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    requester = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="delivery_requests",
    )
    matched_plan = models.ForeignKey(
        TravelPlan,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="matched_delivery_requests",
    )
    pickup_name = models.CharField(max_length=255)
    dropoff_name = models.CharField(max_length=255)
    pickup_latitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    pickup_longitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    dropoff_latitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    dropoff_longitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    scheduled_time = models.DateTimeField()
    package_description = models.TextField()
    weight_kg = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    insured_value = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    insurance_opted = models.BooleanField(default=False)
    damage_report = models.JSONField(default=dict, blank=True)
    status = models.CharField(
        max_length=16, choices=Status.choices, default=Status.OPEN, db_index=True
    )
    cancelled_reason = models.CharField(max_length=255, blank=True)
    cancelled_notes = models.TextField(blank=True)
    cancelled_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="cancelled_delivery_requests",
    )
    cancelled_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


class TravelMatch(models.Model):
    class MatchType(models.TextChoices):
        RIDE = "ride", "Ride"
        DELIVERY = "delivery", "Delivery"

    class Status(models.TextChoices):
        PROPOSED = "proposed", "Proposed"
        ACCEPTED = "accepted", "Accepted"
        REJECTED = "rejected", "Rejected"
        ACTIVE = "active", "Active"
        COMPLETED = "completed", "Completed"
        CANCELLED = "cancelled", "Cancelled"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    travel_plan = models.ForeignKey(
        TravelPlan, on_delete=models.CASCADE, related_name="matches"
    )
    ride_request = models.ForeignKey(
        RideRequest, on_delete=models.CASCADE, null=True, blank=True
    )
    delivery_request = models.ForeignKey(
        DeliveryRequest, on_delete=models.CASCADE, null=True, blank=True
    )
    match_type = models.CharField(max_length=16, choices=MatchType.choices)
    agreed_price = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    status = models.CharField(
        max_length=16, choices=Status.choices, default=Status.PROPOSED, db_index=True
    )
    cancelled_reason = models.CharField(max_length=255, blank=True)
    cancelled_notes = models.TextField(blank=True)
    cancelled_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="cancelled_matches",
    )
    cancelled_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)


class TaskReview(models.Model):
    class ReviewType(models.TextChoices):
        RIDE = "ride", "Ride"
        DELIVERY = "delivery", "Delivery"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    match = models.ForeignKey(
        TravelMatch, on_delete=models.CASCADE, related_name="reviews"
    )
    review_type = models.CharField(max_length=16, choices=ReviewType.choices)
    reviewer = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="written_reviews",
    )
    reviewee = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="received_reviews",
    )
    rating = models.PositiveSmallIntegerField()
    comment = models.TextField(blank=True)
    tags = models.JSONField(default=list, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=["match", "reviewer"],
                name="unique_task_review_per_reviewer",
            )
        ]


class TaskMessage(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    match = models.ForeignKey(
        TravelMatch, on_delete=models.CASCADE, related_name="messages"
    )
    sender = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="sent_task_messages",
    )
    body = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ["created_at"]


class TaskIncidentReport(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    match = models.ForeignKey(
        TravelMatch, on_delete=models.CASCADE, related_name="incident_reports"
    )
    reporter = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="task_incident_reports",
    )
    reason = models.CharField(max_length=255)
    details = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]


class TrackingSession(models.Model):
    class Status(models.TextChoices):
        IDLE = "idle", "Idle"
        LIVE = "live", "Live"
        PAUSED = "paused", "Paused"
        ENDED = "ended", "Ended"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    travel_plan = models.OneToOneField(
        TravelPlan, on_delete=models.CASCADE, related_name="tracking_session"
    )
    status = models.CharField(
        max_length=16, choices=Status.choices, default=Status.IDLE, db_index=True
    )
    started_at = models.DateTimeField(null=True, blank=True)
    ended_at = models.DateTimeField(null=True, blank=True)
    updated_at = models.DateTimeField(auto_now=True)


class TrackingEvent(models.Model):
    class EventType(models.TextChoices):
        LOCATION = "location", "Location"
        STATUS = "status", "Status"
        NOTE = "note", "Note"
        SOS = "sos", "SOS"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    session = models.ForeignKey(
        TrackingSession, on_delete=models.CASCADE, related_name="events"
    )
    actor = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="tracking_events",
    )
    event_type = models.CharField(
        max_length=16, choices=EventType.choices, default=EventType.LOCATION
    )
    latitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    longitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    note = models.CharField(max_length=255, blank=True)
    payload = models.JSONField(default=dict, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)


class EmergencyAlert(models.Model):
    class Status(models.TextChoices):
        OPEN = "open", "Open"
        ACKNOWLEDGED = "acknowledged", "Acknowledged"
        RESOLVED = "resolved", "Resolved"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="emergency_alerts",
    )
    travel_plan = models.ForeignKey(
        TravelPlan, on_delete=models.SET_NULL, null=True, blank=True
    )
    latitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    longitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    message = models.CharField(max_length=255, blank=True)
    status = models.CharField(
        max_length=16, choices=Status.choices, default=Status.OPEN, db_index=True
    )
    created_at = models.DateTimeField(auto_now_add=True)

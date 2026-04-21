from django.contrib import admin

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


@admin.register(TravelPlan)
class TravelPlanAdmin(admin.ModelAdmin):
    list_display = ("title", "created_by", "plan_type", "status", "origin_name", "destination_name", "departure_time", "is_live")
    list_filter = ("plan_type", "status", "is_live", "vehicle_type")
    search_fields = ("title", "created_by__email", "origin_name", "destination_name")
    raw_id_fields = ("created_by",)
    readonly_fields = ("created_at", "updated_at")
    date_hierarchy = "departure_time"


@admin.register(RideRequest)
class RideRequestAdmin(admin.ModelAdmin):
    list_display = ("requester", "status", "origin_name", "destination_name", "scheduled_time", "seats_requested", "created_at")
    list_filter = ("status", "scheduled_time")
    search_fields = ("requester__email", "origin_name", "destination_name", "note", "cancelled_reason")
    raw_id_fields = ("requester", "matched_plan", "cancelled_by")
    readonly_fields = ("created_at", "updated_at", "cancelled_at")
    date_hierarchy = "scheduled_time"


@admin.register(DeliveryRequest)
class DeliveryRequestAdmin(admin.ModelAdmin):
    list_display = ("requester", "status", "pickup_name", "dropoff_name", "scheduled_time", "weight_kg", "insurance_opted")
    list_filter = ("status", "insurance_opted", "scheduled_time")
    search_fields = ("requester__email", "pickup_name", "dropoff_name", "package_description", "cancelled_reason")
    raw_id_fields = ("requester", "matched_plan", "cancelled_by")
    readonly_fields = ("created_at", "updated_at", "cancelled_at")
    date_hierarchy = "scheduled_time"


@admin.register(TravelMatch)
class TravelMatchAdmin(admin.ModelAdmin):
    list_display = ("match_type", "status", "travel_plan", "agreed_price", "created_at")
    list_filter = ("match_type", "status")
    search_fields = (
        "travel_plan__title",
        "travel_plan__created_by__email",
        "ride_request__requester__email",
        "delivery_request__requester__email",
        "cancelled_reason",
    )
    raw_id_fields = ("travel_plan", "ride_request", "delivery_request", "cancelled_by")
    readonly_fields = ("created_at", "cancelled_at")


@admin.register(TaskReview)
class TaskReviewAdmin(admin.ModelAdmin):
    list_display = ("review_type", "reviewer", "reviewee", "rating", "created_at")
    list_filter = ("review_type", "rating")
    search_fields = ("reviewer__email", "reviewee__email", "comment")
    raw_id_fields = ("match", "reviewer", "reviewee")
    readonly_fields = ("created_at", "updated_at")


@admin.register(TaskMessage)
class TaskMessageAdmin(admin.ModelAdmin):
    list_display = ("match", "sender", "short_body", "created_at")
    search_fields = ("sender__email", "body")
    raw_id_fields = ("match", "sender")
    readonly_fields = ("created_at", "updated_at")

    @admin.display(description="Message")
    def short_body(self, obj):
        return obj.body[:80]


@admin.register(TaskIncidentReport)
class TaskIncidentReportAdmin(admin.ModelAdmin):
    list_display = ("match", "reporter", "reason", "created_at")
    search_fields = ("reporter__email", "reason", "details")
    raw_id_fields = ("match", "reporter")
    readonly_fields = ("created_at",)


@admin.register(TrackingSession)
class TrackingSessionAdmin(admin.ModelAdmin):
    list_display = ("travel_plan", "status", "started_at", "ended_at", "updated_at")
    list_filter = ("status",)
    search_fields = ("travel_plan__title", "travel_plan__created_by__email")
    raw_id_fields = ("travel_plan",)
    readonly_fields = ("updated_at",)


@admin.register(TrackingEvent)
class TrackingEventAdmin(admin.ModelAdmin):
    list_display = ("session", "actor", "event_type", "latitude", "longitude", "created_at")
    list_filter = ("event_type",)
    search_fields = ("actor__email", "note")
    raw_id_fields = ("session", "actor")
    readonly_fields = ("created_at",)


@admin.register(EmergencyAlert)
class EmergencyAlertAdmin(admin.ModelAdmin):
    list_display = ("user", "status", "message", "latitude", "longitude", "created_at")
    list_filter = ("status",)
    search_fields = ("user__email", "message")
    raw_id_fields = ("user", "travel_plan")
    readonly_fields = ("created_at",)

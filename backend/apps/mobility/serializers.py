from __future__ import annotations

from django.contrib.auth import get_user_model
from django.db.models import Avg
from rest_framework import serializers

from .models import DeliveryRequest, EmergencyAlert, RideRequest, TaskIncidentReport, TaskMessage, TaskReview, TrackingEvent, TrackingSession, TravelMatch, TravelPlan

User = get_user_model()


class UserSummarySerializer(serializers.ModelSerializer):
    full_name = serializers.SerializerMethodField()
    home_away_label = serializers.SerializerMethodField()
    rating_count = serializers.SerializerMethodField()
    average_rating = serializers.SerializerMethodField()
    completed_jobs = serializers.SerializerMethodField()
    linked_socials = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            "id",
            "email",
            "phone_number",
            "full_name",
            "home_city",
            "current_city",
            "home_away_label",
            "rating_count",
            "average_rating",
            "completed_jobs",
            "linked_socials",
        ]

    def get_full_name(self, obj):
        return obj.get_full_name() or obj.email

    def get_home_away_label(self, obj):
        if obj.home_city and obj.current_city and obj.home_city.lower() != obj.current_city.lower():
            return "away"
        return "home"

    def get_rating_count(self, obj):
        return obj.received_reviews.count()

    def get_average_rating(self, obj):
        aggregate = obj.received_reviews.aggregate(value=Avg("rating"))
        return round(float(aggregate["value"] or 0), 1)

    def get_completed_jobs(self, obj):
        return TravelMatch.objects.filter(
            travel_plan__created_by=obj,
            status=TravelMatch.Status.COMPLETED,
        ).count()

    def get_linked_socials(self, obj):
        profile = getattr(obj, "profile", None)
        return profile.linked_socials if profile else {}


class TravelPlanSerializer(serializers.ModelSerializer):
    created_by = UserSummarySerializer(read_only=True)

    class Meta:
        model = TravelPlan
        fields = "__all__"
        read_only_fields = ["created_by", "is_live", "created_at", "updated_at"]


class RideRequestSerializer(serializers.ModelSerializer):
    requester = UserSummarySerializer(read_only=True)

    class Meta:
        model = RideRequest
        fields = "__all__"
        read_only_fields = ["requester", "status", "created_at", "updated_at"]


class DeliveryRequestSerializer(serializers.ModelSerializer):
    requester = UserSummarySerializer(read_only=True)

    class Meta:
        model = DeliveryRequest
        fields = "__all__"
        read_only_fields = ["requester", "status", "created_at", "updated_at", "damage_report"]


class TravelMatchSerializer(serializers.ModelSerializer):
    travel_plan = TravelPlanSerializer(read_only=True)
    ride_request = RideRequestSerializer(read_only=True)
    delivery_request = DeliveryRequestSerializer(read_only=True)
    reviews = serializers.SerializerMethodField()

    class Meta:
        model = TravelMatch
        fields = "__all__"

    def get_reviews(self, obj):
        return TaskReviewSerializer(obj.reviews.all(), many=True).data


class TrackingEventSerializer(serializers.ModelSerializer):
    actor = UserSummarySerializer(read_only=True)

    class Meta:
        model = TrackingEvent
        fields = "__all__"
        read_only_fields = ["actor", "session", "created_at"]


class TrackingSessionSerializer(serializers.ModelSerializer):
    events = TrackingEventSerializer(many=True, read_only=True)

    class Meta:
        model = TrackingSession
        fields = ["id", "travel_plan", "status", "started_at", "ended_at", "updated_at", "events"]


class EmergencyAlertSerializer(serializers.ModelSerializer):
    class Meta:
        model = EmergencyAlert
        fields = "__all__"
        read_only_fields = ["user", "status", "created_at"]


class TaskReviewSerializer(serializers.ModelSerializer):
    reviewer = UserSummarySerializer(read_only=True)
    reviewee = UserSummarySerializer(read_only=True)

    class Meta:
        model = TaskReview
        fields = "__all__"
        read_only_fields = ["reviewer", "reviewee", "match", "created_at", "updated_at"]


class TaskMessageSerializer(serializers.ModelSerializer):
    sender = UserSummarySerializer(read_only=True)

    class Meta:
        model = TaskMessage
        fields = "__all__"
        read_only_fields = ["sender", "match", "created_at", "updated_at"]


class TaskIncidentReportSerializer(serializers.ModelSerializer):
    reporter = UserSummarySerializer(read_only=True)

    class Meta:
        model = TaskIncidentReport
        fields = "__all__"
        read_only_fields = ["reporter", "match", "created_at"]

from __future__ import annotations

from django.contrib.auth import get_user_model
from rest_framework import serializers

from .models import DeliveryRequest, EmergencyAlert, RideRequest, TrackingEvent, TrackingSession, TravelMatch, TravelPlan

User = get_user_model()


class UserSummarySerializer(serializers.ModelSerializer):
    full_name = serializers.SerializerMethodField()
    home_away_label = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ["id", "email", "full_name", "home_city", "current_city", "home_away_label"]

    def get_full_name(self, obj):
        return obj.get_full_name() or obj.email

    def get_home_away_label(self, obj):
        if obj.home_city and obj.current_city and obj.home_city.lower() != obj.current_city.lower():
            return "away"
        return "home"


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

    class Meta:
        model = TravelMatch
        fields = "__all__"


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

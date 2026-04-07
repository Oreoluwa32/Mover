from django.contrib import admin

from .models import DeliveryRequest, EmergencyAlert, RideRequest, TrackingEvent, TrackingSession, TravelMatch, TravelPlan

admin.site.register(TravelPlan)
admin.site.register(RideRequest)
admin.site.register(DeliveryRequest)
admin.site.register(TravelMatch)
admin.site.register(TrackingSession)
admin.site.register(TrackingEvent)
admin.site.register(EmergencyAlert)

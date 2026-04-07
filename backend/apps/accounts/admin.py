from django.contrib import admin

from .models import KycRecord, User, UserProfile, Vehicle

admin.site.register(User)
admin.site.register(UserProfile)
admin.site.register(Vehicle)
admin.site.register(KycRecord)

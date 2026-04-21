from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin

from .models import KycRecord, User, UserProfile, Vehicle


@admin.register(User)
class UserAdmin(DjangoUserAdmin):
    ordering = ("email",)
    list_display = (
        "email",
        "account_type",
        "auth_provider",
        "is_active",
        "is_staff",
        "is_email_verified",
        "is_phone_verified",
        "created_at",
    )
    list_filter = (
        "account_type",
        "auth_provider",
        "is_active",
        "is_staff",
        "is_email_verified",
        "is_phone_verified",
    )
    search_fields = ("email", "phone_number", "first_name", "last_name", "home_city", "current_city")
    readonly_fields = ("created_at", "updated_at", "last_login", "date_joined")
    fieldsets = (
        (None, {"fields": ("email", "password")}),
        ("Personal information", {"fields": ("first_name", "last_name", "phone_number")}),
        (
            "Movr profile",
            {
                "fields": (
                    "account_type",
                    "auth_provider",
                    "home_city",
                    "current_city",
                    "is_phone_verified",
                    "is_email_verified",
                )
            },
        ),
        ("Permissions", {"fields": ("is_active", "is_staff", "is_superuser", "groups", "user_permissions")}),
        ("Important dates", {"fields": ("last_login", "date_joined", "created_at", "updated_at")}),
    )
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": (
                    "email",
                    "password1",
                    "password2",
                    "account_type",
                    "auth_provider",
                    "is_active",
                    "is_staff",
                    "is_superuser",
                ),
            },
        ),
    )


@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ("user", "gender", "address", "created_at", "updated_at")
    search_fields = ("user__email", "emergency_contact_name", "emergency_contact_phone", "address")
    raw_id_fields = ("user",)
    readonly_fields = ("created_at", "updated_at")


@admin.register(Vehicle)
class VehicleAdmin(admin.ModelAdmin):
    list_display = ("owner", "vehicle_type", "make", "model", "plate_number", "seats", "is_verified", "created_at")
    list_filter = ("vehicle_type", "is_verified")
    search_fields = ("owner__email", "make", "model", "plate_number", "color")
    raw_id_fields = ("owner",)
    readonly_fields = ("created_at",)


@admin.register(KycRecord)
class KycRecordAdmin(admin.ModelAdmin):
    list_display = ("user", "status", "submitted_at", "updated_at")
    list_filter = ("status",)
    search_fields = ("user__email", "bvn", "nin")
    raw_id_fields = ("user",)
    readonly_fields = ("submitted_at", "updated_at")

from django.conf import settings
from django.contrib import admin, messages
from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin
from django.utils.html import format_html

from .models import KycRecord, User, UserProfile, Vehicle
from .storage_utils import StorageConfigurationError, resolve_supabase_asset_url


def _vehicle_metadata(instance: Vehicle) -> dict:
    return instance.metadata if isinstance(instance.metadata, dict) else {}


def _resolve_vehicle_asset_url(value: str | None) -> str:
    if not value:
        return ""
    try:
        return resolve_supabase_asset_url(
            value,
            bucket=settings.SUPABASE_VEHICLE_BUCKET,
            public_access=settings.SUPABASE_STORAGE_VEHICLE_PUBLIC,
            supabase_url=settings.SUPABASE_URL,
            service_role_key=settings.SUPABASE_SERVICE_ROLE_KEY,
            signed_url_ttl_seconds=settings.SUPABASE_STORAGE_SIGNED_URL_TTL_SECONDS,
        )
    except (StorageConfigurationError, ValueError):
        return value or ""


class VehicleReviewStatusFilter(admin.SimpleListFilter):
    title = "review status"
    parameter_name = "review_status"

    def lookups(self, request, model_admin):
        return (
            ("pending", "Pending"),
            ("verified", "Verified"),
            ("rejected", "Rejected"),
        )

    def queryset(self, request, queryset):
        value = self.value()
        if value == "verified":
            return queryset.filter(is_verified=True)
        if value == "rejected":
            return queryset.filter(metadata__review_status="rejected")
        if value == "pending":
            return queryset.exclude(is_verified=True).exclude(
                metadata__review_status="rejected"
            )
        return queryset


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
    search_fields = (
        "email",
        "phone_number",
        "first_name",
        "last_name",
        "home_city",
        "current_city",
    )
    readonly_fields = ("created_at", "updated_at", "last_login", "date_joined")
    fieldsets = (
        (None, {"fields": ("email", "password")}),
        (
            "Personal information",
            {"fields": ("first_name", "last_name", "phone_number")},
        ),
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
        (
            "Permissions",
            {
                "fields": (
                    "is_active",
                    "is_staff",
                    "is_superuser",
                    "groups",
                    "user_permissions",
                )
            },
        ),
        (
            "Important dates",
            {"fields": ("last_login", "date_joined", "created_at", "updated_at")},
        ),
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
    search_fields = (
        "user__email",
        "emergency_contact_name",
        "emergency_contact_phone",
        "address",
    )
    raw_id_fields = ("user",)
    readonly_fields = ("created_at", "updated_at")


@admin.register(Vehicle)
class VehicleAdmin(admin.ModelAdmin):
    list_display = (
        "owner",
        "vehicle_type",
        "make",
        "model",
        "plate_number",
        "review_status_badge",
        "seats",
        "created_at",
    )
    list_filter = ("vehicle_type", "is_verified", VehicleReviewStatusFilter)
    search_fields = ("owner__email", "make", "model", "plate_number", "color")
    raw_id_fields = ("owner",)
    readonly_fields = (
        "created_at",
        "vehicle_review_status",
        "vehicle_reviewer_notes",
        "vehicle_photo_preview",
        "driver_license_preview",
        "vehicle_report_preview",
        "vehicle_insurance_preview",
        "vehicle_documents_summary",
    )
    actions = (
        "mark_vehicle_pending",
        "approve_vehicle_documents",
        "reject_vehicle_documents",
    )
    fieldsets = (
        (
            "Vehicle details",
            {
                "fields": (
                    "owner",
                    "vehicle_type",
                    "make",
                    "model",
                    "color",
                    "plate_number",
                    "seats",
                    "created_at",
                )
            },
        ),
        (
            "Review",
            {
                "fields": (
                    "vehicle_review_status",
                    "is_verified",
                    "vehicle_reviewer_notes",
                )
            },
        ),
        (
            "Uploaded documents",
            {
                "fields": (
                    "vehicle_documents_summary",
                    "vehicle_photo_preview",
                    "driver_license_preview",
                    "vehicle_report_preview",
                    "vehicle_insurance_preview",
                )
            },
        ),
    )

    @admin.display(description="Review status")
    def review_status_badge(self, obj: Vehicle):
        status = self._vehicle_review_status(obj)
        color = {
            "verified": "#2E7D32",
            "rejected": "#C62828",
            "pending": "#F9A825",
        }.get(status, "#6D6D6D")
        label = status.replace("_", " ").title()
        return format_html(
            '<span style="padding:4px 10px;border-radius:999px;background:{}20;color:{};font-weight:600;">{}</span>',
            color,
            color,
            label,
        )

    @admin.display(description="Review status")
    def vehicle_review_status(self, obj: Vehicle):
        return self._vehicle_review_status(obj).replace("_", " ").title()

    @admin.display(description="Reviewer notes")
    def vehicle_reviewer_notes(self, obj: Vehicle):
        return _vehicle_metadata(obj).get("reviewer_notes", "") or "No notes."

    @admin.display(description="Uploaded documents")
    def vehicle_documents_summary(self, obj: Vehicle):
        metadata = _vehicle_metadata(obj)
        labels = {
            "vehicle_photo": "Vehicle photo",
            "driver_license": "Driver's license",
            "vehicle_report": "Vehicle report",
            "vehicle_insurance": "Vehicle insurance",
        }
        rows = []
        for key, label in labels.items():
            url = _resolve_vehicle_asset_url(metadata.get(key))
            if not url:
                rows.append(f"<li>{label}: missing</li>")
                continue
            rows.append(
                f'<li>{label}: <a href="{url}" target="_blank" rel="noopener noreferrer">open file</a></li>'
            )
        return format_html(
            "<ul style='margin:0;padding-left:18px;'>{}</ul>",
            format_html("".join(rows)),
        )

    @admin.display(description="Vehicle photo")
    def vehicle_photo_preview(self, obj: Vehicle):
        return self._document_preview(obj, "vehicle_photo", "Vehicle photo")

    @admin.display(description="Driver's license")
    def driver_license_preview(self, obj: Vehicle):
        return self._document_preview(obj, "driver_license", "Driver's license")

    @admin.display(description="Vehicle report")
    def vehicle_report_preview(self, obj: Vehicle):
        return self._document_preview(obj, "vehicle_report", "Vehicle report")

    @admin.display(description="Vehicle insurance")
    def vehicle_insurance_preview(self, obj: Vehicle):
        return self._document_preview(obj, "vehicle_insurance", "Vehicle insurance")

    @admin.action(description="Mark selected vehicle documents as pending review")
    def mark_vehicle_pending(self, request, queryset):
        updated = 0
        for vehicle in queryset:
            metadata = _vehicle_metadata(vehicle)
            metadata["review_status"] = "pending"
            metadata["reviewer_notes"] = ""
            vehicle.metadata = metadata
            vehicle.is_verified = False
            vehicle.save(update_fields=["metadata", "is_verified"])
            updated += 1
        self.message_user(
            request,
            f"{updated} vehicle submission(s) marked as pending review.",
            level=messages.SUCCESS,
        )

    @admin.action(description="Approve selected vehicle documents")
    def approve_vehicle_documents(self, request, queryset):
        updated = 0
        for vehicle in queryset:
            metadata = _vehicle_metadata(vehicle)
            metadata["review_status"] = "verified"
            vehicle.metadata = metadata
            vehicle.is_verified = True
            vehicle.save(update_fields=["metadata", "is_verified"])
            updated += 1
        self.message_user(
            request,
            f"{updated} vehicle submission(s) approved.",
            level=messages.SUCCESS,
        )

    @admin.action(description="Reject selected vehicle documents")
    def reject_vehicle_documents(self, request, queryset):
        updated = 0
        for vehicle in queryset:
            metadata = _vehicle_metadata(vehicle)
            metadata["review_status"] = "rejected"
            if not metadata.get("reviewer_notes"):
                metadata["reviewer_notes"] = (
                    "Vehicle documents were rejected during admin review."
                )
            vehicle.metadata = metadata
            vehicle.is_verified = False
            vehicle.save(update_fields=["metadata", "is_verified"])
            updated += 1
        self.message_user(
            request,
            f"{updated} vehicle submission(s) rejected.",
            level=messages.WARNING,
        )

    def _vehicle_review_status(self, obj: Vehicle) -> str:
        metadata = _vehicle_metadata(obj)
        if obj.is_verified:
            return "verified"
        return str(metadata.get("review_status") or "pending")

    def _document_preview(self, obj: Vehicle, key: str, label: str):
        metadata = _vehicle_metadata(obj)
        url = _resolve_vehicle_asset_url(metadata.get(key))
        if not url:
            return format_html(
                "<span style='color:#888;'>{} not uploaded.</span>", label
            )
        return format_html(
            '<div style="display:flex;flex-direction:column;gap:8px;">'
            '<a href="{0}" target="_blank" rel="noopener noreferrer">Open {1}</a>'
            '<img src="{0}" alt="{1}" style="max-width:240px;max-height:180px;border-radius:8px;border:1px solid #ddd;object-fit:cover;" />'
            "</div>",
            url,
            label,
        )


@admin.register(KycRecord)
class KycRecordAdmin(admin.ModelAdmin):
    list_display = (
        "user",
        "status_badge",
        "bvn",
        "nin",
        "submitted_at",
        "updated_at",
    )
    list_filter = ("status",)
    search_fields = ("user__email", "bvn", "nin")
    raw_id_fields = ("user",)
    readonly_fields = (
        "submitted_at",
        "updated_at",
        "id_document_preview",
        "selfie_preview",
    )
    actions = ("mark_kyc_pending", "approve_kyc", "reject_kyc")
    fieldsets = (
        (
            "User details",
            {
                "fields": (
                    "user",
                    "bvn",
                    "nin",
                    "submitted_at",
                    "updated_at",
                )
            },
        ),
        (
            "Review",
            {
                "fields": (
                    "status",
                    "reviewer_notes",
                )
            },
        ),
        (
            "Uploaded verification files",
            {
                "fields": (
                    "id_document_url",
                    "id_document_preview",
                    "selfie_url",
                    "selfie_preview",
                )
            },
        ),
    )

    @admin.display(description="Status")
    def status_badge(self, obj: KycRecord):
        color = {
            "verified": "#2E7D32",
            "rejected": "#C62828",
            "pending": "#F9A825",
        }.get(obj.status, "#6D6D6D")
        return format_html(
            '<span style="padding:4px 10px;border-radius:999px;background:{}20;color:{};font-weight:600;">{}</span>',
            color,
            color,
            obj.status.title(),
        )

    @admin.display(description="ID document")
    def id_document_preview(self, obj: KycRecord):
        return self._kyc_document_preview(obj.id_document_url, "ID document")

    @admin.display(description="Selfie")
    def selfie_preview(self, obj: KycRecord):
        return self._kyc_document_preview(obj.selfie_url, "Selfie")

    @admin.action(description="Mark selected KYC submissions as pending review")
    def mark_kyc_pending(self, request, queryset):
        updated = queryset.update(status=KycRecord.Status.PENDING, reviewer_notes="")
        self.message_user(
            request,
            f"{updated} identification submission(s) marked as pending review.",
            level=messages.SUCCESS,
        )

    @admin.action(description="Approve selected KYC submissions")
    def approve_kyc(self, request, queryset):
        updated = queryset.update(status=KycRecord.Status.VERIFIED)
        self.message_user(
            request,
            f"{updated} identification submission(s) approved.",
            level=messages.SUCCESS,
        )

    @admin.action(description="Reject selected KYC submissions")
    def reject_kyc(self, request, queryset):
        updated = queryset.update(status=KycRecord.Status.REJECTED)
        self.message_user(
            request,
            f"{updated} identification submission(s) rejected.",
            level=messages.WARNING,
        )

    def _kyc_document_preview(self, url: str | None, label: str):
        if not url:
            return format_html(
                "<span style='color:#888;'>{} not uploaded.</span>", label
            )
        return format_html(
            '<div style="display:flex;flex-direction:column;gap:8px;">'
            '<a href="{0}" target="_blank" rel="noopener noreferrer">Open {1}</a>'
            '<img src="{0}" alt="{1}" style="max-width:240px;max-height:180px;border-radius:8px;border:1px solid #ddd;object-fit:cover;" />'
            "</div>",
            url,
            label,
        )

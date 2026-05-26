"""Queryset builders for the dashboard tables (search / filter / paginate)."""
from __future__ import annotations

from datetime import timedelta

from django.db.models import Count, Q, QuerySet
from django.utils import timezone

from apps.accounts.models import KycRecord, User
from apps.mobility.models import DeliveryRequest, RideRequest

INACTIVE_AFTER_DAYS = 30


class UserStatus:
    ACTIVE = "active"
    INACTIVE = "inactive"
    SUSPENDED = "suspended"
    IN_REVIEW = "in_review"

    LABELS = {
        ACTIVE: "Active",
        INACTIVE: "Inactive",
        SUSPENDED: "Suspended",
        IN_REVIEW: "In review",
    }


def _inactive_cutoff():
    return timezone.now() - timedelta(days=INACTIVE_AFTER_DAYS)


def user_status(user: User, cutoff=None) -> str:
    """Derive a display status without a dedicated DB field (v1)."""
    if not user.is_active:
        return UserStatus.SUSPENDED
    kyc = getattr(user, "kyc_record", None)
    if kyc is not None and kyc.status == KycRecord.Status.PENDING:
        return UserStatus.IN_REVIEW
    cutoff = cutoff or _inactive_cutoff()
    if user.last_login is None or user.last_login < cutoff:
        return UserStatus.INACTIVE
    return UserStatus.ACTIVE


def users_queryset(search: str = "", status: str = "") -> QuerySet[User]:
    qs = (
        User.objects.select_related("profile", "kyc_record", "wallet")
        .annotate(verified_vehicles=Count("vehicles", filter=Q(vehicles__is_verified=True)))
        .order_by("-date_joined")
    )
    if search:
        qs = qs.filter(
            Q(email__icontains=search)
            | Q(first_name__icontains=search)
            | Q(last_name__icontains=search)
            | Q(phone_number__icontains=search)
        )

    cutoff = _inactive_cutoff()
    if status == UserStatus.SUSPENDED:
        qs = qs.filter(is_active=False)
    elif status == UserStatus.IN_REVIEW:
        qs = qs.filter(is_active=True, kyc_record__status=KycRecord.Status.PENDING)
    elif status == UserStatus.INACTIVE:
        qs = qs.filter(is_active=True).filter(
            Q(last_login__isnull=True) | Q(last_login__lt=cutoff)
        ).exclude(kyc_record__status=KycRecord.Status.PENDING)
    elif status == UserStatus.ACTIVE:
        qs = qs.filter(is_active=True, last_login__gte=cutoff).exclude(
            kyc_record__status=KycRecord.Status.PENDING
        )
    return qs


def kyc_queryset(search: str = "", status: str = "") -> QuerySet[KycRecord]:
    qs = KycRecord.objects.select_related("user").order_by("-submitted_at")
    if search:
        qs = qs.filter(
            Q(user__email__icontains=search) | Q(bvn__icontains=search) | Q(nin__icontains=search)
        )
    if status in dict(KycRecord.Status.choices):
        qs = qs.filter(status=status)
    return qs


def rides_queryset(search: str = "", status: str = "") -> QuerySet[RideRequest]:
    qs = RideRequest.objects.select_related("requester", "matched_plan", "matched_plan__created_by").order_by(
        "-created_at"
    )
    if search:
        qs = qs.filter(
            Q(requester__email__icontains=search)
            | Q(origin_name__icontains=search)
            | Q(destination_name__icontains=search)
        )
    if status in dict(RideRequest.Status.choices):
        qs = qs.filter(status=status)
    return qs


def delivery_queryset(search: str = "", status: str = "") -> QuerySet[DeliveryRequest]:
    qs = DeliveryRequest.objects.select_related(
        "requester", "matched_plan", "matched_plan__created_by"
    ).order_by("-created_at")
    if search:
        qs = qs.filter(
            Q(requester__email__icontains=search)
            | Q(pickup_name__icontains=search)
            | Q(dropoff_name__icontains=search)
            | Q(package_description__icontains=search)
        )
    if status in dict(DeliveryRequest.Status.choices):
        qs = qs.filter(status=status)
    return qs

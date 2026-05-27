"""Aggregation helpers for the Control Center dashboard.

All counting/summing happens in the database. Functions return plain Python
numbers so they can be rendered in templates or JSON-serialized for charts.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timedelta
from decimal import Decimal

from django.db.models import Count, DecimalField, Q, Sum, Value
from django.db.models.functions import Coalesce, ExtractWeekDay, TruncMonth
from django.utils import timezone

from apps.accounts.models import User
from apps.mobility.models import DeliveryRequest, RideRequest, TravelMatch, TravelPlan
from apps.payments.models import Wallet, WalletTransaction

PERIODS = {
    "7d": ("Last 7 Days", 7),
    "30d": ("Last 30 Days", 30),
    "90d": ("Last 90 Days", 90),
    "365d": ("Last 12 Months", 365),
}
DEFAULT_PERIOD = "30d"

WEEKDAY_LABELS = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
]
MONTH_LABELS = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
]

EARNING_TYPES = [WalletTransaction.Type.DEPOSIT, WalletTransaction.Type.SUBSCRIPTION]
_ZERO_MONEY = Coalesce(Sum("amount"), Value(Decimal("0")), output_field=DecimalField())


@dataclass
class Period:
    key: str
    label: str
    start: datetime
    end: datetime
    prev_start: datetime
    prev_end: datetime


def resolve_period(key: str | None) -> Period:
    key = key if key in PERIODS else DEFAULT_PERIOD
    label, days = PERIODS[key]
    end = timezone.now()
    start = end - timedelta(days=days)
    return Period(
        key=key,
        label=label,
        start=start,
        end=end,
        prev_start=start - timedelta(days=days),
        prev_end=start,
    )


def _growth_pct(current: Decimal, previous: Decimal) -> float | None:
    if not previous:
        return None
    return round(float((current - previous) / previous * 100), 1)


def _earnings(start: datetime, end: datetime) -> Decimal:
    return WalletTransaction.objects.filter(
        status=WalletTransaction.Status.SUCCESS,
        transaction_type__in=EARNING_TYPES,
        created_at__gte=start,
        created_at__lt=end,
    ).aggregate(total=_ZERO_MONEY)["total"]


def stat_cards(period: Period) -> dict:
    earnings = _earnings(period.start, period.end)
    prev_earnings = _earnings(period.prev_start, period.prev_end)

    active_route_statuses = [TravelPlan.Status.PUBLISHED, TravelPlan.Status.IN_PROGRESS]
    cancelled_trips = (
        RideRequest.objects.filter(status=RideRequest.Status.CANCELLED).count()
        + DeliveryRequest.objects.filter(
            status=DeliveryRequest.Status.CANCELLED
        ).count()
    )

    return {
        "total_users": User.objects.count(),
        "total_wallet_balance": Wallet.objects.aggregate(
            total=Coalesce(
                Sum("balance"), Value(Decimal("0")), output_field=DecimalField()
            )
        )["total"],
        "earnings": earnings,
        "earnings_growth": _growth_pct(earnings, prev_earnings),
        "active_routes": TravelPlan.objects.filter(
            status__in=active_route_statuses
        ).count(),
        "total_routes": TravelPlan.objects.count(),
        "active_ride_sharing": TravelMatch.objects.filter(
            match_type=TravelMatch.MatchType.RIDE,
            status__in=[TravelMatch.Status.ACCEPTED, TravelMatch.Status.ACTIVE],
        ).count(),
        "active_delivery": DeliveryRequest.objects.filter(
            status=DeliveryRequest.Status.IN_TRANSIT
        ).count(),
        "cancelled_trips": cancelled_trips,
    }


def trips_weekday_series(period: Period) -> dict:
    """Ride-sharing vs delivery matches bucketed by weekday over the period."""
    rows = (
        TravelMatch.objects.filter(
            created_at__gte=period.start, created_at__lt=period.end
        )
        .annotate(weekday=ExtractWeekDay("created_at"))
        .values("weekday", "match_type")
        .annotate(total=Count("id"))
    )
    ride = [0] * 7
    delivery = [0] * 7
    for row in rows:
        idx = (row["weekday"] or 1) - 1  # Django: 1=Sunday .. 7=Saturday
        if not 0 <= idx < 7:
            continue
        if row["match_type"] == TravelMatch.MatchType.RIDE:
            ride[idx] = row["total"]
        elif row["match_type"] == TravelMatch.MatchType.DELIVERY:
            delivery[idx] = row["total"]
    return {"labels": WEEKDAY_LABELS, "ride": ride, "delivery": delivery}


def routes_split() -> dict:
    counts = dict(
        TravelMatch.objects.values_list("match_type")
        .annotate(total=Count("id"))
        .values_list("match_type", "total")
    )
    ride = counts.get(TravelMatch.MatchType.RIDE, 0)
    delivery = counts.get(TravelMatch.MatchType.DELIVERY, 0)
    return {"ride": ride, "delivery": delivery, "total": ride + delivery}


def revenue_monthly_series(months: int = 12) -> dict:
    """Successful earnings summed by calendar month for the trailing `months`."""
    now = timezone.now()
    start = (now - timedelta(days=31 * (months - 1))).replace(
        day=1, hour=0, minute=0, second=0, microsecond=0
    )
    rows = (
        WalletTransaction.objects.filter(
            status=WalletTransaction.Status.SUCCESS,
            transaction_type__in=EARNING_TYPES,
            created_at__gte=start,
        )
        .annotate(month=TruncMonth("created_at"))
        .values("month")
        .annotate(total=_ZERO_MONEY)
        .order_by("month")
    )
    totals = {
        row["month"].strftime("%Y-%m"): float(row["total"])
        for row in rows
        if row["month"]
    }

    labels: list[str] = []
    values: list[float] = []
    cursor = start
    for _ in range(months):
        labels.append(MONTH_LABELS[cursor.month - 1])
        values.append(totals.get(cursor.strftime("%Y-%m"), 0.0))
        # advance one month
        cursor = (cursor.replace(day=28) + timedelta(days=4)).replace(day=1)
    return {"labels": labels, "values": values}

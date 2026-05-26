from __future__ import annotations

from django.contrib import messages
from django.contrib.admin.views.decorators import staff_member_required
from django.core.paginator import Paginator
from django.db.models import Prefetch
from django.http import JsonResponse
from django.shortcuts import get_object_or_404, redirect, render
from django.urls import reverse
from django.views.decorators.http import require_POST

from apps.accounts.models import KycRecord
from apps.mobility.models import TrackingEvent, TrackingSession

from . import metrics, selectors

PER_PAGE = 15


def _paginate(request, queryset, per_page: int = PER_PAGE):
    paginator = Paginator(queryset, per_page)
    return paginator.get_page(request.GET.get("page"))


def _querystring(request, **overrides) -> str:
    params = request.GET.copy()
    for key, value in overrides.items():
        if value is None:
            params.pop(key, None)
        else:
            params[key] = value
    params.pop("page", None)
    encoded = params.urlencode()
    return f"&{encoded}" if encoded else ""


@staff_member_required
def dashboard(request):
    period = metrics.resolve_period(request.GET.get("period"))
    context = {
        "active_nav": "dashboard",
        "page_title": "Dashboard",
        "page_subtitle": "Track and manage analytics",
        "period": period,
        "periods": metrics.PERIODS,
        "cards": metrics.stat_cards(period),
        "trips_series": metrics.trips_weekday_series(period),
        "routes_split": metrics.routes_split(),
        "revenue_series": metrics.revenue_monthly_series(),
    }
    return render(request, "dashboard/dashboard.html", context)


@staff_member_required
def users(request):
    search = request.GET.get("q", "").strip()
    status = request.GET.get("status", "").strip()
    page = _paginate(request, selectors.users_queryset(search, status))
    cutoff = selectors._inactive_cutoff()
    rows = [{"user": u, "status": selectors.user_status(u, cutoff)} for u in page]
    context = {
        "active_nav": "users",
        "page_title": "Users",
        "page_subtitle": "Overview of every registered user",
        "page": page,
        "rows": rows,
        "search": search,
        "status": status,
        "status_choices": selectors.UserStatus.LABELS,
        "base_qs": _querystring(request),
    }
    return render(request, "dashboard/users.html", context)


@staff_member_required
def kyc_list(request):
    search = request.GET.get("q", "").strip()
    status = request.GET.get("status", "").strip()
    page = _paginate(request, selectors.kyc_queryset(search, status))
    context = {
        "active_nav": "kyc",
        "page_title": "KYC",
        "page_subtitle": "Identity verification submissions",
        "page": page,
        "search": search,
        "status": status,
        "status_choices": dict(KycRecord.Status.choices),
        "can_view_pii": request.user.is_superuser,
        "base_qs": _querystring(request),
    }
    return render(request, "dashboard/kyc.html", context)


@staff_member_required
@require_POST
def kyc_action(request, pk: int):
    record = get_object_or_404(KycRecord, pk=pk)
    action = request.POST.get("action")
    if action == "approve":
        record.status = KycRecord.Status.VERIFIED
        record.reviewer_notes = request.POST.get("notes", record.reviewer_notes)
        record.save(update_fields=["status", "reviewer_notes", "updated_at"])
        messages.success(request, f"KYC for {record.user.email} approved.")
    elif action == "reject":
        record.status = KycRecord.Status.REJECTED
        record.reviewer_notes = request.POST.get("notes", record.reviewer_notes)
        record.save(update_fields=["status", "reviewer_notes", "updated_at"])
        messages.warning(request, f"KYC for {record.user.email} rejected.")
    elif action == "pending":
        record.status = KycRecord.Status.PENDING
        record.save(update_fields=["status", "updated_at"])
        messages.info(request, f"KYC for {record.user.email} set back to pending.")
    else:
        messages.error(request, "Unknown KYC action.")
    return redirect(f"{reverse('dashboard:kyc')}?{request.GET.urlencode()}")


@staff_member_required
def rides(request):
    search = request.GET.get("q", "").strip()
    status = request.GET.get("status", "").strip()
    page = _paginate(request, selectors.rides_queryset(search, status))
    from apps.mobility.models import RideRequest

    context = {
        "active_nav": "rides",
        "page_title": "Rides",
        "page_subtitle": "Ride-sharing requests and matches",
        "page": page,
        "search": search,
        "status": status,
        "status_choices": dict(RideRequest.Status.choices),
        "base_qs": _querystring(request),
    }
    return render(request, "dashboard/rides.html", context)


@staff_member_required
def delivery(request):
    search = request.GET.get("q", "").strip()
    status = request.GET.get("status", "").strip()
    page = _paginate(request, selectors.delivery_queryset(search, status))
    from apps.mobility.models import DeliveryRequest

    context = {
        "active_nav": "delivery",
        "page_title": "Delivery",
        "page_subtitle": "Delivery requests and matches",
        "page": page,
        "search": search,
        "status": status,
        "status_choices": dict(DeliveryRequest.Status.choices),
        "base_qs": _querystring(request),
    }
    return render(request, "dashboard/delivery.html", context)


@staff_member_required
def live_tracking(request):
    live_count = TrackingSession.objects.filter(status=TrackingSession.Status.LIVE).count()
    context = {
        "active_nav": "live_tracking",
        "page_title": "Live Tracking",
        "page_subtitle": "Track every ride sharing and delivery",
        "live_count": live_count,
        "maps_key": _maps_key(),
        "api_url": reverse("dashboard:api_live_tracking"),
    }
    return render(request, "dashboard/live_tracking.html", context)


def _maps_key() -> str:
    from django.conf import settings

    return getattr(settings, "GOOGLE_MAPS_BROWSER_KEY", "")


@staff_member_required
def api_live_tracking(request):
    """Latest known position for each live tracking session."""
    latest_location = Prefetch(
        "events",
        queryset=TrackingEvent.objects.filter(
            event_type=TrackingEvent.EventType.LOCATION, latitude__isnull=False
        ).order_by("-created_at"),
        to_attr="recent_locations",
    )
    sessions = (
        TrackingSession.objects.filter(status=TrackingSession.Status.LIVE)
        .select_related("travel_plan", "travel_plan__created_by")
        .prefetch_related(latest_location)
    )

    movers = []
    for session in sessions:
        locations = getattr(session, "recent_locations", [])
        if not locations:
            continue
        loc = locations[0]
        mover = session.travel_plan.created_by
        movers.append(
            {
                "session_id": str(session.id),
                "plan_id": str(session.travel_plan_id),
                "name": mover.get_full_name() or mover.email,
                "email": mover.email,
                "reference": f"#{str(session.travel_plan_id)[:12]}",
                "type": session.travel_plan.get_plan_type_display(),
                "lat": float(loc.latitude),
                "lng": float(loc.longitude),
                "updated_at": loc.created_at.isoformat(),
            }
        )
    return JsonResponse({"count": len(movers), "movers": movers})


@staff_member_required
def stub(request, screen: str):
    titles = {
        "analytics": "Analytics",
        "transactions": "Transactions",
        "chat-support": "Chat Support",
    }
    context = {
        "active_nav": screen.replace("-", "_"),
        "page_title": titles.get(screen, "Coming soon"),
        "page_subtitle": "This section is not part of the current design yet",
    }
    return render(request, "dashboard/stub.html", context)

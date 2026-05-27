from __future__ import annotations

from decimal import Decimal

from django.test import TestCase
from django.urls import reverse
from django.utils import timezone

from apps.accounts.models import KycRecord, User
from apps.mobility.models import TravelMatch, TravelPlan
from apps.payments.models import WalletTransaction

from . import metrics

PROTECTED_VIEWS = ["index", "users", "kyc", "rides", "delivery", "live_tracking"]


class AccessControlTests(TestCase):
    def setUp(self):
        self.staff = User.objects.create_user("staff@movr.test", "pw", is_staff=True)
        self.normal = User.objects.create_user("user@movr.test", "pw")

    def test_anonymous_redirected(self):
        for name in PROTECTED_VIEWS:
            resp = self.client.get(reverse(f"dashboard:{name}"))
            self.assertEqual(resp.status_code, 302, name)

    def test_non_staff_redirected(self):
        self.client.force_login(self.normal)
        resp = self.client.get(reverse("dashboard:index"))
        self.assertEqual(resp.status_code, 302)

    def test_staff_access(self):
        self.client.force_login(self.staff)
        for name in PROTECTED_VIEWS:
            resp = self.client.get(reverse(f"dashboard:{name}"))
            self.assertEqual(resp.status_code, 200, name)


class KycActionTests(TestCase):
    def setUp(self):
        self.staff = User.objects.create_user("staff@movr.test", "pw", is_staff=True)
        self.subject = User.objects.create_user("kyc@movr.test", "pw")
        self.record = KycRecord.objects.create(
            user=self.subject, status=KycRecord.Status.PENDING
        )
        self.client.force_login(self.staff)

    def test_approve(self):
        resp = self.client.post(
            reverse("dashboard:kyc_action", args=[self.record.pk]),
            {"action": "approve", "notes": "ok"},
        )
        self.assertEqual(resp.status_code, 302)
        self.record.refresh_from_db()
        self.assertEqual(self.record.status, KycRecord.Status.VERIFIED)
        self.assertEqual(self.record.reviewer_notes, "ok")

    def test_reject(self):
        self.client.post(
            reverse("dashboard:kyc_action", args=[self.record.pk]), {"action": "reject"}
        )
        self.record.refresh_from_db()
        self.assertEqual(self.record.status, KycRecord.Status.REJECTED)


class UserActionTests(TestCase):
    def setUp(self):
        self.staff = User.objects.create_user("staff@movr.test", "pw", is_staff=True)
        self.subject = User.objects.create_user("target@movr.test", "pw")
        self.client.force_login(self.staff)

    def _post(self, user, action):
        return self.client.post(
            reverse("dashboard:user_action", args=[user.pk]), {"action": action}
        )

    def test_suspend_and_activate(self):
        resp = self._post(self.subject, "suspend")
        self.assertEqual(resp.status_code, 302)
        self.subject.refresh_from_db()
        self.assertFalse(self.subject.is_active)

        self._post(self.subject, "activate")
        self.subject.refresh_from_db()
        self.assertTrue(self.subject.is_active)

    def test_verify_kyc_creates_record(self):
        self.assertFalse(hasattr(self.subject, "kyc_record"))
        self._post(self.subject, "verify_kyc")
        record = KycRecord.objects.get(user=self.subject)
        self.assertEqual(record.status, KycRecord.Status.VERIFIED)

    def test_reset_kyc(self):
        KycRecord.objects.create(user=self.subject, status=KycRecord.Status.VERIFIED)
        self._post(self.subject, "reset_kyc")
        record = KycRecord.objects.get(user=self.subject)
        self.assertEqual(record.status, KycRecord.Status.PENDING)

    def test_cannot_suspend_superuser(self):
        target = User.objects.create_superuser("super@movr.test", "pw")
        self._post(target, "suspend")
        target.refresh_from_db()
        self.assertTrue(target.is_active)


class MetricsTests(TestCase):
    def setUp(self):
        self.user = User.objects.create_user("m@movr.test", "pw")
        WalletTransaction.objects.create(
            wallet=self.user.wallet,
            transaction_type=WalletTransaction.Type.DEPOSIT,
            status=WalletTransaction.Status.SUCCESS,
            amount=Decimal("5000"),
            reference="t1",
        )
        plan = TravelPlan.objects.create(
            created_by=self.user,
            title="r",
            status=TravelPlan.Status.PUBLISHED,
            origin_name="a",
            destination_name="b",
            departure_time=timezone.now(),
        )
        TravelMatch.objects.create(
            travel_plan=plan,
            match_type=TravelMatch.MatchType.RIDE,
            status=TravelMatch.Status.ACTIVE,
            agreed_price=Decimal("100"),
        )

    def test_stat_cards(self):
        period = metrics.resolve_period("30d")
        cards = metrics.stat_cards(period)
        self.assertEqual(cards["total_users"], 1)
        self.assertEqual(cards["earnings"], Decimal("5000"))
        self.assertEqual(cards["active_routes"], 1)
        self.assertEqual(cards["active_ride_sharing"], 1)

    def test_revenue_series_has_twelve_months(self):
        series = metrics.revenue_monthly_series()
        self.assertEqual(len(series["labels"]), 12)
        self.assertEqual(len(series["values"]), 12)

    def test_trips_series_shape(self):
        series = metrics.trips_weekday_series(metrics.resolve_period("30d"))
        self.assertEqual(len(series["ride"]), 7)
        self.assertEqual(len(series["delivery"]), 7)

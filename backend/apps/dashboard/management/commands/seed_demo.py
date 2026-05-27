"""Populate demo data so the dashboard's cards, charts, tables and map are non-empty.

Usage: python manage.py seed_demo [--users 30]
Safe to re-run; it appends a fresh batch of demo records each time.
"""

from __future__ import annotations

import random
from datetime import timedelta
from decimal import Decimal

from django.core.management.base import BaseCommand
from django.utils import timezone

from apps.accounts.models import KycRecord, User, UserProfile, Vehicle
from apps.mobility.models import (
    DeliveryRequest,
    RideRequest,
    TrackingEvent,
    TrackingSession,
    TravelMatch,
    TravelPlan,
)
from apps.payments.models import Wallet, WalletTransaction

LAGOS = (6.5244, 3.3792)
FIRST = [
    "Victor",
    "Jacob",
    "Robert",
    "Annette",
    "Wade",
    "Leslie",
    "Devon",
    "Courtney",
    "Adaeze",
    "Jenny",
    "Jerome",
    "Ralph",
    "Albert",
    "Moyiwa",
    "Dominion",
]
LAST = [
    "Ikechukwu",
    "Jones",
    "Fox",
    "Black",
    "Warren",
    "Alexander",
    "Lane",
    "Henry",
    "Princess",
    "Wilson",
    "Bell",
    "Edwards",
    "Flores",
    "Adekunle",
    "Adeyemi",
]


class Command(BaseCommand):
    help = "Seed demo data for the Control Center dashboard."

    def add_arguments(self, parser):
        parser.add_argument("--users", type=int, default=30)

    def handle(self, *args, **options):
        random.seed()
        n = options["users"]
        now = timezone.now()
        stamp = now.strftime("%H%M%S")
        users: list[User] = []

        for i in range(n):
            email = f"demo_{stamp}_{i}@movr.test"
            user = User.objects.create_user(
                email=email,
                password="demo-pass-123",
                first_name=random.choice(FIRST),
                last_name=random.choice(LAST),
                phone_number=f"0{random.randint(700000000, 909999999)}",
                account_type=random.choice([c[0] for c in User.AccountType.choices]),
                is_active=random.random() > 0.12,
            )
            User.objects.filter(pk=user.pk).update(
                last_login=(
                    now - timedelta(days=random.choice([0, 1, 3, 8, 45, 90]))
                    if random.random() > 0.2
                    else None
                )
            )
            UserProfile.objects.get_or_create(user=user)
            Wallet.objects.filter(user=user).update(
                balance=Decimal(random.randint(0, 9000)),
                available_balance=Decimal(random.randint(0, 9000)),
            )
            if random.random() > 0.3:
                KycRecord.objects.create(
                    user=user,
                    bvn=str(random.randint(10**10, 10**11 - 1)),
                    nin=str(random.randint(10**10, 10**11 - 1)),
                    status=random.choice([c[0] for c in KycRecord.Status.choices]),
                )
            if random.random() > 0.5:
                Vehicle.objects.create(
                    owner=user,
                    vehicle_type=random.choice(
                        [c[0] for c in Vehicle.VehicleType.choices]
                    ),
                    make="Toyota",
                    model="Corolla",
                    plate_number=f"LAG-{random.randint(100, 999)}",
                    is_verified=random.random() > 0.4,
                )
            users.append(user)

        # Deposits spread over the last 12 months (drives Revenue Growth chart)
        for _ in range(120):
            owner = random.choice(users)
            txn = WalletTransaction.objects.create(
                wallet=owner.wallet,
                transaction_type=WalletTransaction.Type.DEPOSIT,
                status=WalletTransaction.Status.SUCCESS,
                amount=Decimal(random.randint(1000, 250000)),
                reference=f"seed-{stamp}-{random.randint(0, 10**9)}",
                gateway="seed",
            )
            WalletTransaction.objects.filter(pk=txn.pk).update(
                created_at=now - timedelta(days=random.randint(0, 360))
            )

        # Travel plans + requests + matches + a few live tracking sessions
        statuses = [c[0] for c in TravelPlan.Status.choices]
        for _ in range(40):
            creator = random.choice(users)
            plan = TravelPlan.objects.create(
                created_by=creator,
                title="Lagos route",
                plan_type=random.choice([c[0] for c in TravelPlan.PlanType.choices]),
                status=random.choice(statuses),
                origin_name="Ikeja",
                destination_name="Lekki",
                departure_time=now + timedelta(hours=random.randint(1, 72)),
                is_live=random.random() > 0.7,
            )
            if plan.is_live:
                session = TrackingSession.objects.create(
                    travel_plan=plan, status=TrackingSession.Status.LIVE, started_at=now
                )
                TrackingEvent.objects.create(
                    session=session,
                    actor=creator,
                    event_type=TrackingEvent.EventType.LOCATION,
                    latitude=Decimal(
                        str(round(LAGOS[0] + random.uniform(-0.08, 0.08), 6))
                    ),
                    longitude=Decimal(
                        str(round(LAGOS[1] + random.uniform(-0.08, 0.08), 6))
                    ),
                )

            requester = random.choice(users)
            ride = RideRequest.objects.create(
                requester=requester,
                origin_name="Yaba",
                destination_name="VI",
                scheduled_time=now + timedelta(hours=random.randint(1, 48)),
                status=random.choice([c[0] for c in RideRequest.Status.choices]),
            )
            DeliveryRequest.objects.create(
                requester=requester,
                pickup_name="Surulere",
                dropoff_name="Ajah",
                scheduled_time=now + timedelta(hours=random.randint(1, 48)),
                package_description="Parcel",
                weight_kg=Decimal("3.5"),
                status=random.choice([c[0] for c in DeliveryRequest.Status.choices]),
            )
            match = TravelMatch.objects.create(
                travel_plan=plan,
                ride_request=ride,
                match_type=random.choice([c[0] for c in TravelMatch.MatchType.choices]),
                agreed_price=Decimal(random.randint(1000, 50000)),
                status=random.choice([c[0] for c in TravelMatch.Status.choices]),
            )
            TravelMatch.objects.filter(pk=match.pk).update(
                created_at=now - timedelta(days=random.randint(0, 6))
            )

        self.stdout.write(
            self.style.SUCCESS(
                f"Seeded {n} demo users plus plans, matches, transactions and tracking sessions."
            )
        )

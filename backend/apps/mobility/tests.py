from asgiref.sync import async_to_sync
from channels.testing import WebsocketCommunicator
from django.contrib.auth import get_user_model
from django.test import TransactionTestCase
from django.utils import timezone
from rest_framework import status
from rest_framework.test import APITestCase

from apps.mobility.consumers import TrackingConsumer
from apps.mobility.geo import (
    cell_for_coord,
    corridor_cells,
    h3_available,
    request_hits_corridor,
)
from apps.mobility.models import TravelPlan

User = get_user_model()


class MobilityApiTests(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email="driver@movr.app",
            password="StrongPass123",
            is_email_verified=True,
        )
        login = self.client.post(
            "/api/auth/login/",
            {"email": "driver@movr.app", "password": "StrongPass123"},
            format="json",
        )
        self.client.credentials(
            HTTP_AUTHORIZATION=f"Bearer {login.data['tokens']['access']}"
        )

    def test_create_travel_plan_and_toggle_live(self):
        create_response = self.client.post(
            "/api/mobility/travel-plans/",
            {
                "title": "Airport run",
                "plan_type": "ride",
                "origin_name": "Ikeja",
                "destination_name": "Lekki",
                "departure_time": timezone.now().isoformat(),
                "vehicle_type": "car",
                "seats_available": 3,
                "price_per_seat": "3500.00",
            },
            format="json",
        )
        self.assertEqual(create_response.status_code, status.HTTP_201_CREATED)
        travel_plan_id = create_response.data["id"]

        toggle_response = self.client.post(
            f"/toggle-is-live/{travel_plan_id}/",
            {"is_live": True},
            format="json",
        )
        self.assertEqual(toggle_response.status_code, status.HTTP_200_OK)
        self.assertTrue(toggle_response.data["is_live"])


class TrackingConsumerAuthTests(TransactionTestCase):
    """Verify the WebSocket consumer gates by travel-plan participation."""

    async def _connect(self, user, travel_plan_id):
        communicator = WebsocketCommunicator(
            TrackingConsumer.as_asgi(),
            f"/ws/tracking/{travel_plan_id}/",
        )
        communicator.scope["user"] = user
        communicator.scope["url_route"] = {
            "kwargs": {"travel_plan_id": str(travel_plan_id)}
        }
        communicator.scope.setdefault("subprotocols", [])
        connected, _ = await communicator.connect()
        await communicator.disconnect()
        return connected

    def setUp(self):
        self.owner = User.objects.create_user(
            email="owner@movr.app", password="StrongPass123", is_email_verified=True
        )
        self.outsider = User.objects.create_user(
            email="outsider@movr.app", password="StrongPass123", is_email_verified=True
        )
        self.plan = TravelPlan.objects.create(
            created_by=self.owner,
            title="t",
            origin_name="a",
            destination_name="b",
            departure_time=timezone.now(),
        )

    def test_owner_accepted(self):
        self.assertTrue(async_to_sync(self._connect)(self.owner, self.plan.id))

    def test_outsider_rejected(self):
        self.assertFalse(async_to_sync(self._connect)(self.outsider, self.plan.id))


class CorridorMatchingTests(TransactionTestCase):
    """H3 corridor cells populate on save and light up simple hit tests."""

    def setUp(self):
        self.creator = User.objects.create_user(
            email="creator@movr.app",
            password="StrongPass123",
            is_email_verified=True,
        )

    def test_travel_plan_records_corridor_cells_on_save(self):
        if not h3_available():
            self.skipTest("h3 not installed in this environment")
        # Lagos corridor: Ikeja (6.6018, 3.3515) -> Lekki (6.4351, 3.5540)
        plan = TravelPlan.objects.create(
            created_by=self.creator,
            title="Ikeja -> Lekki",
            origin_name="Ikeja",
            destination_name="Lekki",
            origin_latitude="6.6018",
            origin_longitude="3.3515",
            destination_latitude="6.4351",
            destination_longitude="3.5540",
            departure_time=timezone.now(),
        )
        self.assertGreater(
            len(plan.corridor_h3_cells),
            5,
            "Corridor should have many cells between Ikeja and Lekki",
        )

    def test_request_hits_corridor_along_path(self):
        if not h3_available():
            self.skipTest("h3 not installed in this environment")
        cells = corridor_cells(6.6018, 3.3515, 6.4351, 3.5540)
        # Use the geometric midpoint of the corridor so we're guaranteed
        # to land on one of its H3 cells.
        pickup = cell_for_coord(6.5185, 3.4528)
        dropoff = cell_for_coord(6.4400, 3.5450)
        self.assertTrue(
            request_hits_corridor(cells, pickup, dropoff),
            "A midpoint pickup and a near-dropoff should hit the "
            "Ikeja->Lekki corridor",
        )

    def test_request_far_from_corridor_misses(self):
        if not h3_available():
            self.skipTest("h3 not installed in this environment")
        cells = corridor_cells(6.6018, 3.3515, 6.4351, 3.5540)
        # A pickup 300 km north should not intersect the corridor.
        far_pickup = cell_for_coord(9.0765, 7.3986)  # Abuja
        far_dropoff = cell_for_coord(9.1, 7.4)
        self.assertFalse(request_hits_corridor(cells, far_pickup, far_dropoff))

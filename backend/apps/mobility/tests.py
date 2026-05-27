from django.contrib.auth import get_user_model
from django.utils import timezone
from rest_framework import status
from rest_framework.test import APITestCase

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

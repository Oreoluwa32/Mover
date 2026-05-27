from django.contrib.auth import get_user_model
from rest_framework import status
from rest_framework.test import APITestCase

User = get_user_model()


class PaymentApiTests(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email="wallet@movr.app",
            password="StrongPass123",
            is_email_verified=True,
        )
        login = self.client.post(
            "/api/auth/login/",
            {"email": "wallet@movr.app", "password": "StrongPass123"},
            format="json",
        )
        self.client.credentials(
            HTTP_AUTHORIZATION=f"Bearer {login.data['tokens']['access']}"
        )

    def test_initialize_and_verify_payment(self):
        init_response = self.client.post(
            "/api/payments/initialize",
            {
                "amount": "5000.00",
                "description": "Wallet top up",
                "related_type": "deposit",
            },
            format="json",
        )
        self.assertEqual(init_response.status_code, status.HTTP_200_OK)
        reference = init_response.data["data"]["reference"]

        verify_response = self.client.post(
            "/api/payments/verify",
            {"reference": reference},
            format="json",
        )
        self.assertEqual(verify_response.status_code, status.HTTP_200_OK)
        self.assertEqual(verify_response.data["data"]["reference"], reference)

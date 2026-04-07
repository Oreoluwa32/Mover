from rest_framework import status
from rest_framework.test import APITestCase


class AuthenticationTests(APITestCase):
    def test_register_and_login(self):
        register_response = self.client.post(
            "/api/auth/register/",
            {
                "email": "tester@movr.app",
                "password": "StrongPass123",
                "first_name": "Movr",
                "last_name": "Tester",
                "account_type": "both",
            },
            format="json",
        )
        self.assertEqual(register_response.status_code, status.HTTP_201_CREATED)
        self.assertIn("tokens", register_response.data)

        login_response = self.client.post(
            "/api/auth/login/",
            {
                "email": "tester@movr.app",
                "password": "StrongPass123",
            },
            format="json",
        )
        self.assertEqual(login_response.status_code, status.HTTP_200_OK)
        self.assertIn("access", login_response.data["tokens"])

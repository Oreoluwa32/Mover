from django.contrib.auth import get_user_model
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.utils.http import urlsafe_base64_encode
from rest_framework import status
from rest_framework.test import APITestCase
from unittest.mock import patch

User = get_user_model()


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

    @patch("apps.accounts.views.send_password_reset_email")
    def test_forgot_password_returns_generic_success(self, mock_send_password_reset_email):
        user = User.objects.create_user(
            email="tester@movr.app",
            password="StrongPass123",
        )
        response = self.client.post(
            "/api/auth/password/forgot/",
            {"email": user.email},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("detail", response.data)
        mock_send_password_reset_email.assert_called_once()

    def test_reset_password_confirms_with_uid_and_token(self):
        user = User.objects.create_user(
            email="tester@movr.app",
            password="StrongPass123",
        )
        uid = urlsafe_base64_encode(str(user.pk).encode("utf-8"))
        token = PasswordResetTokenGenerator().make_token(user)

        response = self.client.post(
            "/api/auth/password/reset/",
            {
                "uid": uid,
                "token": token,
                "new_password": "NewStrongPass123",
                "confirm_password": "NewStrongPass123",
            },
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        user.refresh_from_db()
        self.assertTrue(user.check_password("NewStrongPass123"))

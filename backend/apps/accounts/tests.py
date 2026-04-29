from django.contrib.auth import get_user_model
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.utils.http import urlsafe_base64_encode
from rest_framework import status
from rest_framework.test import APITestCase
from unittest.mock import patch

User = get_user_model()


class AuthenticationTests(APITestCase):
    @patch("apps.accounts.views.send_email_verification_email")
    def test_register_requires_email_verification_before_login(self, mock_send_email_verification_email):
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
        self.assertTrue(register_response.data["email_verification_required"])
        mock_send_email_verification_email.assert_called_once()

        login_response = self.client.post(
            "/api/auth/login/",
            {
                "email": "tester@movr.app",
                "password": "StrongPass123",
            },
            format="json",
        )
        self.assertEqual(login_response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(login_response.data["code"], "email_verification_required")

    @patch("apps.accounts.views.send_email_verification_email")
    def test_verify_email_then_login(self, mock_send_email_verification_email):
        user = User.objects.create_user(
            email="tester@movr.app",
            password="StrongPass123",
        )
        verification_request = self.client.post(
            "/api/auth/email-verification/request/",
            {"email": user.email},
            format="json",
        )
        self.assertEqual(verification_request.status_code, status.HTTP_200_OK)
        verification = user.email_verification_codes.first()
        self.assertIsNotNone(verification)

        verify_response = self.client.post(
            "/api/auth/email-verification/confirm/",
            {"email": user.email, "code": verification.code},
            format="json",
        )
        self.assertEqual(verify_response.status_code, status.HTTP_200_OK)

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

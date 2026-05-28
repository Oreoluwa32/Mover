from django.contrib.auth import get_user_model
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.utils.http import urlsafe_base64_encode
from rest_framework import status
from rest_framework.test import APITestCase
from unittest.mock import patch

from apps.accounts.emailing import (
    send_email_verification_email,
    send_password_reset_email,
)

User = get_user_model()


class AuthenticationTests(APITestCase):
    @patch("apps.accounts.views.send_email_verification_email")
    def test_register_requires_email_verification_before_login(
        self, mock_send_email_verification_email
    ):
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
        self.assertEqual(register_response.status_code, status.HTTP_202_ACCEPTED)
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
    def test_register_with_verified_email_returns_uniform_response(
        self, mock_send_email_verification_email
    ):
        # An already-verified account must not be revealed by register.
        User.objects.create_user(
            email="taken@movr.app",
            password="StrongPass123",
            is_email_verified=True,
        )
        register_response = self.client.post(
            "/api/auth/register/",
            {
                "email": "taken@movr.app",
                "password": "StrongPass123",
                "first_name": "Movr",
                "last_name": "Tester",
                "account_type": "both",
            },
            format="json",
        )
        self.assertEqual(register_response.status_code, status.HTTP_202_ACCEPTED)
        self.assertTrue(register_response.data["email_verification_required"])
        # No verification email should be dispatched for a verified account.
        mock_send_email_verification_email.assert_not_called()

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
    def test_forgot_password_returns_generic_success(
        self, mock_send_password_reset_email
    ):
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


class EmailVerificationLockoutTests(APITestCase):
    """Brute-force protection for the verification code."""

    def setUp(self):
        # The DRF throttle cache persists across tests in the same process;
        # clear it so this test exercises only the in-view lockout logic.
        from django.core.cache import cache

        cache.clear()

    def test_code_locks_after_too_many_wrong_attempts(self):
        user = User.objects.create_user(
            email="locktest@movr.app", password="StrongPass123"
        )
        # Seed an active code we know.
        from datetime import timedelta

        from django.utils import timezone

        from apps.accounts.models import EmailVerificationCode

        EmailVerificationCode.objects.create(
            user=user,
            code="111111",
            expires_at=timezone.now() + timedelta(minutes=15),
        )

        # Five wrong tries should each return 400. The fifth try also locks
        # the code, so even the correct code afterwards is rejected.
        for _ in range(5):
            wrong = self.client.post(
                "/api/auth/email-verification/confirm/",
                {"email": user.email, "code": "999999"},
                format="json",
            )
            self.assertEqual(wrong.status_code, status.HTTP_400_BAD_REQUEST)

        correct = self.client.post(
            "/api/auth/email-verification/confirm/",
            {"email": user.email, "code": "111111"},
            format="json",
        )
        self.assertEqual(correct.status_code, status.HTTP_400_BAD_REQUEST)


class PIIEncryptionTests(APITestCase):
    """KycRecord.bvn / .nin are written as ciphertext but transparent to readers."""

    def test_bvn_nin_stored_as_ciphertext(self):
        from django.db import connection

        from apps.accounts.encryption import PII_PREFIX
        from apps.accounts.models import KycRecord

        user = User.objects.create_user(email="pii@movr.app", password="StrongPass123")
        record = KycRecord.objects.create(
            user=user, bvn="12345678901", nin="98765432101"
        )

        # ORM round trip returns plaintext.
        refreshed = KycRecord.objects.get(pk=record.pk)
        self.assertEqual(refreshed.bvn, "12345678901")
        self.assertEqual(refreshed.nin, "98765432101")

        # Raw SQL confirms the column is encrypted at rest.
        with connection.cursor() as cur:
            cur.execute(
                "SELECT bvn, nin FROM accounts_kycrecord WHERE id = %s",
                [record.pk],
            )
            raw_bvn, raw_nin = cur.fetchone()
        self.assertTrue(raw_bvn.startswith(PII_PREFIX))
        self.assertTrue(raw_nin.startswith(PII_PREFIX))
        self.assertNotIn("12345678901", raw_bvn)
        self.assertNotIn("98765432101", raw_nin)


class EmailingFunctionTests(APITestCase):
    """Exercise the real email builders (mock only the network sender)."""

    @patch("apps.accounts.emailing._send_resend_email")
    def test_verification_email_builds_html(self, mock_send):
        send_email_verification_email(
            to_email="user@movr.app",
            recipient_name="Ada Driver",
            verification_code="1234",
        )
        mock_send.assert_called_once()
        html_body = mock_send.call_args.kwargs["html"]
        self.assertIn("1234", html_body)
        self.assertIn("Ada Driver", html_body)

    @patch("apps.accounts.emailing._send_resend_email")
    def test_password_reset_email_builds_html(self, mock_send):
        send_password_reset_email(
            to_email="user@movr.app",
            recipient_name="Ada Driver",
            reset_url="movr://reset?token=abc",
            reset_open_url="https://movr.app/reset?token=abc",
        )
        mock_send.assert_called_once()
        html_body = mock_send.call_args.kwargs["html"]
        self.assertIn("https://movr.app/reset", html_body)

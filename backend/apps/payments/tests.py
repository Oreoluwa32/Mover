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


from decimal import Decimal

from django.contrib.auth import get_user_model
from django.core.exceptions import ValidationError
from django.test import TransactionTestCase

from apps.payments.models import InsufficientFundsError, Wallet


class WalletConcurrencyTests(TransactionTestCase):
    def setUp(self):
        User = get_user_model()
        self.user = User.objects.create_user(
            email="wallet@movr.app",
            password="StrongPass123",
            is_email_verified=True,
        )
        self.wallet = Wallet.objects.get(user=self.user)

    def test_credit_and_debit_normalise_and_persist(self):
        self.wallet.credit(Decimal("1000.00"))
        self.wallet.refresh_from_db()
        self.assertEqual(self.wallet.balance, Decimal("1000.00"))
        self.assertEqual(self.wallet.available_balance, Decimal("1000.00"))

        self.wallet.debit(Decimal("250.50"))
        self.wallet.refresh_from_db()
        self.assertEqual(self.wallet.balance, Decimal("749.50"))
        self.assertEqual(self.wallet.available_balance, Decimal("749.50"))

    def test_debit_beyond_available_balance_raises(self):
        self.wallet.credit(Decimal("100.00"))
        with self.assertRaises(InsufficientFundsError):
            self.wallet.debit(Decimal("150.00"))
        self.wallet.refresh_from_db()
        # Balance untouched by the failed debit.
        self.assertEqual(self.wallet.available_balance, Decimal("100.00"))

    def test_non_positive_amount_rejected(self):
        with self.assertRaises(ValidationError):
            self.wallet.credit(Decimal("0"))
        with self.assertRaises(ValidationError):
            self.wallet.debit(Decimal("-5"))

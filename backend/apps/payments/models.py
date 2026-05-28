from __future__ import annotations

import uuid
from decimal import Decimal

from django.conf import settings
from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver


class Wallet(models.Model):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="wallet"
    )
    balance = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    available_balance = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    currency = models.CharField(max_length=8, default="NGN")
    updated_at = models.DateTimeField(auto_now=True)

    def credit(self, amount: Decimal):
        self.balance += amount
        self.available_balance += amount
        self.save(update_fields=["balance", "available_balance", "updated_at"])

    def debit(self, amount: Decimal):
        self.balance -= amount
        self.available_balance -= amount
        self.save(update_fields=["balance", "available_balance", "updated_at"])


class MonnifyReservedAccount(models.Model):
    wallet = models.OneToOneField(
        Wallet, on_delete=models.CASCADE, related_name="monnify_account"
    )
    account_reference = models.CharField(max_length=64, unique=True)
    reservation_reference = models.CharField(max_length=64, blank=True)
    account_name = models.CharField(max_length=120)
    account_number = models.CharField(max_length=20, blank=True)
    bank_name = models.CharField(max_length=120, blank=True)
    bank_code = models.CharField(max_length=16, blank=True)
    currency_code = models.CharField(max_length=8, default="NGN")
    customer_email = models.EmailField()
    customer_name = models.CharField(max_length=120)
    status = models.CharField(max_length=24, blank=True)
    accounts = models.JSONField(default=list, blank=True)
    raw_response = models.JSONField(default=dict, blank=True)
    provider = models.CharField(max_length=32, default="monnify")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def sync_from_response(self, response_body: dict):
        primary_account = (response_body.get("accounts") or [{}])[0]
        self.reservation_reference = response_body.get("reservationReference", "")
        self.account_name = response_body.get("accountName", self.account_name)
        self.account_number = primary_account.get("accountNumber", "")
        self.bank_name = primary_account.get("bankName", "")
        self.bank_code = primary_account.get("bankCode", "")
        self.currency_code = response_body.get("currencyCode", self.currency_code)
        self.customer_email = response_body.get("customerEmail", self.customer_email)
        self.customer_name = response_body.get("customerName", self.customer_name)
        self.status = response_body.get("status", self.status)
        self.accounts = response_body.get("accounts") or []
        self.raw_response = response_body

    def __str__(self):
        return f"{self.wallet.user.email} monnify account"


class WalletTransaction(models.Model):
    class Type(models.TextChoices):
        DEPOSIT = "deposit", "Deposit"
        WITHDRAWAL = "withdrawal", "Withdrawal"
        SUBSCRIPTION = "subscription", "Subscription"
        PAYOUT = "payout", "Payout"
        ESCROW = "escrow", "Escrow"
        ADJUSTMENT = "adjustment", "Adjustment"

    class Status(models.TextChoices):
        PENDING = "pending", "Pending"
        SUCCESS = "success", "Success"
        FAILED = "failed", "Failed"
        CANCELLED = "cancelled", "Cancelled"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    wallet = models.ForeignKey(
        Wallet, on_delete=models.CASCADE, related_name="transactions"
    )
    transaction_type = models.CharField(max_length=24, choices=Type.choices)
    status = models.CharField(
        max_length=16, choices=Status.choices, default=Status.PENDING, db_index=True
    )
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    reference = models.CharField(max_length=64, unique=True)
    description = models.CharField(max_length=255, blank=True)
    related_type = models.CharField(max_length=64, blank=True)
    gateway = models.CharField(max_length=32, blank=True)
    gateway_response = models.JSONField(default=dict, blank=True)
    customer_email = models.EmailField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def mark_successful(self):
        if self.status == self.Status.SUCCESS:
            return
        self.status = self.Status.SUCCESS
        self.save(update_fields=["status", "updated_at"])
        if self.transaction_type in [self.Type.DEPOSIT, self.Type.ADJUSTMENT]:
            self.wallet.credit(self.amount)
        elif self.transaction_type in [self.Type.WITHDRAWAL, self.Type.PAYOUT]:
            self.wallet.debit(self.amount)

    def mark_failed(self):
        self.status = self.Status.FAILED
        self.save(update_fields=["status", "updated_at"])


class SavedBankAccount(models.Model):
    wallet = models.ForeignKey(
        Wallet, on_delete=models.CASCADE, related_name="bank_accounts"
    )
    account_name = models.CharField(max_length=120)
    account_number = models.CharField(max_length=20)
    bank_code = models.CharField(max_length=16)
    bank_name = models.CharField(max_length=120)
    is_default = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)


@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def ensure_wallet_exists(sender, instance, created, **kwargs):
    if created:
        Wallet.objects.get_or_create(user=instance)

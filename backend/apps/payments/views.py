from __future__ import annotations

import hashlib
import hmac
import json
import uuid
from decimal import Decimal

from django.conf import settings
from django.http import HttpResponse
from django.shortcuts import get_object_or_404
from django.urls import reverse
from rest_framework import permissions, response, status
from rest_framework.exceptions import ValidationError
from rest_framework.views import APIView

from apps.accounts.models import KycRecord

from .models import MonnifyReservedAccount, SavedBankAccount, Wallet, WalletTransaction
from .monnify import get_reserved_account, reserve_account
from .serializers import (
    MonnifyReservedAccountSerializer,
    PaymentInitializeSerializer,
    SavedBankAccountSerializer,
    WalletSerializer,
    WalletTransactionSerializer,
    WithdrawalInitializeSerializer,
)

SUPPORTED_BANKS = [
    {"name": "Access Bank", "code": "044"},
    {"name": "First Bank", "code": "011"},
    {"name": "GTBank", "code": "058"},
    {"name": "UBA", "code": "033"},
    {"name": "Zenith Bank", "code": "057"},
]


def _stable_monnify_account_reference(wallet: Wallet) -> str:
    return f"movr-wallet-{wallet.id}"


def _display_name_for_user(user) -> str:
    full_name = f"{user.first_name} {user.last_name}".strip()
    if full_name:
        return full_name
    local_part = user.email.split("@", 1)[0].replace(".", " ").replace("_", " ").strip()
    return local_part.title() or "Movr User"


def _extract_missing_kyc_fields(user) -> list[str]:
    try:
        kyc_record = user.kyc_record
    except KycRecord.DoesNotExist:
        return ["bvn_or_nin"]
    if kyc_record.bvn or kyc_record.nin:
        return []
    return ["bvn_or_nin"]


def _build_reserved_account_payload(wallet: Wallet) -> dict:
    missing = _extract_missing_kyc_fields(wallet.user)
    if missing:
        raise ValidationError(
            {
                "detail": "Complete your KYC with at least your BVN or NIN before creating a funding account.",
                "code": "kyc_required",
                "missing_requirements": missing,
            }
        )

    kyc_record = wallet.user.kyc_record
    payload = {
        "accountReference": _stable_monnify_account_reference(wallet),
        "accountName": f"Movr {wallet.user.first_name or _display_name_for_user(wallet.user)} Wallet".strip(),
        "currencyCode": wallet.currency,
        "contractCode": settings.MONNIFY_CONTRACT_CODE,
        "customerEmail": wallet.user.email,
        "customerName": _display_name_for_user(wallet.user),
        "getAllAvailableBanks": True,
    }
    if kyc_record.bvn:
        payload["bvn"] = kyc_record.bvn
    if kyc_record.nin:
        payload["nin"] = kyc_record.nin
    return payload


def _upsert_reserved_account(wallet: Wallet, response_body: dict) -> MonnifyReservedAccount:
    reserved_account, _ = MonnifyReservedAccount.objects.get_or_create(
        wallet=wallet,
        defaults={
            "account_reference": response_body.get("accountReference", _stable_monnify_account_reference(wallet)),
            "account_name": response_body.get("accountName", f"Movr {wallet.user.email}"),
            "customer_email": response_body.get("customerEmail", wallet.user.email),
            "customer_name": response_body.get("customerName", _display_name_for_user(wallet.user)),
            "currency_code": response_body.get("currencyCode", wallet.currency),
        },
    )
    if not reserved_account.account_reference:
        reserved_account.account_reference = response_body.get("accountReference", _stable_monnify_account_reference(wallet))
    reserved_account.sync_from_response(response_body)
    reserved_account.save()
    return reserved_account


def _ensure_reserved_account(wallet: Wallet) -> MonnifyReservedAccount:
    existing_account = getattr(wallet, "monnify_account", None)
    if existing_account and existing_account.account_number:
        return existing_account

    account_reference = _stable_monnify_account_reference(wallet)
    payload = _build_reserved_account_payload(wallet)
    try:
        monnify_payload = reserve_account(payload)
        response_body = monnify_payload.get("responseBody") or {}
    except ValidationError as exc:
        error_text = str(exc.detail)
        if "same reference" not in error_text.lower() and "existing active reserved account" not in error_text.lower():
            raise
        response_body = (get_reserved_account(account_reference) or {}).get("responseBody") or {}

    if not response_body:
        raise ValidationError("Monnify did not return reserved account details.")

    return _upsert_reserved_account(wallet, response_body)


def _build_mock_checkout_url(request, reference: str) -> str:
    return request.build_absolute_uri(reverse("payment-checkout", kwargs={"reference": reference}))


def _legacy_verify_payload(transaction: WalletTransaction) -> dict:
    return {
        "id": str(transaction.id),
        "domain": "movr",
        "status": transaction.status,
        "reference": transaction.reference,
        "receipt_number": str(transaction.id),
        "amount": int(transaction.amount * Decimal("100")),
        "message": transaction.description,
        "gateway_response": transaction.gateway_response.get("message", transaction.status),
        "paid_at": transaction.updated_at.isoformat(),
        "created_at": transaction.created_at.isoformat(),
        "channel": "mock_checkout",
        "currency": transaction.wallet.currency,
        "fees": 0,
        "customer": {
            "email": transaction.customer_email or transaction.wallet.user.email,
        },
    }


class WalletView(APIView):
    def get(self, request):
        wallet, _ = Wallet.objects.get_or_create(user=request.user)
        wallet_data = WalletSerializer(wallet).data
        wallet_data["transactions"] = WalletTransactionSerializer(wallet.transactions.order_by("-created_at")[:50], many=True).data
        return response.Response(wallet_data)


class LegacyWalletView(WalletView):
    pass


class FundingAccountView(APIView):
    def get(self, request):
        wallet, _ = Wallet.objects.get_or_create(user=request.user)
        funding_account = getattr(wallet, "monnify_account", None)
        if not funding_account:
            missing = _extract_missing_kyc_fields(request.user)
            return response.Response(
                {
                    "status": False,
                    "message": "No dedicated funding account yet.",
                    "detail": (
                        "Complete your KYC with at least your BVN or NIN before creating a funding account."
                        if missing
                        else "Create your Monnify funding account to top up your wallet by bank transfer."
                    ),
                    "missing_requirements": missing,
                    "data": None,
                },
                status=status.HTTP_404_NOT_FOUND,
            )

        return response.Response(
            {
                "status": True,
                "message": "Funding account retrieved.",
                "data": MonnifyReservedAccountSerializer(funding_account).data,
            }
        )

    def post(self, request):
        wallet, _ = Wallet.objects.get_or_create(user=request.user)
        funding_account = _ensure_reserved_account(wallet)
        return response.Response(
            {
                "status": True,
                "message": "Funding account ready.",
                "data": MonnifyReservedAccountSerializer(funding_account).data,
            },
            status=status.HTTP_201_CREATED,
        )


class WalletBalanceView(APIView):
    def get(self, request):
        wallet, _ = Wallet.objects.get_or_create(user=request.user)
        return response.Response(
            {
                "status": True,
                "balance": wallet.balance,
                "available_balance": wallet.available_balance,
                "currency": wallet.currency,
            }
        )


class TransactionHistoryView(APIView):
    def get(self, request):
        wallet, _ = Wallet.objects.get_or_create(user=request.user)
        transactions = wallet.transactions.order_by("-created_at")
        return response.Response(
            {
                "status": True,
                "count": transactions.count(),
                "results": WalletTransactionSerializer(transactions[:100], many=True).data,
            }
        )


class PaymentInitializeView(APIView):
    def post(self, request):
        serializer = PaymentInitializeSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        wallet, _ = Wallet.objects.get_or_create(user=request.user)
        reference = serializer.validated_data.get("reference") or uuid.uuid4().hex[:16]
        transaction = WalletTransaction.objects.create(
            wallet=wallet,
            transaction_type=WalletTransaction.Type.DEPOSIT,
            status=WalletTransaction.Status.PENDING,
            amount=serializer.validated_data["amount"],
            reference=reference,
            description=serializer.validated_data.get("description", ""),
            related_type=serializer.validated_data.get("related_type", ""),
            gateway="mock_paystack",
            customer_email=serializer.validated_data.get("email", request.user.email),
        )
        return response.Response(
            {
                "status": True,
                "message": "Payment initialized.",
                "data": {
                    "reference": transaction.reference,
                    "access_code": transaction.reference,
                    "authorization_url": _build_mock_checkout_url(request, transaction.reference),
                },
            }
        )


class PaymentCheckoutView(APIView):
    permission_classes = [permissions.AllowAny]
    authentication_classes = []

    def get(self, request, reference):
        transaction = get_object_or_404(WalletTransaction, reference=reference)
        result = request.query_params.get("result")
        if result == "successful":
            transaction.gateway_response = {"message": "Simulated checkout completed"}
            transaction.save(update_fields=["gateway_response", "updated_at"])
            transaction.mark_successful()
        elif result == "cancelled":
            transaction.mark_failed()

        success_url = f"{request.path}?result=successful&reference={transaction.reference}"
        cancel_url = f"{request.path}?result=cancelled"
        html = f"""
        <html>
          <head><title>Movr Checkout</title></head>
          <body style="font-family: Arial; padding: 24px;">
            <h1>Movr Mock Checkout</h1>
            <p>This placeholder checkout lets the mobile app work before live gateway credentials are configured.</p>
            <p>Reference: <strong>{transaction.reference}</strong></p>
            <a href="{success_url}" style="display:inline-block;padding:12px 20px;background:#0f766e;color:white;text-decoration:none;margin-right:12px;">Simulate Success</a>
            <a href="{cancel_url}" style="display:inline-block;padding:12px 20px;background:#b91c1c;color:white;text-decoration:none;">Cancel</a>
          </body>
        </html>
        """
        return HttpResponse(html)


class PaymentVerifyView(APIView):
    def post(self, request):
        transaction = get_object_or_404(WalletTransaction, reference=request.data.get("reference"), wallet__user=request.user)
        return response.Response(
            {
                "status": True,
                "message": "Payment verification completed.",
                "data": {
                    "reference": transaction.reference,
                    "status": transaction.status,
                    "amount": transaction.amount,
                    "currency": transaction.wallet.currency,
                },
            }
        )


class LegacyPaystackInitializeView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = PaymentInitializeSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        wallet = request.user.wallet if request.user and request.user.is_authenticated else Wallet.objects.first()
        if wallet is None:
            return response.Response({"status": False, "message": "Create a user before testing legacy payments."}, status=status.HTTP_400_BAD_REQUEST)
        reference = serializer.validated_data.get("reference") or uuid.uuid4().hex[:16]
        transaction = WalletTransaction.objects.create(
            wallet=wallet,
            transaction_type=WalletTransaction.Type.DEPOSIT,
            status=WalletTransaction.Status.PENDING,
            amount=serializer.validated_data["amount"],
            reference=reference,
            description="Legacy Paystack initialization",
            related_type=serializer.validated_data.get("related_type", "deposit"),
            gateway="legacy_paystack",
            customer_email=serializer.validated_data.get("email", wallet.user.email),
        )
        return response.Response(
            {
                "status": True,
                "message": "Initialized successfully.",
                "data": {
                    "authorization_url": _build_mock_checkout_url(request, transaction.reference),
                    "access_code": transaction.reference,
                    "reference": transaction.reference,
                },
            }
        )


class LegacyPaystackVerifyView(APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, _request, reference):
        transaction = get_object_or_404(WalletTransaction, reference=reference)
        return response.Response({"status": True, "message": "Verification complete.", "data": _legacy_verify_payload(transaction)})


class LegacyMonnifyInitializeView(LegacyPaystackInitializeView):
    def post(self, request):
        payload = super().post(request).data
        data = payload["data"]
        return response.Response(
            {
                "paymentUrl": data["authorization_url"],
                "accessCode": data["access_code"],
                "reference": data["reference"],
            }
        )


class LegacyMonnifyVerifyView(APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, _request, reference):
        transaction = get_object_or_404(WalletTransaction, reference=reference)
        return response.Response({"status": transaction.status == WalletTransaction.Status.SUCCESS})


class MonnifyWebhookView(APIView):
    permission_classes = [permissions.AllowAny]
    authentication_classes = []

    def post(self, request):
        raw_body = request.body or b""
        provided_signature = request.headers.get("monnify-signature", "")
        expected_signature = hmac.new(
            settings.MONNIFY_SECRET_KEY.encode("utf-8"),
            raw_body,
            hashlib.sha512,
        ).hexdigest()

        if not provided_signature or not hmac.compare_digest(provided_signature.lower(), expected_signature.lower()):
            return response.Response({"status": False, "message": "Invalid webhook signature."}, status=status.HTTP_401_UNAUTHORIZED)

        try:
            payload = json.loads(raw_body.decode("utf-8"))
        except json.JSONDecodeError:
            return response.Response({"status": False, "message": "Invalid JSON payload."}, status=status.HTTP_400_BAD_REQUEST)

        event_type = payload.get("eventType")
        event_data = payload.get("eventData") or {}
        product = event_data.get("product") or {}
        if event_type != "SUCCESSFUL_TRANSACTION":
            return response.Response({"status": True, "message": "Webhook ignored."})
        if product.get("type") != "RESERVED_ACCOUNT":
            return response.Response({"status": True, "message": "Webhook ignored."})
        if str(event_data.get("paymentStatus", "")).upper() != "PAID":
            return response.Response({"status": True, "message": "Webhook ignored."})

        account_reference = product.get("reference")
        if not account_reference:
            return response.Response({"status": False, "message": "Reserved account reference missing."}, status=status.HTTP_400_BAD_REQUEST)

        funding_account = MonnifyReservedAccount.objects.filter(account_reference=account_reference).select_related("wallet").first()
        if funding_account is None:
            return response.Response({"status": True, "message": "Funding account not found locally."})

        transaction_reference = event_data.get("transactionReference") or event_data.get("paymentReference")
        if not transaction_reference:
            return response.Response({"status": False, "message": "Transaction reference missing."}, status=status.HTTP_400_BAD_REQUEST)

        amount = Decimal(str(event_data.get("amountPaid") or event_data.get("totalPayable") or "0"))
        transaction, created = WalletTransaction.objects.get_or_create(
            reference=transaction_reference,
            defaults={
                "wallet": funding_account.wallet,
                "transaction_type": WalletTransaction.Type.DEPOSIT,
                "status": WalletTransaction.Status.PENDING,
                "amount": amount,
                "description": "Wallet funding via Monnify transfer",
                "related_type": "wallet_top_up",
                "gateway": "monnify_reserved_account",
                "gateway_response": payload,
                "customer_email": funding_account.customer_email,
            },
        )
        if not created:
            transaction.gateway_response = payload
            transaction.save(update_fields=["gateway_response", "updated_at"])

        if transaction.status != WalletTransaction.Status.SUCCESS:
            transaction.mark_successful()

        return response.Response({"status": True, "message": "Webhook processed."})


class BanksView(APIView):
    def get(self, _request):
        return response.Response({"status": True, "data": SUPPORTED_BANKS})


class WithdrawalInitializeView(APIView):
    def post(self, request):
        serializer = WithdrawalInitializeSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        wallet, _ = Wallet.objects.get_or_create(user=request.user)
        amount = serializer.validated_data["amount"]
        if wallet.available_balance < amount:
            return response.Response({"status": False, "message": "Insufficient wallet balance."}, status=status.HTTP_400_BAD_REQUEST)

        reference = uuid.uuid4().hex[:16]
        transaction = WalletTransaction.objects.create(
            wallet=wallet,
            transaction_type=WalletTransaction.Type.WITHDRAWAL,
            status=WalletTransaction.Status.PENDING,
            amount=amount,
            reference=reference,
            description="Withdrawal request",
            related_type="withdrawal",
            gateway="bank_transfer",
            customer_email=request.user.email,
        )
        SavedBankAccount.objects.update_or_create(
            wallet=wallet,
            account_number=serializer.validated_data["account_number"],
            defaults={
                "account_name": serializer.validated_data["account_name"],
                "bank_code": serializer.validated_data["bank_code"],
                "bank_name": next((bank["name"] for bank in SUPPORTED_BANKS if bank["code"] == serializer.validated_data["bank_code"]), "Bank"),
                "is_default": True,
            },
        )
        return response.Response({"status": True, "message": "Withdrawal initialized.", "data": {"reference": transaction.reference, "transfer_code": transaction.reference}}, status=status.HTTP_201_CREATED)


class WithdrawalCompleteView(APIView):
    def post(self, request):
        transaction = get_object_or_404(
            WalletTransaction,
            reference=request.data.get("reference"),
            wallet__user=request.user,
            transaction_type=WalletTransaction.Type.WITHDRAWAL,
        )
        if transaction.status == WalletTransaction.Status.SUCCESS:
            return response.Response({"status": True, "message": "Withdrawal already completed."})
        if transaction.wallet.available_balance < transaction.amount:
            transaction.mark_failed()
            return response.Response({"status": False, "message": "Insufficient wallet balance."}, status=status.HTTP_400_BAD_REQUEST)

        transaction.mark_successful()
        return response.Response({"status": True, "message": "Withdrawal completed.", "data": {"reference": transaction.reference, "status": transaction.status}})


class BankAccountListView(APIView):
    def get(self, request):
        wallet, _ = Wallet.objects.get_or_create(user=request.user)
        return response.Response(SavedBankAccountSerializer(wallet.bank_accounts.all(), many=True).data)

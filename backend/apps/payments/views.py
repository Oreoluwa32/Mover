from __future__ import annotations

import uuid
from decimal import Decimal

from django.http import HttpResponse
from django.shortcuts import get_object_or_404
from django.urls import reverse
from rest_framework import permissions, response, status
from rest_framework.views import APIView

from .models import SavedBankAccount, Wallet, WalletTransaction
from .serializers import PaymentInitializeSerializer, SavedBankAccountSerializer, WalletSerializer, WalletTransactionSerializer, WithdrawalInitializeSerializer

SUPPORTED_BANKS = [
    {"name": "Access Bank", "code": "044"},
    {"name": "First Bank", "code": "011"},
    {"name": "GTBank", "code": "058"},
    {"name": "UBA", "code": "033"},
    {"name": "Zenith Bank", "code": "057"},
]


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

from __future__ import annotations

from rest_framework import serializers

from .models import MonnifyReservedAccount, SavedBankAccount, Wallet, WalletTransaction


class WalletTransactionSerializer(serializers.ModelSerializer):
    type = serializers.CharField(source="transaction_type", read_only=True)
    date = serializers.SerializerMethodField()
    time = serializers.SerializerMethodField()

    class Meta:
        model = WalletTransaction
        fields = [
            "id",
            "type",
            "transaction_type",
            "amount",
            "status",
            "reference",
            "description",
            "related_type",
            "created_at",
            "date",
            "time",
        ]

    def get_date(self, obj):
        return obj.created_at.date().isoformat()

    def get_time(self, obj):
        return obj.created_at.strftime("%H:%M")


class WalletSerializer(serializers.ModelSerializer):
    funding_account = serializers.SerializerMethodField()
    transactions = WalletTransactionSerializer(many=True, read_only=True)

    class Meta:
        model = Wallet
        fields = ["balance", "available_balance", "currency", "funding_account", "transactions"]

    def get_funding_account(self, obj):
        funding_account = getattr(obj, "monnify_account", None)
        if not funding_account:
            return None
        return MonnifyReservedAccountSerializer(funding_account).data


class PaymentInitializeSerializer(serializers.Serializer):
    amount = serializers.DecimalField(max_digits=12, decimal_places=2)
    description = serializers.CharField(required=False, allow_blank=True, default="")
    related_type = serializers.CharField(required=False, allow_blank=True, default="deposit")
    email = serializers.EmailField(required=False)
    reference = serializers.CharField(required=False, allow_blank=True)
    channels = serializers.ListField(child=serializers.CharField(), required=False)


class WithdrawalInitializeSerializer(serializers.Serializer):
    amount = serializers.DecimalField(max_digits=12, decimal_places=2)
    account_number = serializers.CharField()
    bank_code = serializers.CharField()
    account_name = serializers.CharField()


class SavedBankAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = SavedBankAccount
        fields = "__all__"
        read_only_fields = ["wallet", "created_at"]


class MonnifyReservedAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = MonnifyReservedAccount
        fields = [
            "account_reference",
            "reservation_reference",
            "account_name",
            "account_number",
            "bank_name",
            "bank_code",
            "currency_code",
            "customer_email",
            "customer_name",
            "status",
            "accounts",
            "provider",
        ]

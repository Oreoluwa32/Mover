from __future__ import annotations

from rest_framework import serializers

from .models import SavedBankAccount, Wallet, WalletTransaction


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
    transactions = WalletTransactionSerializer(many=True, read_only=True)

    class Meta:
        model = Wallet
        fields = ["balance", "available_balance", "currency", "transactions"]


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

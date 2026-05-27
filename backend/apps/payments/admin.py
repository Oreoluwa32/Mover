from django.contrib import admin

from .models import SavedBankAccount, Wallet, WalletTransaction


@admin.register(Wallet)
class WalletAdmin(admin.ModelAdmin):
    list_display = ("user", "balance", "available_balance", "currency", "updated_at")
    search_fields = ("user__email",)
    raw_id_fields = ("user",)
    readonly_fields = ("updated_at",)


@admin.register(WalletTransaction)
class WalletTransactionAdmin(admin.ModelAdmin):
    list_display = (
        "reference",
        "wallet",
        "transaction_type",
        "status",
        "amount",
        "gateway",
        "customer_email",
        "created_at",
    )
    list_filter = ("transaction_type", "status", "gateway")
    search_fields = (
        "reference",
        "wallet__user__email",
        "customer_email",
        "description",
    )
    raw_id_fields = ("wallet",)
    readonly_fields = ("created_at", "updated_at")
    date_hierarchy = "created_at"


@admin.register(SavedBankAccount)
class SavedBankAccountAdmin(admin.ModelAdmin):
    list_display = (
        "wallet",
        "account_name",
        "account_number",
        "bank_name",
        "is_default",
        "created_at",
    )
    list_filter = ("is_default", "bank_name")
    search_fields = (
        "wallet__user__email",
        "account_name",
        "account_number",
        "bank_name",
    )
    raw_id_fields = ("wallet",)
    readonly_fields = ("created_at",)

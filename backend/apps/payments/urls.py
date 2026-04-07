from django.urls import path

from .views import (
    BankAccountListView,
    BanksView,
    LegacyMonnifyInitializeView,
    LegacyMonnifyVerifyView,
    LegacyPaystackInitializeView,
    LegacyPaystackVerifyView,
    PaymentCheckoutView,
    PaymentInitializeView,
    PaymentVerifyView,
    TransactionHistoryView,
    WalletBalanceView,
    WalletView,
    WithdrawalCompleteView,
    WithdrawalInitializeView,
)

urlpatterns = [
    path("wallet/", WalletView.as_view()),
    path("wallet/balance", WalletBalanceView.as_view()),
    path("transactions", TransactionHistoryView.as_view()),
    path("initialize", PaymentInitializeView.as_view()),
    path("verify", PaymentVerifyView.as_view()),
    path("banks", BanksView.as_view()),
    path("bank-accounts/", BankAccountListView.as_view()),
    path("withdrawal/initialize", WithdrawalInitializeView.as_view()),
    path("withdrawal/complete", WithdrawalCompleteView.as_view()),
    path("checkout/<str:reference>/", PaymentCheckoutView.as_view(), name="payment-checkout"),
    path("paystack/initialize-transaction", LegacyPaystackInitializeView.as_view()),
    path("paystack/verify-transaction/<str:reference>", LegacyPaystackVerifyView.as_view()),
    path("v1/merchant/transactions/init-transaction", LegacyMonnifyInitializeView.as_view()),
    path("v1/merchant/transactions/verify/<str:reference>", LegacyMonnifyVerifyView.as_view()),
]

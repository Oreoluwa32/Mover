from django.contrib import admin

from .models import SavedBankAccount, Wallet, WalletTransaction

admin.site.register(Wallet)
admin.site.register(WalletTransaction)
admin.site.register(SavedBankAccount)

class WalletModel {
  final double? balance;
  final double? availableBalance;
  final String? currency;
  final WalletFundingAccount? fundingAccount;
  final List<WalletTransaction>? transactions;

  WalletModel({
    this.balance,
    this.availableBalance,
    this.currency,
    this.fundingAccount,
    this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: (json['balance'] as num?)?.toDouble(),
      availableBalance: (json['available_balance'] as num?)?.toDouble(),
      currency: json['currency']?.toString(),
      fundingAccount: json['funding_account'] is Map<String, dynamic>
          ? WalletFundingAccount.fromJson(
              json['funding_account'] as Map<String, dynamic>,
            )
          : null,
      transactions: (json['transactions'] as List?)
          ?.map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WalletFundingAccount {
  final String? accountReference;
  final String? reservationReference;
  final String? accountName;
  final String? accountNumber;
  final String? bankName;
  final String? bankCode;
  final String? currencyCode;
  final String? customerEmail;
  final String? customerName;
  final String? status;
  final List<WalletFundingBankAccount> accounts;

  WalletFundingAccount({
    this.accountReference,
    this.reservationReference,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.bankCode,
    this.currencyCode,
    this.customerEmail,
    this.customerName,
    this.status,
    this.accounts = const [],
  });

  factory WalletFundingAccount.fromJson(Map<String, dynamic> json) {
    return WalletFundingAccount(
      accountReference: json['account_reference']?.toString(),
      reservationReference: json['reservation_reference']?.toString(),
      accountName: json['account_name']?.toString(),
      accountNumber: json['account_number']?.toString(),
      bankName: json['bank_name']?.toString(),
      bankCode: json['bank_code']?.toString(),
      currencyCode: json['currency_code']?.toString(),
      customerEmail: json['customer_email']?.toString(),
      customerName: json['customer_name']?.toString(),
      status: json['status']?.toString(),
      accounts: (json['accounts'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(WalletFundingBankAccount.fromJson)
              .toList() ??
          const [],
    );
  }
}

class WalletFundingBankAccount {
  final String? bankCode;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;

  WalletFundingBankAccount({
    this.bankCode,
    this.bankName,
    this.accountNumber,
    this.accountName,
  });

  factory WalletFundingBankAccount.fromJson(Map<String, dynamic> json) {
    return WalletFundingBankAccount(
      bankCode: json['bankCode']?.toString(),
      bankName: json['bankName']?.toString(),
      accountNumber: json['accountNumber']?.toString(),
      accountName: json['accountName']?.toString(),
    );
  }
}

class WalletTransaction {
  final String? id;
  final String? type;
  final String? amount;
  final String? status;
  final String? date;
  final String? time;

  WalletTransaction({
    this.id,
    this.type,
    this.amount,
    this.status,
    this.date,
    this.time,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    // Basic mapping, might need adjustment based on actual API response format
    return WalletTransaction(
      id: json['id']?.toString(),
      type: json['transaction_type'] ?? json['type'] ?? 'Transaction',
      amount: json['amount']?.toString(),
      status: json['status'],
      date: json['date'] ?? json['created_at']?.toString().split('T').first,
      time: json['time'] ??
          json['created_at']?.toString().split('T').last.substring(0, 5),
    );
  }
}

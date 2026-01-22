class WalletModel {
  final double? balance;
  final List<WalletTransaction>? transactions;

  WalletModel({this.balance, this.transactions});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: (json['balance'] as num?)?.toDouble(),
      transactions: (json['transactions'] as List?)
          ?.map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      time: json['time'] ?? json['created_at']?.toString().split('T').last.substring(0, 5),
    );
  }
}

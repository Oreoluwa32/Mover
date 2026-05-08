import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatAmount(
    num? amount, {
    String currency = 'NGN',
    int decimalDigits = 2,
  }) {
    final normalizedAmount = amount ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '$currency ',
      decimalDigits: decimalDigits,
    );
    return formatter.format(normalizedAmount);
  }

  static String formatSignedAmount(
    num? amount, {
    String currency = 'NGN',
    int decimalDigits = 2,
  }) {
    final normalizedAmount = amount ?? 0;
    final sign = normalizedAmount >= 0 ? '+' : '-';
    return '$sign ${formatAmount(
      normalizedAmount.abs(),
      currency: currency,
      decimalDigits: decimalDigits,
    )}';
  }
}

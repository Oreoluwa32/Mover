class PaystackPaymentState {
  final String paymentUrl;
  final bool isLoading;
  final String error;
  final bool paymentSuccessful;
  final String reference;

  PaystackPaymentState({
    required this.paymentUrl,
    required this.isLoading,
    required this.error,
    required this.paymentSuccessful,
    required this.reference,
  });

  PaystackPaymentState copyWith({
    String? paymentUrl,
    bool? isLoading,
    String? error,
    bool? paymentSuccessful,
    String? reference,
  }) {
    return PaystackPaymentState(
      paymentUrl: paymentUrl ?? this.paymentUrl,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      paymentSuccessful: paymentSuccessful ?? this.paymentSuccessful,
      reference: reference ?? this.reference,
    );
  }
}
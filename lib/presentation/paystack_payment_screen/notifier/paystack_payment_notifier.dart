import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'paystack_payment_state.dart';

final paystackPaymentNotifier = StateNotifierProvider.autoDispose<
    PaystackPaymentNotifier,
    PaystackPaymentState>((ref) => PaystackPaymentNotifier());

class PaystackPaymentNotifier extends StateNotifier<PaystackPaymentState> {
  PaystackPaymentNotifier()
      : super(PaystackPaymentState(
          paymentUrl: '',
          isLoading: false,
          error: '',
          paymentSuccessful: false,
          reference: '',
        ));

  void setPaymentUrl(String url) {
    state = state.copyWith(paymentUrl: url);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }

  void setPaymentSuccessful(bool successful, String reference) {
    state = state.copyWith(
      paymentSuccessful: successful,
      reference: reference,
    );
  }

  void resetState() {
    state = PaystackPaymentState(
      paymentUrl: '',
      isLoading: false,
      error: '',
      paymentSuccessful: false,
      reference: '',
    );
  }
}
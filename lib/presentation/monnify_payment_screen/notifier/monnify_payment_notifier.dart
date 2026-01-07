import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'monnify_payment_state.dart';

final monnifyPaymentNotifier = StateNotifierProvider.autoDispose<
    MonnifyPaymentNotifier,
    MonnifyPaymentState>((ref) => MonnifyPaymentNotifier());

class MonnifyPaymentNotifier extends StateNotifier<MonnifyPaymentState> {
  MonnifyPaymentNotifier()
      : super(MonnifyPaymentState(
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
    state = MonnifyPaymentState(
      paymentUrl: '',
      isLoading: false,
      error: '',
      paymentSuccessful: false,
      reference: '',
    );
  }
}

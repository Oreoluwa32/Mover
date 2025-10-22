import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/paystack_api_service.dart';
import 'wallet_notifier.dart';

/// State class for payment operations
class PaymentState {
  final String? reference;
  final String? accessCode;
  final String? authorizationUrl;
  final bool isInitializing;
  final bool isVerifying;
  final String? error;
  final String? successMessage;
  final bool isPaymentSuccessful;

  const PaymentState({
    this.reference,
    this.accessCode,
    this.authorizationUrl,
    this.isInitializing = false,
    this.isVerifying = false,
    this.error,
    this.successMessage,
    this.isPaymentSuccessful = false,
  });

  /// Create a copy of this state with optional field replacements
  PaymentState copyWith({
    String? reference,
    String? accessCode,
    String? authorizationUrl,
    bool? isInitializing,
    bool? isVerifying,
    String? error,
    String? successMessage,
    bool? isPaymentSuccessful,
  }) {
    return PaymentState(
      reference: reference ?? this.reference,
      accessCode: accessCode ?? this.accessCode,
      authorizationUrl: authorizationUrl ?? this.authorizationUrl,
      isInitializing: isInitializing ?? this.isInitializing,
      isVerifying: isVerifying ?? this.isVerifying,
      error: error,
      successMessage: successMessage,
      isPaymentSuccessful: isPaymentSuccessful ?? this.isPaymentSuccessful,
    );
  }

  /// Reset payment state
  PaymentState reset() {
    return const PaymentState();
  }
}

/// Riverpod StateNotifier for managing payment operations
class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaystackApiService apiService;

  PaymentNotifier({required this.apiService}) : super(const PaymentState());

  /// Initialize a payment with the backend
  Future<bool> initializePayment({
    required double amount,
    required String description,
    required String relatedType,
  }) async {
    state = state.copyWith(
      isInitializing: true,
      error: null,
      successMessage: null,
    );

    try {
      final response = await apiService.initializePayment(
        amount: amount,
        description: description,
        relatedType: relatedType,
      );

      if (response['status'] == true) {
        final data = response['data'] as Map<String, dynamic>;
        state = state.copyWith(
          reference: data['reference'] as String?,
          accessCode: data['access_code'] as String?,
          authorizationUrl: data['authorization_url'] as String?,
          isInitializing: false,
          successMessage: 'Payment initialized successfully',
        );
        return true;
      } else {
        throw Exception(
          response['message'] ?? 'Failed to initialize payment',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isInitializing: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Verify a payment with the backend
  Future<bool> verifyPayment({required String reference}) async {
    state = state.copyWith(
      isVerifying: true,
      error: null,
      successMessage: null,
    );

    try {
      final response = await apiService.verifyPayment(reference: reference);

      if (response['status'] == true) {
        final data = response['data'] as Map<String, dynamic>;
        final paymentStatus = data['status'] as String?;

        if (paymentStatus == 'success') {
          state = state.copyWith(
            isVerifying: false,
            isPaymentSuccessful: true,
            successMessage: 'Payment verified successfully',
          );
          return true;
        } else {
          throw Exception('Payment verification failed: $paymentStatus');
        }
      } else {
        throw Exception(
          response['message'] ?? 'Failed to verify payment',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isVerifying: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Clear any error messages
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Clear success messages
  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }

  /// Reset payment state for new transaction
  void resetPayment() {
    state = state.reset();
  }
}

/// Riverpod provider for the payment notifier
final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  final apiService = ref.watch(paystackApiServiceProvider);
  return PaymentNotifier(apiService: apiService);
});
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/paystack_api_service.dart';
import '../../../core/constants/paystack_constants.dart';

/// State class for wallet information
class WalletState {
  final double balance;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const WalletState({
    this.balance = 0.0,
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  /// Create a copy of this state with optional field replacements
  WalletState copyWith({
    double? balance,
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// Riverpod StateNotifier for managing wallet operations
class WalletNotifier extends StateNotifier<WalletState> {
  final PaystackApiService apiService;

  WalletNotifier({required this.apiService}) : super(const WalletState());

  /// Fetch the current wallet balance
  Future<void> fetchWalletBalance() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await apiService.getWalletBalance();

      if (response['status'] == true) {
        final data = response['data'] as Map<String, dynamic>;
        final balance = (data['balance'] as num).toDouble();

        state = state.copyWith(
          balance: balance,
          isLoading: false,
          successMessage: 'Balance fetched successfully',
        );
      } else {
        throw Exception(
          response['message'] ?? 'Failed to fetch wallet balance',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh wallet balance (useful for pull-to-refresh)
  Future<void> refreshBalance() async {
    await fetchWalletBalance();
  }

  /// Clear any error messages
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Clear success messages
  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }
}

/// Riverpod provider for the Paystack API service
final paystackApiServiceProvider = Provider<PaystackApiService>((ref) {
  return PaystackApiService(
    customBaseUrl: PaystackConstants.apiBaseUrl,
  );
});

/// Riverpod provider for the wallet notifier
final walletNotifierProvider =
    StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  final apiService = ref.watch(paystackApiServiceProvider);
  return WalletNotifier(apiService: apiService);
});

/// Riverpod provider to fetch wallet balance on demand
final walletBalanceProvider = FutureProvider<double>((ref) async {
  final apiService = ref.watch(paystackApiServiceProvider);
  final response = await apiService.getWalletBalance();

  if (response['status'] == true) {
    final data = response['data'] as Map<String, dynamic>;
    return (data['balance'] as num).toDouble();
  } else {
    throw Exception(response['message'] ?? 'Failed to fetch balance');
  }
});
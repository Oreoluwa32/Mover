import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'quick_deposit_state.dart';

/// Notifier for quick deposit bottom sheet
class QuickDepositNotifier extends StateNotifier<QuickDepositState> {
  QuickDepositNotifier() : super(QuickDepositState());

  /// Initialize controllers
  void init() {
    state = state.copyWith(
      amountController: TextEditingController(),
      emailController: TextEditingController(),
    );
  }

  /// Reset state when closing bottom sheet
  void reset() {
    state.amountController?.clear();
    state.emailController?.clear();
    state.amountController?.dispose();
    state.emailController?.dispose();
  }

  /// Update amount
  void setAmount(String amount) {
    state = state.copyWith(amount: amount);
  }

  /// Update email
  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Set error message
  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for quick deposit notifier
final quickDepositNotifier = StateNotifierProvider<QuickDepositNotifier, QuickDepositState>((ref) {
  final notifier = QuickDepositNotifier();
  notifier.init();
  return notifier;
});
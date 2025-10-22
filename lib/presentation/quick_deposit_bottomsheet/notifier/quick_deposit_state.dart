import 'package:flutter/material.dart';

/// State for quick deposit bottom sheet
class QuickDepositState {
  final TextEditingController? amountController;
  final TextEditingController? emailController;
  final String amount;
  final String email;
  final bool isLoading;
  final String? error;

  QuickDepositState({
    this.amountController,
    this.emailController,
    this.amount = '',
    this.email = '',
    this.isLoading = false,
    this.error,
  });

  /// Create a copy with modified fields
  QuickDepositState copyWith({
    TextEditingController? amountController,
    TextEditingController? emailController,
    String? amount,
    String? email,
    bool? isLoading,
    String? error,
  }) {
    return QuickDepositState(
      amountController: amountController ?? this.amountController,
      emailController: emailController ?? this.emailController,
      amount: amount ?? this.amount,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
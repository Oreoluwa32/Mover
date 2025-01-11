import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/payment_model.dart';
part 'payment_state.dart';

final paymentNotifier =
    StateNotifierProvider.autoDispose<PaymentNotifier, PaymentState>(
  (ref) => PaymentNotifier(PaymentState()),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier(PaymentState state) : super(state);
}

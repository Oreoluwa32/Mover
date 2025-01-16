import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/deposit_bottomsheet_model.dart';
part 'deposit_bottomsheet_state.dart';

final depositBottomsheetNotifier = StateNotifierProvider.autoDispose<
    DepositBottomsheetNotifier, DepositBottomsheetState>(
  (ref) => DepositBottomsheetNotifier(DepositBottomsheetState(
      cardNumController: TextEditingController(),
      expiryDateController: TextEditingController(),
      cvvController: TextEditingController(),
      nameController: TextEditingController())),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class DepositBottomsheetNotifier
    extends StateNotifier<DepositBottomsheetState> {
  DepositBottomsheetNotifier(DepositBottomsheetState state) : super(state);
}

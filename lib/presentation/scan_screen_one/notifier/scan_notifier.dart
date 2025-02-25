import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../core/app_export.dart';
import '../models/scan_model.dart';
part 'scan_state.dart';

final scanNotifier = StateNotifierProvider.autoDispose<ScanNotifier, ScanState>(
  (ref) => ScanNotifier(ScanState(
    codeController: TextEditingController(),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class ScanNotifier extends StateNotifier<ScanState> with CodeAutoFill{
  ScanNotifier(ScanState state) : super(state);

  @override
  void codeUpdated() {
    state.codeController?.text = code ?? '';
  }
}
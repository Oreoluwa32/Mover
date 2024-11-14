import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../core/app_export.dart';
import '../models/check_mail_model.dart';
part 'check_mail_state.dart';

final checkMailNotifier = StateNotifierProvider.autoDispose<CheckMailNotifier, CheckMailState>(
  (ref) => CheckMailNotifier(CheckMailState(
    otpController: TextEditingController(),
  )),
);

// A notifier that manages the state of check mail according to the event that is dispatched to it.
class CheckMailNotifier extends StateNotifier<CheckMailState> with CodeAutoFill{
  CheckMailNotifier(CheckMailState state) : super(state);

  @override
  void codeUpdated() {
    state.otpController?.text = code ?? '';
  }
}
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/reset_password_model.dart';
part 'reset_password_state.dart';

final resetPasswordNotifier = StateNotifierProvider.autoDispose.family<ResetPasswordNotifier, ResetPasswordState, String?>(
  (ref, resetToken) => ResetPasswordNotifier(ResetPasswordState(
    passwordController: TextEditingController(),
    confirmpasswordController: TextEditingController(),
    resetToken: resetToken,
  )),
);

// A notifier that manages the state of reset password according to the event that is dispatched to it
class ResetPasswordNotifier extends StateNotifier<ResetPasswordState>{
  ResetPasswordNotifier(ResetPasswordState state) : super(state);
}
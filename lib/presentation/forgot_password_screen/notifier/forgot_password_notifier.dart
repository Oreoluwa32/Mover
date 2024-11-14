import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/forgot_password_model.dart';
part 'forgot_password_state.dart';

final forgotPasswordNotifier = StateNotifierProvider.autoDispose<ForgotPasswordNotifier, ForgotPasswordState>(
  (ref) => ForgotPasswordNotifier(ForgotPasswordState(
    emailController: TextEditingController(),
  )),
);

// A notifier that manages the state of forgot password according to the event that is dispatched to it
class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordNotifier(ForgotPasswordState state) : super(state);
}
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/email_verified_model.dart';
part 'email_verified_state.dart';

final emailVerifiedNotifier = StateNotifierProvider.autoDispose<EmailVerifiedNotifier, EmailVerifiedState>(
  (ref) => EmailVerifiedNotifier(EmailVerifiedState()),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class EmailVerifiedNotifier extends StateNotifier<EmailVerifiedState>{
  EmailVerifiedNotifier(EmailVerifiedState state) : super(state);
}
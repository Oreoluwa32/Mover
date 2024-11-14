import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/verification_model.dart';
part 'verification_state.dart';

final verificationNotifier = StateNotifierProvider.autoDispose<VerificationNotifier, VerificationState>(
  (ref) => VerificationNotifier(VerificationState()),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class VerificationNotifier extends StateNotifier<VerificationState>{
  VerificationNotifier(VerificationState state) : super(state);
}
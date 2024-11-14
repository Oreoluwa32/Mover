import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:new_project/presentation/sign_in_screen/sign_in_screen.dart';
import '../../../core/app_export.dart';
import '../models/sign_in_model.dart';
part 'sign_in_state.dart';

final signInNotifier = StateNotifierProvider.autoDispose<SignInNotifier, SignInState>(
  (ref) => SignInNotifier(SignInState(
    emailController: TextEditingController(),
    passwordController: TextEditingController(),
  )),
);

// A notifier that manages the state of a sign in according to the event that is dispatched to it.
class SignInNotifier extends StateNotifier<SignInState>{
  SignInNotifier(SignInState state) : super(state);
}
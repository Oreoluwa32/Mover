import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/create_account_model.dart';
part 'create_account_state.dart';

final createAccountNotifier = StateNotifierProvider.autoDispose<CreateAccountNotifier, CreateAccountState>(
  (ref) => CreateAccountNotifier(CreateAccountState(
    emailController: TextEditingController(),
    passwordController: TextEditingController(),
  )),
);

// This notifier manages the state of a splash according to the event that is dispateched to it
class CreateAccountNotifier extends StateNotifier<CreateAccountState>{
  CreateAccountNotifier(CreateAccountState state) : super(state);
}
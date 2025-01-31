import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/account_funded_model.dart';
part 'account_funded_state.dart';

final accountFundedNotifier = StateNotifierProvider.autoDispose<AccountFundedNotifier, AccountFundedState>(
  (ref) => AccountFundedNotifier(AccountFundedState()),
);

// A notifier class that is used to manage the state of the account funded screen according to the event that is dispatched to it
class AccountFundedNotifier extends StateNotifier<AccountFundedState>{
  AccountFundedNotifier(AccountFundedState state) : super(state);
}
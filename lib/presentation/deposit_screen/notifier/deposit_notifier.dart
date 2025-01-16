import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/deposit_model.dart';
import '../models/deposit_item_model.dart';
part 'deposit_state.dart';

final depositNotifier =
    StateNotifierProvider.autoDispose<DepositNotifier, DepositState>(
  (ref) => DepositNotifier(DepositState(
    depositModelObj: DepositModel(depositItemList: [
      DepositItemModel(
          depositIcon: ImageConstant.imgCreditCard,
          depositOption: "Debit/Credit Card",
          depositText: "Add money directly from your bank card"),
      DepositItemModel(
          depositIcon: ImageConstant.imgBank,
          depositOption: "Bank Transfer",
          depositText: "Add money via mobile or internet banking"),
      DepositItemModel(
        depositIcon: ImageConstant.imgSmartphone,
          depositOption: "Bank USSD",
          depositText: "Fund your wallet with banks USSD code")
    ]),
  )),
);

// A notifier that manages the state of the screen according to the event that dispatched to it
class DepositNotifier extends StateNotifier<DepositState> {
  DepositNotifier(DepositState state) : super(state);
}

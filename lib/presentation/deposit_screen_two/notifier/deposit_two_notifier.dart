import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/deposit_model_two.dart';
import '../models/deposit_item_two_model.dart';
part 'deposit_two_state.dart';

final depositTwoNotifier =
    StateNotifierProvider.autoDispose<DepositTwoNotifier, DepositTwoState>(
  (ref) => DepositTwoNotifier(DepositTwoState(
    amountController: TextEditingController(),
    depositModelTwoObj: DepositModelTwo(depositItemTwoList: [
      DepositItemTwoModel(
          image: ImageConstant.imgMastercard,
          cardNum: "**** **** **** 1234",
          cardType: "Mastercard"),
      DepositItemTwoModel(
          image: ImageConstant.imgVisa,
          cardNum: "**** **** **** 1234",
          cardType: "Visa")
    ]),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class DepositTwoNotifier extends StateNotifier<DepositTwoState> {
  DepositTwoNotifier(DepositTwoState state) : super(state);

  void changeRadioBtn(
    int index,
    bool value,
  ) {
    List<DepositItemTwoModel> newList = List<DepositItemTwoModel>.from(
        state.depositModelTwoObj!.depositItemTwoList);
    newList[index] = newList[index].copyWith(radioBtn: value);
    state = state.copyWith(
        depositModelTwoObj:
            state.depositModelTwoObj?.copyWith(depositItemTwoList: newList));
  }
}

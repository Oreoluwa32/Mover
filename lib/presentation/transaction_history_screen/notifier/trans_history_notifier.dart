import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/transaction_history_model.dart';
import '../models/transaction_item_model.dart';
import '../models/balance_item_model.dart';
import '../models/month_trans_item_model.dart';
part 'trans_history_state.dart';

final transHistoryNotifier = StateNotifierProvider.autoDispose<TransHistoryNotifier, TransHistoryState>(
  (ref) => TransHistoryNotifier(TransHistoryState(
    transactionHistoryModelObj: TransactionHistoryModel(
      balanceList: [
        BalanceItemModel(
          title: "Balance",
          icon: ImageConstant.imgEye,
          balance: "₦10000.00"
        ),
        BalanceItemModel(
          title: "Unavailable",
          icon: ImageConstant.imgHelp,
          balance: "₦3500.00"
        )
      ],
      monthTransList: [
        MonthTransItemModel(
          transStatus: "Transfer Successful",
          transDate: "13 Jan",
          transTime: "12:00",
          amount: "- ₦2000.00",
          status: "Successful",
        ),
        MonthTransItemModel(
          transStatus: "Deposit Successful",
          transDate: "13 Jan",
          transTime: "3:47",
          amount: "+ ₦5000.00",
          status: "Successful",
        ),
        MonthTransItemModel(
          transStatus: "Deposit Failed",
          transDate: "12 Jan",
          transTime: "06:32",
          amount: "- ₦3000.00",
          status: "Failed",
        )
      ],
      transactionList: [
        TransactionItemModel(
          transStatus: "Transfer Successful",
          transDate: "13 Jan",
          transTime: "12:00",
          amount: "- ₦2000.00",
          status: "Successful",
          id: "1"
        ),
        TransactionItemModel(
          transStatus: "Deposit Successful",
          transDate: "13 Jan",
          transTime: "3:47",
          amount: "+ ₦5000.00",
          status: "Successful",
          id: "2"
        ),
        TransactionItemModel(
          transStatus: "Deposit Failed",
          transDate: "12 Jan",
          transTime: "06:32",
          amount: "- ₦3000.00",
          status: "Failed",
          id: "3"
        )
      ]),
    )
  ),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class TransHistoryNotifier extends StateNotifier<TransHistoryState>{
  TransHistoryNotifier(TransHistoryState state) : super(state);
}

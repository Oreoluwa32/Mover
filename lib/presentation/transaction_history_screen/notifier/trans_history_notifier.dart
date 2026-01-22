import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/services/wallet_api_service.dart';
import '../../../data/models/wallet_model.dart';
import '../models/transaction_history_model.dart';
import '../models/transaction_item_model.dart';
import '../models/balance_item_model.dart';
import '../models/month_trans_item_model.dart';

part 'trans_history_state.dart';

final transHistoryNotifier =
    StateNotifierProvider.autoDispose<TransHistoryNotifier, TransHistoryState>(
  (ref) {
    final walletApiService = ref.watch(walletApiServiceProvider);
    return TransHistoryNotifier(
      TransHistoryState(
        sliderIndex: 0,
        transactionHistoryModelObj: TransactionHistoryModel(
          balanceList: [
            BalanceItemModel(
              title: "Balance",
              icon: ImageConstant.imgEye,
              balance: "₦0.00",
            ),
            BalanceItemModel(
              title: "Unavailable Balance",
              icon: ImageConstant.imgEye,
              balance: "₦0.00",
            )
          ],
          monthTransList: const [],
          transactionList: const [],
        ),
      ),
      walletApiService,
    )..fetchWalletData();
  },
);

class TransHistoryNotifier extends StateNotifier<TransHistoryState> {
  TransHistoryNotifier(TransHistoryState state, this._walletApiService)
      : super(state);

  final WalletApiService _walletApiService;

  void changeSliderIndex(int index) {
    state = state.copyWith(sliderIndex: index);
  }

  void toggleBalanceVisibility() {
    state = state.copyWith(isBalanceVisible: !state.isBalanceVisible);
  }

  Future<void> fetchWalletData() async {
    state = state.copyWith(isLoading: true);
    try {
      final walletData = await _walletApiService.fetchWalletData();
      
      final balanceList = [
        BalanceItemModel(
          title: "Balance",
          icon: ImageConstant.imgEye,
          balance: "₦${walletData.balance?.toStringAsFixed(2) ?? '0.00'}",
        ),
        BalanceItemModel(
          title: "Unavailable Balance",
          icon: ImageConstant.imgEye,
          balance: "₦0.00", // Default as not provided in API
        )
      ];

      final transactionList = walletData.transactions?.map((t) {
        return TransactionItemModel(
          id: t.id,
          transStatus: t.type,
          transDate: t.date,
          transTime: t.time,
          amount: (double.tryParse(t.amount ?? '0') ?? 0) >= 0 
              ? "+ ₦${t.amount}" 
              : "- ₦${(double.tryParse(t.amount ?? '0') ?? 0).abs()}",
          status: t.status,
        );
      }).toList() ?? [];

      // For simplicity, using same list for monthTransList as well
      final monthTransList = walletData.transactions?.map((t) {
        return MonthTransItemModel(
          transStatus: t.type,
          transDate: t.date,
          transTime: t.time,
          amount: (double.tryParse(t.amount ?? '0') ?? 0) >= 0 
              ? "+ ₦${t.amount}" 
              : "- ₦${(double.tryParse(t.amount ?? '0') ?? 0).abs()}",
          status: t.status,
        );
      }).toList() ?? [];

      state = state.copyWith(
        isLoading: false,
        transactionHistoryModelObj: state.transactionHistoryModelObj?.copyWith(
          balanceList: balanceList,
          transactionList: transactionList,
          monthTransList: monthTransList,
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Handle error, maybe add an error state or show a toast
    }
  }
}

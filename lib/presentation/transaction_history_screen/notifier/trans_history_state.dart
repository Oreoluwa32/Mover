part of 'trans_history_notifier.dart';

// Represents the state of the transaction history screen
// ignore for file, class must be immutable
class TransHistoryState extends Equatable {
  TransHistoryState({
    this.sliderIndex = 0,
    this.transactionHistoryModelObj,
    this.isBalanceVisible = true,
    this.isLoading = false,
  });

  final TransactionHistoryModel? transactionHistoryModelObj;
  final int sliderIndex;
  final bool isBalanceVisible;
  final bool isLoading;

  @override
  List<Object?> get props => [
        sliderIndex,
        transactionHistoryModelObj,
        isBalanceVisible,
        isLoading,
      ];

  TransHistoryState copyWith({
    int? sliderIndex,
    TransactionHistoryModel? transactionHistoryModelObj,
    bool? isBalanceVisible,
    bool? isLoading,
  }) {
    return TransHistoryState(
      sliderIndex: sliderIndex ?? this.sliderIndex,
      transactionHistoryModelObj:
          transactionHistoryModelObj ?? this.transactionHistoryModelObj,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

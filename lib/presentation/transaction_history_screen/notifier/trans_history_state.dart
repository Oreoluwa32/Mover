part of 'trans_history_notifier.dart';

// Represents the state of the transaction history screen
// ignore for file, class must be immutable
class TransHistoryState extends Equatable {
  TransHistoryState({
    this.sliderIndex = 0,
    this.transactionHistoryModelObj,
    this.isBalanceVisible = true,
    this.isLoading = false,
    this.fundingAccountLoading = false,
    this.fundingAccount,
    this.fundingAccountError,
  });

  final TransactionHistoryModel? transactionHistoryModelObj;
  final int sliderIndex;
  final bool isBalanceVisible;
  final bool isLoading;
  final bool fundingAccountLoading;
  final WalletFundingAccount? fundingAccount;
  final String? fundingAccountError;

  @override
  List<Object?> get props => [
        sliderIndex,
        transactionHistoryModelObj,
        isBalanceVisible,
        isLoading,
        fundingAccountLoading,
        fundingAccount,
        fundingAccountError,
      ];

  TransHistoryState copyWith({
    int? sliderIndex,
    TransactionHistoryModel? transactionHistoryModelObj,
    bool? isBalanceVisible,
    bool? isLoading,
    bool? fundingAccountLoading,
    WalletFundingAccount? fundingAccount,
    String? fundingAccountError,
  }) {
    return TransHistoryState(
      sliderIndex: sliderIndex ?? this.sliderIndex,
      transactionHistoryModelObj:
          transactionHistoryModelObj ?? this.transactionHistoryModelObj,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
      isLoading: isLoading ?? this.isLoading,
      fundingAccountLoading:
          fundingAccountLoading ?? this.fundingAccountLoading,
      fundingAccount: fundingAccount ?? this.fundingAccount,
      fundingAccountError: fundingAccountError,
    );
  }
}

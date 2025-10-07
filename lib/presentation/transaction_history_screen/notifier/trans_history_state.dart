part of 'trans_history_notifier.dart';

// Represents the state of the transaction history screen
// ignore for file, class must be immutable
class TransHistoryState extends Equatable{
  TransHistoryState({this.sliderIndex = 0, this.transactionHistoryModelObj});

  TransactionHistoryModel? transactionHistoryModelObj;

  int sliderIndex;

  @override
  List<Object?> get props => [sliderIndex, transactionHistoryModelObj];
  TransHistoryState copyWith({
    int? sliderIndex,
    TransactionHistoryModel? transactionHistoryModelObj
  }) {
    return TransHistoryState(
      sliderIndex: sliderIndex ?? this.sliderIndex,
      transactionHistoryModelObj: transactionHistoryModelObj ?? this.transactionHistoryModelObj
    );
  }
}
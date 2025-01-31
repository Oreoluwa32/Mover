part of 'trans_history_notifier.dart';

// Represents the state of the transaction history screen
// ignore for file, class must be immutable
class TransHistoryState extends Equatable{
  TransHistoryState({this.transactionHistoryModelObj});

  TransactionHistoryModel? transactionHistoryModelObj;

  @override
  List<Object?> get props => [transactionHistoryModelObj];
  TransHistoryState copyWith({
    TransactionHistoryModel? transactionHistoryModelObj
  }) {
    return TransHistoryState(
      transactionHistoryModelObj: transactionHistoryModelObj ?? this.transactionHistoryModelObj
    );
  }
}
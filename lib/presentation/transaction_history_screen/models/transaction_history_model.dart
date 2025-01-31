import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import 'transaction_item_model.dart';
import 'balance_item_model.dart';
import 'month_trans_item_model.dart';

// This class defines the properties of the transaction history screen model and is used to hold data that is passed between the different layers of the application
// ignore for file, class must be immutable
class TransactionHistoryModel extends Equatable{
  TransactionHistoryModel({
    this.transactionList = const [],
    this.balanceList = const [],
    this.monthTransList = const [],
  });

  List<TransactionItemModel> transactionList;
  List<BalanceItemModel> balanceList;
  List<MonthTransItemModel> monthTransList;

  TransactionHistoryModel copyWith({
    List<TransactionItemModel>? transactionList,
    List<BalanceItemModel>? balanceList,
    List<MonthTransItemModel>? monthTransList,
  }) {
    return TransactionHistoryModel(
      transactionList: transactionList ?? this.transactionList,
      balanceList: balanceList ?? this.balanceList,
      monthTransList: monthTransList ?? this.monthTransList,
    );
  }

  @override
  List<Object?> get props => [
    transactionList,
    balanceList,
    monthTransList];
}
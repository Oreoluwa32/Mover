import '../../../core/app_export.dart';

// This class is used in the transaction history screen to define the properties of the month transaction item model and is used to hold data that is passed between the different layers of the application
// ignore for file, class must be immutable

class MonthTransItemModel {
  MonthTransItemModel({
    this.transStatus,
    this.transDate,
    this.transTime,
    this.amount,
    this.status,
    this.id
  }) {
    transStatus = transStatus ?? "Transfer Successful";
    transDate = transDate ?? "13 Jan";
    transTime = transTime ?? "12:00";
    amount = amount ?? "- ₦2000.00";
    status = status ?? "Successful";
    id = id ?? "";
  }

  String? transStatus;
  String? transDate;
  String? transTime;
  String? amount;
  String? status;
  String? id;
}
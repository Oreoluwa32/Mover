import '../../../core/app_export.dart';

// This class defines the properties of the balance item model and is used to hold data that is passed between the different layers of the application
// ignore for file, class must be immutable
class BalanceItemModel {
  BalanceItemModel({
    this.title,
    this.icon,
    this.balance,
    this.id
  }) {
    title = title ?? "Balance";
    icon = icon ?? ImageConstant.imgEye;
    balance = balance ?? "₦10000.00";
    id = id ?? "";
  }

  String? title;
  String? icon;
  String? balance;
  String? id;
}
import '../../../core/app_export.dart';

// This class is used in the screen
// ignore for file, class must be immutable
class DepositItemModel {
  DepositItemModel(
      {this.amount, this.email, this.depositIcon, this.depositOption, this.depositText, this.id}) {
    amount = amount ?? 0;
    email = email ?? "";
    depositIcon = depositIcon ?? ImageConstant.imgCreditCard;
    depositOption = depositOption ?? "Debit/Credit Card";
    depositText = depositText ?? "Add money directly from your bank card";
    id = id ?? "";
  }

  int? amount;
  String? email;
  String? depositIcon;
  String? depositOption;
  String? depositText;
  String? id;
}

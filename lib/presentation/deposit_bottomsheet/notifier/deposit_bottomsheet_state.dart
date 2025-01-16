part of 'deposit_bottomsheet_notifier.dart';

// Represents the state of the screen in the app

// ignore for file, class must be immutable
class DepositBottomsheetState extends Equatable {
  DepositBottomsheetState(
      {this.cardNumController,
      this.expiryDateController,
      this.cvvController,
      this.nameController,
      this.depositBottomsheetModelObj});

  TextEditingController? cardNumController;
  TextEditingController? expiryDateController;
  TextEditingController? cvvController;
  TextEditingController? nameController;
  DepositBottomsheetModel? depositBottomsheetModelObj;

  @override
  List<Object?> get props => [
        cardNumController,
        expiryDateController,
        cvvController,
        nameController,
        depositBottomsheetModelObj
      ];
  DepositBottomsheetState copyWith(
      {TextEditingController? cardNumController,
      TextEditingController? expiryDateController,
      TextEditingController? cvvController,
      TextEditingController? nameController,
      DepositBottomsheetModel? depositBottomsheetModelObj}) {
    return DepositBottomsheetState(
        cardNumController: cardNumController ?? this.cardNumController,
        expiryDateController: expiryDateController ?? this.expiryDateController,
        cvvController: cvvController ?? this.cvvController,
        nameController: nameController ?? this.nameController,
        depositBottomsheetModelObj:
            depositBottomsheetModelObj ?? this.depositBottomsheetModelObj);
  }
}

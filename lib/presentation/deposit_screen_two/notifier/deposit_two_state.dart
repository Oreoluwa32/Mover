part of 'deposit_two_notifier.dart';

// Represents the state of the screen the app
// ignore for file, class must be immutable
class DepositTwoState extends Equatable {
  DepositTwoState({this.amountController, this.depositModelTwoObj});

  TextEditingController? amountController;
  DepositModelTwo? depositModelTwoObj;

  @override
  List<Object?> get props => [amountController, depositModelTwoObj];
  DepositTwoState copyWith(
      {TextEditingController? amountController,
      DepositModelTwo? depositModelTwoObj}) {
    return DepositTwoState(
        amountController: amountController ?? this.amountController,
        depositModelTwoObj: depositModelTwoObj ?? this.depositModelTwoObj);
  }
}

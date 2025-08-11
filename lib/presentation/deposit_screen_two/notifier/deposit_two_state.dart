part of 'deposit_two_notifier.dart';

// Represents the state of the screen the app
// ignore for file, class must be immutable
class DepositTwoState extends Equatable {
  DepositTwoState({this.amountController, this.emailController, this.referenceController, this.depositModelTwoObj});

  TextEditingController? amountController;
  TextEditingController? referenceController;
  TextEditingController? emailController;
  DepositModelTwo? depositModelTwoObj;

  @override
  List<Object?> get props => [amountController, emailController, referenceController, depositModelTwoObj];
  DepositTwoState copyWith(
      {TextEditingController? amountController,
      TextEditingController? referenceController,
      TextEditingController? emailController,
      DepositModelTwo? depositModelTwoObj}) {
    return DepositTwoState(
        amountController: amountController ?? this.amountController,
        referenceController: referenceController ?? this.referenceController,
        emailController: emailController ?? this.emailController,
        depositModelTwoObj: depositModelTwoObj ?? this.depositModelTwoObj);
  }
}

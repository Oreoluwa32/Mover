part of 'deposit_notifier.dart';

// Represents the state of the screen in the app

// ignore for file, must be immutable
class DepositState extends Equatable {
  DepositState({this.depositModelObj});

  DepositModel? depositModelObj;

  @override
  List<Object?> get props => [depositModelObj];
  DepositState copyWith({DepositModel? depositModelObj}) {
    return DepositState(
        depositModelObj: depositModelObj ?? this.depositModelObj);
  }
}

part of 'account_funded_notifier.dart';

// Represents the state of the account funded screen
// ignore for file, class must be immutable
class AccountFundedState extends Equatable{
  AccountFundedState({this.accountFundedModelObj});

  AccountFundedModel? accountFundedModelObj;

  @override
  List<Object?> get props => [accountFundedModelObj];
  AccountFundedState copyWith({
    AccountFundedModel? accountFundedModelObj
  }) {
    return AccountFundedState(
      accountFundedModelObj: accountFundedModelObj ?? this.accountFundedModelObj
    );
  }
}
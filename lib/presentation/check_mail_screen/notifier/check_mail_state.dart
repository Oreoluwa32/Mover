part of 'check_mail_notifier.dart';

// Represents the state of check mail in the app
// ignore for file, must be immutable
class CheckMailState extends Equatable{
  CheckMailState({
    this.otpController,
    this.checkMailModelObj
  });

  TextEditingController? otpController;
  CheckMailModel? checkMailModelObj;

  @override
  List<Object?> get props => [otpController, checkMailModelObj];
  CheckMailState copyWith({
    TextEditingController? otpController,
    CheckMailModel? checkMailModelObj,
  }) {
    return CheckMailState(
      otpController: otpController ?? this.otpController,
      checkMailModelObj: checkMailModelObj ?? this.checkMailModelObj,
    );
  }
}
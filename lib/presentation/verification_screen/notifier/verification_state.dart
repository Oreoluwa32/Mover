part of 'verification_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable

class VerificationState extends Equatable{
  VerificationState({this.verificationModelObj});

  VerificationModel? verificationModelObj;

  @override
  List<Object?> get props => [verificationModelObj];
  VerificationState copyWith({VerificationModel? verificationModelObj}) {
    return VerificationState(
      verificationModelObj: verificationModelObj ?? this.verificationModelObj,
    );
  }
}
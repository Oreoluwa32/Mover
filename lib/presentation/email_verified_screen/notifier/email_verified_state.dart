part of 'email_verified_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable

class EmailVerifiedState extends Equatable{
  EmailVerifiedState({this.emailVerifiedModelObj});

  EmailVerifiedModel? emailVerifiedModelObj;

  @override
  List<Object?> get props => [emailVerifiedModelObj];
  EmailVerifiedState copyWith({
    EmailVerifiedModel? emailVerifiedModelObj
  }) {
    return EmailVerifiedState(
      emailVerifiedModelObj: emailVerifiedModelObj ?? this.emailVerifiedModelObj
    );
  }
}
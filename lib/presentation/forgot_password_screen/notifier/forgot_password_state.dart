part of 'forgot_password_notifier.dart';

// Represnts the state of forgot password in the app
// ignore for file, class must be immutable
class ForgotPasswordState extends Equatable{
  ForgotPasswordState({
    this.emailController,
    this.forgotPasswordModelObj
  });

  TextEditingController? emailController;
  ForgotPasswordModel? forgotPasswordModelObj;

  @override
  List<Object?> get props => [emailController, forgotPasswordModelObj];
  ForgotPasswordState copyWith({
    TextEditingController? emailController,
    ForgotPasswordModel? forgotPasswordModelObj,
  }) {
    return ForgotPasswordState(
      emailController: emailController ?? this.emailController,
      forgotPasswordModelObj: forgotPasswordModelObj ?? this.forgotPasswordModelObj,
    );
  }
}
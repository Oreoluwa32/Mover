part of 'reset_password_notifier.dart';

// Reperesents the state of the reset password in the app
// ignore for file, class must be immutable

class ResetPasswordState extends Equatable{
  ResetPasswordState({
    this.passwordController,
    this.confirmpasswordController,
    this.resetPasswordModelObj,
    this.resetToken
  });

  TextEditingController? passwordController;
  TextEditingController? confirmpasswordController;
  ResetPasswordModel? resetPasswordModelObj;
  String? resetToken;

  @override
  List<Object?> get props => [passwordController, confirmpasswordController, resetPasswordModelObj, resetToken];
  ResetPasswordState copyWith({
    TextEditingController? passwordController,
    TextEditingController? confirmpasswordController,
    ResetPasswordModel? resetPasswordModelObj,
    String? resetToken,
  }) {
    return ResetPasswordState(
      passwordController: passwordController ?? this.passwordController,
      confirmpasswordController: confirmpasswordController ?? this.confirmpasswordController,
      resetPasswordModelObj: resetPasswordModelObj ?? this.resetPasswordModelObj,
      resetToken: resetToken ?? this.resetToken
    );
  }
}
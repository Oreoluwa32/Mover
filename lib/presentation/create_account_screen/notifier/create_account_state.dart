part of 'create_account_notifier.dart';

// Represents the state of create account in the app
// ignore for file, must be immutable
class CreateAccountState extends Equatable{
  CreateAccountState({
    this.emailController,
    this.passwordController,
    this.createAccountModelObj
  });

  TextEditingController? emailController;
  TextEditingController? passwordController;
  CreateAccountModel? createAccountModelObj;

  @override
  List<Object?> get props => [emailController, passwordController, createAccountModelObj];
  CreateAccountState copyWith({
    TextEditingController? emailController,
    TextEditingController? passwordController,
    CreateAccountModel? createAccountModelObj,
  }) {
    return CreateAccountState(
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      createAccountModelObj: createAccountModelObj ?? this.createAccountModelObj,
    );
  }
}
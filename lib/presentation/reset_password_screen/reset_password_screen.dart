import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../data/services/auth_api_service.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/loading_dialog.dart';
import 'notifier/reset_password_notifier.dart';

// Class must be immutable
class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? resetUid;
  final String? resetToken;

  const ResetPasswordScreen({super.key, this.resetUid, this.resetToken});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

// ignore for file, class must be immutable
class ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Function to reset password with backend
  Future<void> resetPassword(
    BuildContext context,
    ResetPasswordState resetState,
  ) async {
    final password = resetState.passwordController?.text.trim() ?? '';
    final confirmPassword =
        resetState.confirmpasswordController?.text.trim() ?? '';
    final uid = widget.resetUid?.trim() ?? '';
    final token = widget.resetToken?.trim() ?? '';
    final authApiService = AuthApiService();

    if (uid.isEmpty || token.isEmpty) {
      Fluttertoast.showToast(
          msg: "Invalid or expired reset token. Please try again.");
      return;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill in all fields.");
      return;
    }

    if (password != confirmPassword) {
      Fluttertoast.showToast(msg: "Passwords do not match.");
      return;
    }

    LoadingDialog.show(context, message: 'Resetting your password...');
    try {
      final response = await authApiService.confirmPasswordReset(
        uid: uid,
        token: token,
        newPassword: password,
        confirmPassword: confirmPassword,
      );
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      Fluttertoast.showToast(
        msg: response['detail']?.toString() ?? "Password reset successful.",
        backgroundColor: appTheme.green50,
        textColor: Colors.white,
      );
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.signInScreen, (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      Fluttertoast.showToast(msg: authApiService.extractErrorMessage(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(resetPasswordNotifier(widget.resetToken));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  left: 16.h,
                  top: 48.h,
                  right: 16.h,
                ),
                child: Column(
                  children: [
                    CustomIconButton(
                      height: 56.h,
                      width: 56.h,
                      padding: EdgeInsets.all(14.h),
                      decoration: IconButtonStyleHelper.outlineGray,
                      child: CustomImageView(
                        imagePath: ImageConstant.imgKey,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "Set new password",
                      style: theme.textTheme.headlineSmall,
                    ),
                    Text(
                      "Your new password must be different to the previously used passwords.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        height: 1.20,
                      ),
                    ),
                    SizedBox(height: 26.h),
                    _buildColumnpassword(context),
                    SizedBox(height: 22.h),
                    _buildColumnconfirm(context),
                    SizedBox(height: 24.h),
                    CustomElevatedButton(
                      text: "Reset password",
                      buttonStyle: CustomButtonStyles.fillPrimaryTL41,
                      buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          resetPassword(context, resetState);
                        }
                      },
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgLeftArrow,
                          height: 20.h,
                          width: 20.h,
                        ),
                        SizedBox(width: 8.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.signInScreen);
                          },
                          child: Text(
                            "Back to log in",
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 4.h)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildColumnpassword(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Password",
                style: CustomTextStyles.titleSmallGray600,
              ),
              SizedBox(height: 6.h),
              CustomTextFormField(
                controller: ref
                    .watch(resetPasswordNotifier(widget.resetToken))
                    .passwordController,
                hintText: "Create a password",
                textInputType: TextInputType.visiblePassword,
                obscureText: true,
                contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
                validator: (value) {
                  if (value == null ||
                      (!isValidPassword(value, isRequired: true))) {
                    return "Please enter a valid password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 6.h),
              Text(
                "Must be at least 8 characters.",
                style: CustomTextStyles.bodyMediumGray600,
              )
            ],
          ),
        );
      },
    );
  }

  // Section Widget

  Widget _buildColumnconfirm(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Confirm password",
                style: CustomTextStyles.titleSmallGray600,
              ),
              SizedBox(height: 4.h),
              CustomTextFormField(
                controller: ref
                    .watch(resetPasswordNotifier(widget.resetToken))
                    .confirmpasswordController,
                hintText: "Confirm password",
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.visiblePassword,
                obscureText: true,
                contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please confirm your password";
                  }
                  final password = ref
                          .watch(resetPasswordNotifier(widget.resetToken))
                          .passwordController
                          ?.text ??
                      '';
                  if (value != password) {
                    return "Passwords don't match";
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Navigates back to the splash screen two when the action is triggered
  onTapResetPassword(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.passwordSuccessScreen);
  }

  // Navigates back to the splash screen two when the action is triggered
  onTapBack(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/forgot_password_notifier.dart';

// Class must be immutable
class ForgotPasswordScreen extends ConsumerStatefulWidget{
  const ForgotPasswordScreen({Key? key})
    : super(key: key,);

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

// ignore for file, class must be immutable
class ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // API call function to reset password
  Future<void> resetPassword(BuildContext context, ForgotPasswordNotifier forgotPasswordNotifier) async {
    final email = forgotPasswordNotifier.state.emailController?.text.trim() ?? '';

    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your email address.");
      return;
    }

    final url = Uri.parse('https://movr-api.onrender.com/api/v1/auth/forgot-password');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Reset instructions sent to your email.",
          backgroundColor: appTheme.green50,
          textColor: Colors.white,
        );
        Navigator.pushNamed(
          context,
          AppRoutes.passwordCheckMailScreen,
          arguments: {'email': email},
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? "Failed to send reset instructions.";
        Fluttertoast.showToast(msg: errorMessage);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context){
    bool _isFormValid = false;

    void _validateForm() {
      setState(() {
        final email = ref.watch(forgotPasswordNotifier).emailController?.text ?? '';
        _isFormValid = isValidEmail(email, isRequired: true);
      });
    }

    final forgotNotifier = ref.watch(forgotPasswordNotifier.notifier);
    forgotNotifier.state.emailController?.addListener(_validateForm);
    _validateForm(); // Initial validation

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
                          width: 20.h,
                          height: 20.h
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        "Forgot password?",
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        "No worries, we'll send you reset instructions.",
                        style: theme.textTheme.bodyLarge,
                      ),
                      SizedBox(height: 24.h),
                      _buildColumnemailaddr(context),
                      SizedBox(height: 24.h),
                      CustomElevatedButton(
                        text: "Reset password",
                        buttonStyle: _isFormValid ? CustomButtonStyles.fillPrimaryTL41 : CustomButtonStyles.fillBlueGray,
                        buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                        onPressed: _isFormValid ? () => resetPassword(context, forgotNotifier) : null,
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
                            onTap: () {onTapBack(context);},
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
  Widget _buildColumnemailaddr(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email Address*",
            style: CustomTextStyles.titleSmallGray600,
          ),
          SizedBox(height: 6.h),
          Consumer(
            builder: (context, ref, _) {
              return CustomTextFormField(
                controller: ref.watch(forgotPasswordNotifier).emailController,
                hintText: "Enter your email address",
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.emailAddress,
                contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
                validator: (value) {
                  if(value == null || (!isValidEmail(value, isRequired: true))) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              );
            }
          )
        ],
      ),
    );
  }

  // Navigates back to the sign in screen when the action is triggered
  onTapBack(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }

  // Navigates to the password check mail screen when the action is triggered
  onTapResetPassword(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.passwordCheckMailScreen);
  }
}
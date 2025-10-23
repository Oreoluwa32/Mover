import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_project/presentation/check_mail_screen/notifier/check_mail_notifier.dart';
import 'package:new_project/theme/custom_button_style.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_pin_code_text_field.dart';

  // Function to verify OTP with backend
  Future<void> verifyOtp(BuildContext context, CheckMailNotifier checkMailNotifier, String email) async {
    final url = Uri.parse('https://movr-api.onrender.com/api/v1/auth/verify-otp'); // API endpoint

    // Send POST request with email and OTP
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": email.trim(), // Use the passed email directly
        "otp": checkMailNotifier.state.otpController?.text.trim(),    // OTP code from user input
      }),
    );

    // Handle response
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Email verified successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: appTheme.green50,
        textColor: Colors.white,
      );
      Navigator.pushNamed(context, AppRoutes.emailVerifiedScreen);
    } else {
      Fluttertoast.showToast(
        msg: "OTP verification failed: ${response.body}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: appTheme.red50,
        textColor: Colors.white,
      );
    }
  }

  // Function to resend OTP
  Future<void> resendOtp(BuildContext context, String email) async {
    final url = Uri.parse('https://movr-api.onrender.com/api/v1/auth/send-otp'); // Resend OTP endpoint

    try {
      // Show loading
      Fluttertoast.showToast(msg: "Resending OTP...");
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email.trim()}),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "OTP resent to your email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: appTheme.green50,
          textColor: Colors.white,
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['detail'] ?? 'Failed to resend OTP';
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: appTheme.red50,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error resending OTP: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: appTheme.red50,
        textColor: Colors.white,
      );
    }
  }

class CheckMailScreen extends ConsumerStatefulWidget{
  final String email;
  const CheckMailScreen({Key? key, required this.email}) : super(key: key);

  @override
  CheckMailScreenState createState() => CheckMailScreenState();
}

class CheckMailScreenState extends ConsumerState<CheckMailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
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
                        imagePath: ImageConstant.imgMail,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "Check your email",
                      style: theme.textTheme.headlineSmall,
                    ),
                    SizedBox(
                      width: 218.h,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "We sent a verification code to ",
                              style: theme.textTheme.bodyLarge,
                            ),
                            TextSpan(
                              text: widget.email,
                              style: CustomTextStyles.titleMediumGray600_1,
                            )
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 30.h),
                      child: Consumer(
                        builder: (context, ref, _) {
                          return CustomPinCodeTextField(
                            context: context,
                            controller: ref.watch(checkMailNotifier).otpController, 
                            onChanged: (value) {
                              ref.read(checkMailNotifier.notifier).state = 
                                ref.read(checkMailNotifier.notifier).state.copyWith(
                                  otpController: TextEditingController(text: value),);
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 32.h),
                    CustomElevatedButton(
                      text: "Verify email",
                      buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                      onPressed: () {
                        verifyOtp(context, ref.read(checkMailNotifier.notifier), widget.email);
                      }, // Call verifyOtp
                    ),
                    SizedBox(height: 30.h),
                    GestureDetector(
                      onTap: () => resendOtp(context, widget.email),
                      child: Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                          left: 38.h,
                          right: 42.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the email?",
                              style: CustomTextStyles.bodyMediumGray600,
                            ),
                            Text(
                              "Click to resend",
                              style: CustomTextStyles.titleSmallPrimary_1,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
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
                          onTap: () => Navigator.pushNamed(context, AppRoutes.signInScreen),
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
      );
  }

  // Navigates to the password success screen when the action is triggered
  onTapVerifyEmail(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.emailVerifiedScreen);
  }

  // Navigates back to the sign in screen when the action is triggered
  onTapBack(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }
}
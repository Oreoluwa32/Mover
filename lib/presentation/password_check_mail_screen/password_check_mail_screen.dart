import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_export.dart';
import '../../data/services/auth_api_service.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/loading_dialog.dart';

class PasswordCheckMailScreen extends StatelessWidget {
  final String? email;

  const PasswordCheckMailScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                left: 16.h,
                top: 140.h,
                right: 16.h,
              ),
              child: Column(
                children: [
                  CustomIconButton(
                    height: 56.h,
                    width: 56.h,
                    padding: EdgeInsets.all(14.h),
                    decoration: IconButtonStyleHelper.outlineGrayTL20,
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
                    width: double.maxFinite,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "We sent a password reset link to ",
                            style: theme.textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text: email ?? "your email",
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
                  CustomElevatedButton(
                    text: "Open email app",
                    buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                    onPressed: () {
                      onTapOpenEmailApp(context);
                    },
                  ),
                  SizedBox(height: 30.h),
                  Container(
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
                          style: CustomTextStyles.bodyMediumMulishGray600,
                        ),
                        SizedBox(width: 1.h),
                        GestureDetector(
                          onTap: () {
                            onTapResend(context);
                          },
                          child: Text(
                            "Click to resend",
                            style: CustomTextStyles.titleSmallPrimary,
                          ),
                        )
                      ],
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
                        onTap: () {
                          onTapBackToLogIn(context);
                        },
                        child: Text(
                          "Back to log in",
                          style: CustomTextStyles.titleSmallGray600,
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

  // Reloads the password check mail screen when the action is triggered
  Future<void> onTapResend(BuildContext context) async {
    final targetEmail = email?.trim() ?? '';
    if (targetEmail.isEmpty) {
      Fluttertoast.showToast(msg: 'Email address is missing.');
      return;
    }

    final authApiService = AuthApiService();
    LoadingDialog.show(context, message: 'Resending reset instructions...');
    try {
      final response =
          await authApiService.requestPasswordReset(email: targetEmail);
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      Fluttertoast.showToast(
        msg: response['detail']?.toString() ?? 'Reset instructions sent again.',
      );
    } catch (e) {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      Fluttertoast.showToast(msg: authApiService.extractErrorMessage(e));
    }
  }

  // Navigates to the sign in screen when the action is triggered
  onTapBackToLogIn(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }

  // Navigates to the reset password screen when the action is triggered
  Future<void> onTapOpenEmailApp(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email ?? '',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Fluttertoast.showToast(msg: 'Unable to open your email app right now.');
    }
  }
}

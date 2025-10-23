import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';

class PasswordCheckMailScreen extends StatelessWidget{
  final String? email;

  const PasswordCheckMailScreen({Key? key, this.email})
    : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      onPressed: () {onTapOpenEmailApp(context);},
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
                          SizedBox(width: 8.h),
                          GestureDetector(
                            onTap: () {onTapResend(context);},
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
      ),
    );
  }

  // Reloads the password check mail screen when the action is triggered
  onTapResend(BuildContext context){
    Navigator.pushNamed(
      context,
      AppRoutes.forgotPasswordScreen,
      arguments: {'email': email},
    );
  }

  // Navigates to the sign in screen when the action is triggered
  onTapBackToLogIn(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }

  // Navigates to the reset password screen when the action is triggered
  onTapOpenEmailApp(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.resetPasswordScreen);
  }
}
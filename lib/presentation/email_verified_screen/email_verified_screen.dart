import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import 'notifier/email_verified_notifier.dart';

class EmailVerifiedScreen extends ConsumerStatefulWidget{
  const EmailVerifiedScreen({Key? key})
  : super(key: key,
  );

  @override
  EmailVerifiedScreenState createState() => EmailVerifiedScreenState();
}

class EmailVerifiedScreenState extends ConsumerState<EmailVerifiedScreen> {
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
                  right: 16.h
                ),
                child: Column(
                  children: [
                    CustomIconButton(
                      height: 56.h,
                      width: 56.h,
                      padding: EdgeInsets.all(14.h),
                      decoration: IconButtonStyleHelper.outlineGreen,
                      child: CustomImageView(
                        imagePath: ImageConstant.imgCheckCircle,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Email Verified",
                      style: theme.textTheme.headlineSmall,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Your email has been verified. Click below to log in magically.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        height: 1.20,
                      ),
                    ),
                    SizedBox(height: 26.h),
                    CustomElevatedButton(
                      text: "Continue",
                      buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                      onPressed: () {onTapContinue(context);},
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
                          onTap: () {onTapBackToLogIn(context);},
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

  // Navigates to the sign in screen when the action is triggered
  onTapContinue(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }

  // Navigates to the sign in screen when the action is triggered
  onTapBackToLogIn(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }
}
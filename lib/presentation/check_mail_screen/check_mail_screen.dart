import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_pin_code_text_field.dart';

class CheckMailScreen extends StatelessWidget{
  const CheckMailScreen({Key? key})
    : super(key: key,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.h,
                  vertical: 48.h,
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
                              text: "johndoe@gmail.com",
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
                      child: CustomPinCodeTextField(
                        context: context,
                        onChanged: (value) {},
                      ),
                    ),
                    SizedBox(height: 32.h),
                    CustomElevatedButton(
                      text: "Verify email",
                      buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                      onPressed: () {onTapVerifyEmail(context);},
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
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                          SizedBox(width: 8.h),
                          Text(
                            "Click to resend",
                            style: CustomTextStyles.titleSmallPrimary_1,
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

  // Navigates to the password success screen when the action is triggered
  onTapVerifyEmail(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.emailVerifiedScreen);
  }

  // Navigates back to the sign in screen when the action is triggered
  onTapBack(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }
}
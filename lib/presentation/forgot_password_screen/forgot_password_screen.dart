import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';

// Class must be immutable
class ForgotPasswordScreen extends StatelessWidget{
  ForgotPasswordScreen({Key? key})
    : super(key: key,
  );

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context){
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
                        imagePath: ImageConstant.imgKey,
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
                      buttonStyle: CustomButtonStyles.fillBlueGray,
                      buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                      onPressed: () {},
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
                            style: theme.textTheme.titleSmall,
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
          CustomTextFormField(
            controller: emailController,
            hintText: "Enter your email address",
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.emailAddress,
            contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
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
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';

// Class must be immutable
class ResetPasswordScreen extends StatelessWidget{
  ResetPasswordScreen({Key? key})
    : super(key: key,
  );

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

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
                      buttonStyle: CustomButtonStyles.fillBlueGray,
                      buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                      onPressed: () {onTapResetPassword(context);},
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
  Widget _buildColumnpassword(BuildContext context){
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
            controller: passwordController,
            hintText: "Create a password",
            textInputType: TextInputType.visiblePassword,
            obscureText: true,
            contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          ),
          SizedBox(height: 6.h),
          Text(
            "Must be at least 8 characters.",
            style: CustomTextStyles.bodyMediumGray600,
          )
        ],
      ),
    );
  }

  // Section Widget 

  Widget _buildColumnconfirm(BuildContext context){
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
            controller: confirmpasswordController,
            hintText: "Confirm password",
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.visiblePassword,
            obscureText: true,
            contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          )
        ],
      ),
    );
  }

  // Navigates back to the splash screen two when the action is triggered
  onTapResetPassword(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.passwordSuccessScreen);
  }

  // Navigates back to the splash screen two when the action is triggered
  onTapBack(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }
}
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';

// Class must be immutable
class SignInScreen extends StatelessWidget{
  SignInScreen({Key? key})
    : super(key: key,);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                    CustomImageView(
                      imagePath: ImageConstant.imgLogoWithoutText,
                      height: 32.h,
                      width: 50.h,
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Welcome back",
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Welcome back! Please enter your details.",
                        style: CustomTextStyles.titleMediumGray600,
                      ),
                    ),
                    SizedBox(height: 26.h),
                    _buildColumnemailaddr(context),
                    SizedBox(height: 22.h),
                    _buildColumnpassword(context),
                    SizedBox(height: 22.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {onTapForgotPassword(context);},
                        child: Text(
                          "Forgot password",
                          style: CustomTextStyles.titleSmallPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildSignin(context),
                    SizedBox(height: 16.h),
                    _buildSigninwith(context),
                    SizedBox(height: 30.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(
                        left: 64.h,
                        right: 68.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                          SizedBox(width: 8.h),
                          GestureDetector(
                            onTap: () {onTapSignUp(context);},
                            child: Text(
                              "Sign up",
                              style: CustomTextStyles.titleSmallPrimary_1,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 142.h)
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
  Widget _buildEmail(BuildContext context){
    return CustomTextFormField(
      controller: emailController,
      hintText: "Enter your email address",
      textInputType: TextInputType.emailAddress,
      contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
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
          _buildEmail(context)
        ],
      ),
    );
  }

  // Section Widget 
  Widget _buildPassword(BuildContext context){
    return CustomTextFormField(
      controller: passwordController,
      hintText: "Enter your password",
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.visiblePassword,
      obscureText: true,
      contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
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
            "Password*",
            style: CustomTextStyles.titleSmallGray600,
          ),
          SizedBox(height: 6.h),
          _buildPassword(context),
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
  Widget _buildSignin(BuildContext context){
    return CustomElevatedButton(
      text: "Sign in",
      buttonStyle: CustomButtonStyles.fillBlueGray,
      buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
      onPressed: () {onTapSignIn(context);},
    );
  }

  // Section Widget
  Widget _buildSigninwith(BuildContext context){
    return CustomOutlinedButton(
      text: "Sign in with Google",
      leftIcon: Container(
        margin: EdgeInsets.only(right: 12.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgGoogleLogo,
          height: 24.h,
          width: 24.h,
        ),
      ),
    );
  }

  // Navigates to the forgot password screen when the action is triggered
  onTapForgotPassword(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.forgotPasswordScreen);
  }

  // Navigates to the create account screen when the action is trigered
  onTapSignUp(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.createAccountScreen);
  }

  // Navigates to the check mail screen when the action is triggered
  onTapSignIn(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.selectPlanScreen);
  }
}
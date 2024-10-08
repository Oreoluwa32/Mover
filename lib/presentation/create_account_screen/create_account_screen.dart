import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';

// Class must be immutable
class CreateAccountScreen extends StatelessWidget{
  CreateAccountScreen({Key? key})
    : super(key: key,);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                    CustomImageView(
                      imagePath: ImageConstant.imgLogoWithoutText,
                      height: 32.h,
                      width: 50.h,
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Let's get you started",
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    Text(
                      "Unlock the power of interconnected mobility",
                      style: CustomTextStyles.titleMediumGray600,
                    ),
                    SizedBox(height: 26.h),
                    _buildColumnemailaddr(context),
                    SizedBox(height: 22.h),
                    _buildColumnpassword(context),
                    SizedBox(height: 22.h),
                    _buildGetstarted(context),
                    SizedBox(height: 16.h),
                    _buildSignupwith(context),
                    SizedBox(height: 32.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(
                        left: 58.h,
                        right: 62.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                          SizedBox(width: 8.h),
                          GestureDetector(
                            onTap: () {onTapSignIn(context);},
                            child: Text(
                              "Sign in",
                              style: CustomTextStyles.titleSmallPrimary_1,
                            ),
                          )
                        ],
                      ),
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
      hintText: "Create a password",
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

  // Sectiom Widget 
  Widget _buildGetstarted(BuildContext context){
    return CustomElevatedButton(
      text: "Get Started",
      buttonStyle: CustomButtonStyles.fillBlueGray,
      buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
      onPressed: () {
        onTapGetStarted(context);
      },
    );
  }

  // Sectiomn Widget 
  Widget _buildSignupwith(BuildContext context){
    return CustomOutlinedButton(
      text: "Sign up with Google",
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

  // Navigates to the sign in screen when the action is triggered
  onTapGetStarted(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.checkMailScreen);
  }

  // Navigates to the sign in screen when the action is triggered
  onTapSignIn(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }
}
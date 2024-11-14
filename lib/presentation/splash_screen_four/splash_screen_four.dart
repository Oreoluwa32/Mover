import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import 'notifier/splash_screen_four_notifier.dart';

class SplashScreenFour extends ConsumerStatefulWidget{
  const SplashScreenFour({Key? key})
  : super(key: key,);

  @override
  SplashScreenFourState createState() => SplashScreenFourState();
}

class SplashScreenFourState extends ConsumerState<SplashScreenFour>{
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.maxFinite,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withOpacity(1),
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgSplashScreenFour,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              SizedBox(
                height: SizeUtils.height,
                width: double.maxFinite,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgSplashScreenFour,
                      height: 730.h,
                      width: double.maxFinite,
                      alignment: Alignment.bottomCenter,
                    ),
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 40.h,
                      ),
                      decoration: BoxDecoration(
                        color: appTheme.black900.withOpacity(0.75),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _buildRowline(context),
                          Spacer(
                            flex: 72,
                          ),
                          _buildColumnreallive(context),
                          Spacer(
                            flex: 24,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],),
          ),
        ),
      ),);
  }

  // Section Widget
  Widget _buildRowline(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: theme.colorScheme.onPrimary.withOpacity(1),
            )
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Divider(
              color: theme.colorScheme.onPrimary.withOpacity(1),
            )
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Divider(
              color: theme.colorScheme.onPrimary.withOpacity(1),
            ),
          )
      ],),
    );
  }

  // Section Widget
  Widget _buildColumnreallive(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Text(
            "Bridge of Connectivity",
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.maxFinite,
            child: Text(
              "Connect logistics needs with available movers effortlessly commute, run errands, or navigate daily routines with ease.",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyLargeOnPrimary.copyWith(
                height: 1.50,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          CustomElevatedButton(
            text: "Get Started",
            buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
            onPressed: () {onTapGetStarted(context);},
          ),
          SizedBox(height: 16.h),
          CustomOutlinedButton(
            text: "Sign In",
            buttonStyle: CustomButtonStyles.outlineOnPrimary,
            buttonTextStyle: CustomTextStyles.titleSmallOnPrimary,
            onPresssed: () {onTapSignIn(context);},
          ),
        ],
      ),
    );
  }

  // Navigates to the create account screen when the action is triggered
  onTapGetStarted(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.createAccountScreen);
  }

  // Navigates back to the splash screen three when the action is triggered
  onTapBack(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.splashScreenThree);
  }

  // Navigates to the sign in screen when the action is triggered
  onTapSignIn(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }
}
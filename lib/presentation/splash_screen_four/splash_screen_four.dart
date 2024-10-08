import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class SplashScreenFour extends StatelessWidget{
  const SplashScreenFour({Key? key})
  : super(key: key,);
  
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
            color: theme.colorScheme.onPrimary,
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgSplashScreenFour,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: SizedBox(
            width: double.maxFinite,
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
                      decoration: AppDecoration.fillBlack,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildRowprogressflow(context),
                          Spacer(
                            flex: 75,
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
  Widget _buildRowprogressflow(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 6.h,
              width: 106.h,
            ),
          ),
          SizedBox(width: 12.h),
        Expanded(
          child: SizedBox(
            height: 6.h,
            width: 106.h,
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Divider(
            color: appTheme.gray700,
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
            "Real-Live Tracking",
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.maxFinite,
            child: Text(
              "Efficiently track deliveries and rides in real time for a seamless, transparent, and connected experience.",
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
          SizedBox(height: 22.h),
          GestureDetector(
            onTap: () {onTapBack(context);},
            child: Text(
              "Back",
              style: theme.textTheme.titleSmall,
            ),
          )
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
}
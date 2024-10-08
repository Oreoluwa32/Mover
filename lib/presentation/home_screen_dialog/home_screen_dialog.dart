import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart'; //ignore for file: must be immutable

class HomeScreenDialog extends StatelessWidget{
  const HomeScreenDialog({Key? key})
    : super(key: key,
    );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(14.h),
          decoration: AppDecoration.shadowx1.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgSparkleFill,
                height: 40.h,
                width: 40.h,
                alignment: Alignment.centerLeft,
              ),
              SizedBox(height: 20.h),
              Text(
                "Your Journey Awaits, Complete Your Profile Now!",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.titleMedium18.copyWith(
                  height: 1.20,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                "Complete your profile to unlock amazing features that will make every journey seamless",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.bodyMediumGray700.copyWith(
                  height: 1.20,
                ),
              ),
              SizedBox(height: 16.h),
              CustomElevatedButton(
                text: "Complete profile",
                buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                onPressed: () {onTapCompleteProfile(context);},
              ),
              SizedBox(height: 22.h),
              GestureDetector(
                onTap: () {onTapLater(context);},
                child: Text(
                  "I'll do it later",
                  style: CustomTextStyles.titleSmallPrimary_1,
              ),
              )
            ],
          ),
        )
      ],
    );
  }

  // Navigates to the verification screen
  onTapCompleteProfile(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.verificationScreen);
  }

  // Navigates to the home one screen when the action is triggered
  onTapLater(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.homeOneScreen);
  }
}
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart'; 
import 'notifier/home_dialog_notifier.dart'; //ignore for file: must be immutable

class HomeScreenDialog extends ConsumerStatefulWidget{
  const HomeScreenDialog({Key? key})
    : super(key: key,
    );

  @override
  HomeScreenDialogState createState() => HomeScreenDialogState();
}

class HomeScreenDialogState extends ConsumerState<HomeScreenDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
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
                  style: CustomTextStyles.titleMediumGray8000118.copyWith(
                    height: 1.20,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  "Complete your profile to unlock amazing features that will make every journey seamless",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.bodyMediumMulishGray800.copyWith(
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
                    style: CustomTextStyles.titleSmallPrimary,
                ),
                )
              ],
            ),
          )
        ],
      ),
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
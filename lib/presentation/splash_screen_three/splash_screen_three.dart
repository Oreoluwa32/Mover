import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class SplashScreenThree extends StatelessWidget{
  const SplashScreenThree({Key? key})
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
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgSplashScreenThree,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 40.h,
            ),
            child: Column(children: [
              _buildRowprogressflow(context),
              Spacer(flex: 78,),
              _buildColumnyouarein(context),
              Spacer(flex: 21,)
            ],),
          ),
        ),
      ),);
  }

  // Section Widget
  Widget _buildRowprogressflow(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Row(children: [
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
  Widget _buildColumnyouarein(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Text(
            "You are in Control",
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 14.h),
          Text(
              "Choose when, where and how you want to move. You can also choose the best price.",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyLargeOnPrimary.copyWith(
                height: 1.50,
              ),
            ),
          SizedBox(height: 24.h),
          CustomElevatedButton(
            text: "Next",
            buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
            onPressed: () {onTapNext(context);},
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

  // Navigates to the splash screen four when the action is triggered
  onTapNext(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.splashScreenFour);
  }

  // Navigates back to the splash screen two when the action is triggered
  onTapBack(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.splashScreenTwo);
  }
}
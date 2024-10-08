import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class UnderReviewScreen extends StatelessWidget{
  const UnderReviewScreen({Key? key})
    : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.h,
                    vertical: 56.h,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 66.h),
                      CustomImageView(
                        imagePath: ImageConstant.imgAlarmClock,
                        height: 170.h,
                        width: 170.h,
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        "Documents under review",
                        style: CustomTextStyles.titleMediumGray8000118,
                      ),
                      SizedBox(height: 30.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          "Your documents are under review and you can expect a notification withine the next 24 hours.",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.bodyMediumMulishGray800.copyWith(height: 1.50,),
                        ),
                      ),
                      Spacer(),
                      CustomElevatedButton(
                        text: "Close",
                        buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                        onPressed: () {onTapClose(context);},
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Navigates to the home screen 
  onTapClose(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.homeOneScreen);
  }
}
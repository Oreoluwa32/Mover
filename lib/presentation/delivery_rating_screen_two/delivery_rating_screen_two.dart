import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class DeliveryRatingScreenTwo extends StatelessWidget{
  const DeliveryRatingScreenTwo({Key? key})
    : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 8.h,
            top: 2.h,
            right: 8.h,
          ),
          child: Column(
            children: [
              Text(
                "Delivery Complete",
                style: CustomTextStyles.titleMediumGray80001,
              ),
              SizedBox(height: 10.h),
              CustomImageView(
                imagePath: ImageConstant.imgGreenCheck,
                height: 202.h,
                width: double.maxFinite,
              ),
              SizedBox(height: 40.h),
              Text(
                "Thank you for the feedback",
                style: CustomTextStyles.titleMediumBlack900,
              ),
              SizedBox(height: 14.h),
              Text(
                "Your response has been recorded",
                style: CustomTextStyles.bodySmallBlack900,
              ),
              SizedBox(height: 4.h)
            ],
          ),
        ),
      ),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context){
    return CustomAppBar(
      height: 56.h,
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgCancel,
          margin: EdgeInsets.only(
            top: 16.h,
            right: 15.h,
            bottom: 16.h,
          ),
        )
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class VerificationScreenOne extends StatelessWidget{
  const VerificationScreenOne({Key? key})
    : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(context),
      body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 16.h,
            top: 32.h,
            right: 16.h,
          ),
          child: Column(
            children: [
              _buildAccountcard(context),
              SizedBox(height: 16.h),
              _buildAccountcardone(context),
              SizedBox(height: 16.h),
              _buildAccountcardtwo(context),
              SizedBox(height: 4.h)
            ],
          ),
        ),
      );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context){
    return CustomAppBar(
      height: 90.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgLeftArrow1,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 44.h,
          bottom: 22.h,
        ),
        onTap: () {},
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Verification",
        margin: EdgeInsets.only(
          top: 45.h,
          bottom: 20.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildAccountcard(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Personal Information",
            style: CustomTextStyles.titleMediumGray80001Medium,
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgGreenCheck,
            height: 16.h,
            width: 16.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgRightArrow1,
            height: 16.h,
            width: 16.h,
            margin: EdgeInsets.only(left: 8.h),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildAccountcardone(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration:BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Identification",
            style: CustomTextStyles.titleMediumGray80001Medium,
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadiusStyle.roundedBorder4,
            ),
            child: Text(
              "Review",
              textAlign: TextAlign.center,
              style: CustomTextStyles.labelLargeOnPrimary,
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgRightArrow1,
            height: 16.h,
            width: 16.h,
            margin: EdgeInsets.only(left: 16.h),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildAccountcardtwo(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Vehicle Identification",
            style: CustomTextStyles.titleMediumGray80001Medium,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgRightArrow1,
            height: 16.h,
            width: 16.h,
          )
        ],
      ),
    );
  }

  // Navigates back to the home screen
  onTapLeftArrow(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.homeOneInitialPage);
  }
}
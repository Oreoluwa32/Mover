import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'notifier/verification_notifier.dart';

class VerificationScreen extends ConsumerStatefulWidget{
  const VerificationScreen({Key? key})
    : super(key: key,);

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends ConsumerState<VerificationScreen> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
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
              SizedBox(
                width: double.maxFinite,
                child: GestureDetector(
                  onTap: () {onTapPersonalInfo(context);},
                  child: _buildAccountcardOne(
                    context,
                    identification: "Personal Identification",
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.maxFinite,
                child: GestureDetector(
                  onTap: () {},
                  child: _buildAccountcardOne(
                    context,
                    identification: "Identification",
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.maxFinite,
                child: GestureDetector(
                  onTap: () {onTapVehicleInfo(context);},
                  child: _buildAccountcardOne(
                    context,
                    identification: "Vehicle Identification",
                  ),
                ),
              ),
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
        imagePath: ImageConstant.imgChevronLeftBlack,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 44.h,
          bottom: 22.h,
        ),
        onTap: () {onTapLeftArrow1(context);},
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

  // Common Widget
  Widget _buildAccountcardOne(BuildContext context, {
    required String identification,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            identification,
            style: CustomTextStyles.bodyMediumMulishBlack900.copyWith(
              color: appTheme.gray80001,
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgBlackChevronRight,
            height: 16.h,
            width: 16.h,
          )
        ],
      ),
    );
  }

  // Naviagtes back to the home one dialog screen
  onTapLeftArrow1(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.homeScreenDialog);
  }

  // Navigates to the personal info screen when the action is triggered
  onTapPersonalInfo(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.personalInformationScreen);
  }

  // Navigates to the vehicle info screen when the action is triggered
  onTapVehicleInfo(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.vehicleInformationScreen);
  }

  // Navigates to the sign in screen when the action is triggered
  onTapIdentification(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.underReviewScreen);
  }
}
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../presentation/home_screen_dialog/home_screen_dialog.dart';
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
            top: 22.h,
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
                  onTap: () {
                    onTapIdentification(context);
                  },
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
          top: 24.h,
          bottom: 42.h,
        ),
        onTap: () {onTapLeftArrow1(context);},
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Verification",
        margin: EdgeInsets.only(
          top: 22.h,
          bottom: 44.h,
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
        color: theme.colorScheme.onPrimary.withValues(alpha: 1),
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

  // Navigates back to the home one screen with dialog
  onTapLeftArrow1(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.homeOneScreen);
    Future.delayed(Duration(milliseconds: 100), () {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => HomeScreenDialog(),
        );
      }
    });
  }

  // Navigates to the personal info screen when the action is triggered
  onTapPersonalInfo(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.personalInformationScreen);
  }

  // Navigates to the vehicle info screen when the action is triggered
  onTapVehicleInfo(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.vehicleInformationScreen);
  }

  // Navigates to the identification screen when the action is triggered
  onTapIdentification(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.identificationScreen);
  }
}
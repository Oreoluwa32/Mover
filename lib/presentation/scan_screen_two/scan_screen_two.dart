import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class ScanScreenTwo extends StatelessWidget{
  const ScanScreenTwo({Key? key})
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
            top: 46.h,
            right: 16.h,
          ),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 30.h),
                child: Column(
                  children: [
                    Text(
                      "Scan QR Code",
                      style: CustomTextStyles.titleMediumBlack900,
                    ),
                    SizedBox(height: 52.h),
                    CustomImageView(
                      imagePath: ImageConstant.imgQRCode,
                      height: 280.h,
                      width: double.maxFinite,
                    ),
                    SizedBox(height: 52.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Switch to pin code",
                          style: CustomTextStyles.titleSmallPurple900,
                        ),
                        SizedBox(width: 12.h),
                        CustomImageView(
                          imagePath: ImageConstant.imgRepeat,
                          height: 18.h,
                          width: 18.h,
                        )
                      ],
                    )
                  ],
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
      height: 92.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgLeftArrow1,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 44.h,
          bottom: 24.h,
        ),
        onTap: () {},
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Confirm Delivery",
        margin: EdgeInsets.only(
          top: 46.h,
          bottom: 21.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Navigates back to the previous screen
}
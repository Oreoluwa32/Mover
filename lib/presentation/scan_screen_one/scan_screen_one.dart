import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_pin_code_text_field.dart';

class ScanScreenOne extends StatelessWidget{
  const ScanScreenOne({Key? key})
    : super(key: key,);
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
              Text(
                "Enter pin code",
                style: CustomTextStyles.titleMediumBlack900,
              ),
              SizedBox(height: 52.h),
              SizedBox(
                width: double.maxFinite,
                child: CustomPinCodeTextField(
                  context: context, 
                  onChanged: (value) {},
                ),
              ),
              SizedBox(height: 52.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Switch to scan",
                    style: CustomTextStyles.titleSmallPurple900,
                  ),
                  SizedBox(width: 12.h),
                  CustomImageView(
                    imagePath: ImageConstant.imgRepeat,
                    height: 18.h,
                    width: 18.h,
                  )
                ],
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
        text: "Pin Code",
        margin: EdgeInsets.only(
          top: 44.h,
          bottom: 23.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Navigates back to the previous screen 
}
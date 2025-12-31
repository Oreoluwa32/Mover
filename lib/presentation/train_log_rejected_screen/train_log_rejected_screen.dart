import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';

class TrainLogRejectedScreen extends StatelessWidget{
  const TrainLogRejectedScreen({Key? key})
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
            top: 28.h,
            right: 16.h,
          ),
          child: Column(
            children: [
              CustomIconButton(
                height: 56.h,
                width: 56.h,
                padding: EdgeInsets.all(14.h),
                decoration: IconButtonStyleHelper.outlineRed,
                child: CustomImageView(
                  imagePath: ImageConstant.imgError,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Train log rejected",
                style: CustomTextStyles.titleMediumGray8000118,
              ),
              SizedBox(height: 28.h),
              SizedBox(
                width: double.maxFinite,
                child: Text(
                  "After careful review, we regret to inform you that your train log upload was unsuccessful due to a blurry image. Please upload a clear and non-blurry image.",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.bodyMediumMulishGray800.copyWith(height: 1.50,),
                ),
              ),
              SizedBox(height: 44.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Need assistance",
                      style: theme.textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: "Chat us now",
                      style: CustomTextStyles.bodySmallPrimary.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    )
                  ],
                ),
                textAlign: TextAlign.left,
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
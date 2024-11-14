import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_rating_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

// ignore for file, class must be immutable
class DeliveryRatingScreenOne extends StatelessWidget{
  DeliveryRatingScreenOne({Key? key})
    : super(key: key,);

  TextEditingController experienceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                left: 8.h,
                top: 52.h,
                right: 8.h,
              ),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Text(
                    "Delivery Complete",
                    style: CustomTextStyles.titleMediumGray80001,
                  ),
                  SizedBox(height: 10.h),
                  _buildStackratetext(context),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 84.h,
                      right: 82.h,
                    ),
                    child: CustomRatingBar(
                      initialRating: 0,
                      itemSize: 32,
                    ),
                  ),
                  SizedBox(height: 38.h),
                  _buildColumntitle(context)
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildColumnpost(context),
      )
    );
  }

  // Section Widget 
  Widget _buildStackratetext(BuildContext context){
    return SizedBox(
      height: 242.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgGreenCheck,
            height: 202.h,
            width: double.maxFinite,
            alignment: Alignment.topCenter,
          ),
          Text(
            "How would you rate your experience\nwith Benard Joseph",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: CustomTextStyles.titleMediumBlack900.copyWith(height: 1.50,),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildColumntitle(BuildContext context){
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "0/500",
                  style: theme.textTheme.labelLarge,
                ),
                SizedBox(height: 4.h),
                CustomTextFormField(
                  controller: experienceController,
                  hintText: "Describe your experience",
                  textInputAction: TextInputAction.done,
                  contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
                )
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: appTheme.gray10001,
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 2.h),
                Text(
                  "Items were handled with care, and everything arrived in perfect condition",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall!.copyWith(height: 1.20,),
                )
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(
              left: 16.h,
              top: 8.h,
              bottom: 8.h,
            ),
            decoration: BoxDecoration(
              color: appTheme.gray10001,
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 2.h),
                SizedBox(
                  width: 274.h,
                  child: Text(
                    "Movers were prompt and efficient, completing the delivery on time",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall!.copyWith(height: 1.20,),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(
              left: 16.h,
              top: 8.h,
              bottom: 8.h,
            ),
            decoration: BoxDecoration(
              color: appTheme.gray10001,
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 2.h),
                SizedBox(
                  width: 270.h,
                  child: Text(
                    "Excellent communication throughput, keeping me informed about the delivery",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall!.copyWith(height: 1.20),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Section Widget 
  Widget _buildColumnpost(BuildContext context){
    return Container(
      height: 62.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomElevatedButton(
            text: "Post",
            margin: EdgeInsets.only(bottom: 12.h),
            buttonStyle: CustomButtonStyles.fillBlueGray,
          )
        ],
      ),
    );
  }
}
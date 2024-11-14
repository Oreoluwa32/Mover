import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import 'widgets/pickup_one_widget.dart'; //ignore for file, must be immutable

class DeliveryPickupScreenOne extends StatelessWidget{
  const DeliveryPickupScreenOne({Key? key})
    : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        borderRadius: BorderRadiusStyle.customBorderTL24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.h),
          _buildColumn(context),
          SizedBox(height: 40.h),
          _buildButtonnav(context)
        ],
      ),
    );
  }

  Widget _buildColumn(BuildContext context){
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          SizedBox(
            width: 50.h,
            child: Divider(),
          ),
          SizedBox(height: 14.h),
          Text(
            "Proceed to pick up item",
            style: CustomTextStyles.titleMediumGray80001,
          ),
          SizedBox(height: 34.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgProfile,
                  height: 50.h,
                  width: 50.h,
                  radius: BorderRadius.circular(24.h),
                ),
                SizedBox(width: 16.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "John Doe",
                        style: CustomTextStyles.bodyMediumMulishBlack900,
                      ),
                      SizedBox(height: 6.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                "10m away",
                                style: CustomTextStyles.bodySmallInterGray600,
                              ),
                            ),
                            Container(
                              height: 2.h,
                              width: 2.h,
                              margin: EdgeInsets.only(left: 4.h),
                              decoration: BoxDecoration(
                                color: appTheme.gray700,
                                borderRadius: BorderRadius.circular(1.h),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                "2mins",
                                style: CustomTextStyles.bodySmallInterGray600,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 4.h),
                              padding: EdgeInsets.symmetric(horizontal: 16.h),
                              decoration: BoxDecoration(
                                color: appTheme.lightGreen500,
                                borderRadius: BorderRadiusStyle.roundedBorder8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 2.h),
                                  Text(
                                    "Light",
                                    style: CustomTextStyles.labelMediumInterOnPrimary,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 16.h),
                Text(
                  "₦1200",
                  style: theme.textTheme.titleSmall,
                )
              ],
            ),
          ),
          SizedBox(height: 40.h),
          SizedBox(
            height: 52.h,
            width: 282.h,
            child: ListView.separated(
              padding: EdgeInsets.only(
                left: 32.h,
                right: 26.h,
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return PickupOneWidget();
              }, 
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: 100.h,
                );
              }, 
              itemCount: 3,
            ),
          ),
          SizedBox(height: 34.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delivery Details",
                  style: CustomTextStyles.labelLargeBlack900,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgRightArrow1,
                  height: 16.h,
                  width: 16.h,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildButtonnav(BuildContext context){
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.h, 22.h, 16.h, 24.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border(
          top: BorderSide(
            color: appTheme.gray20001,
            width: 1.h,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            text: "Confirm Pickup - Scan",
          )
        ],
      ),
    );
  }
}
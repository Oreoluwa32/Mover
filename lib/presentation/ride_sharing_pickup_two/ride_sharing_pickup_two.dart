import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
// import '../../widgets/custom_radio_button.dart';
import 'widgets/pickup_two_one_item_widget.dart'; //ignore for file, must be immutable

class RideSharingPickupTwo extends StatelessWidget{
  const RideSharingPickupTwo({Key? key})
    : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withOpacity(1),
          borderRadius: BorderRadiusStyle.customBorderTL24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            _buildColumnlineone(context),
            SizedBox(height: 54.h),
            _buildButtonnav(context)
          ],
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildColumnlineone(BuildContext context){
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          SizedBox(
            width: 50.h,
            child: Divider(),
          ),
          SizedBox(height: 16.h),
          Text(
            "Trip in progress",
            style: CustomTextStyles.titleMediumGray80001,
          ),
          SizedBox(height: 18.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(
              left: 8.h,
              right: 22.h,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24.h,
                  child: Column(
                    children: [
                      // CustomRadioButton(onChange: onChange) //Reserved for the radio button
                      CustomImageView(
                        imagePath: ImageConstant.imgSelectedRadio,
                        height: 24.h,
                        width: double.maxFinite,
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.symmetric(horizontal: 6.h),
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Column(
                          children: [
                            Container(
                              height: 6.h,
                              width: 6.h,
                              decoration: BoxDecoration(
                                color: appTheme.gray20001,
                                borderRadius: BorderRadius.circular(3.h,),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              height: 6.h,
                              width: 6.h,
                              decoration: BoxDecoration(
                                color: appTheme.gray20001,
                                borderRadius: BorderRadius.circular(3.h,),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              height: 6.h,
                              width: 6.h,
                              decoration: BoxDecoration(
                                color: appTheme.gray20001,
                                borderRadius: BorderRadius.circular(3.h,),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              height: 6.h,
                              width: 6.h,
                              decoration: BoxDecoration(
                                color: appTheme.gray20001,
                                borderRadius: BorderRadius.circular(3.h,),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              height: 6.h,
                              width: 6.h,
                              decoration: BoxDecoration(
                                color: appTheme.gray20001,
                                borderRadius: BorderRadius.circular(3.h,),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      // CustomRadioButton(onChange: onChange) //Reserved for the radio button
                      CustomImageView(
                        imagePath: ImageConstant.imgSelectedRadio,
                        height: 24.h,
                        width: double.maxFinite,
                      )
                    ],
                  ),
                ),
                SizedBox(width: 8.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pickup Location",
                        style: CustomTextStyles.labelLargeBold,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Muritala Mohammed Airport",
                        style: theme.textTheme.bodySmall,
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        "Destination",
                        style: CustomTextStyles.labelLargeBold,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Gateway Zone, Magodo Phase II, GRA Lagos State",
                        style: CustomTextStyles.bodySmallGray800,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 18.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgProfile,
                  height: 50.h,
                  width: 50.h,
                  radius: BorderRadius.circular(24.h,),
                ),
                SizedBox(width: 18.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "John Doe",
                        style: CustomTextStyles.bodyMediumMulishGray800,
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Text(
                              "10m away",
                              style: CustomTextStyles.bodySmallInterGray600,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 2.h,
                                width: 2.h,
                                margin: EdgeInsets.only(
                                  left: 4.h,
                                  top: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: appTheme.gray700,
                                  borderRadius: BorderRadius.circular(1.h,),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                "2mins",
                                style: CustomTextStyles.bodySmallInterGray600,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgUsers,
                              height: 12.h,
                              width: 12.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                "3 passenger capacity",
                                style: CustomTextStyles.bodySmallInterGray600,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                )
              ],
            ),
          ),
          SizedBox(height: 46.h),
          SizedBox(
            height: 52.h,
            width: 282.h,
            child: ListView.separated(
              padding: EdgeInsets.only(
                left: 32.h,
                right: 26.h,
              ),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: 100.h,
                );
              },
              itemCount: 3,
              itemBuilder: (context, index) {
                return PickupTwoOneItemWidget();
              },
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildButtonnav(BuildContext context) {
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
            text: "End trip",
          )
        ],
      ),
    );
  }
}
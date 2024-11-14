import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart'; //ignore for file, must be immutable

class RideSharingPickupOne extends StatelessWidget{
  const RideSharingPickupOne({Key? key})
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
            Container(
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
                    "Waiting for passenger",
                    style: CustomTextStyles.titleMediumGray80001,
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
                          radius: BorderRadius.circular(24.h),
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
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(
                      left: 32.h,
                      right: 26.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgChat,
                              height: 24.h,
                              width: 24.h,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "Chat",
                              style: theme.textTheme.bodySmall,
                            )
                          ],
                        ),
                        Expanded(
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(horizontal: 46.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgPhoneCall,
                                  height: 24.h,
                                  width: double.maxFinite,
                                  margin: EdgeInsets.only(left: 2.h),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  "Call",
                                  style: theme.textTheme.bodySmall,
                                )
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgAlert,
                              height: 24.h,
                              width: 24.h,
                              margin: EdgeInsets.only(right: 6.h),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Report",
                              style: theme.textTheme.bodySmall,
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 48.h),
            Container(
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
                    text: "Start trip",
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../share_ride_payment/share_ride_payment.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import 'notifier/share_ride_one_notifier.dart';

class ShareRideScreenOne extends ConsumerStatefulWidget {
  const ShareRideScreenOne({Key? key}) : super(key: key);

  @override
  ShareRideScreenOneState createState() => ShareRideScreenOneState();
}

class ShareRideScreenOneState extends ConsumerState<ShareRideScreenOne> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildAppbar(context),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 16.h, top: 24.h, right: 16.h),
                child: Column(
                  children: [
                    _buildReviews(context),
                    SizedBox(
                      height: 98.h,
                    ),
                    Text(
                      "No ratings or reviews",
                      style: CustomTextStyles.labelLargeBluegray400,
                    ),
                    SizedBox(
                      height: 4.h,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: _buildButtonnav(context),
      ),
    );
  }

  // Section Widget
  Widget _buildAppbar(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(top: 20.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border(
          bottom: BorderSide(color: appTheme.gray20001, width: 1.h),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 22.h,
          ),
          CustomAppBar(
            leadingWidth: 40.h,
            leading: AppbarLeadingImage(
              imagePath: ImageConstant.imgLeftArrow1,
              margin: EdgeInsets.only(left: 16.h),
              onTap: () {
                onTapBack(context);
              },
            ),
            centerTitle: true,
            title: AppbarTitle(text: "Mover"),
          ),
          SizedBox(
            height: 60.h,
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgProfile,
                        height: 76.h,
                        width: 76.h,
                        radius: BorderRadius.circular(38.h),
                        alignment: Alignment.topCenter,
                      ),
                      SizedBox(
                        width: 12.h,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jane Doe",
                              style: theme.textTheme.titleSmall?.copyWith(color: Colors.black87),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            SizedBox(
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Text(
                                    "Leaving 7:30 AM",
                                    style:
                                        CustomTextStyles.bodySmallInterGray600,
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      height: 2.h,
                                      width: 2.h,
                                      margin:
                                          EdgeInsets.only(left: 4.h, top: 4.h),
                                      decoration: BoxDecoration(
                                        color: appTheme.gray700,
                                        borderRadius:
                                            BorderRadius.circular(1.h),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.h),
                                    child: Text(
                                      "4km away",
                                      style: CustomTextStyles
                                          .bodySmallInterGray600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            SizedBox(
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgBlackCar,
                                    height: 16.h,
                                    width: 16.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.h),
                                    child: Text(
                                      "Toyota Camry",
                                      style: CustomTextStyles
                                          .bodySmallInterGray600,
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
                                      "EKY453YB",
                                      style: CustomTextStyles
                                          .bodySmallInterGray600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
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
                                      style: CustomTextStyles
                                          .bodySmallInterGray600,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      height: 2.h,
                                      width: 2.h,
                                      margin:
                                          EdgeInsets.only(left: 4.h, top: 4.h),
                                      decoration: BoxDecoration(
                                        color: appTheme.gray700,
                                        borderRadius:
                                            BorderRadius.circular(1.h),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.h),
                                    child: Text(
                                      "0/3",
                                      style: CustomTextStyles
                                          .bodySmallInterGray600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "Completed jobs: 0",
                              style: CustomTextStyles.labelMediumGray80001,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 12.h,
                      ),
                      Text(
                        "₦700",
                        style: theme.textTheme.titleSmall?.copyWith(color: Colors.black87),
                      )
                    ],
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
  Widget _buildReviews(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Reviews(0)",
            style: CustomTextStyles.titleSmallMedium?.copyWith(color: Colors.black87),
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgFacebook,
            height: 18.h,
            width: 18.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgInstagram,
            height: 18.h,
            width: 18.h,
            margin: EdgeInsets.only(left: 16.h),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgLinkedin,
            height: 18.h,
            width: 18.h,
            margin: EdgeInsets.only(left: 16.h),
          )
        ],
      ),
    );
  }

  // Section Wigdet
  Widget _buildButtonnav(BuildContext context) {
    return Container(
      height: 98.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border(
          top: BorderSide(color: appTheme.gray20001, width: 1.h),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomElevatedButton(
            text: "Share Ride",
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.h)
                    )
                  ),
                  builder: (BuildContext context) {
                    return const ShareRidePayment();
                  });
            },
          )],
      ),
    );
  }

  // Navigates back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }
}

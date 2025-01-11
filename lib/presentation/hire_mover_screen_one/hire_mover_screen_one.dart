import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../payment_bottomsheet/payment_bottomsheet.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import 'notifier/hire_mover_one_notifier.dart';

class HireMoverScreenOne extends ConsumerStatefulWidget {
  const HireMoverScreenOne({Key? key}) : super(key: key);

  @override
  HireMoverScreenOneState createState() => HireMoverScreenOneState();
}

class HireMoverScreenOneState extends ConsumerState<HireMoverScreenOne> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildProfile(context),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 16.h, top: 32.h, right: 16.h),
                child: Column(
                  children: [
                    _buildReviews(context),
                    SizedBox(
                      height: 52.h,
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
  Widget _buildProfile(BuildContext context) {
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
            height: 20.h,
          ),
          CustomAppBar(
            leadingWidth: 40.h,
            leading: AppbarLeadingImage(
              imagePath: ImageConstant.imgLeftArrow,
              margin: EdgeInsets.only(
                left: 16.h,
                top: 1.h,
              ),
              onTap: () {},
            ),
            centerTitle: true,
            title: AppbarTitle(text: "Mover"),
          ),
          SizedBox(
            height: 62.h,
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
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
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 12.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: double.maxFinite,
                                        child: Row(
                                          children: [
                                            Text(
                                              "John Doe",
                                              style: CustomTextStyles
                                                  .titleSmallMedium
                                                  .copyWith(
                                                      color: Colors.black87),
                                            ),
                                            SizedBox(width: 8.h),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CustomImageView(
                                                  imagePath:
                                                      ImageConstant.imgAway,
                                                  height: 16.h,
                                                  width: 16.h,
                                                ),
                                                SizedBox(
                                                  width: 4.h,
                                                ),
                                                CustomImageView(
                                                  imagePath:
                                                      ImageConstant.imgAway,
                                                  height: 16.h,
                                                  width: 16.h,
                                                ),
                                                SizedBox(
                                                  width: 4.h,
                                                ),
                                                CustomImageView(
                                                  imagePath:
                                                      ImageConstant.imgAway,
                                                  height: 16.h,
                                                  width: 16.h,
                                                ),
                                                SizedBox(
                                                  width: 4.h,
                                                ),
                                                CustomImageView(
                                                  imagePath:
                                                      ImageConstant.imgAway,
                                                  height: 16.h,
                                                  width: 16.h,
                                                ),
                                                SizedBox(
                                                  width: 4.h,
                                                ),
                                                CustomImageView(
                                                  imagePath:
                                                      ImageConstant.imgAway,
                                                  height: 16.h,
                                                  width: 16.h,
                                                ),
                                              ],
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
                                            Text(
                                              "2km away",
                                              style: CustomTextStyles
                                                  .bodySmallInterGray600,
                                            ),
                                            Container(
                                              height: 2.h,
                                              width: 2.h,
                                              margin:
                                                  EdgeInsets.only(left: 4.h),
                                              decoration: BoxDecoration(
                                                color: appTheme.gray700,
                                                borderRadius:
                                                    BorderRadius.circular(1.h),
                                              ),
                                            ),
                                            CustomImageView(
                                              imagePath:
                                                  ImageConstant.imgBlackCar,
                                              height: 16.h,
                                              width: 16.h,
                                              margin:
                                                  EdgeInsets.only(left: 4.h),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                      Text(
                                        "No ratings or reviews",
                                        style: CustomTextStyles
                                            .labelLargeBluegray400,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 6.h),
                              child: Text(
                                "₦1700",
                                style: theme.textTheme.titleSmall
                                    ?.copyWith(color: Colors.black87),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      // SizedBox(
                      //   width: double.maxFinite,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Column(
                      //         children: [
                      //           Text(
                      //             "Badges",
                      //             style: CustomTextStyles.labelLargeGray600,
                      //           ),
                      //           Text(
                      //             "5",
                      //             style: CustomTextStyles.titleMediumGray800,
                      //           )
                      //         ],
                      //       ),
                      //       Column(
                      //         children: [
                      //           Text(
                      //             "Trips taken",
                      //             style: CustomTextStyles.labelLargeGray600,
                      //           ),
                      //           Text(
                      //             "0",
                      //             style: CustomTextStyles.titleMediumGray800,
                      //           )
                      //         ],
                      //       ),
                      //       Column(
                      //         children: [
                      //           Text(
                      //             "Ride Shared",
                      //             style: CustomTextStyles.labelLargeGray600,
                      //           ),
                      //           Text(
                      //             "0",
                      //             style: CustomTextStyles.titleMediumGray800,
                      //           )
                      //         ],
                      //       ),
                      //       Column(
                      //         children: [
                      //           Text(
                      //             "Deliveries",
                      //             style: CustomTextStyles.labelLargeGray600,
                      //           ),
                      //           Text(
                      //             "0",
                      //             style: CustomTextStyles.titleMediumGray800,
                      //           )
                      //         ],
                      //       )
                      //     ],
                      //   ),
                      // )
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
            "Reviews (0)",
            style: CustomTextStyles.titleSmallBlack900,
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
          ),
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildButtonnav(BuildContext context) {
    return Container(
      height: 98.h,
      width: double.maxFinite,
      padding: EdgeInsets.only(
        left: 16.h,
        top: 24.h,
        right: 16.h,
      ),
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
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomElevatedButton(
            text: "Hire Mover",
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.h)
                    )
                  ),
                  builder: (BuildContext context) {
                    return PaymentBottomsheet();
                  });
            },
          )
        ],
      ),
    );
  }
}

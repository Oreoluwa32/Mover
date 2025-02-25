import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'user_delivery_pin_tab.dart';
import 'user_delivery_qr_tab.dart';
import 'notifier/user_delivery_notifier.dart';

class UserDeliveryBottomsheetOne extends ConsumerStatefulWidget {
  const UserDeliveryBottomsheetOne({super.key});

  @override
  UserDeliveryBottomsheetOneState createState() =>
      UserDeliveryBottomsheetOneState();
}

// ignore foe file, class must be immutable
class UserDeliveryBottomsheetOneState
    extends ConsumerState<UserDeliveryBottomsheetOne>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(1),
              borderRadius: BorderRadiusStyle.customBorderTL24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 16.h,
                ),
                _buildColumn(context),
                _buildTabbar(context),
                SizedBox(height: 70.h,),
                GestureDetector(
                  onTap: () {
                    NavigatorService.pushNamed(AppRoutes.rideCancelScreenOne);
                  },
                  child: Text(
                    "Cancel Request",
                    style: CustomTextStyles.titleSmallRedA700,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // section Widget
  Widget _buildColumn(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(
                  width: 50.h,
                  child: Divider(),
                ),
                SizedBox(
                  height: 14.h,
                ),
                Text(
                  "Mover will arrive in 10mins",
                  style: CustomTextStyles.titleMediumGray80001,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.h,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                    border: Border.all(color: appTheme.gray20001, width: 1.h),
                  ),
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgProfile,
                        height: 50.h,
                        width: 50.h,
                        radius: BorderRadius.circular(24.h),
                        margin: EdgeInsets.only(top: 4.h),
                      ),
                      SizedBox(
                        width: 16.h,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Row(
                                    children: [
                                      Text(
                                        "John Doe",
                                        style: theme.textTheme.titleSmall?.copyWith(color: Colors.black87),
                                      ),
                                      // Align(
                                      //   alignment: Alignment.topCenter,
                                      //   child: Container(
                                      //     width: 16.h,
                                      //     height: 16.h,
                                      //     alignment: Alignment.center,
                                      //     margin: EdgeInsets.only(left: 8.h),
                                      //     decoration: BoxDecoration(
                                      //       borderRadius: BorderRadiusStyle
                                      //           .roundedBorder4,
                                      //       border: Border.all(
                                      //         color: appTheme.purple900,
                                      //         width: 0.67.h,
                                      //       ),
                                      //       gradient: LinearGradient(
                                      //         begin: Alignment(0.5, -0.04),
                                      //         end: Alignment(0.5, 0.25),
                                      //         colors: [
                                      //           theme.colorScheme.onPrimary
                                      //               .withOpacity(1),
                                      //           theme.colorScheme.primary
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     child: Text(
                                      //       "A",
                                      //       textAlign: TextAlign.center,
                                      //       style: CustomTextStyles
                                      //           .labelMediumOnPrimaryBold,
                                      //     ),
                                      //   ),
                                      // )
                                      Padding(padding: EdgeInsets.only(right: 8.h)),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CustomImageView(
                                            imagePath: ImageConstant.imgAway,
                                            height: 16.h,
                                            width: 16.h,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
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
                                        margin: EdgeInsets.only(left: 4.h),
                                        decoration: BoxDecoration(
                                          color: appTheme.gray700,
                                          borderRadius:
                                              BorderRadius.circular(1.h),
                                        ),
                                      ),
                                      CustomImageView(
                                        imagePath: ImageConstant.imgBlackCar,
                                        height: 16.h,
                                        width: 16.h,
                                        margin: EdgeInsets.only(left: 4.h),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  "No ratings or reviews",
                                  style: CustomTextStyles.labelLargeBluegray400,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
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
                            imagePath: ImageConstant.imgChatSquare,
                            height: 24.h,
                            width: 24.h,
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgPhoneCall,
                                height: 24.h,
                                width: double.maxFinite,
                                margin: EdgeInsets.only(left: 2.h),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
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
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            "Report",
                            style: theme.textTheme.bodySmall,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 44.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: TabBar(
                    controller: tabviewController,
                    labelPadding: EdgeInsets.zero,
                    labelColor: appTheme.gray80001,
                    labelStyle: TextStyle(
                        fontSize: 14.fSize,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w500),
                    unselectedLabelColor: appTheme.blueGray400,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 14.fSize,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: [
                      Tab(
                        height: 48,
                        child: Container(
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          margin: EdgeInsets.only(right: 6.h),
                          decoration: tabIndex == 0
                              ? BoxDecoration(
                                  color: theme.colorScheme.onPrimary
                                      .withOpacity(1),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: theme.colorScheme.primary,
                                      width: 2.h,
                                    ),
                                  ))
                              : BoxDecoration(
                                  color: theme.colorScheme.onPrimary
                                      .withOpacity(1)),
                          child: Text("QR Code"),
                        ),
                      ),
                      Tab(
                        height: 48,
                        child: Container(
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          margin: EdgeInsets.only(left: 6.h),
                          decoration: tabIndex == 1
                              ? BoxDecoration(
                                  color: theme.colorScheme.onPrimary
                                      .withOpacity(1),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: theme.colorScheme.primary,
                                      width: 2.h,
                                    ),
                                  ))
                              : BoxDecoration(
                                  color: theme.colorScheme.onPrimary
                                      .withOpacity(1),
                                ),
                          child: Text(
                            "Pin Code",
                          ),
                        ),
                      )
                    ],
                    indicatorColor:  Colors.white,
                    onTap: (index) {
                      tabIndex = index;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildTabbar(BuildContext context) {
    return SizedBox(
      height: 338.h,
      child: TabBarView(
        controller: tabviewController,
        children: [UserDeliveryQrTab(), UserDeliveryPinTab()],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'user_delivery_two_pin_tab.dart';
import 'user_delivery_two_qr_tab.dart';
import 'notifier/user_delivery_two_notifier.dart';

class UserDeliveryBottomsheetTwo extends ConsumerStatefulWidget {
  const UserDeliveryBottomsheetTwo({Key? key}) : super(key: key);

  @override
  UserDeliveryBottomsheetTwoState createState() =>
      UserDeliveryBottomsheetTwoState();
}

class UserDeliveryBottomsheetTwoState
    extends ConsumerState<UserDeliveryBottomsheetTwo>
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
            padding: EdgeInsets.only(
              left: 16.h,
              top: 16.h,
              right: 16.h,
            ),
            decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary.withOpacity(1),
                borderRadius: BorderRadiusStyle.customBorderTL24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 50.h,
                  child: Divider(),
                ),
                SizedBox(
                  height: 14.h,
                ),
                Text(
                  "Delivery is in progress",
                  style: CustomTextStyles.titleMediumGray80001,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "Your package will be delivered in 10mins",
                  style: CustomTextStyles.bodySmall110,
                ),
                SizedBox(
                  height: 28.h,
                ),
                _buildRoute(context),
                SizedBox(
                  height: 62.h,
                ),
                _buildProfile(context),
                SizedBox(
                  height: 62.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    "Kindly send your delivery tag to the receiver. This will confirm that the delivery was successful.",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.bodyMediumMulishGray800
                        .copyWith(height: 1.20),
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                _buildTabs(context),
                SizedBox(
                  height: 26.h,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgQRCode,
                  height: 200.h,
                  width: double.maxFinite,
                  margin: EdgeInsets.only(left: 72.h, right: 70.h),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildRoute(BuildContext context) {
    return Container(
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
                CustomImageView(
                  imagePath: ImageConstant.imgSelectedRadio,
                  height: 24.h,
                  width: double.maxFinite,
                ),
                SizedBox(
                  height: 2.h,
                ),
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
                          borderRadius: BorderRadius.circular(3.h),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Container(
                        height: 6.h,
                        width: 6.h,
                        decoration: BoxDecoration(
                          color: appTheme.gray20001,
                          borderRadius: BorderRadius.circular(3.h),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Container(
                        height: 6.h,
                        width: 6.h,
                        decoration: BoxDecoration(
                          color: appTheme.gray20001,
                          borderRadius: BorderRadius.circular(3.h),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Container(
                        height: 6.h,
                        width: 6.h,
                        decoration: BoxDecoration(
                          color: appTheme.gray20001,
                          borderRadius: BorderRadius.circular(3.h),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Container(
                        height: 6.h,
                        width: 6.h,
                        decoration: BoxDecoration(
                          color: appTheme.gray20001,
                          borderRadius: BorderRadius.circular(3.h),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgSelectedRadio,
                  height: 24.h,
                  width: double.maxFinite,
                )
              ],
            ),
          ),
          SizedBox(
            width: 8.h,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pickup location",
                  style: CustomTextStyles.labelLargeBold,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  "Peace Estate, Oluyole, Ibadan",
                  style: theme.textTheme.bodySmall,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  "Destination",
                  style: CustomTextStyles.labelLargeBold,
                ),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  "Bateye Street, Imalefalafia, Ibadan",
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildProfile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgProfile,
            height: 50.h,
            width: 50.h,
            radius: BorderRadius.circular(24.h),
            alignment: Alignment.center,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: Column(
                  children: [
                    Text(
                      "John Doe",
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: Colors.black87),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Text(
                            "2km away",
                            style: CustomTextStyles.bodySmallInterGray600,
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
                          CustomImageView(
                            imagePath: ImageConstant.imgBlackCar,
                            height: 16.h,
                            width: 16.h,
                            margin: EdgeInsets.only(left: 4.h),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 4.h, bottom: 2.h),
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgChat,
                  height: 16.h,
                  width: 16.h,
                  margin: EdgeInsets.only(left: 4.h),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Chat",
                    style: theme.textTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 4.h, bottom: 2.h),
          //   child: _buildCallReport(
          //     context,
          //     icon: ImageConstant.imgPhoneCall,
          //     iconTitle: "Call",
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(left: 4.h, bottom: 2.h),
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgPhoneCall,
                  height: 16.h,
                  width: 16.h,
                  margin: EdgeInsets.only(left: 4.h),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Call",
                    style: theme.textTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 4.h),
          //   child: _buildCallReport(context,
          //       icon: ImageConstant.imgAlert, iconTitle: "Report"),
          // )
          Container(
            margin: EdgeInsets.only(left: 4.h, bottom: 2.h),
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgAlert,
                  height: 16.h,
                  width: 16.h,
                  margin: EdgeInsets.only(left: 4.h),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Report",
                    style: theme.textTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildTabs(BuildContext context) {
    return SizedBox(
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
                      color: theme.colorScheme.onPrimary.withOpacity(1),
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2.h,
                        ),
                      ))
                  : BoxDecoration(
                      color: theme.colorScheme.onPrimary.withOpacity(1)),
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
                      color: theme.colorScheme.onPrimary.withOpacity(1),
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2.h,
                        ),
                      ))
                  : BoxDecoration(
                      color: theme.colorScheme.onPrimary.withOpacity(1),
                    ),
              child: Text(
                "Pin Code",
              ),
            ),
          )
        ],
        indicatorColor: Colors.white,
        onTap: (index) {
          tabIndex = index;
          setState(() {});
        },
      ),
    );
  }

  // Section Widget
  Widget _buildTabbar(BuildContext context) {
    return SizedBox(
      height: 338.h,
      child: TabBarView(
        controller: tabviewController,
        children: [UserDeliveryTwoQrTab(), UserDeliveryTwoPinTab()],
      ),
    );
  }
}

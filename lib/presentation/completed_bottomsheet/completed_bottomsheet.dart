import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'notifier/completed_notifier.dart'; // ignore for file, class must be immutable

class CompletedBottomsheet extends ConsumerStatefulWidget{
  const CompletedBottomsheet({Key? key}) : super(key: key);

  @override
  CompletedBottomsheetState createState() => CompletedBottomsheetState();
}

class CompletedBottomsheetState extends ConsumerState<CompletedBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            borderRadius: BorderRadiusStyle.customBorderTL24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildContent(context),
              SizedBox(height: 32.h,),
              _buildPayment(context),
              SizedBox(height: 40.h,)
            ],
          ),
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildContent(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          SizedBox(
            width: 50.h,
            child: Divider(),
          ),
          SizedBox(height: 14.h),
          Text(
            "Trip Completed",
            style: CustomTextStyles.titleMediumGray80001,
          ),
          SizedBox(height: 18.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(
              left: 8.h,
              right: 12.h,
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: _buildLocation(
                    context,
                    title: "Pickup Location",
                    value: "Muritala Mohammed",
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildLocation(
                    context,
                    title: "Destination",
                    value: "Gateway Zone",
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10.h,),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 50.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgCalendar,
                  height: 12.h,
                  width: 12.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    child: Text(
                      "13 Dec",
                      style: theme.textTheme.bodySmall!.copyWith(color: appTheme.black900),
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgClock,
                  height: 12.h,
                  width: 12.h,
                  margin: EdgeInsets.only(left: 8.h),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    child: Text(
                      "13:30",
                      style: theme.textTheme.bodySmall!.copyWith(color: appTheme.black900),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10.h,),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.h,
              vertical: 10.h
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.roundedBorder8,
              border: Border.all(
                color: appTheme.gray20001,
                width: 1.h
              ),
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
                SizedBox(width: 16.h,),
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
                                  style: theme.textTheme.titleSmall!.copyWith(color: appTheme.gray800),
                                ),
                                Container(
                                  width: 16.h,
                                  height: 16.h,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 8.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadiusStyle.roundedBorder2,
                                    border: Border.all(
                                      color: appTheme.purple900,
                                      width: 0.67.h
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment(0.5, -0.04),
                                      end: Alignment(0.5, 0.25),
                                      colors: [
                                        theme.colorScheme.onPrimary.withOpacity(1),
                                        theme.colorScheme.primary
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    "A",
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyles.labelMediumOnPrimaryBold,
                                  ),
                                )
                              ],
                            ),
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
          SizedBox(height: 20.h,),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delivery Details",
                  style: CustomTextStyles.labelLargeMedium,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgChevronRightBlack,
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
  Widget _buildPayment(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment",
            style: CustomTextStyles.titleSmallMedium
          ),
          SizedBox(height: 10.h,),
          SizedBox(
            width: double.maxFinite,
            child: _buildDetails(
              context,
              title: "Mode of payment",
              value: "Wallet"
            ),
          ),
          SizedBox(height: 6.h,),
          SizedBox(
            width: double.maxFinite,
            child: _buildDetails(
              context,
              title: "Transportation",
              value: "Car"
            ),
          ),
          SizedBox(height: 6.h,),
          SizedBox(
            width: double.maxFinite,
            child: _buildDetails(
              context,
              title: "Trip fare",
              value: "₦550"
            ),
          ),
          SizedBox(height: 12.h,),
          SizedBox(
            width: double.maxFinite,
            child: _buildDetails(
              context,
              title: "Service fee",
              value: "₦500"
            ),
          ),
          SizedBox(height: 16.h,),
          SizedBox(
            width: double.maxFinite,
            child: Divider(
              color: appTheme.gray20001,
            ),
          ),
          SizedBox(height: 14.h,),
          SizedBox(
            width: double.maxFinite,
            child: _buildDetails(
              context,
              title: "Total",
              value: "₦1050"
            ),
          )
        ],
      ),
    );
  }

  // Common Widget
  Widget _buildDetails(
    BuildContext context, {
    required String title,
    required String value
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall!.copyWith(
            color: appTheme.black900
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.right,
          style: theme.textTheme.bodySmall!.copyWith(
            color: appTheme.black900
          ),
        )
      ],
    );
  }

  // Common Widget
  Widget _buildLocation(
    BuildContext context, {
    required String title,
    required String value
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 18.h,),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CustomTextStyles.labelLargeBold.copyWith(color: appTheme.gray80001),
                ),
                SizedBox(height: 6.h,),
                Text(
                  value,
                  style: CustomTextStyles.bodySmallGray800.copyWith(color: appTheme.gray800),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
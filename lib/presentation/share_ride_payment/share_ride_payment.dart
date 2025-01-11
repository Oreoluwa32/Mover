import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import 'notifier/share_ride_payment_notifier.dart';

class ShareRidePayment extends ConsumerStatefulWidget {
  const ShareRidePayment({Key? key}) : super(key: key);

  @override
  ShareRidePaymentState createState() => ShareRidePaymentState();
}

class ShareRidePaymentState extends ConsumerState<ShareRidePayment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withOpacity(1),
          borderRadius: BorderRadiusStyle.customBorderTL24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 16.h,
          ),
          _buildPayment(context),
          SizedBox(
            height: 22.h,
          ),
          _buildButtonnav(context)
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildPayment(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          SizedBox(
            width: 50.h,
            child: Divider(),
          ),
          SizedBox(
            height: 14.h,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Make Payment",
                  style: CustomTextStyles.titleMediumGray80001,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgCancel,
                  height: 24.h,
                  width: 24.h,
                  margin: EdgeInsets.only(left: 90.h),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 14.h,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "This fee will be deducted from your wallet. The mover will not receive this payment until the task is been completed and confirmed.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.bodySmall110.copyWith(height: 1.50),
                ),
                SizedBox(
                  height: 24.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildDetails(
                    context,
                    title: "Name of Mover",
                    content: "John Doe",
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child:
                      _buildDetails(context, title: "Amount", content: "₦1700"),
                ),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Divider(
                    color: appTheme.gray20001,
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                Text(
                  "Payment method",
                  style: CustomTextStyles.bodySmallBlack90010,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
                  decoration: BoxDecoration(
                      color: appTheme.gray10001,
                      borderRadius: BorderRadiusStyle.roundedBorder8),
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconButton(
                        height: 40.h,
                        width: 40.h,
                        padding: EdgeInsets.all(8.h),
                        decoration: IconButtonStyleHelper.fillLightGreen,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgWallet,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Balance",
                                  style: CustomTextStyles.labelLargeMedium,
                                ),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Row(
                                    children: [
                                      Text(
                                        "₦260",
                                        style: CustomTextStyles
                                            .labelLargeBluegray400,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 4.h),
                                        child: Text(
                                          "Insufficient funds",
                                          style:
                                              CustomTextStyles.bodySmallRed500,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.h, bottom: 1.5.h),
                          child: Text(
                            "Top up",
                            style: CustomTextStyles.bodySmallPrimary10,
                          ),
                        ),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgChevronRight,
                        height: 12.h,
                        width: 12.h,
                        margin: EdgeInsets.only(left: 4.h),
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
  Widget _buildButtonnav(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.h, 22.h, 16.h, 24.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border(
          top: BorderSide(color: appTheme.gray20001, width: 1.h),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            text: "Proceed",
            buttonStyle: CustomButtonStyles.fillBlueGray,
          )
        ],
      ),
    );
  }

  // Common Widget
  Widget _buildDetails(BuildContext context,
      {required String title, required String content}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              CustomTextStyles.bodySmall110.copyWith(color: appTheme.gray80001),
        ),
        Text(
          content,
          style:
              CustomTextStyles.bodySmall110.copyWith(color: appTheme.gray80001),
        )
      ],
    );
  }
}

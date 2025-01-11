import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import 'notifier/payment_notifier.dart';

class PaymentBottomsheet extends ConsumerStatefulWidget {
  const PaymentBottomsheet({Key? key}) : super(key: key);

  @override
  PaymentBottomsheetState createState() => PaymentBottomsheetState();
}

class PaymentBottomsheetState extends ConsumerState<PaymentBottomsheet> {
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
          _buildColumn(context),
          SizedBox(
            height: 14.h,
          ),
          _buildDescription(context)
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildColumn(BuildContext context) {
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
            height: 16.h,
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
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildDescription(BuildContext context) {
    return SizedBox(
      height: 336.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This fee will not be deducted from your wallet. The mover will not receive this payment until the task is been completed and confirmed.",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall!.copyWith(height: 1.50),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(right: 16.h),
                    child: _buildDetails(
                      context,
                      title: "Name of Mover",
                      content: "John Doe",
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(right: 16.h),
                    child: _buildDetails(context,
                        title: "Amount", content: "₦1700"),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Divider(
                      color: appTheme.gray20001,
                      endIndent: 16.h,
                    ),
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  Text(
                    "Payment method",
                    style: theme.textTheme.bodySmall,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 16.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 12.h,
                    ),
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
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.only(left: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Balance",
                                    style: CustomTextStyles.labelLargeMedium,
                                  ),
                                  Text(
                                    "34,100",
                                    style:
                                        CustomTextStyles.labelLargeBluegray400,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
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
              children: [CustomElevatedButton(text: "Proceed")],
            ),
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
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.black87,
          ),
        ),
        Text(
          content,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.black87,
          ),
        )
      ],
    );
  }
}

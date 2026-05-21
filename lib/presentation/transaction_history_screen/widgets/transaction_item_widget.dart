import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';
import '../models/transaction_item_model.dart';

// ignore for file, class must be immutable
class TransactionItemWidget extends StatelessWidget {
  const TransactionItemWidget(this.transactionItemModelObj, {super.key});

  final TransactionItemModel transactionItemModelObj;

  @override
  Widget build(BuildContext context) {
    final normalizedStatus =
        (transactionItemModelObj.status ?? '').trim().toLowerCase();
    final statusColor = switch (normalizedStatus) {
      'success' || 'successful' || 'completed' => const Color(0xFF2E7D32),
      'pending' => const Color(0xFFB26A00),
      'failed' || 'cancelled' || 'rejected' => const Color(0xFFD32F2F),
      _ => appTheme.gray600,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            height: 40.h,
            width: 40.h,
            padding: EdgeInsets.all(10.h),
            decoration: IconButtonStyleHelper.fillGray,
            child: CustomImageView(
              imagePath: ImageConstant.imgCreditCard,
            ),
          ),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transactionItemModelObj.transStatus!,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.labelLargeMedium,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Text(
                        transactionItemModelObj.transDate!,
                        style: CustomTextStyles.bodySmall110,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 2.h,
                          width: 2.h,
                          margin: EdgeInsets.only(left: 4.h, top: 6.h),
                          decoration: BoxDecoration(
                            color: appTheme.gray80001,
                            borderRadius: BorderRadius.circular(1.h),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          transactionItemModelObj.transTime!,
                          style: CustomTextStyles.bodySmall110,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transactionItemModelObj.amount!,
                style: CustomTextStyles.labelLargeMedium,
              ),
              Text(
                transactionItemModelObj.status!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

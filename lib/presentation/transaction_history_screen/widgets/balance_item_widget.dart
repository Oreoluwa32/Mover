import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/balance_item_model.dart';

// ignore for file, class must be immutable
class BalanceItemWidget extends StatelessWidget{
  BalanceItemWidget(this.balanceItemModelObj, {Key? key})
    : super(
      key: key,
    );

  BalanceItemModel balanceItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164.h,
      padding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 10.h
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(
          color: appTheme.blueGray10002,
          width: 1.h
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Text(
                  balanceItemModelObj.title!,
                  style: CustomTextStyles.labelLargeGray600,
                ),
                CustomImageView(
                  imagePath: balanceItemModelObj.icon!,
                  height: 14.h,
                  width: 14.h,
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(left: 4.h),
                )
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            balanceItemModelObj.balance!,
            style: CustomTextStyles.bodyLargeGray80001,
          )
        ],
      ),
    );
  }
}
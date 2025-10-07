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
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        vertical: 24.h
      ),
      decoration: AppDecoration.fillBlack900.copyWith(borderRadius: BorderRadiusStyle.circleBorder14),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                balanceItemModelObj.title!,
                style: CustomTextStyles.bodyMediumWhiteA700,
              ),
              CustomImageView(
                imagePath: balanceItemModelObj.icon!,
                height: 14.h,
                width: 14.h,
              )
            ],
          ),
          Text(
            balanceItemModelObj.balance!,
            style: CustomTextStyles.headlineLargeOnPrimary,
          ),
          SizedBox(height: 15.h,)
        ],
      ),
    );
  }
}
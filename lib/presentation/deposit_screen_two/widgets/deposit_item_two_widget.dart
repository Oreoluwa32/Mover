import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_checkbox_button.dart';
import '../models/deposit_item_two_model.dart';

// ignore for file, class must be immutable
class DepositItemTwoWidget extends StatelessWidget {
  DepositItemTwoWidget(this.depositItemTwoModelObj,
      {Key? key, this.changeRadioBtn})
      : super(key: key);

  DepositItemTwoModel depositItemTwoModelObj;

  Function(bool)? changeRadioBtn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(
          color: appTheme.gray400,
          width: 1.h,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 24.h,
            width: 34.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.roundedBorder2,
              border: Border.all(color: appTheme.gray20001, width: 1.h),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImageView(
                  imagePath: depositItemTwoModelObj.image!,
                  height: 12.h,
                  width: 22.h,
                )
              ],
            ),
          ),
          SizedBox(
            width: 4.h,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  depositItemTwoModelObj.cardNum!,
                  style: CustomTextStyles.bodySmallGray800,
                ),
                Text(
                  depositItemTwoModelObj.cardType!,
                  style: CustomTextStyles.bodySmallBluegray40012,
                )
              ],
            ),
          ),
          SizedBox(
            width: 4.h,
          ),
          CustomCheckboxButton(
            value: depositItemTwoModelObj.radioBtn!,
            onChange: (value) {
              changeRadioBtn?.call(value!);
            },
          )
        ],
      ),
    );
  }
}

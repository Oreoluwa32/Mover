import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';
import '../models/deposit_item_model.dart';

// ignore for file, must be immutable
class DepositItemWidget extends StatelessWidget {
  DepositItemWidget(this.depositItemModelObj, {Key? key}) : super(key: key);

  DepositItemModel depositItemModelObj;

  @override
  Widget build(BuildContext context) {
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
              imagePath: depositItemModelObj.depositIcon!,
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
                  depositItemModelObj.depositOption!,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.labelLargeMedium,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  depositItemModelObj.depositText!,
                  style: CustomTextStyles.bodySmall110,
                )
              ],
            ),
          ),
          SizedBox(
            width: 8.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgChevronRightBlack,
            height: 20.h,
            width: 20.h,
          )
        ],
      ),
    );
  }
}

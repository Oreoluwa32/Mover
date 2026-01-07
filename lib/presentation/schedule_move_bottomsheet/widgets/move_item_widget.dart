import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/move_item_model.dart';

// ignore for file, must be immutable
class MoveItemWidget extends StatelessWidget {
  MoveItemWidget(
    this.moveItemModelObj, {
    Key? key,
    this.onTap,
  }) : super(key: key);

  MoveItemModel moveItemModelObj;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
        decoration: BoxDecoration(
            color: appTheme.gray10001,
            borderRadius: BorderRadiusStyle.roundedBorder8),
        child: Row(
          children: [
            CustomImageView(
              imagePath: moveItemModelObj.serviceIcon!,
              height: 50.h,
              width: 50.h,
            ),
            SizedBox(
              width: 16.h,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moveItemModelObj.serviceTitle!,
                  style: CustomTextStyles.labelLargeBlack900,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  moveItemModelObj.serviceText!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.bodySmallBlack90010
                      .copyWith(height: 1.50),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/delivery_task_item_model.dart';

class DeliveryTaskOneBottomsheetWidget extends StatelessWidget {
  DeliveryTaskOneBottomsheetWidget(this.deliveryTaskItemModelObj, {super.key});

  DeliveryTaskItemModel deliveryTaskItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.h,
      padding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: appTheme.gray20001,
        borderRadius: BorderRadiusStyle.roundedBorder2,
      ),
      child: Text(
        deliveryTaskItemModelObj.selectPrice!,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: CustomTextStyles.bodySmallBlack900,
      ),
    );
  }
}

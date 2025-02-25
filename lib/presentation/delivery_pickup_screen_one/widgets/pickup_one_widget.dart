import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/delivery_pickup_item_model.dart';

class PickupOneWidget extends StatelessWidget{
  PickupOneWidget(this.deliveryPickupModelObj, {super.key});

  DeliveryPickupItemModel deliveryPickupModelObj;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26.h,
      child: Column(
        children: [
          CustomImageView(
            imagePath: deliveryPickupModelObj.icon!,
            height: 24.h,
            width: double.maxFinite,
          ),
          SizedBox(height: 6.h),
          Text(
            deliveryPickupModelObj.iconTitle!,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
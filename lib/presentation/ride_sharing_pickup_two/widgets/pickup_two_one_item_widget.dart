import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/ride_sharing_item_model.dart';

// ignore for file, class must be immutable
class PickupTwoOneItemWidget extends StatelessWidget{
  PickupTwoOneItemWidget(this.rideSharingItemModelObj, {Key? key})
    : super(key: key);

  RideSharingItemModel rideSharingItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
        children: [
          CustomImageView(
            imagePath: rideSharingItemModelObj.icon!,
            height: 24.h,
            width: 24.h,
          ),
          Text(
            rideSharingItemModelObj.title!,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          )
        ],
      );
  }
}
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class PickupTwoOneItemWidget extends StatelessWidget{
  const PickupTwoOneItemWidget({Key? key})
    : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26.h,
      child: Column(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgChat,
            height: 24.h,
            width: double.maxFinite,
          ),
          SizedBox(height: 6.h),
          Text(
            "Chat",
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
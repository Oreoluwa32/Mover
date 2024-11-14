import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class DeliveryTaskOneBottomsheetWidget extends StatelessWidget{
  const DeliveryTaskOneBottomsheetWidget({Key? key})
    : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.h,
      padding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: appTheme.gray20001,
        borderRadius: BorderRadiusStyle.roundedBorder4,
      ),
      child: Text(
        "400",
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: CustomTextStyles.bodySmallBlack900,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/add_route_item_model.dart';

class AddRouteThreeWidget extends StatelessWidget {
  AddRouteThreeWidget(this.addRouteItemModelObj, {super.key});

  AddRouteItemModel addRouteItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.h,
      padding: EdgeInsets.symmetric(
        horizontal: 30.h,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 1),
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(
          color: appTheme.blueGray10002,
          width: 1.h,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: addRouteItemModelObj.tabImage!,
            height: 54.h,
            width: double.maxFinite,
          ),
          Text(
            addRouteItemModelObj.tabTitle!,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium,
          )
        ],
      ),
    );
  }
}

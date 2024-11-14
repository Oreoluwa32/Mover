import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/add_route_one_item_model.dart';

class AddRouteOneItemWidget extends StatelessWidget{
  AddRouteOneItemWidget(this.addRouteOneItemModelObj, {Key? key})
    : super(key: key,);

  AddRouteOneItemModel addRouteOneItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.h,
      padding: EdgeInsets.symmetric(
        horizontal: 30.h,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
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
            imagePath: addRouteOneItemModelObj.meansImage!,
            height: 54.h,
            width: double.maxFinite,
          ),
          Text(
            addRouteOneItemModelObj.meansTitle!,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium,
          )
        ],
      ),
    );
  }
}
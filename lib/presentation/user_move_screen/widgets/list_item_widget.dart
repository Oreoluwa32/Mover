import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/list_item_model.dart';

// ignore for file, class must be immutable
class ListItemWidget extends StatelessWidget{
  ListItemWidget(this.listItemModelObj, {Key? key}) : super(key: key,);

  ListItemModel listItemModelObj;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 254.h,
      child: CustomImageView(
        imagePath: listItemModelObj.image!,
        height: 130.h,
        width: 254.h,
        radius: BorderRadius.circular(8.h),
      ),
    );
  }
}
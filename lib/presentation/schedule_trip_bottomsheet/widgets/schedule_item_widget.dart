import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/schedule_item_model.dart';

// ignore for file, class must be immutable
class ScheduleItemWidget extends StatelessWidget{
  ScheduleItemWidget(this.scheduleItemModelObj, {Key? key}) : super(key: key);

  ScheduleItemModel scheduleItemModelObj;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26.h,
      child: Column(
        children: [
          CustomImageView(
            imagePath: scheduleItemModelObj.icon!,
            height: 26.h,
            width: double.maxFinite,
          ),
          SizedBox(height: 6.h,),
          Text(
            scheduleItemModelObj.title!,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
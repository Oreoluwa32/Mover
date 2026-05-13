import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/task_route_map.dart';
import '../models/scheduled_item_model.dart';

// ignore for file, class must be immutable
class ScheduledItemWidget extends StatelessWidget{
  ScheduledItemWidget(this.scheduledItemModelObj, {Key? key}) : super(key: key);  
  
  ScheduledItemModel scheduledItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 1),
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(
          color: appTheme.blueGray10002,
          width: 1.h
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 118.h,
            width: double.maxFinite,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 118.h,
                  width: 310.h,
                  child: TaskRouteMap(
                    pickupLatitude: scheduledItemModelObj.pickupLatitude ?? 0,
                    pickupLongitude: scheduledItemModelObj.pickupLongitude ?? 0,
                    destinationLatitude:
                        scheduledItemModelObj.destinationLatitude ?? 0,
                    destinationLongitude:
                        scheduledItemModelObj.destinationLongitude ?? 0,
                    overlayIconPath: scheduledItemModelObj.icon,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h,),
          Text(
            scheduledItemModelObj.address!,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 6.h,),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgCalendar,
                  height: 12.h,
                  width: 12.h,
                  alignment: Alignment.topCenter,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.h),
                  child: Text(
                    scheduledItemModelObj.date!,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgClock,
                  height: 12.h,
                  width: 12.h,
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(left: 8.h),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.h),
                  child: Text(
                    scheduledItemModelObj.time!,
                    style: theme.textTheme.bodySmall
                  ),
                ),
                Spacer(),
                Text(
                  scheduledItemModelObj.status!,
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          ),
          SizedBox(height: 12.h,),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgProfile,
                  height: 50.h,
                  width: 50.h,
                  radius: BorderRadius.circular(24.h),
                ),
                SizedBox(width: 16.h,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scheduledItemModelObj.moverName!,
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        scheduledItemModelObj.rating!,
                        style: CustomTextStyles.bodySmallBluegray40012,
                      )
                    ],
                  ),
                ),
                SizedBox(width: 16.h,),
                Text(
                  scheduledItemModelObj.price!,
                  style: theme.textTheme.labelLarge,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

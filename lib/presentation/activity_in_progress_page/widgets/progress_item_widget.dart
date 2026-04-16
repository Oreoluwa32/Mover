import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/task_route_map.dart';
import '../models/progress_item_model.dart';

// ignore for file, msut be immutable
class ProgressItemWidget extends StatelessWidget{
  ProgressItemWidget(this.progressItemModelObj, {Key? key})
    : super(key: key,);

  ProgressItemModel progressItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
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
                    pickupLatitude: progressItemModelObj.pickupLatitude ?? 0,
                    pickupLongitude: progressItemModelObj.pickupLongitude ?? 0,
                    destinationLatitude:
                        progressItemModelObj.destinationLatitude ?? 0,
                    destinationLongitude:
                        progressItemModelObj.destinationLongitude ?? 0,
                    overlayIconPath: progressItemModelObj.icon,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h,),
          Text(
            progressItemModelObj.address!,
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
                    progressItemModelObj.date!,
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
                    progressItemModelObj.time!,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                Spacer(),
                Text(
                  progressItemModelObj.status!,
                  style: CustomTextStyles.bodySmallOrange300,
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
                        progressItemModelObj.moverName!,
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        progressItemModelObj.rating!,
                        style: CustomTextStyles.bodySmallBluegray40012,
                      )
                    ],
                  ),
                ),
                SizedBox(width: 16.h,),
                Text(
                  progressItemModelObj.price!,
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

import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/saved_route_model.dart';

class SavedrouteItemWidget extends StatelessWidget {
  SavedrouteItemWidget(this.savedrouteItemModelObj, {Key? key})
      : super(
          key: key,
        );

  SavedRouteModel savedrouteItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(color: appTheme.gray20001, width: 1.h),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  savedrouteItemModelObj.routetitle!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: appTheme.gray800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  savedrouteItemModelObj.address!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.gray600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgClock,
                      height: 16.h,
                      width: 16.h,
                      color: appTheme.gray600,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.h),
                      child: Text(
                        savedrouteItemModelObj.time!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: appTheme.gray600,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.h),
                    CustomImageView(
                      imagePath: ImageConstant.imgCalendar,
                      height: 16.h,
                      width: 16.h,
                      color: appTheme.gray600,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.h),
                      child: Text(
                        savedrouteItemModelObj.days!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: appTheme.gray600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgChevronRightBlack,
            height: 20.h,
            width: 20.h,
            margin: EdgeInsets.only(left: 8.h),
          ),
        ],
      ),
    );
  }
}

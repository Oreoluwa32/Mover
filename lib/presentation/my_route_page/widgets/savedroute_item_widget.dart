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
        border: Border.all(
          color: appTheme.gray20001,
          width: 1.h
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  savedrouteItemModelObj.routetitle!,
                  style: CustomTextStyles.labelLargeGray800,
                ),
                Spacer(),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 6.h,
                    width: 6.h,
                    margin: EdgeInsets.only(top: 4.h),
                    decoration: BoxDecoration(
                      color: appTheme.redA700,
                      borderRadius: BorderRadius.circular(
                        3.h,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.h),
                  child: Text(
                    savedrouteItemModelObj.islive!,
                    style: CustomTextStyles.labelMediumInterRedA700,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 6.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          savedrouteItemModelObj.address!,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.bodySmallInterGray60010,
                        ),
                        SizedBox(height: 6.h),
                        SizedBox(
                          width: double.maxFinite,
                          child: Row(
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgClock,
                                height: 12.h,
                                width: 12.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.h),
                                child: Text(
                                  savedrouteItemModelObj.time!,
                                  style: CustomTextStyles.bodySmallInterGray60010,
                                ),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgCalendar,
                                height: 12.h,
                                width: 12.h,
                                margin: EdgeInsets.only(left: 10.h),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.h),
                                child: Text(
                                  savedrouteItemModelObj.days!,
                                  style: CustomTextStyles.bodySmallInterGray60010,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgChevronRight,
                  height: 16.h,
                  width: 16.h,
                  margin: EdgeInsets.only(top: 8.h),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

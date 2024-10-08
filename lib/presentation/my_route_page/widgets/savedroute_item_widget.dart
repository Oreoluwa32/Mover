import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class SavedrouteItemWidget extends StatelessWidget{
  const SavedrouteItemWidget({Key? key})
    : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 12.h,
      ),
      decoration: AppDecoration.black100.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
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
                  "Work Route",
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
                      borderRadius: BorderRadius.circular(3.h,),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.h),
                  child: Text(
                    "Live",
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
                          "Gateway Zone, Magodo Phase II, GRA Lagos State",
                          style: CustomTextStyles.bodySmall110,
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
                                  "7:30PM",
                                  style: CustomTextStyles.bodySmall110,
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
                                  "Mon - Fri",
                                  style: CustomTextStyles.bodySmall110,
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
                  imagePath: ImageConstant.imgRightArrow,
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
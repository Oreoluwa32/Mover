import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/movers_item_model.dart';

// ignore for file, class must be immutable
class MoversItemWidget extends StatelessWidget {
  MoversItemWidget(this.moversItemModelObj, {Key? key}) : super(key: key);

  MoversItemModel moversItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(color: appTheme.gray20001, width: 1.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgProfile,
            height: 50.h,
            width: 50.h,
            radius: BorderRadius.circular(24.h),
            margin: EdgeInsets.only(top: 2.h),
          ),
          SizedBox(
            width: 16.h,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      moversItemModelObj.name!,
                      style: theme.textTheme.titleSmall?.copyWith(color: Colors.black87),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Text(
                            moversItemModelObj.time!,
                            style: CustomTextStyles.bodySmallInterGray600,
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 2.h,
                              width: 2.h,
                              margin: EdgeInsets.only(
                                left: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: appTheme.gray700,
                                borderRadius: BorderRadius.circular(1.h),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.h),
                            child: Text(
                              moversItemModelObj.distance!,
                              style: CustomTextStyles.bodySmallInterGray600,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgBlackCar,
                            height: 12.h,
                            width: 12.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.h),
                            child: Text(
                              moversItemModelObj.vehicle!,
                              style: CustomTextStyles.bodySmallInterGray600,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 2.h,
                              width: 2.h,
                              margin: EdgeInsets.only(
                                left: 4.h,
                                top: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: appTheme.gray700,
                                borderRadius: BorderRadius.circular(1.h),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.h),
                            child: Text(
                              moversItemModelObj.plateNum!,
                              style: CustomTextStyles.bodySmallInterGray600,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgUsers,
                            height: 12.h,
                            width: 12.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.h),
                            child: Text(
                              moversItemModelObj.seats!,
                              style: CustomTextStyles.bodySmallInterGray600,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 16.h,
          ),
          SizedBox(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                moversItemModelObj.price!,
                style: theme.textTheme.titleSmall?.copyWith(color: Colors.black87),
              ),
            ),
          )
        ],
      ),
    );
  }
}

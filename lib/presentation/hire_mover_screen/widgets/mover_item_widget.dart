import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_rating_bar.dart';
import '../models/mover_item_model.dart';

// ignore for file, class must be immutable
class MoverItemWidget extends StatelessWidget{
  MoverItemWidget(this.moverItemModelObj, {Key? key}) : super(key: key);

  MoverItemModel moverItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(
          color: appTheme.gray20001,
          width: 1.h,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: moverItemModelObj.profileImage!,
            height: 50.h,
            width: 50.h,
            radius: BorderRadius.circular(24.h),
            alignment: Alignment.topCenter,
          ),
          SizedBox(width: 16.h,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Text(
                        moverItemModelObj.moverName!,
                        style: theme.textTheme.titleSmall,
                      ),
                      Container(
                        height: 16.h,
                        width: 16.h,
                        margin: EdgeInsets.only(left: 8.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusStyle.roundedBorder4,
                          border: Border.all(
                            color: appTheme.purple900,
                            width: 0.67.h,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment(0.5, -0.04),
                            end: Alignment(0.5, 0.25),
                            colors: [
                              theme.colorScheme.onPrimary.withOpacity(1),
                              theme.colorScheme.primary
                            ],
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomImageView(
                              imagePath: moverItemModelObj.homeAway!,
                              height: 10.h,
                              width: 10.h,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Text(
                        moverItemModelObj.distance!,
                        style: CustomTextStyles.bodySmallInterGray600,
                      ),
                      Container(
                        height: 2.h,
                        width: 2.h,
                        margin: EdgeInsets.only(left: 4.h),
                        decoration: BoxDecoration(
                          color: appTheme.gray700,
                          borderRadius: BorderRadius.circular(1.h),
                        ),
                      ),
                      CustomImageView(
                        imagePath: moverItemModelObj.vehicleType!,
                        height: 16.h,
                        width: 16.h,
                        margin: EdgeInsets.only(left: 4.h),
                      )
                    ],
                  ),
                ),
                CustomRatingBar(
                  ignoreGestures: true,
                  initialRating: 5,
                )
              ],
            ),
          ),
          SizedBox(width: 16.h),
          Text(
            moverItemModelObj.price!,
            style: theme.textTheme.titleSmall,
          )
        ],
      ),
    );
  }
}
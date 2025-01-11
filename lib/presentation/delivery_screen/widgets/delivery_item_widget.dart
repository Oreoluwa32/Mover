import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_rating_bar.dart';
import '../models/delivery_item_model.dart';

// ignore for file, class must be immutable
class DeliveryItemWidget extends StatelessWidget {
  DeliveryItemWidget(this.deliveryItemModelObj, {Key? key}) : super(key: key);

  DeliveryItemModel deliveryItemModelObj;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgProfile,
                  height: 40.h,
                  width: 40.h,
                ),
                SizedBox(
                  width: 8.h,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deliveryItemModelObj.name!,
                        style: CustomTextStyles.titleSmallInterBlack900,
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            CustomRatingBar(
                              ignoreGestures: true,
                              initialRating: 5,
                              itemSize: 12,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                deliveryItemModelObj.star!,
                                style: CustomTextStyles.bodySmallInterBlack900,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 8.h,
                ),
                Text(
                  deliveryItemModelObj.time!,
                  style: CustomTextStyles.bodySmallInterBlack900,
                )
              ],
            ),
          ),
          SizedBox(
            height: 14.h,
          ),
          Text(
            deliveryItemModelObj.review!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style:
                CustomTextStyles.bodySmallInterBlack900.copyWith(height: 1.50),
          )
        ],
      ),
    );
  }
}

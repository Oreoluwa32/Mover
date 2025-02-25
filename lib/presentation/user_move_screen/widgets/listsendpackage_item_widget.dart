import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listsendpackage_item_model.dart';

// ignore for file, must be immutable
class ListsendpackageItemWidget extends StatelessWidget{
  ListsendpackageItemWidget(this.listsendpackageItemModelObj, {Key? key, this.onTapSendPackage}) : super(key: key);

  ListsendpackageItemModel listsendpackageItemModelObj;

  VoidCallback? onTapSendPackage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapSendPackage?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusStyle.roundedBorder8,
          border: Border.all(
            color: appTheme.gray20001,
            width: 1.h,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 166.h,
              margin: EdgeInsets.only(left: 14.h),
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Text(
                          listsendpackageItemModelObj.title!,
                          style: CustomTextStyles.labelLargePurple900,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgPurpleRightArrow,
                          height: 14.h,
                          width: 14.h,
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(left: 8.h),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    listsendpackageItemModelObj.description!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.bodySmallBlack90010.copyWith(height: 1.60),
                  )
                ],
              ),
            ),
            CustomImageView(
              imagePath: listsendpackageItemModelObj.titleImg!,
              height: 110.h,
              width: 112.h,
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';
import '../models/month_trans_item_model.dart';

// ignore for file, class must be immutable
class MonthTransItemWidget extends StatelessWidget{
  MonthTransItemWidget(this.monthTransItemModelObj, {Key? key})
    : super(
      key: key,
    );

  MonthTransItemModel monthTransItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 8.h
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            height: 40.h,
            width: 40.h,
            padding: EdgeInsets.all(10.h),
            decoration: IconButtonStyleHelper.fillGray,
            child: CustomImageView(
              imagePath: ImageConstant.imgPackageBlack,
            ),
          ),
          Expanded(
            child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 108.h,
                    child: Text(
                      monthTransItemModelObj.transStatus!,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.labelLargeMedium,
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Text(
                          monthTransItemModelObj.transDate!,
                          style: CustomTextStyles.bodySmall110,
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 2.h,
                            width: 2.h,
                            margin: EdgeInsets.only(
                              left: 4.h,
                              top: 6.h
                            ),
                            decoration: BoxDecoration(
                              color: appTheme.gray80001,
                              borderRadius: BorderRadius.circular(1.h),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4.h),
                          child: Text(
                            monthTransItemModelObj.transTime!,
                            style: CustomTextStyles.bodySmall110,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  monthTransItemModelObj.amount!,
                  style: CustomTextStyles.labelLargeMedium,
                ),
                Text(
                  monthTransItemModelObj.status!,
                  style: CustomTextStyles.bodySmallLightGreen900,
                )
              ],
          )
        ],
      ),
    );
  }
}
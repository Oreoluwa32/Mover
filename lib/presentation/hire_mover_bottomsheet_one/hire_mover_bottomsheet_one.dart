import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'notifier/hire_mover_one_notifier.dart';

class HireMoverBottomsheetOne extends ConsumerStatefulWidget {
  const HireMoverBottomsheetOne({Key? key}) : super(key: key);

  @override
  HireMoverBottomsheetOneState createState() => HireMoverBottomsheetOneState();
}

class HireMoverBottomsheetOneState
    extends ConsumerState<HireMoverBottomsheetOne> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(left: 16.h, top: 16.h, right: 16.h),
      decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withOpacity(1),
          borderRadius: BorderRadiusStyle.customBorderTL24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50.h,
            child: Divider(),
          ),
          SizedBox(
            height: 14.h,
          ),
          Text(
            "Waiting for mover to respond",
            style: CustomTextStyles.titleMediumBlack900,
          ),
          SizedBox(
            height: 18.h,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Divider(
              color: appTheme.blueGray10001,
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgProfile,
                  height: 76.h,
                  width: 76.h,
                  radius: BorderRadius.circular(38.h),
                  alignment: Alignment.topCenter,
                ),
                SizedBox(
                  width: 12.h,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "John Doe",
                        style: theme.textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Text(
                              "2km away",
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
                              imagePath: ImageConstant.imgCar,
                              height: 16.h,
                              width: 16.h,
                              margin: EdgeInsets.only(left: 4.h),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "Completed jobs",
                        style: CustomTextStyles.labelMediumGray80001,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "No ratings or reviews",
                        style: CustomTextStyles.labelLargeBluegray400,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 12.h,
                ),
                Text(
                  "₦1700",
                  style: theme.textTheme.titleSmall,
                )
              ],
            ),
          ),
          SizedBox(
            height: 36.h,
          )
        ],
      ),
    );
  }
}

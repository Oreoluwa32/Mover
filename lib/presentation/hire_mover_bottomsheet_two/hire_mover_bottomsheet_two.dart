import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import 'notifier/hire_mover_two_notifier.dart';

class HireMoverBottomsheetTwo extends ConsumerStatefulWidget {
  const HireMoverBottomsheetTwo({Key? key}) : super(key: key);

  @override
  HireMoverBottomsheetTwoState createState() => HireMoverBottomsheetTwoState();
}

class HireMoverBottomsheetTwoState
    extends ConsumerState<HireMoverBottomsheetTwo> {
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
            height: 24.h,
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            child: Column(
              children: [
                CustomIconButton(
                  height: 56.h,
                  width: 56.h,
                  padding: EdgeInsets.all(14.h),
                  decoration: IconButtonStyleHelper.outlineRed,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgRedAlert,
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                Text(
                  "Request Denied",
                  style: CustomTextStyles.titleMediumGray80001,
                ),
                SizedBox(
                  height: 14.h,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text:
                            "Your delivery request has been denied by the mover due to the inclusion of an illegal item. To maintain the safety and compliance of our services, please review our ",
                        style: theme.textTheme.bodySmall),
                    TextSpan(
                      text: "policy ",
                      style: CustomTextStyles.bodySmallPrimary
                          .copyWith(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                        text:
                            "and ensure that all items adhere to our guidelines.",
                        style: theme.textTheme.bodySmall),
                  ]),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          CustomElevatedButton(
            text: "Close",
          ),
          SizedBox(
            height: 8.h,
          )
        ],
      ),
    );
  }
}

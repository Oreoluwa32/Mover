import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'notifier/route_setting_notifier.dart'; // ignore for file: class must be immutable

class AddRouteThreeBottomsheet extends ConsumerStatefulWidget {
  const AddRouteThreeBottomsheet({Key? key})
      : super(
          key: key,
        );

  @override
  AddRouteThreeBottomsheetState createState() =>
      AddRouteThreeBottomsheetState();
}

class AddRouteThreeBottomsheetState
    extends ConsumerState<AddRouteThreeBottomsheet> {
  double _distance = 1;
  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    final routeSettingNot = ref.watch(routeSettingNotifier.notifier);

    return Material(
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(
          left: 16.h,
          top: 16.h,
          right: 16.h,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 1),
          borderRadius: BorderRadiusStyle.roundedBorder24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 50.h,
              child: Divider(),
            ),
            SizedBox(height: 16.h),
            Text(
              "Route Settings",
              style: CustomTextStyles.titleMediumBlack900,
            ),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Distance",
                          style: CustomTextStyles.titleSmallBlack900,
                        ),
                        Text(
                          "${_distance.toStringAsFixed(1)}km",
                          style: CustomTextStyles.titleSmallBlack900,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(horizontal: 6.h),
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackShape: RoundedRectSliderTrackShape(),
                        inactiveTrackColor: appTheme.gray400,
                        thumbColor: theme.colorScheme.onPrimary.withValues(alpha: 1),
                        thumbShape: const RoundSliderThumbShape(),
                      ),
                      child: Slider(
                        value: _value,
                        min: 0.0,
                        max: 100.0,
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                            _distance = 1.0 + (value / 100) * 9;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 48.h),
            SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  CustomElevatedButton(
                    text: "Save",
                    onPressed: () {
                      routeSettingNot.setDistance(_distance);
                      NavigatorService.goBack();
                    },
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      onTapBack(context);
                    },
                    child: Text(
                      "Cancel",
                      style: CustomTextStyles.titleSmallErrorContainerMedium,
                  ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.h)
          ],
        ),
      ),
    );
  }

  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }
}

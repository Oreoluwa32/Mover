import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_radio_button.dart';
import 'notifier/search_mover_notifier.dart';

class SearchMoverBottomsheet extends ConsumerStatefulWidget{
  const SearchMoverBottomsheet({Key? key}) : super(key: key);

  @override
  SearchMoverBottomsheetState createState() => SearchMoverBottomsheetState();
}

class SearchMoverBottomsheetState extends ConsumerState<SearchMoverBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(
        left: 16.h,
        top: 16.h,
        right: 16.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        borderRadius: BorderRadiusStyle.customBorderTL24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50.h,
            child: Divider(),
          ),
          SizedBox(height: 14.h),
          Text(
            "Searching for mover",
            style: CustomTextStyles.titleMediumBlack900,
          ),
          SizedBox(height: 18.h),
          SizedBox(
            width: double.maxFinite,
            child: Divider(
              color: appTheme.blueGray10001,
            ),
          ),
          SizedBox(height: 24.h),
          _buildSeenMovers(context),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.maxFinite,
            child: Divider(
              color: appTheme.gray20001,
            ),
          ),
          SizedBox(height: 22.h),
          _buildLocation(context),
          SizedBox(height: 24.h),
          CustomElevatedButton(
            text: "View Prices",
            buttonStyle: CustomButtonStyles.none,
          ),
          SizedBox(height: 24.h),
          Text(
            "Cancel request",
            style: CustomTextStyles.titleSmallRedA700Medium,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildSeenMovers(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          Container(
            width: 50.h,
            height: 50.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(1),
              borderRadius: BorderRadiusStyle.roundedBorder24,
              border: Border.all(
                color: appTheme.gray400,
                width: 1.h,
              ),
            ),
            child: Text(
              "0",
              textAlign: TextAlign.center,
              style: CustomTextStyles.titleMediumGray80001,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 8.h,
                bottom: 12.h,
              ),
              child: Text(
                "Movers have seen your request",
                style: CustomTextStyles.titleSmallBlack900,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildLocation(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Consumer(
        builder: (context, ref, _) {
          return Column(
            children: [
              CustomRadioButton(
                text: "",
                value: "",
                groupValue: ref.watch(searchMoverNotifier).radioGroup,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.h,
                  vertical: 14.h,
                ),
                isExpandedText: true,
                overflow: TextOverflow.ellipsis,
                decoration: RadioStyleHelper.fillOnPrimary,
                onChange: (value) {
                  ref.read(searchMoverNotifier.notifier).changeRadioButton(value);
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: CustomRadioButton(
                  text: "",
                  value: "",
                  groupValue: ref.watch(searchMoverNotifier).radioGroup,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.h,
                    vertical: 14.h,
                  ),
                  isExpandedText: true,
                  overflow: TextOverflow.ellipsis,
                  decoration: RadioStyleHelper.fillOnPrimary,
                  onChange: (value) {
                    ref.read(searchMoverNotifier.notifier).changeRadioButton(value);
                  }
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
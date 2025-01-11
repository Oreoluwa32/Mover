import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_radio_button.dart';
import 'models/ride_sharing_details_model.dart';
import 'notifier/ride_sharing_details_notifier.dart';

class RideSharingDetailsScreen extends ConsumerStatefulWidget {
  const RideSharingDetailsScreen({Key? key}) : super(key: key);

  @override
  RideSharingDetailsScreenState createState() =>
      RideSharingDetailsScreenState();
}

class RideSharingDetailsScreenState
    extends ConsumerState<RideSharingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _buildAppbar(context),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                left: 16.h,
                top: 24.h,
                right: 16.h,
              ),
              child: Column(
                children: [
                  _buildLocation(context),
                  SizedBox(
                    height: 22.h,
                  ),
                  _buildPassengers(context),
                  SizedBox(
                    height: 4.h,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: _buildButtonnav(context),
    ));
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 90.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgLeftArrow1,
        margin: EdgeInsets.only(left: 16.h, top: 44.h, bottom: 22.h),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Share a ride",
        margin: EdgeInsets.only(top: 45.h, bottom: 20.h),
      ),
      styleType: Style.bgOutline,
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
                text: "Dominion University",
                value: "Dominion Unniversity",
                groupValue: ref.watch(rideSharingDetailsNotifier).radioGroup,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.h,
                  vertical: 14.h,
                ),
                isExpandedText: true,
                overflow: TextOverflow.ellipsis,
                decoration: RadioStyleHelper.fillOnPrimary,
                onChange: (value) {
                  ref
                      .read(rideSharingDetailsNotifier.notifier)
                      .changeRadioButton(value);
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: CustomRadioButton(
                  text: "Peace Estate, Elebu, Ibadan",
                  value: "Peace Estate, Elebu, Ibadan",
                  groupValue: ref.watch(rideSharingDetailsNotifier).radioGroup,
                  padding: EdgeInsets.fromLTRB(12.h, 14.h, 30.h, 14.h),
                  textStyle: CustomTextStyles.bodySmallGray400,
                  onChange: (value) {
                    ref
                        .read(rideSharingDetailsNotifier.notifier)
                        .changeRadioButton(value);
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  // Section Widget
  Widget _buildPassengers(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Number of passenger",
            style: CustomTextStyles.labelLargeGray600,
          ),
          SizedBox(
            height: 4.h,
          ),
          Consumer(builder: (context, ref, _) {
            return CustomDropDown(
              icon: Container(
                margin: EdgeInsets.only(left: 16.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgBlueGrayDownArrow,
                  height: 16.h,
                  width: 20.h,
                  fit: BoxFit.contain,
                ),
              ),
              iconSize: 16.h,
              hintText: "Select number of passenger",
              items: ref
                      .watch(rideSharingDetailsNotifier)
                      .rideSharingDetailsModelObj
                      ?.dropdownItemList
                      .map((item) => item.title)
                      .toList() ??
                  [],
              prefix: Container(
                margin: EdgeInsets.fromLTRB(14.h, 14.h, 12.h, 14.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgOneUser,
                  height: 16.h,
                  width: 16.h,
                  fit: BoxFit.contain,
                ),
              ),
              prefixConstraints: BoxConstraints(maxHeight: 46.h),
              contentPadding: EdgeInsets.all(14.h),
            );
          })
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildButtonnav(BuildContext context) {
    return Container(
      height: 98.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 24.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border(
          top: BorderSide(color: appTheme.gray20001, width: 1.h),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [CustomElevatedButton(text: "Find Mover")],
      ),
    );
  }

  // Navigates back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }
}

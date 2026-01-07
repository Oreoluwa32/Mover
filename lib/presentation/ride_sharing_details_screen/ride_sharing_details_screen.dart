import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_search_view.dart';
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
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: _buildAppbar(context),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                left: 16.h,
                // top: 12.h,
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
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 90.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeft,
        margin: EdgeInsets.only(left: 16.h, top: 24.h, bottom: 42.h),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Share a ride",
        margin: EdgeInsets.only(top: 25.h, bottom: 45.h),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildLocation(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 14.h,
            ),
            decoration: BoxDecoration(
              color: appTheme.gray10001,
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: Row(
              children: [
                Container(
                  height: 12.h,
                  width: 12.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.h),
                Expanded(
                  child: Text(
                    "Gateway Zone, Magodo Phase II, GRA Lagos St...",
                    style: CustomTextStyles.bodySmallGray800,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 22.h),
          Consumer(
            builder: (context, ref, _) {
              return CustomSearchView(
                hintText: "Destination",
                borderDecoration: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.h),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.h,
                  vertical: 14.h,
                ),
                onChanged: (value) {
                  ref
                      .read(rideSharingDetailsNotifier.notifier)
                      .updateDestination(value);
                },
              );
            },
          ),
        ],
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
        vertical: 22.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 1),
        border: Border(
          top: BorderSide(color: appTheme.gray20001, width: 1.h),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [CustomElevatedButton(text: "Find Mover", onPressed: () {NavigatorService.pushNamed(AppRoutes.searchMoverBottomsheet);})],
      ),
    );
  }

  // Navigates back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }
}

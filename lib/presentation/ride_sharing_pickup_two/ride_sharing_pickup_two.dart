import 'package:flutter/material.dart';
import 'package:new_project/presentation/delivery_pickup_screen_two/notifier/pickup_notifier.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../theme/custom_button_style.dart';
import 'models/ride_sharing_item_model.dart';
import 'notifier/ride_sharing_pickup_notifier.dart';
import 'widgets/pickup_two_one_item_widget.dart'; //ignore for file, must be immutable

class RideSharingPickupTwo extends ConsumerStatefulWidget {
  const RideSharingPickupTwo({Key? key}) : super(key: key);

  @override
  RideSharingPickupTwoState createState() => RideSharingPickupTwoState();
}

class RideSharingPickupTwoState extends ConsumerState<RideSharingPickupTwo>{
 
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.maxFinite,
        decoration: AppDecoration.shadowx1.copyWith(
          borderRadius: BorderRadiusStyle.customBorderTL24
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            SizedBox(height: 52.h, child: Divider()),
            SizedBox(height: 16.h),
            Text(
              "Trip in progress",
              style: CustomTextStyles.titleMediumGray80001,
            ),
            SizedBox(height: 18.h),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(
                left: 24.h,
                right: 38.h,
              ),
              height: 114.h,
              child: Consumer(
                builder: (context, ref, _) {
                  return Timeline.tileBuilder(
                    shrinkWrap: true,
                    theme: TimelineThemeData(
                      nodePosition: 0.5,
                      indicatorPosition: 0,
                    ),
                    builder: TimelineTileBuilder.connected(
                      connectionDirection: ConnectionDirection.before,
                      itemCount: ref.watch(rideSharingPickupNotifier).rideSharingPickupModelObj?.rideSharingItemList.length ?? 0,
                      connectorBuilder: (context, index, type) {
                        return SolidLineConnector();
                      }
                    ),
                  );
                }
              ),
            ),
            SizedBox(height: 18.h),
            _buildUserDetails(context),
            SizedBox(height: 46.h),
            _buildActions(context),
            SizedBox(height: 54.h),
            _buildButtonnav(context)
          ],
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildUserDetails(BuildContext context){
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgProfile,
                  height: 50.h,
                  width: 50.h,
                  radius: BorderRadius.circular(24.h,),
                ),
                SizedBox(width: 16.h),
                Expanded(
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "John Doe",
                        style: CustomTextStyles.bodyMediumMulishGray800,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Text(
                              "10m away",
                              style: CustomTextStyles.bodySmallInterGray600,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 2.h,
                                width: 2.h,
                                margin: EdgeInsets.only(
                                  left: 4.h,
                                  top: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: appTheme.gray700,
                                  borderRadius: BorderRadius.circular(1.h,),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                "2mins",
                                style: CustomTextStyles.bodySmallInterGray600,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgUsers,
                              height: 12.h,
                              width: 12.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                "3 passenger capacity",
                                style: CustomTextStyles.bodySmallInterGray600,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                )
              ],
            ),
          );
  }

  // Section Widget
  Widget _buildActions(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 48.h, right: 42.h),
      width: double.maxFinite,
      child: Consumer(
        builder: (context, ref, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 100.h,
              children: List.generate(
                ref.watch(rideSharingPickupNotifier).rideSharingPickupModelObj?.rideSharingItemList.length ?? 0, 
                (index) {
                  RideSharingItemModel model = ref.watch(rideSharingPickupNotifier).rideSharingPickupModelObj?.rideSharingItemList[index] ?? RideSharingItemModel();
                  return PickupTwoOneItemWidget(model);
                }
              ),
            ),
          );
        }
      ),
    );
  }

  // Section Widget
  Widget _buildButtonnav(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.h, 22.h, 16.h, 24.h),
      decoration: AppDecoration.outlineGray20001,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            text: "End trip",
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/schedule_item_model.dart';
import 'notifier/schedule_trip_notifier.dart';
import 'widgets/schedule_item_widget.dart'; // ignore for file, class must be immutable

class ScheduleTripBottomsheet extends ConsumerStatefulWidget{
  const ScheduleTripBottomsheet({Key? key}) : super(key: key);

  @override
  ScheduleTripBottomsheetState createState() => ScheduleTripBottomsheetState();
}

class ScheduleTripBottomsheetState extends ConsumerState<ScheduleTripBottomsheet>{
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(
              left: 16.h,
              top: 16.h,
              right: 16.h
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(1),
              borderRadius: BorderRadiusStyle.customBorderTL24
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 50.h,
                  child: Divider(),
                ),
                SizedBox(height: 16.h,),
                Text(
                  "Trip Scheduled",
                  style: CustomTextStyles.titleMediumGray80001,
                ),
                SizedBox(height: 16.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      _buildLocation(context),
                      SizedBox(height: 10.h,),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.symmetric(horizontal: 10.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgCalendar,
                              height: 12.h,
                              width: 12.h,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(left: 4.h),
                                child: Text(
                                  "13 Dec",
                                  style: theme.textTheme.bodySmall!.copyWith(color: appTheme.black900),
                                ),
                              ),
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgClock,
                              height: 12.h,
                              width: 12.h,
                              margin: EdgeInsets.only(left: 8.h),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(left: 4.h),
                                child: Text(
                                  "13:50",
                                  style: theme.textTheme.bodySmall!.copyWith(color: appTheme.black900),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      _buildMover(context),
                      SizedBox(height: 24.h,),
                      _buildScheduleTrip(context),
                      SizedBox(height: 34.h,),
                      _buildDeliveryDetails(context),
                      SizedBox(height: 36.h,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment",
                          style: CustomTextStyles.titleSmallMedium,
                        ),
                      ),
                      SizedBox(height: 12.h,),
                      SizedBox(
                        width: double.maxFinite,
                        child: _buildDetails(
                          context,
                          title: "Mode of payment",
                          value: "Wallet"
                        ),
                      ),
                      SizedBox(height: 12.h,),
                      SizedBox(
                        width: double.maxFinite,
                        child: _buildDetails(
                          context,
                          title: "Transportation",
                          value: "Car"
                        ),
                      ),
                      SizedBox(height: 12.h,),
                      SizedBox(
                        width: double.maxFinite,
                        child: _buildDetails(
                          context,
                          title: "Trip fare",
                          value: "₦550",
                        ),
                      ),
                      SizedBox(height: 12.h,),
                      SizedBox(
                        width: double.maxFinite,
                        child: _buildDetails(
                          context,
                          title: "Service fee",
                          value: "₦550"
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 48.h,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildLocation(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 8.h,
        right: 12.h
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: _buildLocationDetails(
              context,
              title: "Pickup Location",
              value: "Muritala Mohammed"
            ),
          ),
          SizedBox(height: 10.h,),
          SizedBox(
            width: double.maxFinite,
            child: _buildLocationDetails(
              context,
              title: "Destination",
              value: "Gateway Zone",
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildMover(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(
          color: appTheme.gray20001,
          width: 1.h,
        ),
      ),
      width: double.maxFinite,
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgProfile,
            height: 50.h,
            width: 50.h,
            radius: BorderRadius.circular(
              24.h
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "John Doe",
                              style: theme.textTheme.titleSmall!.copyWith(color: appTheme.gray800),
                            ),
                          ),
                          Container(
                            height: 2.h,
                            width: 2.h,
                            margin: EdgeInsets.only(
                              left: 4.h,
                              top: 10.h
                            ),
                            decoration: BoxDecoration(
                              color: appTheme.gray700,
                              borderRadius: BorderRadius.circular(
                                1.h
                              ),
                            ),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgBlackCar,
                            height: 16.h,
                            width: 16.h,
                            margin: EdgeInsets.only(left: 4.h, top: 2.h),
                          )
                        ],
                      ),
                    ),
                    Text(
                      "No ratings or reviews",
                      style: CustomTextStyles.labelLargeBluegray400,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildScheduleTrip(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 32.h,
        right: 26.h
      ),
      width: double.maxFinite,
      child: Consumer(
        builder: (context, ref, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 100.h,
              children: List.generate(
                ref.watch(scheduleTripNotifier).scheduleTripModelObj?.scheduleItemList.length ?? 0, 
                (index) {
                  ScheduleItemModel model = ref.watch(scheduleTripNotifier).scheduleTripModelObj?.scheduleItemList[index] ?? ScheduleItemModel();
                  return ScheduleItemWidget(
                    model
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // Section Widget
  Widget _buildDeliveryDetails(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Delivery Details",
            style: CustomTextStyles.labelLargeBlack900,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgChevronRightBlack,
            height: 16.h,
            width: 16.h,
          )
        ],
      ),
    );
  }

  // Common Widget
  Widget _buildDetails(BuildContext context, {required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall!.copyWith(color: appTheme.black900),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall!.copyWith(color: appTheme.black900),
        )
      ],
    );
  }

  // Common Widget
  Widget _buildLocationDetails(BuildContext context, {required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CustomTextStyles.labelLargeBold.copyWith(color: appTheme.gray80001),
                ),
                SizedBox(height: 6.h,),
                Text(
                  value,
                  style: CustomTextStyles.bodySmallGray800.copyWith(color: appTheme.gray800),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
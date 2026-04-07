import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import 'models/schedule_item_model.dart';
import 'notifier/schedule_trip_notifier.dart';
import 'widgets/schedule_item_widget.dart';

class ScheduleTripBottomsheet extends ConsumerStatefulWidget {
  const ScheduleTripBottomsheet({Key? key}) : super(key: key);

  @override
  ScheduleTripBottomsheetState createState() => ScheduleTripBottomsheetState();
}

class ScheduleTripBottomsheetState
    extends ConsumerState<ScheduleTripBottomsheet> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final pickupLocation =
        args['pickupLocation']?.toString() ?? 'Pickup location';
    final destinationLocation =
        args['destinationLocation']?.toString() ?? 'Destination';
    final date = args['date']?.toString() ?? 'TBD';
    final time = args['time']?.toString() ?? '--:--';
    final moverName = args['moverName']?.toString() ?? 'Finding a mover';
    final rating = args['rating']?.toString() ?? 'Waiting for match confirmation';
    final price = args['price']?.toString() ?? 'Pending';
    final requestType = args['requestType']?.toString() ?? 'delivery';
    final status = args['status']?.toString() ?? 'Scheduled';

    return Material(
      child: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 16.h, top: 16.h, right: 16.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(1),
              borderRadius: BorderRadiusStyle.customBorderTL24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 50.h, child: const Divider()),
                SizedBox(height: 16.h),
                Text(
                  status == 'Matched' ? "Mover Matched" : "Trip Scheduled",
                  style: CustomTextStyles.titleMediumGray80001,
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      _buildLocation(
                        context,
                        pickupLocation: pickupLocation,
                        destinationLocation: destinationLocation,
                      ),
                      SizedBox(height: 10.h),
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
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                date,
                                style: theme.textTheme.bodySmall!
                                    .copyWith(color: appTheme.black900),
                              ),
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgClock,
                              height: 12.h,
                              width: 12.h,
                              margin: EdgeInsets.only(left: 8.h),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                time,
                                style: theme.textTheme.bodySmall!
                                    .copyWith(color: appTheme.black900),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildMover(
                        context,
                        moverName: moverName,
                        rating: rating,
                        requestType: requestType,
                      ),
                      SizedBox(height: 24.h),
                      _buildScheduleTrip(context),
                      SizedBox(height: 34.h),
                      _buildDeliveryDetails(context, requestType: requestType),
                      SizedBox(height: 36.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Request Summary",
                          style: CustomTextStyles.titleSmallMedium,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: _buildDetails(
                          context,
                          title: "Status",
                          value: status,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: _buildDetails(
                          context,
                          title: "Transportation",
                          value: requestType == 'ride' ? "Ride sharing" : "Delivery",
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: _buildDetails(
                          context,
                          title: "Estimated price",
                          value: price,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: _buildDetails(
                          context,
                          title: "Payment",
                          value: "Pending payment setup",
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 48.h)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocation(
    BuildContext context, {
    required String pickupLocation,
    required String destinationLocation,
  }) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 8.h, right: 12.h),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: _buildLocationDetails(
              context,
              title: "Pickup Location",
              value: pickupLocation,
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.maxFinite,
            child: _buildLocationDetails(
              context,
              title: "Destination",
              value: destinationLocation,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMover(
    BuildContext context, {
    required String moverName,
    required String rating,
    required String requestType,
  }) {
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
            radius: BorderRadius.circular(24.h),
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moverName,
                        style: theme.textTheme.titleSmall!
                            .copyWith(color: appTheme.gray800),
                      ),
                      Container(
                        height: 2.h,
                        width: 2.h,
                        margin: EdgeInsets.only(left: 4.h, top: 10.h),
                        decoration: BoxDecoration(
                          color: appTheme.gray700,
                          borderRadius: BorderRadius.circular(1.h),
                        ),
                      ),
                      CustomImageView(
                        imagePath: requestType == 'ride'
                            ? ImageConstant.imgBlackCar
                            : ImageConstant.imgPackageBlack,
                        height: 16.h,
                        width: 16.h,
                        margin: EdgeInsets.only(left: 4.h, top: 2.h),
                      )
                    ],
                  ),
                  Text(
                    rating,
                    style: CustomTextStyles.labelLargeBluegray400,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildScheduleTrip(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 32.h, right: 26.h),
      width: double.maxFinite,
      child: Consumer(
        builder: (context, ref, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 100.h,
              children: List.generate(
                ref.watch(scheduleTripNotifier).scheduleTripModelObj?.scheduleItemList.length ??
                    0,
                (index) {
                  ScheduleItemModel model = ref
                          .watch(scheduleTripNotifier)
                          .scheduleTripModelObj
                          ?.scheduleItemList[index] ??
                      ScheduleItemModel();
                  return ScheduleItemWidget(model);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeliveryDetails(BuildContext context, {required String requestType}) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            requestType == 'ride' ? "Ride Details" : "Delivery Details",
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

  Widget _buildDetails(
    BuildContext context, {
    required String title,
    required String value,
  }) {
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

  Widget _buildLocationDetails(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: CustomTextStyles.labelLargeBold
                    .copyWith(color: appTheme.gray80001),
              ),
              SizedBox(height: 6.h),
              Text(
                value,
                style: CustomTextStyles.bodySmallGray800
                    .copyWith(color: appTheme.gray800),
              )
            ],
          ),
        )
      ],
    );
  }
}

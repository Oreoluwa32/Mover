import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/task_route_map.dart';

class CompletedBottomsheet extends ConsumerStatefulWidget {
  const CompletedBottomsheet({Key? key}) : super(key: key);

  @override
  CompletedBottomsheetState createState() => CompletedBottomsheetState();
}

class CompletedBottomsheetState extends ConsumerState<CompletedBottomsheet> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final requestType = args['requestType']?.toString() ?? 'delivery';
    final pickupLocation =
        args['pickupLocation']?.toString() ?? 'Pickup Location';
    final destinationLocation =
        args['destinationLocation']?.toString() ?? 'Destination';
    final date = args['date']?.toString() ?? 'TBD';
    final time = args['time']?.toString() ?? '--:--';
    final moverName = args['moverName']?.toString() ?? 'Assigned mover';
    final rating = args['rating']?.toString() ?? 'No ratings or reviews';
    final requestData = Map<String, dynamic>.from(
      args['requestData'] as Map? ?? const <String, dynamic>{},
    );
    final match = Map<String, dynamic>.from(
      requestData['_match'] as Map? ?? const <String, dynamic>{},
    );
    final paymentMode = args['paymentMode']?.toString() ?? 'Wallet';
    final transportation = _resolveTransportationLabel(
      requestType: requestType,
      requestData: requestData,
      match: match,
    );
    final tripFare = _resolvePrice(args['price'], match['agreed_price']);
    final serviceFee = _resolvePrice(
      requestData['service_fee'],
      requestData['platform_fee'],
    );
    final total = tripFare + serviceFee;
    final pickupLatitude = _safeDouble(
      args['pickupLatitude'] ??
          requestData['pickup_latitude'] ??
          requestData['origin_latitude'],
    );
    final pickupLongitude = _safeDouble(
      args['pickupLongitude'] ??
          requestData['pickup_longitude'] ??
          requestData['origin_longitude'],
    );
    final destinationLatitude = _safeDouble(
      args['destinationLatitude'] ??
          requestData['dropoff_latitude'] ??
          requestData['destination_latitude'],
    );
    final destinationLongitude = _safeDouble(
      args['destinationLongitude'] ??
          requestData['dropoff_longitude'] ??
          requestData['destination_longitude'],
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: Stack(
        children: [
          Positioned.fill(
            child: TaskRouteMap(
              pickupLatitude: pickupLatitude,
              pickupLongitude: pickupLongitude,
              destinationLatitude: destinationLatitude,
              destinationLongitude: destinationLongitude,
              routeColor: const Color(0xFF2F2F2F),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFloatingCircleButton(
                    iconPath: ImageConstant.imgChevronLeftBlack,
                    onTap: NavigatorService.goBack,
                  ),
                  _buildFloatingCircleButton(
                    iconPath: requestType == 'ride'
                        ? ImageConstant.imgBlackCar
                        : ImageConstant.imgPackageBlack,
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.5,
            maxChildSize: 0.75,
            snap: true,
            snapSizes: const [0.5, 0.75],
            builder: (context, scrollController) {
              return Container(
                width: double.maxFinite,
                padding: EdgeInsets.fromLTRB(16.h, 12.h, 16.h, 24.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.h),
                    topRight: Radius.circular(28.h),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20.h,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Container(
                        width: 52.h,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: appTheme.gray300,
                          borderRadius: BorderRadius.circular(12.h),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Trip Completed',
                        style: CustomTextStyles.titleMediumGray80001,
                      ),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            scrollbars: false,
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRouteTimeline(
                                  pickupLocation: pickupLocation,
                                  destinationLocation: destinationLocation,
                                ),
                                SizedBox(height: 18.h),
                                _buildDateTimeRow(date: date, time: time),
                                SizedBox(height: 22.h),
                                _buildMoverCard(
                                  moverName: moverName,
                                  rating: rating,
                                  requestType: requestType,
                                  onTap: () => _openRatingFlow(
                                    context,
                                    requestType: requestType,
                                    moverName: moverName,
                                    requestData: requestData,
                                  ),
                                ),
                                SizedBox(height: 28.h),
                                _buildDetailsLink(
                                  label: requestType == 'ride'
                                      ? 'Ride Details'
                                      : 'Delivery Details',
                                  onTap: requestType == 'ride'
                                      ? null
                                      : () {
                                          NavigatorService.pushNamed(
                                            AppRoutes.deliveryPickupScreenTwo,
                                            arguments: {
                                              'requestData': requestData,
                                            },
                                          );
                                        },
                                ),
                                SizedBox(height: 28.h),
                                Text(
                                  'Payment',
                                  style: CustomTextStyles.titleSmallMedium.copyWith(
                                    color: appTheme.gray80001,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                _buildPaymentRow(
                                  title: 'Mode of payment',
                                  value: paymentMode,
                                ),
                                SizedBox(height: 12.h),
                                _buildPaymentRow(
                                  title: 'Transportation',
                                  value: transportation,
                                ),
                                SizedBox(height: 12.h),
                                _buildPaymentRow(
                                  title: 'Trip fare',
                                  value: _formatCurrency(tripFare),
                                ),
                                SizedBox(height: 12.h),
                                _buildPaymentRow(
                                  title: 'Service fee',
                                  value: _formatCurrency(serviceFee),
                                ),
                                SizedBox(height: 16.h),
                                Divider(color: appTheme.gray20001, height: 0.1.h),
                                SizedBox(height: 16.h),
                                _buildPaymentRow(
                                  title: 'Total',
                                  value: _formatCurrency(total),
                                  isTotal: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCircleButton({
    required String iconPath,
    VoidCallback? onTap,
  }) {
    return CustomIconButton(
      height: 48.h,
      width: 48.h,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14.h,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      onTap: onTap,
      child: CustomImageView(imagePath: iconPath),
    );
  }

  Widget _buildRouteTimeline({
    required String pickupLocation,
    required String destinationLocation,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: SizedBox(
            width: 18.h,
            height: 90.h,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 8.h,
                  bottom: 10.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (_) => Container(
                        width: 4.h,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: appTheme.gray300,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    width: 18.h,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2.h,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 8.h,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 18.h,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pickup Location',
                style: CustomTextStyles.labelLargeBold.copyWith(
                  color: appTheme.gray80001,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                pickupLocation,
                style: CustomTextStyles.bodySmallGray800.copyWith(
                  color: appTheme.gray800,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Destination',
                style: CustomTextStyles.labelLargeBold.copyWith(
                  color: appTheme.gray80001,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                destinationLocation,
                style: CustomTextStyles.bodySmallGray800.copyWith(
                  color: appTheme.gray800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeRow({
    required String date,
    required String time,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 30.h),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgCalendar,
            height: 14.h,
            width: 14.h,
          ),
          SizedBox(width: 6.h),
          Text(
            date,
            style: theme.textTheme.bodySmall!.copyWith(
              color: appTheme.black900,
            ),
          ),
          SizedBox(width: 14.h),
          CustomImageView(
            imagePath: ImageConstant.imgClock,
            height: 14.h,
            width: 14.h,
          ),
          SizedBox(width: 6.h),
          Text(
            time,
            style: theme.textTheme.bodySmall!.copyWith(
              color: appTheme.black900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoverCard({
    required String moverName,
    required String rating,
    required String requestType,
    VoidCallback? onTap,
  }) {
    final trimmedName = moverName.trim();
    final badge = trimmedName.isNotEmpty
        ? trimmedName.substring(0, 1).toUpperCase()
        : 'A';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(
            color: appTheme.gray20001,
            width: 1.h,
          ),
        ),
        child: Row(
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgProfile,
              height: 52.h,
              width: 52.h,
              radius: BorderRadius.circular(26.h),
            ),
            SizedBox(width: 14.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          moverName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: appTheme.gray800,
                          ),
                        ),
                      ),
                      Container(
                        width: 18.h,
                        height: 18.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                        child: Text(
                          badge,
                          style: CustomTextStyles.labelMediumOnPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        '2km away',
                        style: CustomTextStyles.bodySmallInterGray600,
                      ),
                      SizedBox(width: 6.h),
                      CustomImageView(
                        imagePath: requestType == 'ride'
                            ? ImageConstant.imgBlackCar
                            : ImageConstant.imgPackageBlack,
                        height: 16.h,
                        width: 16.h,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    rating,
                    style: CustomTextStyles.labelLargeBluegray400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsLink({
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: CustomTextStyles.labelLargeBlack900.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgChevronRightBlack,
            height: 16.h,
            width: 16.h,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow({
    required String title,
    required String value,
    bool isTotal = false,
  }) {
    final style = isTotal
        ? CustomTextStyles.titleSmallMedium.copyWith(color: appTheme.black900)
        : theme.textTheme.bodySmall!.copyWith(color: appTheme.black900);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(
          value,
          textAlign: TextAlign.right,
          style: style,
        ),
      ],
    );
  }

  String _resolveTransportationLabel({
    required String requestType,
    required Map<String, dynamic> requestData,
    required Map<String, dynamic> match,
  }) {
    final rawTravelPlan = match['travel_plan'] ??
        requestData['_travel_plan'] ??
        const <String, dynamic>{};
    final travelPlan = Map<String, dynamic>.from(rawTravelPlan as Map);
    final vehicleType = travelPlan['vehicle_type']?.toString();
    if (vehicleType != null && vehicleType.isNotEmpty) {
      return _titleCase(vehicleType);
    }
    return requestType == 'ride' ? 'Car' : 'Delivery';
  }

  String _titleCase(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value
        .split(RegExp(r'[_\s]+'))
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  double _resolvePrice(dynamic primary, dynamic fallback) {
    final primaryValue = _safeDouble(primary);
    if (primaryValue > 0) {
      return primaryValue;
    }
    return _safeDouble(fallback);
  }

  double _safeDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _formatCurrency(double value) {
    final normalized = value % 1 == 0
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
    return '₦ $normalized';
  }

  void _openRatingFlow(
    BuildContext context, {
    required String requestType,
    required String moverName,
    required Map<String, dynamic> requestData,
  }) {
    final matchId = requestData['_match_id']?.toString() ??
        (requestData['_match'] as Map?)?['id']?.toString() ??
        '';
    Navigator.of(context).pushNamed(
      AppRoutes.deliveryRatingScreenOne,
      arguments: {
        'matchId': matchId,
        'moverName': moverName,
        'requestType': requestType,
      },
    );
  }
}

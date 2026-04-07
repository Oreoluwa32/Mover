import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/app_export.dart';
import '../../data/services/mobility_api_service.dart';
import '../../data/services/mobility_realtime_service.dart';
import 'user_delivery_pin_tab.dart';
import 'user_delivery_qr_tab.dart';

class UserDeliveryBottomsheetOne extends ConsumerStatefulWidget {
  const UserDeliveryBottomsheetOne({super.key});

  @override
  UserDeliveryBottomsheetOneState createState() =>
      UserDeliveryBottomsheetOneState();
}

class UserDeliveryBottomsheetOneState
    extends ConsumerState<UserDeliveryBottomsheetOne>
    with TickerProviderStateMixin {
  final MobilityApiService _mobilityApiService = MobilityApiService();
  final MobilityRealtimeService _mobilityRealtimeService =
      MobilityRealtimeService();
  late TabController tabviewController;
  StreamSubscription<Map<String, dynamic>>? _trackingSubscription;
  int tabIndex = 0;
  String? _connectedTravelPlanId;
  String _trackingStateLabel = 'Waiting';
  String _trackingMessage = 'Tracking will appear when the mover goes live.';
  String? _trackingUpdatedAt;
  bool _isLoadingTracking = false;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final travelPlanId = args['travelPlanId']?.toString() ?? '';
    if (travelPlanId != _connectedTravelPlanId) {
      unawaited(_initializeTracking(travelPlanId));
    }
  }

  @override
  void dispose() {
    _trackingSubscription?.cancel();
    unawaited(_mobilityRealtimeService.dispose());
    tabviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final requestId = args['requestId']?.toString() ?? 'movr-request';
    final requestType = args['requestType']?.toString() ?? 'delivery';
    final moverName = args['moverName']?.toString() ?? 'Assigned mover';
    final rating = args['rating']?.toString() ?? 'No ratings or reviews';
    final status = args['status']?.toString() ?? 'In progress';
    final pickupLocation = args['pickupLocation']?.toString() ?? 'Pickup';
    final destinationLocation =
        args['destinationLocation']?.toString() ?? 'Destination';
    final travelPlanId = args['travelPlanId']?.toString() ?? '';
    final pinCode = _buildPinFromRequestId(requestId);

    return Material(
      child: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(1),
              borderRadius: BorderRadiusStyle.customBorderTL24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                _buildColumn(
                  context,
                  requestId: requestId,
                  moverName: moverName,
                  rating: rating,
                  requestType: requestType,
                  status: status,
                  pickupLocation: pickupLocation,
                  destinationLocation: destinationLocation,
                  travelPlanId: travelPlanId,
                ),
                _buildTabbar(
                  context,
                  requestId: requestId,
                  pinCode: pinCode,
                ),
                SizedBox(height: 40.h),
                GestureDetector(
                  onTap: () {
                    NavigatorService.pushNamed(AppRoutes.rideCancelScreenOne);
                  },
                  child: Text(
                    "Cancel Request",
                    style: CustomTextStyles.titleSmallRedA700,
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(
    BuildContext context, {
    required String requestId,
    required String moverName,
    required String rating,
    required String requestType,
    required String status,
    required String pickupLocation,
    required String destinationLocation,
    required String travelPlanId,
  }) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          SizedBox(width: 50.h, child: const Divider()),
          SizedBox(height: 14.h),
          Text(
            status == 'In progress'
                ? "Mover is handling your request"
                : "Mover update",
            style: CustomTextStyles.titleMediumGray80001,
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.roundedBorder8,
              border: Border.all(color: appTheme.gray20001, width: 1.h),
            ),
            width: double.maxFinite,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgProfile,
                  height: 50.h,
                  width: 50.h,
                  radius: BorderRadius.circular(24.h),
                  margin: EdgeInsets.only(top: 4.h),
                ),
                SizedBox(width: 16.h),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              moverName,
                              style: theme.textTheme.titleSmall
                                  ?.copyWith(color: Colors.black87),
                            ),
                            Padding(padding: EdgeInsets.only(right: 8.h)),
                            CustomImageView(
                              imagePath: ImageConstant.imgAway,
                              height: 16.h,
                              width: 16.h,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              requestType == 'ride'
                                  ? "Ride request active"
                                  : "Delivery in progress",
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
                              imagePath: requestType == 'ride'
                                  ? ImageConstant.imgBlackCar
                                  : ImageConstant.imgPackageBlack,
                              height: 16.h,
                              width: 16.h,
                              margin: EdgeInsets.only(left: 4.h),
                            )
                          ],
                        ),
                        SizedBox(height: 4.h),
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
          ),
          SizedBox(height: 24.h),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.roundedBorder8,
              border: Border.all(color: appTheme.gray20001, width: 1.h),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Route",
                  style: CustomTextStyles.labelLargeBold,
                ),
                SizedBox(height: 8.h),
                Text(
                  pickupLocation,
                  style: theme.textTheme.bodySmall,
                ),
                SizedBox(height: 6.h),
                Text(
                  destinationLocation,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _buildTrackingCard(
            context,
            travelPlanId: travelPlanId,
          ),
          SizedBox(height: 28.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionIcon(context, ImageConstant.imgChatSquare, "Chat"),
              Expanded(
                child: _buildActionIcon(
                  context,
                  ImageConstant.imgPhoneCall,
                  "Call",
                ),
              ),
              _buildActionIcon(
                context,
                ImageConstant.imgAlert,
                "Report",
                onTap: () => _reportIssue(
                  requestId: requestId,
                  requestType: requestType,
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          SizedBox(
            width: double.maxFinite,
            child: TabBar(
              controller: tabviewController,
              labelPadding: EdgeInsets.zero,
              labelColor: appTheme.gray80001,
              labelStyle: TextStyle(
                fontSize: 14.fSize,
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelColor: appTheme.blueGray400,
              unselectedLabelStyle: TextStyle(
                fontSize: 14.fSize,
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                _buildTab(title: "QR Code", isSelected: tabIndex == 0),
                _buildTab(title: "Pin Code", isSelected: tabIndex == 1),
              ],
              indicatorColor: Colors.white,
              onTap: (index) {
                tabIndex = index;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingCard(
    BuildContext context, {
    required String travelPlanId,
  }) {
    final isLive = _trackingStateLabel == 'Live';
    final isSos = _trackingStateLabel == 'SOS';
    final chipColor = isSos
        ? const Color(0xFFE53935)
        : (isLive ? appTheme.lightGreen500 : appTheme.deepPurple50);
    final chipTextColor =
        (isLive || isSos) ? Colors.white : appTheme.deepPurple600;

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(color: appTheme.gray20001, width: 1.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Live Tracking",
                style: CustomTextStyles.labelLargeBold,
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.h),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadiusStyle.roundedBorder8,
                ),
                child: Text(
                  _isLoadingTracking ? 'Connecting' : _trackingStateLabel,
                  style: CustomTextStyles.labelLargeOnPrimary.copyWith(
                    color: chipTextColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            _trackingMessage,
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 8.h),
          Text(
            travelPlanId.isEmpty
                ? 'Tracking becomes available after a mover is matched.'
                : 'Route ID: $travelPlanId',
            style: CustomTextStyles.bodySmallInterGray600,
          ),
          if (_trackingUpdatedAt != null && _trackingUpdatedAt!.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              'Updated $_trackingUpdatedAt',
              style: CustomTextStyles.bodySmallInterGray600,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionIcon(
    BuildContext context,
    String iconPath,
    String label, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CustomImageView(
            imagePath: iconPath,
            height: 24.h,
            width: 24.h,
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          )
        ],
      ),
    );
  }

  Tab _buildTab({required String title, required bool isSelected}) {
    return Tab(
      height: 48,
      child: Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 6.h),
        decoration: isSelected
            ? BoxDecoration(
                color: theme.colorScheme.onPrimary.withOpacity(1),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2.h,
                  ),
                ),
              )
            : BoxDecoration(
                color: theme.colorScheme.onPrimary.withOpacity(1),
              ),
        child: Text(title),
      ),
    );
  }

  Widget _buildTabbar(
    BuildContext context, {
    required String requestId,
    required String pinCode,
  }) {
    return SizedBox(
      height: 338.h,
      child: TabBarView(
        controller: tabviewController,
        children: [
          UserDeliveryQrTab(
            child: QrImageView(
              data: requestId,
              size: 200.h,
              backgroundColor: Colors.white,
            ),
          ),
          UserDeliveryPinTab(pinCode: pinCode),
        ],
      ),
    );
  }

  String _buildPinFromRequestId(String requestId) {
    final digits = requestId.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 6) {
      return digits.substring(0, 6);
    }

    final seed = requestId.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    return (100000 + (seed % 900000)).toString();
  }

  Future<void> _initializeTracking(String travelPlanId) async {
    _connectedTravelPlanId = travelPlanId;
    await _trackingSubscription?.cancel();
    _trackingSubscription = null;
    await _mobilityRealtimeService.disconnect();

    if (travelPlanId.isEmpty) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoadingTracking = false;
        _trackingStateLabel = 'Waiting';
        _trackingMessage = 'Tracking becomes available after a mover is matched.';
        _trackingUpdatedAt = null;
      });
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingTracking = true;
        _trackingStateLabel = 'Connecting';
        _trackingMessage = 'Joining the mover live route...';
      });
    }

    try {
      final sessions = await _mobilityApiService.getTrackingSessions();
      final matchingSession = sessions.cast<Map<String, dynamic>?>().firstWhere(
            (session) => session?['travel_plan']?.toString() == travelPlanId,
            orElse: () => null,
          );

      if (matchingSession != null) {
        final events =
            List<Map<String, dynamic>>.from(matchingSession['events'] as List? ?? const []);
        final latestEvent = events.isNotEmpty ? events.last : null;
        if (mounted) {
          setState(() {
            _trackingStateLabel = _buildTrackingStateLabel(
              sessionStatus: matchingSession['status']?.toString(),
              latestEvent: latestEvent,
            );
            _trackingMessage = _buildTrackingMessage(latestEvent);
            _trackingUpdatedAt = _formatTrackingTimestamp(
              latestEvent?['created_at']?.toString() ??
                  matchingSession['updated_at']?.toString(),
            );
          });
        }
      } else if (mounted) {
        setState(() {
          _trackingStateLabel = 'Waiting';
          _trackingMessage = 'The mover has not started live tracking for this route yet.';
          _trackingUpdatedAt = null;
        });
      }

      await _mobilityRealtimeService.connect(travelPlanId);
      _trackingSubscription = _mobilityRealtimeService.events.listen((event) {
        if (!mounted) {
          return;
        }
        setState(() {
          _trackingStateLabel = _buildTrackingStateLabel(latestEvent: event);
          _trackingMessage = _buildTrackingMessage(event);
          _trackingUpdatedAt =
              _formatTrackingTimestamp(event['created_at']?.toString());
        });
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _trackingStateLabel = 'Offline';
        _trackingMessage = 'Unable to connect to live tracking right now.';
      });
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoadingTracking = false;
      });
    }
  }

  String _buildTrackingStateLabel({
    String? sessionStatus,
    Map<String, dynamic>? latestEvent,
  }) {
    final eventType = latestEvent?['event_type']?.toString();
    if (eventType == 'sos') {
      return 'SOS';
    }
    if (eventType == 'location' || sessionStatus == 'live') {
      return 'Live';
    }
    if (eventType == 'status') {
      return 'Status';
    }
    return 'Waiting';
  }

  String _buildTrackingMessage(Map<String, dynamic>? event) {
    if (event == null) {
      return 'The mover has not shared a live update yet.';
    }

    final eventType = event['event_type']?.toString();
    final note = event['note']?.toString();
    if (eventType == 'location') {
      final latitude = event['latitude']?.toString();
      final longitude = event['longitude']?.toString();
      if (latitude != null && longitude != null) {
        return 'Latest live location: $latitude, $longitude';
      }
      return 'The mover shared a live location update.';
    }
    if (eventType == 'sos') {
      return note?.isNotEmpty == true
          ? note!
          : 'An emergency alert was raised on this route.';
    }
    if (note != null && note.isNotEmpty) {
      return note;
    }
    return 'The mover shared a trip update.';
  }

  String? _formatTrackingTimestamp(String? value) {
    final parsed = DateTime.tryParse(value ?? '');
    if (parsed == null) {
      return null;
    }

    final local = parsed.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final suffix = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }

  Future<void> _reportIssue({
    String? requestId,
    required String requestType,
  }) async {
    try {
      await _mobilityApiService.createEmergencyAlert(
        message:
            'User reported an issue from the active $requestType request screen. Request ID: ${requestId ?? 'unknown'}.',
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Issue reported to the Movr team.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      final message = _mobilityApiService.extractErrorMessage(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}

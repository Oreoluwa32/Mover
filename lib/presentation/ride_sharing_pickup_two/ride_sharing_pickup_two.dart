import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../core/utils/task_interaction_helper.dart';
import '../../data/services/mobility_api_service.dart';
import '../home_one_screen/notifier/home_notifier.dart';
import '../../widgets/custom_elevated_button.dart';

class RideSharingPickupTwo extends ConsumerStatefulWidget {
  const RideSharingPickupTwo({Key? key}) : super(key: key);

  @override
  RideSharingPickupTwoState createState() => RideSharingPickupTwoState();
}

class RideSharingPickupTwoState extends ConsumerState<RideSharingPickupTwo> {
  final MobilityApiService _mobilityApiService = MobilityApiService();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final requestData = Map<String, dynamic>.from(
      args['requestData'] as Map? ?? const <String, dynamic>{},
    );
    final requester =
        Map<String, dynamic>.from(requestData['requester'] as Map? ?? const {});
    final match =
        Map<String, dynamic>.from(requestData['_match'] as Map? ?? const {});
    final requesterName =
        requester['full_name']?.toString() ?? 'Passenger';
    final origin = requestData['origin_name']?.toString() ?? 'Pickup';
    final destination =
        requestData['destination_name']?.toString() ?? 'Destination';
    final seatsRequested = requestData['seats_requested']?.toString() ?? '1';
    final matchId = requestData['_match_id']?.toString() ?? '';
    final priceLabel =
        'NGN ${(match['agreed_price'] ?? 0).toString()}';

    return Material(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.82,
        snap: true,
        snapSizes: const [0.5, 0.75],
        builder: (context, scrollController) {
          return Container(
            width: double.maxFinite,
            decoration: AppDecoration.shadowx1.copyWith(
              borderRadius: BorderRadiusStyle.customBorderTL24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                SizedBox(width: 50.h, child: const Divider()),
                SizedBox(height: 16.h),
                Text(
                  'Trip in progress',
                  style: CustomTextStyles.titleMediumGray80001,
                ),
                SizedBox(height: 18.h),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      scrollbars: false,
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.symmetric(horizontal: 24.h),
                            padding: EdgeInsets.all(14.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder8,
                              border: Border.all(
                                color: appTheme.gray20001,
                                width: 1.h,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 10.h,
                                      height: 10.h,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      width: 2.h,
                                      height: 38.h,
                                      color: appTheme.gray300,
                                    ),
                                    Container(
                                      width: 10.h,
                                      height: 10.h,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.onPrimary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: theme.colorScheme.primary,
                                          width: 1.5.h,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 12.h),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pickup Location',
                                        style: CustomTextStyles.labelLargeBold,
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        origin,
                                        style: CustomTextStyles.bodySmallGray800,
                                      ),
                                      SizedBox(height: 22.h),
                                      Text(
                                        'Destination',
                                        style: CustomTextStyles.labelLargeBold,
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        destination,
                                        style: CustomTextStyles.bodySmallGray800,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 18.h),
                          Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.symmetric(horizontal: 16.h),
                            padding: EdgeInsets.all(14.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder8,
                              border: Border.all(
                                color: appTheme.gray20001,
                                width: 1.h,
                              ),
                            ),
                            child: Row(
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgProfile,
                                  height: 50.h,
                                  width: 50.h,
                                  radius: BorderRadius.circular(24.h),
                                ),
                                SizedBox(width: 16.h),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        requesterName,
                                        style: CustomTextStyles.bodyMediumMulishGray800,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '$seatsRequested passenger on board',
                                        style: CustomTextStyles.bodySmallInterGray600,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  priceLabel,
                                  style: CustomTextStyles.bodySmallBlack900,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 28.h),
                          _buildActionsRow(
                            requestData: requestData,
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.fromLTRB(16.h, 22.h, 16.h, 24.h),
                  decoration: AppDecoration.outlineGray20001,
                  child: CustomElevatedButton(
                    text: _isSubmitting ? 'Ending...' : 'End trip',
                    onPressed: _isSubmitting
                        ? null
                        : () => _endTrip(context, matchId: matchId),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionsRow({
    required Map<String, dynamic> requestData,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 48.h),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionIcon(
            ImageConstant.imgChat,
            'Chat',
            onTap: () => TaskInteractionHelper.openTaskChat(
              requestData,
              isMoverSide: true,
            ),
          ),
          _buildActionIcon(
            ImageConstant.imgPhoneCall,
            'Call',
            onTap: () => TaskInteractionHelper.callParticipant(
              requestData,
              isMoverSide: true,
            ),
          ),
          _buildActionIcon(
            ImageConstant.imgAlert,
            'Report',
            onTap: () => TaskInteractionHelper.openTaskReport(
              requestData,
              isMoverSide: true,
              requestType: 'ride',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(String iconPath, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
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
        ),
      ],
    ),
    );
  }

  Future<void> _endTrip(BuildContext context, {required String matchId}) async {
    if (matchId.isEmpty) {
      Fluttertoast.showToast(msg: 'Trip information is missing.');
      return;
    }
    final homeStateNotifier = ref.read(homeNotifier.notifier);

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _mobilityApiService.endRideTrip(matchId: matchId);
      if (!mounted) {
        return;
      }
      NavigatorService.goBack();
      Future<void>.delayed(
        const Duration(milliseconds: 250),
        () => homeStateNotifier.loadPendingTask(),
      );
      Fluttertoast.showToast(msg: 'Trip completed.');
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
      });
      Fluttertoast.showToast(
        msg: _mobilityApiService.extractErrorMessage(error),
      );
    }
  }
}

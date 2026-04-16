import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../core/utils/task_interaction_helper.dart';
import '../../data/services/mobility_api_service.dart';
import '../home_one_screen/notifier/home_notifier.dart';
import '../../widgets/custom_elevated_button.dart';

class RideSharingPickupOne extends ConsumerStatefulWidget {
  const RideSharingPickupOne({Key? key}) : super(key: key);

  @override
  ConsumerState<RideSharingPickupOne> createState() =>
      _RideSharingPickupOneState();
}

class _RideSharingPickupOneState extends ConsumerState<RideSharingPickupOne> {
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
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(1),
              borderRadius: BorderRadiusStyle.customBorderTL24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                SizedBox(width: 50.h, child: const Divider()),
                SizedBox(height: 14.h),
                Text(
                  'Waiting for passenger',
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
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Column(
                        children: [
                          Container(
                            width: double.maxFinite,
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
                                SizedBox(width: 18.h),
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
                                        '$seatsRequested passenger request',
                                        style: CustomTextStyles.bodySmallInterGray600,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '$origin to $destination',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                          SizedBox(height: 34.h),
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
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary.withOpacity(1),
                    border: Border(
                      top: BorderSide(
                        color: appTheme.gray20001,
                        width: 1.h,
                      ),
                    ),
                  ),
                  child: CustomElevatedButton(
                    text: _isSubmitting ? 'Starting...' : 'Start trip',
                    onPressed: _isSubmitting
                        ? null
                        : () => _startTrip(context, matchId: matchId),
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
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _buildActionIcon(
        ImageConstant.imgChat,
        'Chat',
        onTap: () => TaskInteractionHelper.openTaskChat(
          requestData,
          isMoverSide: true,
        ),
      ),
      Expanded(
        child: _buildActionIcon(
          ImageConstant.imgPhoneCall,
          'Call',
          onTap: () => TaskInteractionHelper.callParticipant(
            requestData,
            isMoverSide: true,
          ),
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

  Future<void> _startTrip(BuildContext context, {required String matchId}) async {
    if (matchId.isEmpty) {
      Fluttertoast.showToast(msg: 'Trip information is missing.');
      return;
    }
    final homeStateNotifier = ref.read(homeNotifier.notifier);

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _mobilityApiService.startRideTrip(matchId: matchId);
      if (!mounted) {
        return;
      }
      NavigatorService.goBack();
      Future<void>.delayed(
        const Duration(milliseconds: 250),
        () => homeStateNotifier.loadPendingTask(),
      );
      Fluttertoast.showToast(msg: 'Trip started.');
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

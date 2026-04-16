import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/task_interaction_helper.dart';
import '../../widgets/custom_elevated_button.dart';

class DeliveryPickupScreenOne extends ConsumerStatefulWidget {
  const DeliveryPickupScreenOne({Key? key}) : super(key: key);

  @override
  DeliveryPickupScreenState createState() => DeliveryPickupScreenState();
}

class DeliveryPickupScreenState extends ConsumerState<DeliveryPickupScreenOne> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final requestData = Map<String, dynamic>.from(
      args['requestData'] as Map? ?? const <String, dynamic>{},
    );
    final taskPhase = args['taskPhase']?.toString() ?? 'accepted';
    final isInTransit = taskPhase == 'active';
    final requester =
        Map<String, dynamic>.from(requestData['requester'] as Map? ?? const {});
    final travelPlan =
        Map<String, dynamic>.from(requestData['_travel_plan'] as Map? ?? const {});
    final match =
        Map<String, dynamic>.from(requestData['_match'] as Map? ?? const {});

    final requesterName =
        requester['full_name']?.toString() ?? 'Movr customer';
    final priceLabel =
        '₦ ${(match['agreed_price'] ?? travelPlan['price_per_seat'] ?? 0).toString()}';
    final requestId = requestData['id']?.toString() ?? '';
    final matchId = requestData['_match_id']?.toString() ?? '';
    final pickupLocation = requestData['pickup_name']?.toString() ?? 'Pickup';
    final destinationLocation =
        requestData['dropoff_name']?.toString() ?? 'Destination';

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
              color: theme.colorScheme.onPrimary.withValues(alpha: 1),
              borderRadius: BorderRadiusStyle.customBorderTL24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                Container(
                  width: 50.h,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: appTheme.gray20001,
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  isInTransit ? 'Delivery in progress' : 'Proceed to pick up item',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: const Color(0xFF3D3D3D),
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      scrollbars: false,
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isInTransit) ...[
                            _buildRouteTimeline(
                              pickupLocation: pickupLocation,
                              destinationLocation: destinationLocation,
                            ),
                            SizedBox(height: 26.h),
                          ],
                          _buildRequesterCard(
                            requesterName: requesterName,
                            priceLabel: priceLabel,
                            requestData: requestData,
                          ),
                          SizedBox(height: 28.h),
                          _buildActionsRow(
                            requestData: requestData,
                          ),
                          SizedBox(height: 24.h),
                          GestureDetector(
                            onTap: () {
                              NavigatorService.pushNamed(
                                AppRoutes.deliveryPickupScreenTwo,
                                arguments: {
                                  'requestData': requestData,
                                  'taskPhase': taskPhase,
                                },
                              );
                            },
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: appTheme.gray20001,
                                    width: 1.h,
                                  ),
                                  bottom: BorderSide(
                                    color: appTheme.gray20001,
                                    width: 1.h,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Delivery Details',
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12.fSize,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                      color: const Color(0xFF262626),
                                    ),
                                  ),
                                  const Spacer(),
                                  CustomImageView(
                                    imagePath: ImageConstant.imgChevronRightBlack,
                                    height: 16.h,
                                    width: 16.h,
                                  ),
                                ],
                              ),
                            ),
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
                    color: theme.colorScheme.onPrimary.withValues(alpha: 1),
                    border: Border(
                      top: BorderSide(
                        color: appTheme.gray20001,
                        width: 1.h,
                      ),
                    ),
                  ),
                  child: CustomElevatedButton(
                    text: isInTransit
                        ? 'Confirm Delivery - Scan'
                        : 'Confirm Pickup - Scan',
                    onPressed: () {
                      NavigatorService.pushNamed(
                        AppRoutes.scanScreen,
                        arguments: {
                          'requestType': 'delivery',
                          'requestData': requestData,
                          'requestId': requestId,
                          'matchId': matchId,
                          'confirmationStage':
                              isInTransit ? 'delivery' : 'pickup',
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequesterCard({
    required String requesterName,
    required String priceLabel,
    required Map<String, dynamic> requestData,
  }) {
    final weight =
        double.tryParse(requestData['weight_kg']?.toString() ?? '') ?? 0;
    final weightLabel = weight >= 8
        ? 'Heavy'
        : weight >= 3
            ? 'Medium'
            : 'Light';

    return Row(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgProfile,
          height: 50.h,
          width: 50.h,
          radius: BorderRadius.circular(25.h),
        ),
        SizedBox(width: 18.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                requesterName,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14.fSize,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    '10m away',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.fSize,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6D6D6D),
                    ),
                  ),
                  Container(
                    width: 2.h,
                    height: 2.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.h),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6D6D6D),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    '2mins',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.fSize,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6D6D6D),
                    ),
                  ),
                  SizedBox(width: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: appTheme.lightGreen500,
                      borderRadius: BorderRadius.circular(50.h),
                    ),
                    child: Text(
                      weightLabel,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.fSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 12.h),
        Text(
          priceLabel,
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 14.fSize,
            fontWeight: FontWeight.w400,
            height: 1.2,
            color: const Color(0xFF3D3D3D),
          ),
        ),
      ],
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
            height: 92.h,
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
                style: CustomTextStyles.labelLargeBold,
              ),
              SizedBox(height: 6.h),
              Text(
                pickupLocation,
                style: CustomTextStyles.bodySmallGray800,
              ),
              SizedBox(height: 28.h),
              Text(
                'Destination',
                style: CustomTextStyles.labelLargeBold,
              ),
              SizedBox(height: 6.h),
              Text(
                destinationLocation,
                style: CustomTextStyles.bodySmallGray800,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsRow({
    required Map<String, dynamic> requestData,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionIcon(
          ImageConstant.imgChatSquare,
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
            requestType: 'delivery',
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
}

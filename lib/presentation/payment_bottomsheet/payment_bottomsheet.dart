import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../data/services/mobility_api_service.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';

class PaymentBottomsheet extends ConsumerStatefulWidget {
  const PaymentBottomsheet({
    Key? key,
    this.offerData,
    this.requestType,
    this.requestData,
  }) : super(key: key);

  final Map<String, dynamic>? offerData;
  final String? requestType;
  final Map<String, dynamic>? requestData;

  @override
  PaymentBottomsheetState createState() => PaymentBottomsheetState();
}

class PaymentBottomsheetState extends ConsumerState<PaymentBottomsheet> {
  final MobilityApiService _mobilityApiService = MobilityApiService();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final offerData = widget.offerData ?? const <String, dynamic>{};
    final travelPlan =
        Map<String, dynamic>.from(offerData['travel_plan'] as Map? ?? const {});
    final createdBy =
        Map<String, dynamic>.from(travelPlan['created_by'] as Map? ?? const {});
    final moverName = createdBy['full_name']?.toString() ?? 'John Doe';
    final amount =
        (offerData['agreed_price'] ?? travelPlan['price_per_seat'] ?? 0)
            .toString();

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
          _buildColumn(context),
          SizedBox(height: 14.h),
          _buildDescription(
            context,
            moverName: moverName,
            amount: amount,
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          SizedBox(
            width: 50.h,
            child: const Divider(),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Make Payment",
                  style: CustomTextStyles.titleMediumGray80001,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgCancel,
                  height: 24.h,
                  width: 24.h,
                  margin: EdgeInsets.only(left: 90.h),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(
    BuildContext context, {
    required String moverName,
    required String amount,
  }) {
    return SizedBox(
      height: 336.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This fee will not be deducted from your wallet. The mover will not receive this payment until the task is been completed and confirmed.",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall!.copyWith(height: 1.50),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(right: 16.h),
                    child: _buildDetails(
                      context,
                      title: "Name of Mover",
                      content: moverName,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(right: 16.h),
                    child: _buildDetails(
                      context,
                      title: "Amount",
                      content: '₦ $amount',
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.maxFinite,
                    child: Divider(
                      color: appTheme.gray20001,
                      endIndent: 16.h,
                      height: 0.h,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    "Payment method",
                    style: theme.textTheme.bodySmall,
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    margin: EdgeInsets.only(right: 16.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: appTheme.gray10001,
                      borderRadius: BorderRadiusStyle.roundedBorder8,
                    ),
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconButton(
                          height: 40.h,
                          width: 40.h,
                          padding: EdgeInsets.all(8.h),
                          decoration: IconButtonStyleHelper.fillLightGreen,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgWallet,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.only(left: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Balance",
                                    style: CustomTextStyles.labelLargeMedium,
                                  ),
                                  Text(
                                    "34,100",
                                    style:
                                        CustomTextStyles.labelLargeBluegray400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomElevatedButton(
                  text: _isSubmitting ? "Processing..." : "Proceed",
                  onPressed: _isSubmitting
                      ? null
                      : () => _proceedWithSelection(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: CustomTextStyles.bodySmallInter12,
        ),
        Text(
          content,
          style: CustomTextStyles.bodySmallInter12,
        ),
      ],
    );
  }

  Future<void> _proceedWithSelection(BuildContext context) async {
    final offerData = widget.offerData ?? const <String, dynamic>{};
    final requestData = widget.requestData ?? const <String, dynamic>{};
    final matchId = offerData['id']?.toString() ?? '';
    final requestType = widget.requestType ?? 'delivery';
    if (matchId.isEmpty) {
      Fluttertoast.showToast(msg: 'Selected mover offer is missing.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final acceptedMatch =
          await _mobilityApiService.acceptMatch(matchId: matchId);
      final mergedRequestData = <String, dynamic>{
        ...requestData,
        '_match_id': acceptedMatch['id']?.toString() ?? matchId,
        '_match': acceptedMatch,
        '_travel_plan': acceptedMatch['travel_plan'] as Map? ??
            offerData['travel_plan'] as Map? ??
            const <String, dynamic>{},
      };
      if (!mounted) {
        return;
      }

      Navigator.pop(context, true);
      NavigatorService.pushNamed(
        AppRoutes.userDeliveryBottomsheetOne,
        arguments: {
          'requestId': requestData['id']?.toString(),
          'requestType': requestType,
          'pickupLocation': requestType == 'ride'
              ? requestData['origin_name']?.toString()
              : requestData['pickup_name']?.toString(),
          'destinationLocation': requestType == 'ride'
              ? requestData['destination_name']?.toString()
              : requestData['dropoff_name']?.toString(),
          'status': 'Scheduled',
          'moverName': acceptedMatch['travel_plan']?['created_by']?['full_name']
                  ?.toString() ??
              createdByName(offerData),
          'rating': requestType == 'ride'
              ? 'Mover selected for your trip'
              : 'Mover selected for your delivery',
          'travelPlanId': acceptedMatch['travel_plan']?['id']?.toString() ??
              offerData['travel_plan']?['id']?.toString() ??
              '',
          'matchId': acceptedMatch['id']?.toString() ?? matchId,
          'requestData': mergedRequestData,
          'matchStatus': acceptedMatch['status']?.toString() ?? 'accepted',
        },
      );
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

  String createdByName(Map<String, dynamic> offerData) {
    final travelPlan =
        Map<String, dynamic>.from(offerData['travel_plan'] as Map? ?? const {});
    final createdBy =
        Map<String, dynamic>.from(travelPlan['created_by'] as Map? ?? const {});
    return createdBy['full_name']?.toString() ?? 'Assigned mover';
  }
}

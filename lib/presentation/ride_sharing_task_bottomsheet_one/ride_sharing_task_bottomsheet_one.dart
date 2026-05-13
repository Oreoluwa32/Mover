import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/app_toast.dart';
import '../../data/services/mobility_api_service.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_radio_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/user_avatar.dart';
import '../home_one_screen/notifier/home_notifier.dart';

class RideSharingTaskBottomsheetOne extends ConsumerStatefulWidget {
  const RideSharingTaskBottomsheetOne({super.key});

  @override
  ConsumerState<RideSharingTaskBottomsheetOne> createState() =>
      _RideSharingTaskBottomsheetOneState();
}

class _RideSharingTaskBottomsheetOneState
    extends ConsumerState<RideSharingTaskBottomsheetOne> {
  final MobilityApiService _mobilityApiService = MobilityApiService();
  final TextEditingController _priceController = TextEditingController();
  String _radioGroup = "";

  @override
  void initState() {
    super.initState();
    _priceController.addListener(_refreshPriceState);
  }

  @override
  void dispose() {
    _priceController.removeListener(_refreshPriceState);
    _priceController.dispose();
    super.dispose();
  }

  void _refreshPriceState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final requestData = Map<String, dynamic>.from(
        args['requestData'] as Map? ?? const <String, dynamic>{});
    final origin = requestData['origin_name']?.toString() ?? 'Pickup';
    final destination =
        requestData['destination_name']?.toString() ?? 'Destination';
    final requesterName =
        requestData['requester']?['full_name']?.toString() ?? 'Movr user';
    final requesterAvatarUrl = _extractRequesterAvatarUrl(requestData);
    final requestId = requestData['id']?.toString() ?? '';
    final seatsRequested = requestData['seats_requested']?.toString() ?? '1';
    final suggestedPrice = _deriveRideSuggestedPrice(requestData);
    final isPriceValid = double.tryParse(_priceController.text.trim()) != null;

    if (_priceController.text.isEmpty) {
      _priceController.text = suggestedPrice;
    }

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: double.maxFinite,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(alpha: 1),
              borderRadius: BorderRadiusStyle.customBorderTL24,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16.h),
                  _buildHeader(context),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Column(
                        children: [
                          _buildExpiresIn(context),
                          SizedBox(height: 14.h),
                          _buildRequester(
                            context,
                            requesterName: requesterName,
                            requesterAvatarUrl: requesterAvatarUrl,
                            seatsRequested: seatsRequested,
                          ),
                          SizedBox(height: 12.h),
                          _buildHintCard(context),
                          SizedBox(height: 16.h),
                          _buildLocation(
                            context,
                            origin: origin,
                            destination: destination,
                          ),
                          SizedBox(height: 14.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Price",
                              style: CustomTextStyles.labelLargeGray600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          CustomTextFormField(
                            controller: _priceController,
                            hintText: "NGN",
                            hintStyle: theme.textTheme.bodySmall,
                            contentPadding:
                                EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                          SizedBox(height: 8.h),
                          _buildPriceChips(context,
                              currentValue: suggestedPrice),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                  _buildButtonnav(
                    context,
                    requestId: requestId,
                    isPriceValid: isPriceValid,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          SizedBox(width: 50.h, child: const Divider()),
          SizedBox(height: 14.h),
          Text(
            "Ride sharing task",
            style: CustomTextStyles.titleMediumGray80001,
          )
        ],
      ),
    );
  }

  Widget _buildExpiresIn(BuildContext context) {
    return CustomElevatedButton(
      height: 30.h,
      width: 136.h,
      text: "Open request",
      buttonStyle: CustomButtonStyles.fillRed,
      buttonTextStyle: CustomTextStyles.bodySmallRedA700,
    );
  }

  Widget _buildRequester(
    BuildContext context, {
    required String requesterName,
    required String? requesterAvatarUrl,
    required String seatsRequested,
  }) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          UserAvatar(
            imagePath: requesterAvatarUrl,
            name: requesterName,
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
                  "$seatsRequested passenger request",
                  style: CustomTextStyles.bodySmallInterGray600,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHintCard(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 14.h),
      decoration: BoxDecoration(
        color: appTheme.deepPurple50,
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Text(
        "Use your current route to offer a ride price for this passenger request.",
        style: CustomTextStyles.bodySmallDeeppurple600,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLocation(
    BuildContext context, {
    required String origin,
    required String destination,
  }) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          CustomRadioButton(
            text: origin,
            value: origin,
            groupValue: _radioGroup,
            padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 14.h),
            decoration: RadioStyleHelper.fillOnPrimary,
            onChange: (value) {
              setState(() {
                _radioGroup = value;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: CustomRadioButton(
              text: destination,
              value: destination,
              groupValue: _radioGroup,
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 14.h),
              decoration: RadioStyleHelper.fillOnPrimary,
              onChange: (value) {
                setState(() {
                  _radioGroup = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPriceChips(BuildContext context,
      {required String currentValue}) {
    final base = double.tryParse(currentValue) ?? 1000;
    final suggestions = <String>[
      base.toStringAsFixed(0),
      (base + 200).toStringAsFixed(0),
      (base + 400).toStringAsFixed(0),
      (base + 600).toStringAsFixed(0),
    ];

    return Wrap(
      spacing: 12.h,
      children: suggestions.map((value) {
        final isSelected = _priceController.text.trim() == value;
        return GestureDetector(
          onTap: () {
            setState(() {
              _priceController.text = value;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.h),
            decoration: BoxDecoration(
              color:
                  isSelected ? theme.colorScheme.primary : appTheme.gray10001,
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Text(
              'NGN $value',
              style: isSelected
                  ? CustomTextStyles.labelLargeOnPrimary
                  : CustomTextStyles.labelLargeGray600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildButtonnav(
    BuildContext context, {
    required String requestId,
    required bool isPriceValid,
  }) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.h, 20.h, 16.h, 22.h),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomElevatedButton(
            text: "Bid Price",
            buttonStyle: CustomButtonStyles.fillPrimaryTL41,
            isDisabled: !isPriceValid,
            onPressed: isPriceValid ? () => _submitBid(requestId) : null,
          ),
          SizedBox(height: 22.h),
          GestureDetector(
            onTap: () {
              NavigatorService.goBack();
            },
            child: Text(
              "Decline",
              style: CustomTextStyles.titleSmallRedA700,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _submitBid(String requestId) async {
    final price = double.tryParse(_priceController.text.trim());
    if (requestId.isEmpty || price == null) {
      AppToast.info('Enter a valid bid price.');
      return;
    }

    try {
      final latestTravelPlan = await _mobilityApiService.getLatestTravelPlan(
        planType: 'ride',
      );
      final travelPlan = await _mobilityApiService.getLatestBiddableTravelPlan(
        planType: 'ride',
      );
      final travelPlanId = travelPlan?['id']?.toString() ?? '';
      if (travelPlanId.isEmpty) {
        AppToast.info(
          latestTravelPlan == null
              ? 'Create or publish a ride route before bidding.'
              : 'Publish your ride route before bidding.',
        );
        return;
      }

      await _mobilityApiService.bidRideRequest(
        requestId: requestId,
        agreedPrice: price,
        travelPlanId: travelPlanId,
      );
      await ref.read(homeNotifier.notifier).loadPendingTask();
      AppToast.success('Bid submitted successfully.');
      if (!mounted) {
        return;
      }
      NavigatorService.goBack();
    } catch (error) {
      AppToast.error(_mobilityApiService.extractErrorMessage(error));
    }
  }

  String _deriveRideSuggestedPrice(Map<String, dynamic> requestData) {
    final seats =
        int.tryParse(requestData['seats_requested']?.toString() ?? '') ?? 1;
    final base = seats * 1200;
    return base.toString();
  }

  String? _extractRequesterAvatarUrl(Map<String, dynamic> requestData) {
    final requester = requestData['requester'];
    if (requester is Map) {
      final requesterMap = Map<String, dynamic>.from(requester);
      final directAvatar = requesterMap['avatar_url']?.toString();
      if (directAvatar != null &&
          directAvatar.isNotEmpty &&
          directAvatar != 'null') {
        return directAvatar;
      }
      final nestedProfile = requesterMap['profile'];
      if (nestedProfile is Map) {
        final nestedAvatar = nestedProfile['avatar_url']?.toString();
        if (nestedAvatar != null &&
            nestedAvatar.isNotEmpty &&
            nestedAvatar != 'null') {
          return nestedAvatar;
        }
      }
    }

    final fallbackKeys = <String>[
      'requester_avatar_url',
      'requester_avatar',
      'avatar_url',
    ];
    for (final key in fallbackKeys) {
      final value = requestData[key]?.toString();
      if (value != null && value.isNotEmpty && value != 'null') {
        return value;
      }
    }
    return null;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/app_toast.dart';
import '../../data/services/mobility_api_service.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/user_avatar.dart';
import '../home_one_screen/notifier/home_notifier.dart';

class DeliveryTaskOneBottomsheet extends ConsumerStatefulWidget {
  const DeliveryTaskOneBottomsheet({super.key});

  @override
  DeliveryTaskBottomsheetState createState() => DeliveryTaskBottomsheetState();
}

class DeliveryTaskBottomsheetState
    extends ConsumerState<DeliveryTaskOneBottomsheet> {
  final MobilityApiService _mobilityApiService = MobilityApiService();
  final TextEditingController _priceController = TextEditingController();
  Timer? _countdownTimer;
  Duration _timeRemaining = const Duration(minutes: 1);

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_timeRemaining.inSeconds <= 1) {
        timer.cancel();
        setState(() {
          _timeRemaining = Duration.zero;
        });
        return;
      }
      setState(() {
        _timeRemaining -= const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final requestData = Map<String, dynamic>.from(
      args['requestData'] as Map? ?? const <String, dynamic>{},
    );
    final pickup = requestData['pickup_name']?.toString() ?? 'Pickup';
    final dropoff = requestData['dropoff_name']?.toString() ?? 'Destination';
    final requesterName =
        requestData['requester']?['full_name']?.toString() ?? 'Movr user';
    final requesterAvatarUrl = _extractRequesterAvatarUrl(requestData);
    final requestId = requestData['id']?.toString() ?? '';
    final description = requestData['package_description']?.toString() ??
        'No description provided.';
    final weightLabel = _mapWeightLabel(requestData['weight_kg']?.toString());
    final isPriceValid = double.tryParse(_priceController.text.trim()) != null;

    if (_priceController.text.isEmpty) {
      _priceController.text = '';
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.h),
            topRight: Radius.circular(24.h),
          ),
        ),
        child: SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                Container(
                  width: 50.h,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D1D1),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.h, 16.h, 16.h, 0),
                  child: Row(
                    children: [
                      const Spacer(),
                      Text(
                        'Delivery task',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16.fSize,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                          color: const Color(0xFF3D3D3D),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: NavigatorService.goBack,
                        child: Icon(
                          Icons.close_rounded,
                          size: 24.h,
                          color: const Color(0xFF3D3D3D),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.h, 28.h, 16.h, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Expires in ${_formatCountdown()}',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14.fSize,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              color: const Color(0xFF3D3D3D),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        _buildRequesterRow(
                          requesterName: requesterName,
                          requesterAvatarUrl: requesterAvatarUrl,
                          weightLabel: weightLabel,
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.h,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE8FF),
                            borderRadius: BorderRadius.circular(8.h),
                          ),
                          child: Text(
                            '1234 movers are heading to the same destination',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12.fSize,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              color: const Color(0xFF6018BF),
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h),
                        _buildLocationCard(
                          title: pickup,
                          isPickup: true,
                        ),
                        SizedBox(height: 16.h),
                        _buildLocationCard(
                          title: dropoff,
                          isPickup: false,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Price',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12.fSize,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            color: const Color(0xFF6D6D6D),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.h),
                            border: Border.all(
                              color: const Color(0xFFB0B0B0),
                              width: 1.h,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 14.h),
                          child: Row(
                            children: [
                              Text(
                                'NGN',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 12.fSize,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2,
                                  color: const Color(0xFF3D3D3D),
                                ),
                              ),
                              SizedBox(width: 8.h),
                              Expanded(
                                child: TextField(
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setState(() {}),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your price',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12.fSize,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                      color: const Color(0xFFB0B0B0),
                                    ),
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 12.fSize,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2,
                                    color: const Color(0xFF262626),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        _buildPriceSuggestions(),
                        SizedBox(height: 34.h),
                        Text(
                          'Item Image',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12.fSize,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            color: const Color(0xFF3D3D3D),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Stack(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgShoes,
                              height: 164.h,
                              width: double.maxFinite,
                              radius: BorderRadius.circular(8.h),
                              fit: BoxFit.cover,
                            ),
                            Container(
                              height: 164.h,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(8.h),
                              ),
                            ),
                            Positioned(
                              left: 12.h,
                              bottom: 12.h,
                              child: Container(
                                width: 24.h,
                                height: 24.h,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.zoom_in_rounded,
                                  size: 16.h,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Item Description',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12.fSize,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            color: const Color(0xFF3D3D3D),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          description,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12.fSize,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: const Color(0xFF414141),
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
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFE7E7E7),
                        width: 1.h,
                      ),
                    ),
                  ),
                  child: CustomElevatedButton(
                    text: 'Bid Price',
                    isDisabled: !isPriceValid,
                    buttonStyle: isPriceValid
                        ? CustomButtonStyles.fillPrimaryTL41
                        : CustomButtonStyles.fillBlueGray,
                    onPressed:
                        isPriceValid ? () => _submitBid(requestId) : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequesterRow({
    required String requesterName,
    required String? requesterAvatarUrl,
    required String weightLabel,
  }) {
    return Row(
      children: [
        UserAvatar(
          imagePath: requesterAvatarUrl,
          name: requesterName,
          height: 50.h,
          width: 50.h,
          radius: BorderRadius.circular(25.h),
        ),
        SizedBox(width: 19.h),
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
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFF78C056),
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
    );
  }

  Widget _buildLocationCard({
    required String title,
    required bool isPickup,
  }) {
    return Container(
      width: double.maxFinite,
      height: 50.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(8.h),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: Row(
        children: [
          Container(
            width: 24.h,
            height: 24.h,
            alignment: Alignment.center,
            child: Container(
              width: 14.h,
              height: 14.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF6A1AD3),
                  width: 2.h,
                ),
                color: isPickup ? const Color(0xFF6A1AD3) : Colors.transparent,
              ),
              child: isPickup
                  ? Center(
                      child: Container(
                        width: 8.h,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEDE8FF),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 12.fSize,
                fontWeight: FontWeight.w400,
                height: 1.2,
                color: const Color(0xFF262626),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSuggestions() {
    const suggestions = <String>['400', '700', '1200', '1500'];
    return Wrap(
      spacing: 12.h,
      runSpacing: 12.h,
      children: suggestions.map((value) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _priceController.text = value;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE7E7E7),
              borderRadius: BorderRadius.circular(4.h),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 12.fSize,
                fontWeight: FontWeight.w400,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
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
        planType: 'delivery',
      );
      final travelPlan = await _mobilityApiService.getLatestBiddableTravelPlan(
        planType: 'delivery',
      );
      final travelPlanId = travelPlan?['id']?.toString() ?? '';
      if (travelPlanId.isEmpty) {
        AppToast.info(
          latestTravelPlan == null
              ? 'Create or publish a delivery route before bidding.'
              : 'Publish your delivery route before bidding.',
        );
        return;
      }

      await _mobilityApiService.bidDeliveryRequest(
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

  String _formatCountdown() {
    final minutes =
        _timeRemaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        _timeRemaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _mapWeightLabel(String? weightKg) {
    final value = double.tryParse(weightKg ?? '') ?? 0;
    if (value >= 8) {
      return 'Heavy';
    }
    if (value >= 3) {
      return 'Medium';
    }
    return 'Light';
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

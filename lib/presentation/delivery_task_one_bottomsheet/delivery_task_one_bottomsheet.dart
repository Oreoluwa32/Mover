import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../data/services/mobility_api_service.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_radio_button.dart';
import '../../widgets/custom_text_form_field.dart';
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
  String _radioGroup = "";

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final requestData =
        Map<String, dynamic>.from(args['requestData'] as Map? ?? const <String, dynamic>{});
    final pickup = requestData['pickup_name']?.toString() ?? 'Pickup';
    final dropoff = requestData['dropoff_name']?.toString() ?? 'Destination';
    final requesterName =
        requestData['requester']?['full_name']?.toString() ?? 'Movr user';
    final requestId = requestData['id']?.toString() ?? '';
    final description =
        requestData['package_description']?.toString() ?? 'No description provided.';
    final suggestedPrice = _deriveDeliverySuggestedPrice(requestData);
    final weightLabel = _mapWeightLabel(requestData['weight_kg']?.toString());

    if (_priceController.text.isEmpty) {
      _priceController.text = suggestedPrice;
    }

    return Material(
      child: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(alpha: 1),
              borderRadius: BorderRadiusStyle.customBorderTL24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                _buildTitle(context),
                SizedBox(height: 30.h),
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Column(
                    children: [
                      Text(
                        "Open request",
                        style: CustomTextStyles.bodyMediumMulishGray800,
                      ),
                      SizedBox(height: 28.h),
                      _buildName(context, requesterName: requesterName, weightLabel: weightLabel),
                      SizedBox(height: 16.h),
                      Container(
                        width: 320.h,
                        padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: appTheme.deepPurple50,
                          borderRadius: BorderRadiusStyle.roundedBorder4,
                        ),
                        child: Text(
                          "Set the amount you want to earn for handling this delivery.",
                          style: CustomTextStyles.bodySmallDeeppurple600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildLocation(context, pickup: pickup, dropoff: dropoff),
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
                        hintStyle: theme.textTheme.bodySmall!,
                        textInputAction: TextInputAction.done,
                        contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
                        textInputType: TextInputType.number,
                      ),
                      SizedBox(height: 8.h),
                      _buildPrices(context, currentValue: suggestedPrice),
                      SizedBox(height: 32.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Item Description",
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        description,
                        style: CustomTextStyles.bodySmallGray800,
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
                _buildButtonnav(context, requestId: requestId),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          SizedBox(width: 50.h, child: const Divider()),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Delivery task",
                style: CustomTextStyles.titleMediumGray80001,
              ),
              CustomImageView(
                imagePath: ImageConstant.imgCancel,
                height: 24.h,
                width: 24.h,
                margin: EdgeInsets.only(left: 98.h),
                onTap: () {
                  NavigatorService.goBack();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildName(
    BuildContext context, {
    required String requesterName,
    required String weightLabel,
  }) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
              padding: EdgeInsets.symmetric(horizontal: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    requesterName,
                    style: CustomTextStyles.bodyMediumMulishGray800,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Requester waiting for a mover",
                    style: CustomTextStyles.bodySmallInterGray600,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 18.h),
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            decoration: BoxDecoration(
              color: appTheme.lightGreen500,
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 1.5.h),
                Text(
                  weightLabel,
                  style: CustomTextStyles.labelMediumInterOnPrimary,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLocation(
    BuildContext context, {
    required String pickup,
    required String dropoff,
  }) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          CustomRadioButton(
            text: pickup,
            value: pickup,
            groupValue: _radioGroup,
            padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 14.h),
            isExpandedText: true,
            overflow: TextOverflow.ellipsis,
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
              text: dropoff,
              value: dropoff,
              groupValue: _radioGroup,
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 14.h),
              isExpandedText: true,
              overflow: TextOverflow.ellipsis,
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

  Widget _buildPrices(BuildContext context, {required String currentValue}) {
    final base = double.tryParse(currentValue) ?? 1000;
    final suggestions = <String>[
      base.toStringAsFixed(0),
      (base + 300).toStringAsFixed(0),
      (base + 600).toStringAsFixed(0),
      (base + 900).toStringAsFixed(0),
    ];

    return SizedBox(
      width: double.maxFinite,
      child: Wrap(
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
                color: isSelected ? theme.colorScheme.primary : appTheme.gray10001,
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
      ),
    );
  }

  Widget _buildButtonnav(BuildContext context, {required String requestId}) {
    return Container(
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
            text: "Bid Price",
            buttonStyle: CustomButtonStyles.fillPrimaryTL41,
            onPressed: () => _submitBid(requestId),
          ),
          SizedBox(height: 22.h),
          GestureDetector(
            onTap: () {
              NavigatorService.goBack();
            },
            child: Text(
              "Decline",
              style: CustomTextStyles.titleSmallRedA700Medium,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _submitBid(String requestId) async {
    final price = double.tryParse(_priceController.text.trim());
    if (requestId.isEmpty || price == null) {
      Fluttertoast.showToast(msg: 'Enter a valid bid price.');
      return;
    }

    try {
      await _mobilityApiService.bidDeliveryRequest(
        requestId: requestId,
        agreedPrice: price,
      );
      await ref.read(homeNotifier.notifier).loadPendingTask();
      Fluttertoast.showToast(msg: 'Bid submitted successfully.');
      if (!mounted) {
        return;
      }
      NavigatorService.goBack();
    } catch (error) {
      Fluttertoast.showToast(
        msg: _mobilityApiService.extractErrorMessage(error),
      );
    }
  }

  String _deriveDeliverySuggestedPrice(Map<String, dynamic> requestData) {
    final insuredValue =
        double.tryParse(requestData['insured_value']?.toString() ?? '') ?? 0;
    final weight = double.tryParse(requestData['weight_kg']?.toString() ?? '') ?? 0;
    final base = insuredValue > 0 ? insuredValue * 0.01 : (weight * 250);
    final safeBase = base <= 0 ? 1000 : base;
    return safeBase.toStringAsFixed(0);
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
}

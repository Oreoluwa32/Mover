import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../data/services/mobility_api_service.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_radio_button.dart';
import 'notifier/ride_cancel_notifier.dart';

class RideCancelScreenOne extends ConsumerStatefulWidget{
  const RideCancelScreenOne({Key? key})
    : super(key: key,);

  @override
  RideCancelScreenOneState createState() => RideCancelScreenOneState();
}

class RideCancelScreenOneState extends ConsumerState<RideCancelScreenOne>{
  final MobilityApiService _mobilityApiService = MobilityApiService();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final requestType = args['requestType']?.toString() ?? 'delivery';
    final mode = args['mode']?.toString() ?? 'cancel';
    final isReportMode = mode == 'report';
    final isDelivery = requestType == 'delivery';
    final reasons = <String>[
      isDelivery ? 'Long pickup time' : 'Long wait time',
      isDelivery ? 'Mover not at pickup point' : 'Mover not at pickup point',
      'Mover asked to pay off the app',
      'Mover asked to cancel',
      isDelivery ? "Can't find the mover" : "Can't find the passenger",
    ];

    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(left: 16.h, top: 28.h, right: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                isReportMode ? "What went wrong?" : "What went wrong?",
                style: CustomTextStyles.titleMediumGray80001,
              ),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: SingleChildScrollView(
                child: _buildColumnradio(context, reasons: reasons),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildColumndone(context),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context){
    return CustomAppBar(
      height: 56.h,
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgCancel,
          margin: EdgeInsets.only(
            top: 16.h,
            right: 15.h,
            bottom: 16.h,
          ),
          onTap: () {
            NavigatorService.goBack();
          },
        )
      ],
    );
  }

  // Section Widget
  Widget _buildColumnradio(BuildContext context, {required List<String> reasons}){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Consumer(
              builder: (context, ref, _) {
                final selectedReason = ref.watch(rideCancelNotifier).radioGroup;
                return Column(
                  children: [
                    for (int index = 0; index < reasons.length; index++) ...[
                      CustomRadioButton(
                        width: double.maxFinite,
                        text: reasons[index],
                        value: reasons[index],
                        groupValue: selectedReason,
                        textStyle: CustomTextStyles.bodyMediumMulishGray800,
                        isRightCheck: true,
                        onChange: (value) {
                          ref.read(rideCancelNotifier.notifier).changeRadioBtn(value);
                        },
                      ),
                      if (index != reasons.length - 1) ...[
                        SizedBox(height: 15.h),
                        Divider(
                          color: appTheme.gray20001,
                          thickness: 1.h,
                        ),
                        SizedBox(height: 15.h),
                      ],
                    ],
                  ],
                );
              }
            )
          ),
          SizedBox(height: 15.h,),
          Divider(
            color: appTheme.gray20001,
            thickness: 1.h,
          ),
          SizedBox(height: 15.h),
          GestureDetector(
            onTap: _openOtherReasonDialog,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final state = ref.watch(rideCancelNotifier);
                      final hasOtherReason = state.otherReason.trim().isNotEmpty;
                      return Text(
                        hasOtherReason ? state.otherReason : "Other reason",
                        style: CustomTextStyles.bodyMediumMulishGray800,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgChevronRight,
                    height: 20.h,
                    width: 20.h,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildColumndone(BuildContext context){
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.h, 8.h, 16.h, 12.h),
      child: SafeArea(
        top: false,
          child: CustomElevatedButton(
            text: _isSubmitting ? "Saving..." : "Done",
          buttonStyle: _isSubmitting
              ? CustomButtonStyles.fillBlueGray
              : CustomButtonStyles.fillPrimaryTL41,
          onPressed: _isSubmitting ? null : _submitCancellation,
        ),
      ),
    );
  }

  Future<void> _openOtherReasonDialog() async {
    final existingReason = ref.read(rideCancelNotifier).otherReason;
    final controller = TextEditingController(text: existingReason);

    final submitted = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Other reason'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Tell us what happened',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );

    if (!mounted || submitted == null) {
      return;
    }

    ref.read(rideCancelNotifier.notifier).changeRadioBtn('Other reason');
    ref.read(rideCancelNotifier.notifier).changeOtherReason(submitted);
  }

  Future<void> _submitCancellation() async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final matchId = _readNonEmptyString(
      args,
      const ['matchId', '_match_id', 'taskId'],
    );
    final requestType = args['requestType']?.toString() ?? 'delivery';
    final mode = args['mode']?.toString() ?? 'cancel';
    final isReportMode = mode == 'report';
    final requestId = _readNonEmptyString(
      args,
      const ['requestId', 'rideRequestId', 'deliveryRequestId'],
    );
    final notifier = ref.read(rideCancelNotifier.notifier);
    final state = ref.read(rideCancelNotifier);
    final selectedReason = state.radioGroup.trim();
    final otherReason = state.otherReason.trim();

    if (isReportMode && matchId.isEmpty) {
      Fluttertoast.showToast(msg: 'Task information is missing.');
      return;
    }

    if (!isReportMode && matchId.isEmpty && requestId.isEmpty) {
      Fluttertoast.showToast(msg: 'Task information is missing.');
      return;
    }

    if (selectedReason.isEmpty) {
      Fluttertoast.showToast(msg: 'Please choose a reason first.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final cancellationReason =
          selectedReason == 'Other reason' && otherReason.isNotEmpty
              ? 'Other reason'
              : selectedReason;
      final cancellationDetails =
          selectedReason == 'Other reason' ? otherReason : null;

      if (isReportMode) {
        await _mobilityApiService.submitTaskReport(
          matchId: matchId,
          reason: cancellationReason,
          details: cancellationDetails,
        );
      } else if (matchId.isNotEmpty) {
        await _mobilityApiService.cancelMatch(
          matchId: matchId,
          reason: cancellationReason,
          details: cancellationDetails,
        );
      } else if (requestType == 'ride') {
        await _mobilityApiService.deleteRideRequest(
          requestId: requestId,
        );
      } else {
        await _mobilityApiService.deleteDeliveryRequest(
          requestId: requestId,
        );
      }
      notifier.reset();
      if (!mounted) {
        return;
      }
      Fluttertoast.showToast(
        msg: isReportMode ? 'Report submitted successfully.' : 'Cancellation recorded.',
      );
      Navigator.of(context).pop(true);
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

  String _readNonEmptyString(Map<String, dynamic> args, List<String> keys) {
    for (final key in keys) {
      final value = args[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) {
        return value;
      }
    }
    return '';
  }
}

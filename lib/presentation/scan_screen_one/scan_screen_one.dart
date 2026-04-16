import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../data/services/mobility_api_service.dart';
import '../home_one_screen/notifier/home_notifier.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_pin_text_field.dart';
import 'notifier/scan_notifier.dart';

class ScanScreenOne extends ConsumerStatefulWidget {
  const ScanScreenOne({Key? key}) : super(key: key);

  @override
  ScanScreenOneState createState() => ScanScreenOneState();
}

class ScanScreenOneState extends ConsumerState<ScanScreenOne> {
  final MobilityApiService _mobilityApiService = MobilityApiService();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final confirmationStage = args['confirmationStage']?.toString() ?? 'pickup';
    final title =
        confirmationStage == 'delivery' ? 'Delivery Pin Code' : 'Pickup Pin Code';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: _buildAppbar(context, title: title),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(
          left: 16.h,
          top: 24.h,
          right: 16.h,
          bottom: 24.h,
        ),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            SizedBox(
              width: double.maxFinite,
              child: Consumer(
                builder: (context, ref, _) {
                  return CustomPinTextField(
                    context: context,
                    controller: ref.watch(scanNotifier).codeController,
                    onChanged: (value) {
                      ref.watch(scanNotifier).codeController?.text = value;
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 32.h),
            CustomElevatedButton(
              text: _isSubmitting
                  ? 'Confirming...'
                  : (confirmationStage == 'delivery'
                      ? 'Confirm Delivery'
                      : 'Confirm Pickup'),
              onPressed: _isSubmitting ? null : () => _submitConfirmation(context),
            ),
            SizedBox(height: 32.h),
            GestureDetector(
              onTap: () {
                NavigatorService.goBack();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Switch to scan',
                    style: CustomTextStyles.titleSmallPurple900,
                  ),
                  SizedBox(width: 12.h),
                  CustomImageView(
                    imagePath: ImageConstant.imgRepeat,
                    height: 18.h,
                    width: 18.h,
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context, {required String title}) {
    return CustomAppBar(
      height: 92.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeft,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 44.h,
          bottom: 24.h,
        ),
        onTap: () {
          NavigatorService.goBack();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: title,
        margin: EdgeInsets.only(
          top: 44.h,
          bottom: 23.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  Future<void> _submitConfirmation(BuildContext context) async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final matchId = args['matchId']?.toString() ?? '';
    final confirmationStage = args['confirmationStage']?.toString() ?? 'pickup';
    final verificationCode =
        ref.read(scanNotifier).codeController?.text.trim() ?? '';
    if (matchId.isEmpty || verificationCode.isEmpty) {
      Fluttertoast.showToast(msg: 'Enter the verification code.');
      return;
    }
    final homeStateNotifier = ref.read(homeNotifier.notifier);

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (confirmationStage == 'delivery') {
        await _mobilityApiService.confirmDeliveryDropoff(
          matchId: matchId,
          verificationCode: verificationCode,
        );
      } else {
        await _mobilityApiService.confirmDeliveryPickup(
          matchId: matchId,
          verificationCode: verificationCode,
        );
      }
      if (!mounted) {
        return;
      }
      Navigator.of(context).popUntil(
        (route) => route.settings.name == AppRoutes.homeOneScreen || route.isFirst,
      );
      Future<void>.delayed(
        const Duration(milliseconds: 250),
        () => homeStateNotifier.loadPendingTask(),
      );
      Fluttertoast.showToast(
        msg: confirmationStage == 'delivery'
            ? 'Delivery confirmed.'
            : 'Pickup confirmed. Continue to destination.',
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
}

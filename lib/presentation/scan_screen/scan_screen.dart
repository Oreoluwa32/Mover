import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_export.dart';
import '../../core/utils/app_toast.dart';
import '../../core/utils/delivery_confirmation_code.dart';
import '../../data/services/mobility_api_service.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../home_one_screen/notifier/home_notifier.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  ScanScreenState createState() => ScanScreenState();
}

class ScanScreenState extends ConsumerState<ScanScreen> {
  final MobilityApiService _mobilityApiService = MobilityApiService();
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );

  bool _isSubmitting = false;
  bool _isTorchEnabled = false;
  bool _isRequestingPermission = true;
  bool _hasCameraPermission = false;
  String _statusMessage = 'Align the QR code inside the frame.';
  String? _lastRejectedCode;

  @override
  void initState() {
    super.initState();
    _ensureCameraPermission();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final requestId = args['requestId']?.toString() ?? '';
    final confirmationStage = args['confirmationStage']?.toString() ?? 'pickup';
    final isDeliveryStage = confirmationStage == 'delivery';
    final title = isDeliveryStage ? 'Confirm Delivery' : 'Confirm Pickup';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: _buildAppbar(context, title: title),
      body: Stack(
        children: [
          if (_hasCameraPermission)
            Positioned.fill(
              child: MobileScanner(
                controller: _scannerController,
                onDetect: (capture) =>
                    _handleBarcodeCapture(capture, requestId, isDeliveryStage),
              ),
            )
          else
            Positioned.fill(
              child: Container(color: Colors.black),
            ),
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: Colors.black.withValues(alpha: 0.46),
              ),
            ),
          ),
          if (_hasCameraPermission)
            Center(
              child: IgnorePointer(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 250.h,
                      height: 250.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.h),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.h,
                        ),
                      ),
                    ),
                    Container(
                      width: 235.h,
                      height: 235.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.h),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.14),
                          width: 1.h,
                        ),
                      ),
                    ),
                    _buildScanCorners(),
                  ],
                ),
              ),
            ),
          if (!_hasCameraPermission)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.h),
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.97),
                    borderRadius: BorderRadius.circular(24.h),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.qr_code_scanner_rounded,
                        color: theme.colorScheme.primary,
                        size: 44.h,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Camera access is needed',
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.titleMediumGray80001,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _isRequestingPermission
                            ? 'Checking camera permission...'
                            : 'Allow camera access so the mover can scan the QR code for pickup or delivery confirmation.',
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.bodySmall110?.copyWith(
                          height: 1.45,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      CustomElevatedButton(
                        text: _isRequestingPermission
                            ? 'Checking...'
                            : 'Allow Camera',
                        onPressed: _isRequestingPermission
                            ? null
                            : () {
                                _ensureCameraPermission(forcePrompt: true);
                              },
                      ),
                      SizedBox(height: 12.h),
                      CustomElevatedButton(
                        text: 'Use Pin Code Instead',
                        buttonStyle: CustomButtonStyles.fillGray,
                        buttonTextStyle:
                            CustomTextStyles.titleSmallInterPrimary,
                        onPressed: () {
                          NavigatorService.pushNamed(
                            AppRoutes.scanScreenOne,
                            arguments: args,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: 24.h,
            left: 20.h,
            right: 20.h,
            child: Column(
              children: [
                Text(
                  isDeliveryStage
                      ? 'Scan the receiver\'s QR code to complete this delivery.'
                      : 'Scan the sender\'s QR code to confirm pickup.',
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.bodyMediumMulishGray800?.copyWith(
                    color: Colors.white,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16.h,
            right: 16.h,
            bottom: 24.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isSubmitting)
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Text(
                      'Confirming scanned QR code...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        text: _isTorchEnabled ? 'Torch Off' : 'Torch On',
                        buttonStyle: CustomButtonStyles.fillGray,
                        buttonTextStyle:
                            CustomTextStyles.titleSmallInterPrimary,
                        onPressed: _hasCameraPermission
                            ? () async {
                                await _scannerController.toggleTorch();
                                if (!mounted) {
                                  return;
                                }
                                setState(() {
                                  _isTorchEnabled = !_isTorchEnabled;
                                });
                              }
                            : null,
                      ),
                    ),
                    SizedBox(width: 12.h),
                    Expanded(
                      child: CustomElevatedButton(
                        text: 'Use Pin Code',
                        onPressed: () {
                          NavigatorService.pushNamed(
                            AppRoutes.scanScreenOne,
                            arguments: args,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
          bottom: 21.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  Future<void> _submitConfirmation(
    BuildContext context, {
    required String verificationCode,
  }) async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final matchId = args['matchId']?.toString() ?? '';
    final confirmationStage = args['confirmationStage']?.toString() ?? 'pickup';
    if (matchId.isEmpty) {
      AppToast.info('Task information is missing.');
      return;
    }
    final homeStateNotifier = ref.read(homeNotifier.notifier);

    setState(() {
      _isSubmitting = true;
      _statusMessage = 'Confirming scanned QR code...';
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
        (route) =>
            route.settings.name == AppRoutes.homeOneScreen || route.isFirst,
      );
      Future<void>.delayed(
        const Duration(milliseconds: 250),
        () => homeStateNotifier.loadPendingTask(),
      );
      AppToast.success(
        confirmationStage == 'delivery'
            ? 'Delivery confirmed.'
            : 'Pickup confirmed. Continue to destination.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
        _statusMessage = 'That code could not be confirmed. Try again.';
      });
      AppToast.error(_mobilityApiService.extractErrorMessage(error));
    }
  }

  Future<void> _handleBarcodeCapture(
    BarcodeCapture capture,
    String requestId,
    bool isDeliveryStage,
  ) async {
    if (_isSubmitting) {
      return;
    }

    final scannedCode = capture.barcodes
        .map((barcode) => barcode.rawValue?.trim() ?? '')
        .firstWhere(
          (value) => value.isNotEmpty,
          orElse: () => '',
        );

    if (scannedCode.isEmpty) {
      return;
    }

    if (!DeliveryConfirmationCode.matchesExpectedQrValue(
      scannedCode,
      requestId,
      isDeliveryStage: isDeliveryStage,
    )) {
      if (_lastRejectedCode != scannedCode) {
        _lastRejectedCode = scannedCode;
        if (mounted) {
          setState(() {
            _statusMessage = isDeliveryStage
                ? 'That QR code belongs to a different delivery.'
                : 'That QR code belongs to a different pickup.';
          });
        }
        AppToast.info(
          isDeliveryStage
              ? 'This QR code does not match the current delivery.'
              : 'This QR code does not match the current pickup.',
        );
      }
      return;
    }

    await _submitConfirmation(
      context,
      verificationCode: scannedCode,
    );
  }

  Future<void> _ensureCameraPermission({bool forcePrompt = false}) async {
    if (mounted) {
      setState(() {
        _isRequestingPermission = true;
      });
    }

    var status = await Permission.camera.status;
    if ((forcePrompt || status.isDenied || status.isRestricted) &&
        !status.isGranted) {
      status = await Permission.camera.request();
    }

    if (!mounted) {
      return;
    }

    if (status.isGranted) {
      await _scannerController.start();
      if (!mounted) {
        return;
      }
      setState(() {
        _hasCameraPermission = true;
        _isRequestingPermission = false;
        _statusMessage = 'Align the QR code inside the frame.';
      });
      return;
    }

    await _scannerController.stop();
    if (!mounted) {
      return;
    }
    setState(() {
      _hasCameraPermission = false;
      _isRequestingPermission = false;
      _statusMessage = status.isPermanentlyDenied
          ? 'Camera access is blocked. Open settings or use the PIN code instead.'
          : 'Camera permission is needed to scan the QR code.';
    });

    if (status.isPermanentlyDenied) {
      AppToast.info('Camera access is blocked. Please enable it in settings.');
    }
  }

  Widget _buildScanCorners() {
    const cornerLength = 28.0;
    const strokeWidth = 4.0;
    final cornerColor = theme.colorScheme.primary;

    Widget corner({
      required Alignment alignment,
      required bool showTop,
      required bool showBottom,
      required bool showLeft,
      required bool showRight,
    }) {
      return Align(
        alignment: alignment,
        child: Container(
          width: cornerLength,
          height: cornerLength,
          decoration: BoxDecoration(
            border: Border(
              top: showTop
                  ? BorderSide(color: cornerColor, width: strokeWidth)
                  : BorderSide.none,
              bottom: showBottom
                  ? BorderSide(color: cornerColor, width: strokeWidth)
                  : BorderSide.none,
              left: showLeft
                  ? BorderSide(color: cornerColor, width: strokeWidth)
                  : BorderSide.none,
              right: showRight
                  ? BorderSide(color: cornerColor, width: strokeWidth)
                  : BorderSide.none,
            ),
            borderRadius: BorderRadius.circular(6.h),
          ),
        ),
      );
    }

    return SizedBox(
      width: 250.h,
      height: 250.h,
      child: Stack(
        children: [
          corner(
            alignment: Alignment.topLeft,
            showTop: true,
            showBottom: false,
            showLeft: true,
            showRight: false,
          ),
          corner(
            alignment: Alignment.topRight,
            showTop: true,
            showBottom: false,
            showLeft: false,
            showRight: true,
          ),
          corner(
            alignment: Alignment.bottomLeft,
            showTop: false,
            showBottom: true,
            showLeft: true,
            showRight: false,
          ),
          corner(
            alignment: Alignment.bottomRight,
            showTop: false,
            showBottom: true,
            showLeft: false,
            showRight: true,
          ),
        ],
      ),
    );
  }
}

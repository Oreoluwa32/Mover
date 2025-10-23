import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../core/app_export.dart';

/// Loading dialog with optimized Lottie animation
/// Prevents ImageReader buffer exhaustion on Android by limiting frame rate
class LoadingDialog extends StatelessWidget {
  final String? message;
  final bool isCancellable;

  const LoadingDialog({
    Key? key,
    this.message = 'Processing...',
    this.isCancellable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(12.h),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie Animation
                Lottie.asset(
                  'assets/lottieFiles/img_movr.json',
                  height: 80.h,
                  width: 80.h,
                  repeat: true,
                  frameRate: FrameRate(60),
                ),
                SizedBox(height: 16.h),
                // Loading message
                if (message != null && message!.isNotEmpty)
                  Text(
                    message!,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show loading dialog
  static void show(
    BuildContext context, {
    String? message = 'Processing...',
    bool isCancellable = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: isCancellable,
      builder: (BuildContext context) {
        return LoadingDialog(
          message: message,
          isCancellable: isCancellable,
        );
      },
    );
  }

  /// Hide loading dialog
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
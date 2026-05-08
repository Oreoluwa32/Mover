import 'package:flutter/material.dart';
import '../core/app_export.dart';
import 'movr_loading_indicator.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;
  final bool isCancellable;

  const LoadingDialog({
    super.key,
    this.message = 'Processing...',
    this.isCancellable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SizedBox.expand(
        child: Center(
          child: MovrLoadingIndicator(
            size: 40.h,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            label: message,
            labelStyle: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
            spacing: 18.h,
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
      useRootNavigator: true,
      barrierDismissible: isCancellable,
      barrierColor: Colors.black.withValues(alpha: 0.52),
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
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }
}

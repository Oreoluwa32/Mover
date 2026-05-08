import 'package:flutter/material.dart';
import '../core/app_export.dart';
import 'base_button.dart';
import 'movr_loading_indicator.dart';

class CustomElevatedButton extends BaseButton {
  CustomElevatedButton(
      {super.key,
      this.decoration,
      this.leftIcon,
      this.rightIcon,
      super.margin,
      super.onPressed,
      super.buttonStyle,
      super.alignment,
      super.buttonTextStyle,
      super.isDisabled,
      this.isLoading = false,
      this.loadingWidget,
      this.loadingText,
      super.height,
      super.width,
      required super.text})
      : super();

  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final bool isLoading;
  final Widget? loadingWidget;
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildElevatedButtonWidget)
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
        height: height ?? 50.h,
        width: width ?? double.maxFinite,
        margin: margin,
        decoration: decoration,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed:
              (isDisabled ?? false) || isLoading ? null : onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isLoading) ...[
                loadingWidget ??
                    MovrLoadingIndicator(
                      size: 16.h,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                SizedBox(width: 10.h),
                Text(
                  loadingText ?? text,
                  style: buttonTextStyle ?? theme.textTheme.titleSmall,
                ),
              ] else ...[
                leftIcon ?? const SizedBox.shrink(),
                Text(
                  text,
                  style: buttonTextStyle ?? theme.textTheme.titleSmall,
                ),
                rightIcon ?? const SizedBox.shrink(),
              ],
            ],
          ),
        ),
      );
}

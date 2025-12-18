import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../core/app_export.dart';

// ignore for file, class must be immutable
class CustomSwitch extends StatelessWidget{
  CustomSwitch({
    Key? key,
    required this.onChange,
    this.alignment,
    this.value,
    this.width,
    this.height,
    this.margin,
    this.isDisabled = false,
  }) : super(key: key);

  final Alignment? alignment;
  bool? value;
  final Function(bool) onChange;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: appTheme.gray300,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(alpha: 0.1),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(0, 0)
          ),
        ],
      ),
      child: alignment != null ? Align(
        alignment: alignment ?? Alignment.center,
        child: switchWidget,
      ) : switchWidget,
    );
  }

  Widget get switchWidget => FlutterSwitch(
    value: value ?? false,
    height: 24.h,
    width: 45.h,
    toggleSize: 19,
    borderRadius: 12.h,
    activeColor: appTheme.deepPurple600,
    activeToggleColor: theme.colorScheme.onPrimary,
    inactiveColor: appTheme.gray300,
    inactiveToggleColor: theme.colorScheme.onPrimary,
    disabled: isDisabled,
    onToggle: (value) {
      onChange(value);
    },
  );
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../core/app_export.dart';

// Class must be immutable
class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField(
      {super.key,
      required this.context,
      required this.onChanged,
      this.onCompleted,
      this.length = 4,
      this.alignment,
      this.controller,
      this.textStyle,
      this.hintStyle,
      this.validator});

  final Alignment? alignment;
  final BuildContext context;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final int length;
  final ValueChanged<String>? onCompleted;

  final ValueChanged<String> onChanged;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: pinCodeTextFieldWidget)
        : pinCodeTextFieldWidget;
  }

  Widget get pinCodeTextFieldWidget => PinCodeTextField(
        appContext: context,
        controller: controller,
        length: length,
        keyboardType: TextInputType.number,
        textStyle: textStyle ?? theme.textTheme.displayMedium,
        hintStyle: hintStyle ?? theme.textTheme.displayMedium,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        enableActiveFill: true,
        pinTheme: PinTheme(
          fieldHeight: 64.h,
          fieldWidth: length > 4 ? 40.h : 64.h,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8.h),
          inactiveColor: appTheme.gray400,
          inactiveFillColor: theme.colorScheme.onPrimary,
          selectedColor: appTheme.deepPurple50,
          activeColor: appTheme.deepPurple100,
          activeFillColor: theme.colorScheme.onPrimary,
          selectedFillColor: theme.colorScheme.onPrimary,
        ),
        onChanged: (value) => onChanged(value),
        onCompleted: onCompleted,
        validator: validator,
      );
}

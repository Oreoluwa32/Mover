import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension RadioStyleHelper on CustomRadioButton{
  static BoxDecoration get fillOnPrimary => BoxDecoration(
    color: theme.colorScheme.onPrimary.withValues(alpha: 1),
  );
}

// ignore for file, class must be immutable
  class CustomRadioButton extends StatelessWidget{
    CustomRadioButton(
      {Key? key,
      required this.onChange,
      this.decoration,
      this.alignment,
      this.isRightCheck,
      this.iconSize,
      this.value,
      this.groupValue,
      this.text,
      this.width,
      this.padding,
      this.textStyle,
      this.overflow,
      this.textAlignment,
      this.gradient,
      this.backgroundColor,
      this.isExpandedText = false
      }
    ) : super(key: key,);

    final BoxDecoration? decoration;
    final Alignment? alignment;
    final bool? isRightCheck;
    final double? iconSize;
    String? value;
    final String? groupValue;
    final Function(String) onChange;
    final String? text;
    final double? width;
    final EdgeInsetsGeometry? padding;
    final TextStyle? textStyle;
    final TextOverflow? overflow;
    final TextAlign? textAlignment;
    final Gradient? gradient;
    final Color? backgroundColor;
    final bool isExpandedText;

    @override
  Widget build(BuildContext context) {
    return alignment != null ? Align(
      alignment: alignment ?? Alignment.center,
      child: buildRadioButtonWidget
    ) : buildRadioButtonWidget;
  }

  bool get isGradient => gradient != null;
  BoxDecoration get gradientDecoration => BoxDecoration(gradient: gradient);
  Widget get buildRadioButtonWidget => GestureDetector(
    onTap: () {
      onChange(value!);
    },
    child: Container(
      decoration: decoration,
      width: width,
      padding: padding,
      child: (isRightCheck ?? false) ? rightSideRadioButton : leftSideRadioButton,
    ),
  );
  Widget get leftSideRadioButton => Row(
    children: [
      radioButtonWidget,
      SizedBox(
        width: text != null && text!.isNotEmpty ? 8 : 0,
      ),
      textWidget
    ],
  );
  Widget get rightSideRadioButton => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      textWidget,
      SizedBox(
        width: text != null && text!.isNotEmpty ? 8 : 0,
      ),
      radioButtonWidget
    ],
  );
  Widget get textWidget => Text(
    text ?? "",
    textAlign: textAlignment ?? TextAlign.start,
    style: textStyle ?? CustomTextStyles.bodySmallOnPrimaryContainer,
  );
  Widget get radioButtonWidget {
    final size = iconSize ?? 20.0;
    return SizedBox(
      height: size,
      width: size,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: groupValue == (value ?? "")
            ? theme.colorScheme.primary
            : appTheme.gray400,
        ),
        padding: EdgeInsets.all(size * 0.1),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: groupValue == (value ?? "")
              ? Container(
                  width: size * 0.45,
                  height: size * 0.45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary,
                  ),
                )
              : SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
  BoxDecoration get radioButtonDecoration => BoxDecoration(color: backgroundColor);
}
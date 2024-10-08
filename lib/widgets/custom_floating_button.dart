import 'package:flutter/material.dart';
import '../core/app_export.dart';
import '../theme/custom_button_style.dart';

extension FloatingButtonStyleHelper on CustomFloatingButton{
  static BoxDecoration get fillOnPrimary => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    borderRadius: BorderRadius.circular(20.h),
  );
  static BoxDecoration get fillPrimary => BoxDecoration(
    color: theme.colorScheme.primary,
    borderRadius: BorderRadius.circular(24.h),
  );
}

class CustomFloatingButton extends StatelessWidget{
  CustomFloatingButton(
    {Key? key,
    this.alignment,
    this.backgroundColor,
    this.onTap,
    this.shape,
    this.width,
    this.height,
    this.decoration,
    this.child}
  ) : super(
    key: key,
  );

  final Alignment? alignment;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final ShapeBorder? shape;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final Widget? child;

  @override 
  Widget build(BuildContext context){
    return alignment != null
      ? Align(alignment: alignment ?? Alignment.center, child: fabWidget)
      : fabWidget;
  }

  Widget get fabWidget => FloatingActionButton(
    backgroundColor: backgroundColor,
    onPressed: onTap,
    shape: shape ?? 
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.h),
      ),
    child: Container(
      alignment: Alignment.center,
      width: width ?? 0,
      height: height ?? 0,
      decoration: decoration ??
        BoxDecoration(
          color: theme.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(24.h),
          border: Border.all(
            color: appTheme.blueGray10002,
            width: 1.h,
          ),
        ),
        child: child,
    ),
  );
}
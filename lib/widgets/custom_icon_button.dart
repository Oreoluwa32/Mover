import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension IconButtonStyleHelper on CustomIconButton{
  static BoxDecoration get outlineGray => BoxDecoration(
    color: appTheme.deepPurple50,
    borderRadius: BorderRadius.circular(28.h),
    border: Border.all(
      color: appTheme.gray50,
      width: 10.h
    ),
  );
  static BoxDecoration get outlineGreen => BoxDecoration(
    color: appTheme.lightGreen100,
    borderRadius: BorderRadius.circular(28.h),
    border: Border.all(
      color: appTheme.green50,
      width: 10.h,
    ),
  );
  static BoxDecoration get outlineBlack => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    borderRadius: BorderRadius.circular(20.h),
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withOpacity(0.1),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(
          0,
          0,
        ),
      )
    ],
  );
  static BoxDecoration get outlineBlackTL201 => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    borderRadius: BorderRadius.circular(20.h),
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withOpacity(0.15),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(
          0,
          3,
        ),
      )
    ],
  );
  static BoxDecoration get outlineBlackTL34 => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    borderRadius: BorderRadius.circular(34.h),
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withOpacity(0.15),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(
          0,
          3,
        ),
      )
    ],
  );
  static BoxDecoration get outlineGrayTL20 => BoxDecoration(
    color: appTheme.gray20001,
    borderRadius: BorderRadius.circular(20.h),
    border: Border.all(
      color: appTheme.gray10001,
      width: 6.h,
    ),
  );
  static BoxDecoration get outlineDeepPurple => BoxDecoration(
    color: appTheme.indigo50,
    borderRadius: BorderRadius.circular(20.h),
    border: Border.all(
      color: appTheme.deepPurple50,
      width: 6.h,
    ),
  );
  static BoxDecoration get fillLightGreen => BoxDecoration(
    color: appTheme.lightGreen100,
    borderRadius: BorderRadius.circular(10.h),
  );
  static BoxDecoration get outlineBlackTL241 => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    borderRadius: BorderRadius.circular(24.h),
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withOpacity(0.08),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(
          0, 
          0,
        ),
      )
    ],
  );
  static BoxDecoration get outlineGrayTL16 => BoxDecoration(
    color: appTheme.deepPurple50,
    borderRadius: BorderRadius.circular(16.h),
    border: Border.all(
      color: appTheme.gray50,
      width: 4.h,
    ),
  );
  static BoxDecoration get outlineRed => BoxDecoration(
    color: appTheme.deepOrange50,
    borderRadius: BorderRadius.circular(28.h),
    border: Border.all(
      color: appTheme.red5001,
      width: 10.h,
    ),
  );
}

class CustomIconButton extends StatelessWidget{
  CustomIconButton(
    {Key? key,
    this.alignment,
    this.height,
    this.width,
    this.decoration,
    this.padding,
    this.onTap,
    this.child}
  ) : super(key: key,);

  final Alignment? alignment;
  final double? height;
  final double? width;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context){
    return alignment != null
      ? Align(
        alignment: alignment ?? Alignment.center, child: iconButtonWidget
      ) : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
    height: height ?? 0,
    width: width ?? 0,
    child: DecoratedBox(
      decoration: decoration ??
        BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(24.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.black900.withOpacity(0.15),
              spreadRadius: 2.h,
              blurRadius: 2.h,
              offset: Offset(0, 3,),
            )
          ],
        ),
        child: IconButton(
          padding: padding ?? EdgeInsets.zero,
          onPressed: onTap,
          icon: child ?? Container(),
        ),
      ),
  );
}
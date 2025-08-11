import 'package:flutter/material.dart';
import '../core/app_export.dart';

// A class that offers pre-defined button styles for customizing buttons
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillBlueGray => ElevatedButton.styleFrom(
    backgroundColor: appTheme.blueGray10002,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.h),
    ),
    elevation: 0,
    padding: EdgeInsets.zero
  );
  static ButtonStyle get fillDeepPurple => ElevatedButton.styleFrom(
    backgroundColor: appTheme.deepPurple50,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.h),
    ),
    elevation: 0,
    padding: EdgeInsets.zero
  );
  static ButtonStyle get fillGray => ElevatedButton.styleFrom(
    backgroundColor: appTheme.gray10001,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.h),
    ),
    elevation: 0,
    padding: EdgeInsets.zero,
  );
  static ButtonStyle get fillOnPrimary => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.onPrimary,
    elevation: 0,
  );
  static ButtonStyle get fillOnPrimaryLR4 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.onPrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(
        right: Radius.circular(4.h,),
      ),
    ),
    elevation: 0,
  );
  static ButtonStyle get fillPrimaryTL4 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(4.h,),
      ),
    ),
    elevation: 0,
  );
  static ButtonStyle get fillPrimaryTL41 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        6.h
      ),
    ),
    elevation: 0,
  );
  static ButtonStyle get fillRed => ElevatedButton.styleFrom(
    backgroundColor: appTheme.red50,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.h,),
    ),
    elevation: 0,
  );
  // Text Button Style
  static ButtonStyle get none => ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
    elevation: WidgetStateProperty.all<double>(0),
    side: WidgetStateProperty.all<BorderSide>(
      BorderSide(color: Colors.transparent),
    )
  );
  // Gradient button style
  static BoxDecoration get gradientPrimaryToSecondaryContainerDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(8.h),
    gradient: LinearGradient(
      begin: Alignment(0.5, 0),
      end: Alignment(0.84, 1),
      colors: [
        theme.colorScheme.primary,
        theme.colorScheme.secondaryContainer
      ],
    ),
  );
  // Outline button style
  static ButtonStyle get outlineGray => OutlinedButton.styleFrom(
    backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
    side: BorderSide(
      color: appTheme.gray400,
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.h),
    ),
    padding: EdgeInsets.zero,
  );
  static ButtonStyle get outlineOnPrimary => OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    side: BorderSide(
      color: theme.colorScheme.onPrimary.withOpacity(1),
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.h),
    ),
    padding: EdgeInsets.zero,
  );
}
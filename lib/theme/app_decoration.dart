import 'package:flutter/material.dart';
import '../core/app_export.dart';

class AppDecoration {
  //Black Decorarions
  static BoxDecoration get black100 => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    border: Border.all(
      color: appTheme.gray20001,
      width: 1.h,
      ) 
  );
  static BoxDecoration get black200 => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    border: Border.all(
      color: appTheme.blueGray10002,
      width: 1.h,
      )
  );
  static BoxDecoration get black50 => BoxDecoration(
    color: appTheme.gray10001,
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withOpacity(0.08),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: const Offset(
          0,
          0,
        ),
      )
    ],
  );
  static BoxDecoration get black950 => BoxDecoration(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
  );

  // Blue decorations
  static BoxDecoration get blue500 => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    border: Border.all(
      color: appTheme.deepPurpleA200,
      width: 1.h,
      ),
  );
  static BoxDecoration get blue800 => BoxDecoration(
    color: appTheme.deepPurple600,
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withOpacity(0.1),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 0),
      )
    ],
  );
  static BoxDecoration get blue900 => BoxDecoration(
    border: Border.all(
      color: appTheme.purple900,
      width: 0.67.h,
    ),
    gradient: LinearGradient(
      begin: Alignment(0.5, -0.04),
      end: Alignment(0.5, 0.25),
      colors: [theme.colorScheme.onPrimary, theme.colorScheme.primary],
    ),
  );
  static BoxDecoration get bluePrimary => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    border: Border.all(
      color: theme.colorScheme.primary,
      width: 1.5.h,
    ),
  );
  static BoxDecoration get bluePrimaryBlack50 => BoxDecoration(
    color: appTheme.gray10001,
    border: Border.all(
      color: theme.colorScheme.primary,
      width: 1.h,
    ),
  );

  // Fill decorations 
  static BoxDecoration get fillBlack => BoxDecoration(
    color: appTheme.black900.withOpacity(0.75),
  );
  static BoxDecoration get fillGray => BoxDecoration(
    color: appTheme.gray20001,
  );
  static BoxDecoration get fillGray100 => BoxDecoration(
    color: appTheme.gray100,
  );
  static BoxDecoration get fillGray10001 => BoxDecoration(
    color: appTheme.gray10001,
  );

  // Gradient decorations
  static BoxDecoration get gradientPrimaryToSecondaryContainer => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment(0.5, -0.02),
      end: Alignment(0.84, 1.38),
      colors: [
        theme.colorScheme.primary,
        theme.colorScheme.secondaryContainer
      ],
    ),
  );

  // Green decorations
  static BoxDecoration get green100 => BoxDecoration(
    color: appTheme.lightGreen100,
    border: Border.all(
      color: appTheme.green50,
      width: 6.h,
      strokeAlign: BorderSide.strokeAlignCenter,
    ),
  );
  static BoxDecoration get green400 => BoxDecoration(
    color: appTheme.lightGreen500,
  );

  // Outline decorations
  static BoxDecoration get outlineBlack => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withOpacity(0.1),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 0,),
      )
    ],
  );
  static BoxDecoration get outlineGray => BoxDecoration(
    border: Border.all(
      color: appTheme.gray20001,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlineGray20001 => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    border: Border(
      bottom: BorderSide(
        color: appTheme.gray20001,
        width: 1.h,
      ),
    ),
  );
  static BoxDecoration get outlineGray200011 => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    border: Border(
      bottom: BorderSide(
        color: appTheme.gray20001,
        width: 1.h,
      ),
    ),
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withOpacity(0.08),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 3,),
      )
    ],
  );
  static BoxDecoration get outlineGray200012 => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    border: Border(
      top: BorderSide(
        color: appTheme.gray20001,
        width: 1.h,
      ),
    ),
  );
  static BoxDecoration get outlineGray200013 => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    border: Border(
      top: BorderSide(
        color: appTheme.gray20001,
        width: 1.h,
      ),
    ),
  );
  static BoxDecoration get outlineGray400 => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    border: Border.all(
      color: appTheme.gray400,
      width: 1.h,
    ),
  );
  static BoxDecoration get outlinePrimary => BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: theme.colorScheme.primary,
        width: 2.h,
      ),
    ),
  );
  static BoxDecoration get outlineRed => BoxDecoration(
    color: appTheme.deepOrange50,
    border: Border.all(
      color: appTheme.red5001,
      width: 6.h,
      strokeAlign: BorderSide.strokeAlignCenter,
    ),
  );

  // Shadow decorations
  static BoxDecoration get shadow => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withOpacity(0.1),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 0),
      )
    ],
  );

  // Shadow x1 decorations
  static BoxDecoration get shadowx1 => BoxDecoration(
    color: theme.colorScheme.onPrimary,
  );

  // White decorations
  static BoxDecoration get white => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    boxShadow: [
      BoxShadow(
        color: appTheme.gray9000c,
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 4,
        ),
      )
    ],
  );
}

class BorderRadiusStyle{
    // Circle borders
    static BorderRadius get CircleBorder20 => BorderRadius.circular(
      20.h,
    );
    static BorderRadius get CircleBorder38 => BorderRadius.circular(
      38.h,
    );

    // Custom borders
    static BorderRadius get customBorderLR12 => BorderRadius.horizontal(
      right: Radius.circular(12.h),
    );
    static BorderRadius get customBorderTL12 => BorderRadius.horizontal(
      left: Radius.circular(12.h),
    );
    static BorderRadius get customBorderTL24 => BorderRadius.vertical(
      top: Radius.circular(24.h),
    );

    // Rounded borders
    static BorderRadius get roundedBorder12 => BorderRadius.circular(
      12.h,
    );
    static BorderRadius get roundedBorder16 => BorderRadius.circular(
      16.h,
    );
    static BorderRadius get roundedBorder24 => BorderRadius.circular(
      24.h,
    );
    static BorderRadius get roundedBorder4 => BorderRadius.circular(
      4.h,
    );
    static BorderRadius get roundedBorder8 => BorderRadius.circular(
      8.h,
    );
  }
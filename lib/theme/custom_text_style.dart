import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension on TextStyle {
  TextStyle get mulish {
    return copyWith(
      fontFamily: 'Mulish',
    );
  }

  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style
  static get bodyLargeOnPrimary => theme.textTheme.bodyLarge!.copyWith(
    color: theme.colorScheme.onPrimary,
  );
  static get bodyMediumBluegray400 => theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.blueGray400,
  );
  static get bodyMediumBluegray800 => theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.blueGray800,
  );
  static get bodyMediumGray600 => theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.gray600,
  );
  static get bodyMediumGray700 => theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.gray700,
  );
  static get bodyMediumMulishBluegray400 => theme.textTheme.bodyMedium!.mulish.copyWith(
    color: appTheme.gray400,
  );
  static get bodyMediumMulishGray600 => theme.textTheme.bodyMedium!.mulish.copyWith(
    color: appTheme.gray600,
  );
  static get bodyMediumGray80001 => theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.gray80001,
  );
  static get bodyMediumMulishGray800 => theme.textTheme.bodyMedium!.mulish.copyWith(
    color: appTheme.gray800,
  );
  static get bodySmall110 => theme.textTheme.bodySmall!.copyWith(
    fontSize: 10.fSize,
  );
  static get bodySmall12 => theme.textTheme.bodySmall!.copyWith(
    fontSize: 12.fSize,
  );
  static get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.black900,
    fontSize: 12.fSize,
  );
  static get bodySmallBlack90010 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.black900,
    fontSize: 10.fSize,
  );
  static get bodySmallBluegray10002 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.blueGray10002,
    fontSize: 12.fSize,
  );
  static get bodySmallBluegray400 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.blueGray400,
    fontSize: 10.fSize,
  );
  static get bodySmallBluegray40012 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.blueGray400,
    fontSize: 12.fSize,
  );
  static get bodySmallDeeppurple600 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.deepPurple600,
    fontSize: 12.fSize,
  );
  static get bodySmallErrorContainer => theme.textTheme.bodySmall!.copyWith(
    color: theme.colorScheme.errorContainer,
    fontSize: 12.fSize,
  );
  static get bodySmallGray400 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.gray400,
    fontSize: 10.fSize,
  );
  static get bodySmallGray800 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.gray800,
    fontSize: 12.fSize,
  );
  static get bodySmallGray80001 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.gray80001,
    fontSize: 12.fSize,
  );
  static get bodySmallGray8000110 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.gray80001,
    fontSize: 10.fSize,
  );
  static get bodySmallGray8000112 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.gray80001,
    fontSize: 12.fSize,
  );
  static get bodySmallInter => theme.textTheme.bodySmall!.inter.copyWith(
    fontSize: 10.fSize,
  );
  static get bodySmallInter12 => theme.textTheme.bodySmall!.inter.copyWith(
    fontSize: 12.fSize,
  );
  static get bodySmallInterBlack900 => theme.textTheme.bodySmall!.inter.copyWith(
    color: appTheme.black900,
    fontSize: 10.fSize,
  );
  static get bodySmallInterErrorContainer => theme.textTheme.bodySmall!.inter.copyWith(
    color: theme.colorScheme.errorContainer,
    fontSize: 12.fSize,
  );
  static get bodySmallInterGray600 => theme.textTheme.bodySmall!.inter.copyWith(
    color: appTheme.gray600,
    fontSize: 10.fSize,
  );
  static get bodySmallInterGray60010 => theme.textTheme.bodySmall!.inter.copyWith(
    color: appTheme.gray600,
    fontSize: 10.fSize,
  );
  static get bodySmallInterGray600_1 => theme.textTheme.bodySmall!.inter.copyWith(
    color: appTheme.gray600,
  );
  static get bodySmallLightGreen900 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.lightGreen900,
    fontSize: 10.fSize,
  );
  static get bodySmallOnPrimaryContainer => theme.textTheme.bodySmall!.copyWith(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
    fontSize: 12.fSize,
  );
  static get bodySmallPrimary => theme.textTheme.bodySmall!.copyWith(
    color: theme.colorScheme.primary,
    fontSize: 12.fSize,
  );
  static get bodySmallPrimary12 => theme.textTheme.bodySmall!.copyWith(
    color: theme.colorScheme.primary,
    fontSize: 12.fSize,
  );
  static get bodySmallPrimaryContainer => theme.textTheme.bodySmall!.copyWith(
    color: theme.colorScheme.primaryContainer,
    fontSize: 12.fSize,
  );
  static get bodySmallRedA700 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.redA700,
    fontSize: 12.fSize,
  );
  // Inter text style
  static get interErrorContainer => TextStyle(
    color: theme.colorScheme.errorContainer,
    fontSize: 6.fSize,
    fontWeight: FontWeight.w500,
  ).inter;
  static get interPrimary => TextStyle(
    color: theme.colorScheme.primary,
    fontSize: 6.fSize,
    fontWeight: FontWeight.w500,
  ).inter;
  // label text style
  static get labelLargeBlack900 => theme.textTheme.labelLarge!.copyWith(
    color: appTheme.black900,
    fontWeight: FontWeight.w500,
  );
  static get labelLargeBluegray400 => theme.textTheme.labelLarge!.copyWith(
    color: appTheme.blueGray400,
  );
  static get labelLargeBluegray400Medium =>
    theme.textTheme.labelLarge!.copyWith(
    color: appTheme.blueGray400,
    fontWeight: FontWeight.w500,
  );
  static get labelLargeBold => theme.textTheme.labelLarge!.copyWith(
    fontWeight: FontWeight.w700,
  );
  static get labelLargeGray400 => theme.textTheme.labelLarge!.copyWith(
    color: appTheme.gray400,
  );
  static get labelLargeGray600 => theme.textTheme.labelLarge!.copyWith(
    color: appTheme.gray600,
  );
  static get labelLargeGray800 => theme.textTheme.labelLarge!.copyWith(
    color: appTheme.gray800,
  );
  static get labelLargeMedium => theme.textTheme.labelLarge!.copyWith(
    fontWeight: FontWeight.w500,
  );
  static get labelLargeErrorContainer => theme.textTheme.labelLarge!.copyWith(
    color: theme.colorScheme.errorContainer.withOpacity(0.5),
    fontWeight: FontWeight.w500,
  );
  static get labelLargePrimary => theme.textTheme.labelLarge!.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: FontWeight.w500,
  );
  static get labelLargeOnPrimary => theme.textTheme.labelLarge!.copyWith(
    color: theme.colorScheme.primary.withOpacity(1),
    fontWeight: FontWeight.w500,
  );
  static get labelLargeOnPrimaryContainer => theme.textTheme.labelLarge!.copyWith(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
  );
  static get labelLargePurple900 => theme.textTheme.labelLarge!.copyWith(
    color: appTheme.purple900,
    fontWeight: FontWeight.w500,
  );
  static get labelMediumGray80001 => theme.textTheme.labelMedium!.copyWith(
    color: appTheme.gray80001,
  );
  static get labelMediumInterGray80001 => theme.textTheme.labelMedium!.inter.copyWith(
    color: appTheme.gray80001,
  );
  static get labelMediumInterOnPrimary => theme.textTheme.labelMedium!.inter.copyWith(
    color: theme.colorScheme.onPrimary,
  );
  static get labelMediumInterPrimary =>
    theme.textTheme.labelMedium!.inter.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: FontWeight.w600,
  );
  static get labelMediumInterRedA700 =>
    theme.textTheme.labelMedium!.inter.copyWith(
    color: appTheme.redA700,
  );
  static get labelMediumOnPrimary => theme.textTheme.labelMedium!.copyWith(
    color: theme.colorScheme.onPrimary,
    fontWeight: FontWeight.w700,
  );
  static get labelMediumOnPrimaryBold => theme.textTheme.labelMedium!.copyWith(
    color: theme.colorScheme.onPrimary,
    fontWeight: FontWeight.w700,
  );
  static get labelMediumPrimary => theme.textTheme.labelMedium!.copyWith(
    color: theme.colorScheme.primary,
    fontSize: 11.fSize,
  );
  static get labelMediumPrimaryBold => theme.textTheme.labelMedium!.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: FontWeight.w700,
  );
  // Mulish text style
  static get mulishDeeppurpleA20001 => TextStyle(
    color: appTheme.deepPurpleA20001,
    fontWeight: FontWeight.w600,
  ).mulish;
  // Title text style
  static get titleMedium18 => theme.textTheme.titleMedium!.copyWith(
    fontSize: 18.fSize,
  );
  static get titleMediumBlack900 => theme.textTheme.titleMedium!.copyWith(
    color: appTheme.black900,
  );
  static get titleMediumGray600 => theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray600,
    fontWeight: FontWeight.w500,
  );
  static get titleMediumGray600_1 => theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray600,
    fontWeight: FontWeight.w500,
  );
  static get titleMediumGray800 => theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray800,
  );
  static get titleMediumGray80001 => theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray80001,
  );
  static get titleMediumGray8000118 => theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray80001,
    fontSize: 18.fSize,
  );
  static get titleMediumGray80001Medium => theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray80001,
    fontWeight: FontWeight.w500,
  );
  static get titleMediumGray80001_1 => theme.textTheme.titleMedium!.copyWith(
    color: appTheme.gray80001,
  );
  static get titleMediumInterErrorContainer => theme.textTheme.titleMedium!.inter.copyWith(
    color: theme.colorScheme.errorContainer,
    fontWeight: FontWeight.w500,
  );
  static get titleMediumInterGray80001 => theme.textTheme.titleMedium!.inter.copyWith(
    color: appTheme.gray80001,
    fontSize: 18.fSize,
    fontWeight: FontWeight.w500,
  );
  static get titleMediumMedium => theme.textTheme.titleMedium!.copyWith(
    fontWeight: FontWeight.w500,
  );
  static get titleMediumOnPrimary => theme.textTheme.titleMedium!.copyWith(
    color: theme.colorScheme.onPrimary,
    fontWeight: FontWeight.w700,
  );
  static get titleMediumOnPrimaryContainer =>
    theme.textTheme.titleMedium!.copyWith(
    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
  );
  static get titleSmallBlack900 => theme.textTheme.titleSmall!.copyWith(
    color: appTheme.black900,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallBluegray400 => theme.textTheme.titleSmall!.copyWith(
    color: appTheme.blueGray400,
  fontWeight: FontWeight.w500,
  );
  static get titleSmallBluegray800 => theme.textTheme.titleSmall!.copyWith(
    color: appTheme.blueGray800,
  );
  static get titleSmallGray600 => theme.textTheme.titleSmall!.copyWith(
    color: appTheme.gray600,
  );
  static get titleSmallErrorContainer => theme.textTheme.titleSmall!.copyWith(
    color: theme.colorScheme.errorContainer,
  );
  static get titleSmallInterErrorContainer => theme.textTheme.titleSmall!.inter.copyWith(
    color: theme.colorScheme.errorContainer,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallErrorContainerBold => theme.textTheme.titleSmall!.copyWith(
    color: theme.colorScheme.errorContainer,
    fontWeight: FontWeight.w700,
  );
  static get titleSmallErrorContainerMedium => theme.textTheme.titleSmall!.copyWith(
    color: theme.colorScheme.errorContainer,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallGray600Medium => theme.textTheme.titleSmall!.copyWith(
    color: appTheme.gray600,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallGray700 => theme.textTheme.titleSmall!.copyWith(
    color: appTheme.gray800,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallGray800 => theme.textTheme.titleSmall!.copyWith(
    color: appTheme.gray700,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallGray80001 => theme.textTheme.titleSmall!.copyWith(
    color: appTheme.gray80001,
  );
  static get titleSmallGray80001Bold => theme.textTheme.titleSmall!.copyWith(
    color: appTheme.gray80001,
    fontWeight: FontWeight.w700,
  );
  static get titleSmallGray80001Medium => theme.textTheme.titleSmall!.copyWith(
    color: appTheme.gray80001,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallInter => theme.textTheme.titleSmall!.inter.copyWith(
    fontWeight: FontWeight.w500,
  );
  static get titleSmallInterBlack900 => theme.textTheme.titleSmall!.inter.copyWith(
    color: appTheme.black900,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallInterGray80001 => theme.textTheme.titleSmall!.inter.copyWith(
    color: appTheme.gray80001,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallInterPrimary => theme.textTheme.titleSmall!.inter.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallPrimary => theme.textTheme.titleSmall!.copyWith(
    color: theme.colorScheme.primary,
  );
  static get titleSmallPrimaryMedium => theme.textTheme.titleSmall!.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallPrimary_1 => theme.textTheme.titleSmall!.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallPurple900 => theme.textTheme.titleSmall!.copyWith(
    color: appTheme.purple900,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallRedA700 => theme.textTheme.titleSmall!.copyWith(
    color: appTheme.redA700,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallRedA700Medium => theme.textTheme.titleSmall!.copyWith(
    color: appTheme.redA700,
    fontWeight: FontWeight.w500,
  );
  static get titleSmallOnPrimary => theme.textTheme.titleSmall!.copyWith(
    color: theme.colorScheme.onPrimary.withOpacity(1),
  );
  static get titleSmallOnPrimaryMedium => theme.textTheme.titleSmall!.copyWith(
    color: theme.colorScheme.onPrimary.withOpacity(1),
    fontWeight: FontWeight.w500,
  );
}
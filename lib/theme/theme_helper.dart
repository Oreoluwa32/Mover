import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_export.dart';

class AppThemeTypes {
  static const String lightCode = 'lightCode';
  static const String darkCode = 'darkCode';
}

String _appTheme = AppThemeTypes.lightCode;
LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

// Helper class for managing themes and colors
// ignore_for_file: must_be_immutable
class ThemeHelper {
  // A map of custom color themes supported by the app
  final Map<String, LightCodeColors> _supportedCustomColor = {
    AppThemeTypes.lightCode: LightCodeColors(),
    AppThemeTypes.darkCode: DarkCodeColors(),
  };

  // A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    AppThemeTypes.lightCode: ColorSchemes.lightCodeColorScheme,
    AppThemeTypes.darkCode: ColorSchemes.darkCodeColorScheme,
  };

  // Changes the app theme to [_newTheme]
  void changeTheme(String newTheme) {
    _appTheme = normalizeThemeType(newTheme);
  }

  static String normalizeThemeType(String themeType) {
    if (themeType == AppThemeTypes.darkCode) {
      return AppThemeTypes.darkCode;
    }
    return AppThemeTypes.lightCode;
  }

  static bool isDarkThemeType(String themeType) {
    return normalizeThemeType(themeType) == AppThemeTypes.darkCode;
  }

  bool get isDarkMode => isDarkThemeType(_appTheme);

  static SystemUiOverlayStyle systemOverlayStyleForTheme(String themeType) {
    final isDark = isDarkThemeType(themeType);
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDark ? const Color(0XFF111119) : Colors.white,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    );
  }

  // Returns the lightCode colors for the current theme
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  // Returns the current theme data
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      cardColor: colorScheme.onPrimary,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: appTheme.blueGray100,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return appTheme.indigo50;
          }
          return Colors.transparent;
        }),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return appTheme.indigo50;
          }
          return Colors.transparent;
        }),
        side: BorderSide(
          width: 1,
        ),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.onPrimary,
        foregroundColor: colorScheme.primary,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SmoothPageTransitionsBuilder(),
          TargetPlatform.iOS: SmoothPageTransitionsBuilder(),
          TargetPlatform.macOS: SmoothPageTransitionsBuilder(),
          TargetPlatform.windows: SmoothPageTransitionsBuilder(),
          TargetPlatform.linux: SmoothPageTransitionsBuilder(),
        },
      ),
      dividerTheme: DividerThemeData(
        thickness: 4,
        space: 4,
        color: appTheme.blueGray10002,
      ),
    );
  }

  // Returns the lightCode colors for the current theme
  LightCodeColors themeColor() => _getThemeColors();

  // Returns the current theme data
  ThemeData themeData() => _getThemeData();

  static of(BuildContext context) {}
}

// Class contaning the supported text theme styles
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: appTheme.gray600,
          fontSize: 16.fSize,
          fontFamily: 'Mulish',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 14.fSize,
          fontFamily: 'Mulish',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.gray600,
          fontSize: 11.fSize,
          fontFamily: 'Mulish',
          fontWeight: FontWeight.w400,
        ),
        displayMedium: TextStyle(
          color: appTheme.deepPurpleA20001,
          fontSize: 40.fSize,
          fontFamily: 'Mulish',
          fontWeight: FontWeight.w600,
        ),
        displaySmall: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 34.fSize,
          fontFamily: 'Mulish',
          fontWeight: FontWeight.w800,
        ),
        headlineLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 32.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: appTheme.gray80001,
          fontSize: 24.fSize,
          fontFamily: 'Mulish',
          fontWeight: FontWeight.w700,
        ),
        labelLarge: TextStyle(
          color: appTheme.gray80001,
          fontSize: 12.fSize,
          fontFamily: 'Mulish',
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 10.fSize,
          fontFamily: 'Mulish',
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 20.fSize,
          fontFamily: 'Mulish',
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          color: appTheme.gray80001,
          fontSize: 16.fSize,
          fontFamily: 'Mulish',
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 14.fSize,
          fontFamily: 'Mulish',
          fontWeight: FontWeight.w600,
        ),
      );
}

// Class containing the supported color schemes
class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0XFF6A19D3),
    primaryContainer: Color(0XFFECC54D),
    secondaryContainer: Color(0X666A19D3),
    errorContainer: Color(0XFF4F4F4F),
    onError: Color(0XFF263238),
    onPrimary: Color(0XFFFFFFFF),
    onPrimaryContainer: Color(0XCC262626),
    surface: Color(0XFFFFFFFF),
  );
  static final darkCodeColorScheme = ColorScheme.dark(
    primary: Color(0XFF8F53FF),
    primaryContainer: Color(0XFFECC54D),
    secondaryContainer: Color(0X998F53FF),
    errorContainer: Color(0XFFEDE8FF),
    onError: Color(0XFFF6F2FF),
    onPrimary: Color(0XFF17131F),
    onPrimaryContainer: Color(0XFFECE7F5),
    surface: Color(0XFF100D16),
  );
}

// Class containing custom colors for a lightCode theme
class LightCodeColors {
  // Amber
  Color get amber300 => Color(0XFFFEC84B);
  // Black
  Color get black900 => Color(0XFF000000);
  // BlueGray
  Color get blueGray100 => Color(0XFFCFD4DC);
  Color get blueGray10001 => Color(0XFFD9D9D9);
  Color get blueGray10002 => Color(0XFFD1D1D1);
  Color get blueGray400 => Color(0XFF888888);
  Color get blueGray800 => Color(0XFF344053);
  Color get blueGray900 => Color(0XFF292D32);
  // Deep orange
  Color get deepOrange100 => Color(0XFFFFC3BD);
  Color get deepOrange50 => Color(0XFFFEE3E1);
  // Deep Purple
  Color get deepPurple100 => Color(0XFFC5B1FF);
  Color get deepPurple400 => Color(0XFF7E56D8);
  Color get deepPurple50 => Color(0XFFEDE8FF);
  Color get deepPurple600 => Color(0XFF6018BF);
  Color get deepPurpleA100 => Color(0XFFA985FF);
  Color get deepPurpleA200 => Color(0XFF8F53FF);
  Color get deepPurpleA20001 => Color(0XFF8130F7);
  // Gray
  Color get gray100 => Color(0XFFF5FBF2);
  Color get gray10001 => Color(0XFFF6F6F6);
  Color get gray10002 => Color(0XFFF5F5F5);
  Color get gray10003 => Color(0XFFF5FBF2);
  Color get gray10004 => Color(0XFFF2F5FC);
  Color get gray200 => Color(0XFFEBEBEB);
  Color get gray20001 => Color(0XFFE7E7E7);
  Color get gray20002 => Color(0XFFF0F0F0);
  Color get gray300 => Color(0XFFE6E6E6);
  Color get gray30001 => Color(0XFFE0E0E0);
  Color get gray400 => Color(0XFFB0B0B0);
  Color get gray40001 => Color(0XFFB4B4B4);
  Color get gray50 => Color(0XFFF6F2FF);
  Color get gray5001 => Color(0XFFF6F2FF);
  Color get gray5002 => Color(0XFFFCFAFF);
  Color get gray600 => Color(0XFF6D6D6D);
  Color get gray700 => Color(0XFF5D5D5D);
  Color get gray800 => Color(0XFF414141);
  Color get gray80001 => Color(0XFF3D3D3D);
  // Grayc
  Color get gray9000c => Color(0X0C101828);
  // Green
  Color get green50 => Color(0XFFE8F7E1);
  // Indigo
  Color get indigo400 => Color(0XFF597ED7);
  Color get indigo50 => Color(0XFFDDD4FF);
  Color get indigo500 => Color(0XFF3C52B9);
  Color get indigo5001 => Color(0XFFE4E6EB);
  Color get indigo5002 => Color(0XFFE1E9F8);
  Color get indigo900 => Color(0XFF172B85);
  // Light green
  Color get lightGreen100 => Color(0XFFD2EDC5);
  Color get lightGreen500 => Color(0XFF77C055);
  Color get lightGreen700 => Color(0XFF60A93E);
  Color get lightGreen900 => Color(0XFF3D6E27);
  // Orange
  Color get orange300 => Color(0XFFECC54D);
  Color get orange50 => Color(0XFFFFFBDD);
  Color get orange500 => Color(0XFFF4900C);
  Color get orangeA200 => Color(0XFFFFAC33);
  Color get orangeA700 => Color(0XFFFF5E00);
  // purple
  Color get purple900 => Color(0XFF50169C);
  // Red
  Color get red400 => Color(0XFFB55B52);
  Color get red50 => Color(0XFFFFF1F1);
  Color get red500 => Color(0XFFEA4335);
  Color get red5001 => Color(0XFFFEF2F1);
  Color get red700 => Color(0XFFD92C20);
  Color get red900 => Color(0XFFA02724);
  Color get redA100 => Color(0XFFED847E);
  Color get redA700 => Color(0XFFE41212);
  // White
  Color get whiteA700 => Color(0XFFFDFDFD);
}

class DarkCodeColors extends LightCodeColors {
  @override
  Color get black900 => Color(0XFFF9F7FF);
  @override
  Color get blueGray100 => Color(0XFF393242);
  @override
  Color get blueGray10001 => Color(0XFF2A2532);
  @override
  Color get blueGray10002 => Color(0XFF332C3D);
  @override
  Color get blueGray400 => Color(0XFFA7A0B4);
  @override
  Color get blueGray800 => Color(0XFFD8D2E4);
  @override
  Color get blueGray900 => Color(0XFFEAE5F4);
  @override
  Color get deepPurple50 => Color(0XFF2A1E3B);
  @override
  Color get deepPurple600 => Color(0XFF8F53FF);
  @override
  Color get deepPurpleA20001 => Color(0XFFA985FF);
  @override
  Color get gray100 => Color(0XFF171D17);
  @override
  Color get gray10001 => Color(0XFF1B1724);
  @override
  Color get gray10002 => Color(0XFF1F1A28);
  @override
  Color get gray10003 => Color(0XFF171D17);
  @override
  Color get gray10004 => Color(0XFF191B27);
  @override
  Color get gray200 => Color(0XFF302A38);
  @override
  Color get gray20001 => Color(0XFF342D3D);
  @override
  Color get gray20002 => Color(0XFF241F2C);
  @override
  Color get gray300 => Color(0XFF443C4E);
  @override
  Color get gray30001 => Color(0XFF4A4355);
  @override
  Color get gray400 => Color(0XFF968FA2);
  @override
  Color get gray40001 => Color(0XFFA8A0B2);
  @override
  Color get gray50 => Color(0XFF20172E);
  @override
  Color get gray5001 => Color(0XFF20172E);
  @override
  Color get gray5002 => Color(0XFF17131F);
  @override
  Color get gray600 => Color(0XFFB9B2C4);
  @override
  Color get gray700 => Color(0XFFD3CDDC);
  @override
  Color get gray800 => Color(0XFFE7E1EF);
  @override
  Color get gray80001 => Color(0XFFF3EEF9);
  @override
  Color get gray9000c => Color(0X66100D16);
  @override
  Color get green50 => Color(0XFF172615);
  @override
  Color get indigo50 => Color(0XFF39275E);
  @override
  Color get indigo5001 => Color(0XFF2A2F3B);
  @override
  Color get indigo5002 => Color(0XFF1D2A42);
  @override
  Color get lightGreen100 => Color(0XFF26401E);
  @override
  Color get lightGreen500 => Color(0XFF8ED66A);
  @override
  Color get lightGreen700 => Color(0XFF77C055);
  @override
  Color get lightGreen900 => Color(0XFFA6E58B);
  @override
  Color get orange50 => Color(0XFF332914);
  @override
  Color get red50 => Color(0XFF33191A);
  @override
  Color get red5001 => Color(0XFF3A1E1F);
  @override
  Color get whiteA700 => Color(0XFF17131F);
}

class SmoothPageTransitionsBuilder extends PageTransitionsBuilder {
  const SmoothPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        )
            .chain(
              CurveTween(curve: Curves.easeOutCubic),
            )
            .animate(animation),
        child: child,
      ),
    );
  }
}

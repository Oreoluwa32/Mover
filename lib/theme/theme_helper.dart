import 'package:flutter/material.dart';
import '../core/app_export.dart';

String _appTheme = 'lightCode';
LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

// Helper class for managing themes and colors
// ignore_for_file: must_be_immutable
class ThemeHelper {
  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode' : LightCodeColors()
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode' : ColorSchemes.lightCodeColorScheme
  };

  // Changes the app theme to [_newTheme]
  void changeTheme(String _newTheme){
    _appTheme = _newTheme;
  }

  // Returns the lightCode colors for the current theme
  LightCodeColors _getThemeColors(){
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  // Returns the current theme data
  ThemeData _getThemeData(){
    var colorScheme = 
      _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.onPrimary,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
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
        fillColor: WidgetStateColor.resolveWith((states){
          if(states.contains(WidgetState.selected)){
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
        fillColor: WidgetStateColor.resolveWith((states){
          if(states.contains(WidgetState.selected)){
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
}

// Class contaning the supported text theme styles
class TextThemes{
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
class ColorSchemes{
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0XFF6A19D3),
    primaryContainer: Color(0XFFECC54D),
    secondaryContainer: Color(0X666A19D3),
    errorContainer: Color(0XFF4F4F4F),
    onError: Color(0XFF263238),
    onPrimary: Color(0XFFFFFFFF),
    onPrimaryContainer: Color(0XCC262626),
  );
}

// Class containing custom colors for a lightCode theme
class LightCodeColors{
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
  Color get gray100 => Color (0XFFF5FBF2);
  Color get gray10001 => Color (0XFFF6F6F6);
  Color get gray10002 => Color (0XFFF5F5F5);
  Color get gray200 => Color (0XFFEBEBEB);
  Color get gray20001 => Color (0XFFE7E7E7);
  Color get gray20002 => Color (0XFFF0F0F0);
  Color get gray300 => Color (0XFFE6E6E6);
  Color get gray30001 => Color (0XFFE0E0E0);
  Color get gray400 => Color (0XFFB0B0B0);
  Color get gray40001 => Color (0XFFB4B4B4);
  Color get gray50 => Color (0XFFF6F2FF);
  Color get gray5001 => Color (0XFFFAFAFA);
  Color get gray5002 => Color (0XFFFCFAFF);
  Color get gray600 => Color (0XFF6D6D6D);
  Color get gray700 => Color (0XFFF5D5D5D);
  Color get gray800 => Color (0XFF414141);
  Color get gray80001 => Color (0XFF3D3D3D);
  // Grayc
  Color get gray9000c => Color (0X0C101828);
  // Green
  Color get green50 => Color (0XFFE8F7E1);
  // Indigo
  Color get indigo400 => Color(0XFF597ED7);
  Color get indigo50 => Color(0XFFDDD4FF);
  Color get indigo5001 => Color(0XFFE4E6EB);
  Color get indigo900 => Color(0XFF172B85);
  // Light green
  Color get lightGreen100 => Color(0XFFD2EDC5);
  Color get lightGreen500 => Color(0XFF77C055);
  Color get lightGreen700 => Color(0XFF60A93E);
  Color get lightGreen900 => Color(0XFF3D6E27);
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
}
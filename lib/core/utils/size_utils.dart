import 'package:flutter/material.dart';

const num figmaDesignWidth = 375;
const num figmaDesignHeight = 812;
const num figmaDesignStatusBar = 0;

extension ResponsiveExtension on num{
  double get _width => SizeUtils.width;
  double get h => ((this * _width) / figmaDesignWidth);
  double get fSize => ((this * _width) / figmaDesignWidth);
}

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}){
    return double.parse(toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}){
    return this > 0 ? this : defaultValue.toDouble();
  }
}

enum DeviceType {mobile, tablet, desktop}

typedef ResponsiveBuild = Widget Function(
  BuildContext context, Orientation orientation, DeviceType deviceType);

  class Sizer extends StatelessWidget{
    const Sizer({super.key, required this.builder});

    // Builds the widget whenever the orientation changes
    final ResponsiveBuild builder;

    @override
    Widget build(BuildContext context){
      return LayoutBuilder(builder: (context, constraints){
        return OrientationBuilder(builder: (context, orientation){
          SizeUtils.setScreenSize(context, constraints, orientation);
          return builder(context, orientation, SizeUtils.deviceType);
        }); //OrientationBuilder
      }); //LayoutBuilder
    }
  }


class SizeUtils {
  // Device box constraints
  static late BoxConstraints boxConstraints;

  // Device Oreintations
  static late Orientation orientation;

  // Type of device (mobile or tablet)
  static late DeviceType deviceType;

  // Device's height
  static late double height;

  // Device's width
  static late double width;

  static void setScreenSize(
    BuildContext context,
    BoxConstraints constraints,
    Orientation currentOrientation,
  ) {
    boxConstraints = constraints;
    orientation = currentOrientation;

    final mediaQuery = MediaQuery.of(context);

    // Use MediaQuery to get full width/height minus safe areas
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;

    deviceType = DeviceType.mobile;
  }
}
import 'package:flutter/material.dart';

import '../../core/utils/image_constant.dart';

class OnboardingImagePreloader {
  static final List<String> _imagePaths = [
    ImageConstant.imgSplashScreenTwo,
    ImageConstant.imgSplashScreenThree,
    ImageConstant.imgSplashScreenFour,
  ];

  static Future<void> precacheAll(BuildContext context) async {
    await Future.wait(
      _imagePaths.map(
        (imagePath) => precacheImage(AssetImage(imagePath), context),
      ),
    );
  }

  static Future<void> precachePath(BuildContext context, String imagePath) {
    return precacheImage(AssetImage(imagePath), context);
  }
}

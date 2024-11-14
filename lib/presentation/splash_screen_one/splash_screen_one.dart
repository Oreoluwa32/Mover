import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'notifier/splash_screen_one_notifier.dart';

class SplashScreenOne extends ConsumerStatefulWidget{
  const SplashScreenOne({super.key});

  @override
  SplashScreenOneState createState() => SplashScreenOneState();
}

class SplashScreenOneState extends ConsumerState<SplashScreenOne>{
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.maxFinite,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0.5, -0.02),
              end: const Alignment(0.84, 1.38),
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondaryContainer
              ],
            ), //Linear gradient
          ), //Box decoration
          child: Container(
            padding: EdgeInsets.all(16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SizedBox(height: 6.h), _buildColumnuserone(context)],
            ), //Column
          ), //Container
        ), // Container
      ), // Scaffold
    ); //Safe area
  }

  // Section Widget
  Widget _buildColumnuserone(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgSplashScreenOne,
            height: 40.h,
            width: 64.h,
          ),
        ],
      ),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../services/device_memory_service.dart';
import '../../core/utils/location_manager.dart';
import '../onboarding/onboarding_image_preloader.dart';

class SplashScreenOne extends ConsumerStatefulWidget {
  const SplashScreenOne({super.key});

  @override
  SplashScreenOneState createState() => SplashScreenOneState();
}

class SplashScreenOneState extends ConsumerState<SplashScreenOne> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize device memory service
    final deviceMemory = DeviceMemoryService();
    await deviceMemory.init();

    // Check and request location permission/service
    await LocationManager.checkAndRequestLocationPermission();

    // Check if onboarding is completed
    final onboardingCompleted = await PrefUtils().getOnboardingCompleted();

    if (mounted) {
      await OnboardingImagePreloader.precacheAll(context);
    }

    // A user is considered logged in only when a real auth token exists.
    final hasActiveSession = await deviceMemory.syncSessionState();

    _timer = Timer(const Duration(seconds: 3), () {
      if (onboardingCompleted) {
        if (hasActiveSession) {
          // User already logged in, navigate to home
          NavigatorService.pushNamedAndRemoveUntil(AppRoutes.homeOneScreen);
        } else {
          // Onboarding done but not logged in, navigate to login
          NavigatorService.pushNamedAndRemoveUntil(AppRoutes.signInScreen);
        }
      } else {
        // First time user, show onboarding splash screens
        NavigatorService.pushNamedAndRemoveUntil(AppRoutes.splashScreenTwo);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancels the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
    ); // Scaffold
  }

  // Section Widget
  Widget _buildColumnuserone(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgSplashScreenOne,
            height: 97.h,
            width: 156.h,
          ),
        ],
      ),
    );
  }
}

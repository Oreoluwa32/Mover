import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../services/device_memory_service.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../activity_in_progress_page/activity_in_progress_page.dart';
import '../my_route_page/my_route_page.dart';
import '../profile_screen/profile_screen.dart';
import '../search_mover_bottomsheet/search_mover_bottomsheet.dart';
import '../user_move_screen/user_move_screen.dart';
import '../save_your_route_dialog/save_your_route_dialog.dart';
import 'home_one_initial_page.dart';
import 'notifier/home_notifier.dart';

// ignore for file, must be immutable
class HomeOneScreen extends ConsumerStatefulWidget{
  const HomeOneScreen({Key? key})
    : super(
      key: key,
    );

  @override
  HomeOneScreenState createState() => HomeOneScreenState();
}

// ignore for file, must be immutable
class HomeOneScreenState extends ConsumerState<HomeOneScreen>{
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  bool _hideBottomBar = false;
  bool _dialogShown = false;
  bool _searchSheetShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasActiveSession = await DeviceMemoryService().syncSessionState();
      if (!mounted) {
        return;
      }
      if (!hasActiveSession) {
        NavigatorService.pushNamedAndRemoveUntil(AppRoutes.signInScreen);
        return;
      }

      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        if (args['highlightRoute'] == true &&
            args['locationLat'] != null &&
            args['locationLng'] != null &&
            args['destinationLat'] != null &&
            args['destinationLng'] != null) {
          ref.read(homeNotifier.notifier).setRouteCoordinates(
            locationLat: args['locationLat'] as double,
            locationLng: args['locationLng'] as double,
            destinationLat: args['destinationLat'] as double,
            destinationLng: args['destinationLng'] as double,
            destinationName: args['destinationName'] as String?,
          );
        }
        if (args['showDialog'] == true && !_dialogShown) {
          _dialogShown = true;
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => SaveYourRouteDialog(),
          );
        }
        if (args['autoEnableLive'] == true) {
          final routeId = args['autoEnableLiveRouteId']?.toString();
          unawaited(
            ref.read(homeNotifier.notifier).enableLiveIfNeeded(
                  routeId: routeId,
                ),
          );
        }
        if (args['searchNearbyMovers'] == true && !_searchSheetShown) {
          final searchType =
              args['searchRequestType']?.toString() ?? 'delivery';
          final searchData = Map<String, dynamic>.from(
            args['searchRequestData'] as Map? ?? const <String, dynamic>{},
          );
          _searchSheetShown = true;
          ref.read(homeNotifier.notifier).startNearbyMoverSearch(
                searchType: searchType,
                searchData: searchData,
              );
          AppBottomSheet.show(
            context: context,
            useRootNavigator: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24.h),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            builder: (context) => SearchMoverBottomsheet(
              requestType: searchType,
              requestData: searchData,
            ),
            isScrollControlled: true,
          ).whenComplete(() {
            _searchSheetShown = false;
          });
        }
      }
    });
  }

  void _setBottomBarVisibility(bool hide) {
    setState(() {
      _hideBottomBar = hide;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Navigator(
        key: navigatorKey,
        initialRoute: AppRoutes.homeOneInitialPage,
        onGenerateRoute: (routeSetting) => PageRouteBuilder(
          pageBuilder: (ctx, ani, ani1) => getCurrentPage(context, routeSetting.name!),
          transitionDuration: const Duration(milliseconds: 260),
          reverseTransitionDuration: const Duration(milliseconds: 220),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.03, 0),
                  end: Offset.zero,
                ).chain(
                  CurveTween(curve: Curves.easeOutCubic),
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _hideBottomBar ? null : Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Container(
          width: double.maxFinite,
          child: _buildBottombar(context),
        ),
      ),
    );
  }

  // Section Widget 
  Widget _buildBottombar(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          Navigator.pushNamed(
            navigatorKey.currentContext!, getCurrentRoute(type)
          );
        },
      ),
    );
  }

  // Handling the route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type){
    switch(type){
      case BottomBarEnum.Home:
        return AppRoutes.homeOneInitialPage;
      case BottomBarEnum.Route:
        return AppRoutes.myRoutePage;
      case BottomBarEnum.Move:
        return AppRoutes.userMoveScreen;
      case BottomBarEnum.Activity:
        return AppRoutes.activityInProgressPage;
      case BottomBarEnum.Profile:
        return AppRoutes.profileScreen;
      }
  }

  // Handling the page based on the routes
  Widget getCurrentPage(BuildContext context, String currentRoute){
    switch(currentRoute){
      case AppRoutes.homeOneInitialPage:
        return HomeOneInitialPage();
      case AppRoutes.myRoutePage:
        return MyRoutePage(
          onOverlayChanged: _setBottomBarVisibility,
        );
      case AppRoutes.userMoveScreen:
        return UserMoveScreen(
          onOverlayChanged: _setBottomBarVisibility,
        );
      case AppRoutes.activityInProgressPage:
        return ActivityInProgressPage();
      case AppRoutes.profileScreen:
        return ProfileScreen();
      default:
        return DefaultWidget();
    }
  }
}

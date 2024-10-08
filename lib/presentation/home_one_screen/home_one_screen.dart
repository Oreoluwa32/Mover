import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import 'home_one_initial_page.dart';

// ignore for file, must be immutable
class HomeOneScreen extends StatelessWidget{
  HomeOneScreen({Key? key})
    : super(
      key: key,
    );

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Navigator(
          key: navigatorKey,
          initialRoute: AppRoutes.homeOneInitialPage,
          onGenerateRoute: (routeSetting) => PageRouteBuilder(
            pageBuilder: (ctx, ani, ani1) => getCurrentPage(routeSetting.name!),
            transitionDuration: Duration(seconds: 0),
          ),
        ),
        bottomNavigationBar: Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 16.h),
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
        return AppRoutes.homeOneInitialPage;
      case BottomBarEnum.Activity:
        return AppRoutes.homeOneInitialPage;
      case BottomBarEnum.Profile:
        return AppRoutes.homeOneInitialPage;
      default:
        return "/";
    }
  }

  // Handling the page based on the routes
  Widget getCurrentPage(String currentRoute){
    switch(currentRoute){
      case AppRoutes.homeOneInitialPage:
        return HomeOneInitialPage();
      // case BottomBarEnum.Route:
      //   return AppRoutes.;
      // case BottomBarEnum.Activity:
      //   return AppRoutes.;
      // case BottomBarEnum.Profile:
      //   return AppRoutes.;
      default:
        return DefaultWidget();
    }
  }
}
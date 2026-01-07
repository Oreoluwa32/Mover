import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../activity_in_progress_page/activity_in_progress_page.dart';
import '../my_route_page/my_route_page.dart';
import '../profile_screen/profile_screen.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args?['showDialog'] == true && !_dialogShown) {
        _dialogShown = true;
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => SaveYourRouteDialog(),
        );
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
          transitionDuration: Duration(seconds: 0),
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
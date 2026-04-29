import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../activity_scheduled_screen/activity_scheduled_screen.dart';
import '../activity_completed_screen/activity_completed_screen.dart';
import 'activity_progress_tab.dart';

class ActivityInProgressPage extends ConsumerStatefulWidget {
  const ActivityInProgressPage({Key? key}) : super(key: key);

  @override
  ActivityInProgressPageState createState() => ActivityInProgressPageState();
}

// ignore for file, class must be immutable
class ActivityInProgressPageState extends ConsumerState<ActivityInProgressPage>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withValues(alpha: 1),
        ),
        child: Column(
          children: [
            _buildAppbar(context),
            Expanded(
              child: TabBarView(
                controller: tabviewController,
                children: [
                  ActivityProgressTab(),
                  ActivityScheduledScreen(),
                  ActivityCompletedScreen(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildAppbar(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 170.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomAppBar(
            height: 60.h,
            centerTitle: true,
            title: AppbarSubtitle(
              text: "Activity",
            ),
            actions: [
              AppbarTrailingImage(
                imagePath: ImageConstant.imgFilter,
                margin: EdgeInsets.only(
                  right: 15.h,
                ),
              )
            ],
          ),
          SizedBox(
            height: 14.h,
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: TabBar(
                    controller: tabviewController,
                    labelPadding: EdgeInsets.zero,
                    labelColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      fontSize: 14.fSize,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelColor: appTheme.blueGray400,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 14.fSize,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w500,
                    ),
                    dividerColor: appTheme.blueGray10001,
                    dividerHeight: 1.h,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2.h,
                      ),
                      insets: EdgeInsets.symmetric(horizontal: 6.h),
                    ),
                    tabs: [
                      Tab(
                        height: 48,
                        child: Container(
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          margin: EdgeInsets.only(right: 6.h),
                          child: Text(
                            "Active",
                          ),
                        ),
                      ),
                      Tab(
                        height: 48,
                        child: Container(
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(horizontal: 6.h),
                          child: Text(
                            "Scheduled",
                          ),
                        ),
                      ),
                      Tab(
                        height: 48,
                        child: Container(
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          margin: EdgeInsets.only(left: 6.h),
                          child: Text(
                            "Completed",
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // // Handling the route based on bottom click actions
  // String getCurrentRoute(BottomBarEnum type){
  //   switch(type){
  //     case BottomBarEnum.Home:
  //       return AppRoutes.homeOneInitialPage;
  //     case BottomBarEnum.Route:
  //       return AppRoutes.myRoutePage;
  //     case BottomBarEnum.Activity:
  //       return AppRoutes.activityInProgressPage;
  //     case BottomBarEnum.Profile:
  //       return AppRoutes.profileScreen;
  //     default:
  //       return "/";
  //   }
  // }

  // // Handling the page based on the routes
  // Widget getCurrentPage( BuildContext context, String currentRoute){
  //   switch(currentRoute){
  //     case AppRoutes.homeOneInitialPage:
  //       return HomeOneInitialPage();
  //     case AppRoutes.myRoutePage:
  //       return MyRoutePage();
  //     case AppRoutes.activityInProgressPage:
  //       return ActivityInProgressPage();
  //     case AppRoutes.profileScreen:
  //       return ProfileScreen();
  //     default:
  //       return DefaultWidget();
  //   }
  // }
}

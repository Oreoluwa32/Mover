import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../activity_scheduled_screen/activity_scheduled_screen.dart';
import '../activity_completed_screen/activity_completed_screen.dart';
import 'activity_progress_tab.dart';
import 'notifier/activity_progress_notifier.dart';

class ActivityInProgressPage extends ConsumerStatefulWidget{
  const ActivityInProgressPage({Key? key}) : super(key: key);

  @override
  ActivityInProgressPageState createState() => ActivityInProgressPageState();
}

// ignore for file, class must be immutable
class ActivityInProgressPageState extends ConsumerState<ActivityInProgressPage> with TickerProviderStateMixin{
  late TabController tabviewController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withOpacity(1),
          ),
          child: Column(
            children: [
              _buildAppbar(context),
              Expanded(
                child: Container(
                  child: TabBarView(
                    controller: tabviewController,
                    children: [
                      ActivityProgressTab(),
                      ActivityScheduledScreen(),
                      ActivityCompletedScreen(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildAppbar(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray20001,
            width: 1.h,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 42.h,),
          CustomAppBar(
            height: 26.h,
            centerTitle: true,
            title: AppbarSubtitle(
              text: "Activity",
            ),
            actions: [
              AppbarTrailingImage(
                imagePath: ImageConstant.imgFilter,
                margin: EdgeInsets.only(
                  right: 15.h,
                  bottom: 2.h
                ),
              )
            ],
          ),
          SizedBox(height: 14.h,),
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
                    // labelColor: appTheme.gray80001,
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
                    tabs: [
                      Tab(
                        height: 48,
                        child: Container(
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          margin: EdgeInsets.only(right: 6.h),
                          decoration: tabIndex == 0 ? BoxDecoration(
                            color: theme.colorScheme.onPrimary.withOpacity(1),
                            border: Border(
                              bottom: BorderSide(
                                color: theme.colorScheme.primary,
                                width: 2.h
                              ),
                            )
                          ) : BoxDecoration(
                            color: theme.colorScheme.onPrimary.withOpacity(1)
                          ),
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
                          decoration: tabIndex == 1 ? BoxDecoration(
                            color: theme.colorScheme.onPrimary.withOpacity(1),
                            border: Border(
                              bottom: BorderSide(
                                color: theme.colorScheme.primary,
                                width: 2.h
                              ),
                            )
                          ) : BoxDecoration(
                            color: theme.colorScheme.onPrimary.withOpacity(1)
                          ),
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
                          decoration: tabIndex == 2 ? BoxDecoration(
                            color: theme.colorScheme.onPrimary.withOpacity(1),
                            border: Border(
                              bottom: BorderSide(
                                color: theme.colorScheme.primary,
                                width: 2.h
                              ),
                            )
                          ) : BoxDecoration(
                            color: theme.colorScheme.onPrimary.withOpacity(1)
                          ),
                          child: Text(
                            "Completed",
                          ),
                        ),
                      )
                    ],
                    indicatorColor: Colors.transparent,
                    onTap: (index) {
                      tabIndex = index;
                      setState(() {});
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
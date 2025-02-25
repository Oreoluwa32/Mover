import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/scheduled_item_model.dart';
import 'notifier/activity_scheduled_notifier.dart';
import 'widgets/scheduled_item_widget.dart'; // ignore for file, class must be immutable

class ActivityScheduledScreen extends ConsumerStatefulWidget{
  const ActivityScheduledScreen({Key? key}) : super(key: key);

  @override
  ActivityScheduledScreenState createState() => ActivityScheduledScreenState();
}

class ActivityScheduledScreenState extends ConsumerState<ActivityScheduledScreen> with AutomaticKeepAliveClientMixin<ActivityScheduledScreen>{
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 32.h,
              ),
              _buildSchedules(context)
            ],
          ),
        ),
      )
    );
  }

  // Section Widget 
  Widget _buildSchedules(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, _) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              ScheduledItemModel model = ref.watch(activityScheduledNotifier).activityScheduledModelObj?.scheduledItemList[index] ?? ScheduledItemModel();
              return GestureDetector(
                onTap: () {
                  NavigatorService.pushNamed(AppRoutes.scheduleTripBottomsheet);
                },
                child: ScheduledItemWidget(model),
              );
            }, 
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 16.h,
              );
            }, 
            itemCount: ref.watch(activityScheduledNotifier).activityScheduledModelObj?.scheduledItemList.length ?? 0,
          );
        },
      ),
    );
  }
}
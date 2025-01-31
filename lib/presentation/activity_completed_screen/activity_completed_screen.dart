import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/completed_item_model.dart';
import 'notifier/activity_completed_notifier.dart';
import 'widgets/completed_item_widget.dart'; // ignore for file, class must be immutable

class ActivityCompletedScreen extends ConsumerStatefulWidget{
  const ActivityCompletedScreen({Key? key}) : super(key: key);

  @override
  ActivityCompletedScreenState createState() => ActivityCompletedScreenState();
}

class ActivityCompletedScreenState extends ConsumerState<ActivityCompletedScreen> with AutomaticKeepAliveClientMixin<ActivityCompletedScreen>{
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
              CompletedItemModel model = ref.watch(activityCompletedNotifier).activityCompletedModelObj?.completedItemList[index] ?? CompletedItemModel();
              return CompletedItemWidget(model);
            }, 
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 16.h,
              );
            }, 
            itemCount: ref.watch(activityCompletedNotifier).activityCompletedModelObj?.completedItemList.length ?? 0,
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/activity_in_progress_model.dart';
import 'models/activity_progress_tab_model.dart';
import 'models/progress_item_model.dart';
import 'notifier/activity_progress_notifier.dart';
import 'widgets/progress_item_widget.dart';

class ActivityProgressTab extends ConsumerStatefulWidget {
  const ActivityProgressTab({Key? key}) : super(key: key);

  @override
  ActivityProgressTabState createState() => ActivityProgressTabState();
}

class ActivityProgressTabState extends ConsumerState<ActivityProgressTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          SizedBox(
            height: 32.h,
          ),
          _buildProgress(context),
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildProgress(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, _) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 16.h);
            },
            itemCount: ref.watch(activityProgressNotifier).activityProgressTabModelObj?.progressList.length ?? 0,
            itemBuilder: (context, index) {
              ProgressItemModel model = ref.watch(activityProgressNotifier).activityProgressTabModelObj?.progressList[index] ?? ProgressItemModel();
              return GestureDetector(
                onTap: () {
                  NavigatorService.pushNamed(AppRoutes.userDeliveryBottomsheetOne);
                },
                child: ProgressItemWidget(model),
              );
            },
          );
        },
      ),
    );
  }
}

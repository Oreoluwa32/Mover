import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/list_item_model.dart';
import 'notifier/notification_notifier.dart';
import 'widgets/list_item_widget.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(left: 16.h, top: 28.h,right: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildNotification(context)],
          ),
        ),
      ),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 92.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(text: "Notifications"),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildNotification(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, _) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              ListItemModel model = ref.watch(notificationNotifier).notificationModelObj?.listItemList[index] ?? ListItemModel();
              return ListItemWidget(model);
            }, 
            separatorBuilder: (context, index) {
              return SizedBox(height: 8.h,);
            }, 
            itemCount: ref.watch(notificationNotifier).notificationModelObj?.listItemList.length ?? 0
          );
        },
      ),
    );
  }

  // Navigate back to the previous screen
  onTapBack(BuildContext context){
    NavigatorService.goBack();
  }
}
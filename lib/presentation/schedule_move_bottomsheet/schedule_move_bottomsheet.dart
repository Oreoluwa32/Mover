import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/move_item_model.dart';
import 'notifier/move_notifier.dart';
import 'widgets/move_item_widget.dart'; // ignore for file, must be immutable

class ScheduleMoveBottomsheet extends ConsumerStatefulWidget {
  const ScheduleMoveBottomsheet({Key? key}) : super(key: key);

  @override
  ScheduleMoveBottomsheetState createState() => ScheduleMoveBottomsheetState();
}

class ScheduleMoveBottomsheetState
    extends ConsumerState<ScheduleMoveBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(left: 16.h, top: 16.h, right: 16.h),
      decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withOpacity(1),
          borderRadius: BorderRadiusStyle.customBorderTL24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50.h,
            child: Divider(),
          ),
          SizedBox(
            height: 12.h,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Schedule Service",
                  style: theme.textTheme.titleSmall,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgCancel,
                  height: 24.h,
                  width: 24.h,
                  margin: EdgeInsets.only(left: 92.h),
                )
              ],
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Consumer(builder: (context, ref, _) {
            return ListView.separated(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  MoveItemModel model = ref
                          .watch(moveNotifier)
                          .moveModelObj
                          ?.moveItemList[index] ??
                      MoveItemModel();
                  return MoveItemWidget(model);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 16.h,
                  );
                },
                itemCount:
                    ref.watch(moveNotifier).moveModelObj?.moveItemList.length ??
                        0);
          }),
          SizedBox(height: 8.h,)
        ],
      ),
    );
  }
}

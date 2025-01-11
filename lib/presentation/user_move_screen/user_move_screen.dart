import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/list_item_model.dart';
import 'models/listsendpackage_item_model.dart';
import 'notifier/move_notifier.dart';
import 'widgets/list_item_widget.dart';
import 'widgets/listsendpackage_item_widget.dart';

class UserMoveScreen extends ConsumerStatefulWidget{
  const UserMoveScreen({Key? key}) : super(key: key);

  @override
  UserMoveScreenState createState() => UserMoveScreenState();
}

class UserMoveScreenState extends ConsumerState<UserMoveScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80.h,),
                  SizedBox(
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Column(
                          children: [_buildTitle(context)],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 38.h),
                  _buildColumn(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildTitle(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            ListsendpackageItemModel model = ref.watch(moveNotifier).moveModelObj?.listsendpackageItemList[index] ?? ListsendpackageItemModel();
            return ListsendpackageItemWidget(model);
          }, 
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 16.h,
            );
          }, 
          itemCount: ref.watch(moveNotifier).moveModelObj?.listsendpackageItemList.length ?? 0,
        );
      }
    );
  }

  // Section Widget
  Widget _buildColumn(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(right: 16.h),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Promotions",
                        style: CustomTextStyles.titleSmallBlack900,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "See all",
                          style: CustomTextStyles.labelLargePrimary,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 12.h,),
          Container(
            child: Consumer(
              builder: (context, ref, _) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 12.h,
                    children: List.generate(ref.watch(moveNotifier).moveModelObj?.listItemList.length ?? 0, (index) {
                      ListItemModel model = ref.watch(moveNotifier).moveModelObj?.listItemList[index] ?? ListItemModel();
                      return ListItemWidget(model);
                    },),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
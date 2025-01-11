import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/movers_item_model.dart';
import 'notifier/share_ride_notifier.dart';
import 'widgets/movers_item_widget.dart';

class ShareRideScreen extends ConsumerStatefulWidget {
  const ShareRideScreen({Key? key}) : super(key: key);

  @override
  ShareRideScreenState createState() => ShareRideScreenState();
}

class ShareRideScreenState extends ConsumerState<ShareRideScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(left: 16.h, top: 2.h, right: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Text(
              "2745 movers are heading your way",
              style: CustomTextStyles.titleSmallMedium?.copyWith(color: Colors.black87),
            ),
            SizedBox(
              height: 28.h,
            ),
            _buildMover(context)
          ],
        ),
      ),
    ));
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 90.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgLeftArrow,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 44.h,
          bottom: 22.h,
        ),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Movers",
        margin: EdgeInsets.only(top: 45.h, bottom: 20.h),
      ),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgSort,
          margin: EdgeInsets.only(top: 44.h, bottom: 22.h),
        ),
        AppbarTrailingImage(
          imagePath: ImageConstant.imgFilter,
          margin: EdgeInsets.fromLTRB(8.h, 44.h, 15.h, 22.h),
        )
      ],
      styleType: Style.bgFill,
    );
  }

  // Section Widget
  Widget _buildMover(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, _) {
          return ListView.separated(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                MoversItemModel model = ref
                        .watch(shareRideNotifier)
                        .shareRideModelObj
                        ?.moverItemList[index] ??
                    MoversItemModel();
                return MoversItemWidget(model);
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 8.h,
                );
              },
              itemCount: ref
                      .watch(shareRideNotifier)
                      .shareRideModelObj
                      ?.moverItemList
                      .length ??
                  0);
        },
      ),
    );
  }

  // Navigates back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }
}

import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/mover_item_model.dart';
import 'notifier/hire_mover_notifier.dart';
import 'widgets/mover_item_widget.dart';

class HireMoverScreen extends ConsumerStatefulWidget{
  const HireMoverScreen({Key? key}) : super(key: key);

  @override
  HireMoverScreenState createState() => HireMoverScreenState();
}

class HireMoverScreenState extends ConsumerState<HireMoverScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text(
                "234 movers are heading your direction",
                style: CustomTextStyles.bodyMediumMulishBlack900,
              ),
              SizedBox(height: 28.h),
              _buildMoverlist(context)
            ],
          ),
        ),
      ),
    );
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
          bottom: 22.h
        ),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Movers",
        margin: EdgeInsets.only(
          top: 45.h,
          bottom: 20.h,
        ),
      ),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgSort,
          margin: EdgeInsets.only(
            top: 44.h,
            bottom: 22.h,
          ),
        ),
        AppbarTrailingImage(
          imagePath: ImageConstant.imgFilter,
          margin: EdgeInsets.fromLTRB(8.h, 44.h, 15.h, 22.h),
        )
      ],
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildMoverlist(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, _) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              MoverItemModel model = ref.watch(hireMoverNotifier).hireMoverModelObj?.moverItemList[index] ?? MoverItemModel();
              return GestureDetector(
                onTap: () {
                  NavigatorService.pushNamed(AppRoutes.hireMoverScreenOne);
                },
                child: MoverItemWidget(
                  model,
                ),
              );
            }, 
            separatorBuilder: (context, index) {
              return SizedBox(height: 8.h,);
            }, 
            itemCount: ref.watch(hireMoverNotifier).hireMoverModelObj?.moverItemList.length ?? 0,
          );
        }
      ),
    );
  }

  // Navigates back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }
}
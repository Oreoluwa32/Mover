import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/deposit_item_model.dart';
import 'notifier/deposit_notifier.dart';
import 'widgets/deposit_item_widget.dart';
import '../deposit_bottomsheet/deposit_bottomsheet.dart';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  DepositScreenState createState() => DepositScreenState();
}

class DepositScreenState extends ConsumerState<DepositScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: _buildAppbar(context),
      body: Padding(
          padding: EdgeInsets.only(top: 24.h),
          child: Consumer(
            builder: (context, ref, _) {
              return ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DepositItemModel model = ref
                            .watch(depositNotifier)
                            .depositModelObj
                            ?.depositItemList[index] ??
                        DepositItemModel();
                    return DepositItemWidget(model, onTapCard: () {
                      onTapCard(context);
                    });
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 15.h,
                    );
                  },
                  itemCount: ref
                          .watch(depositNotifier)
                          .depositModelObj
                          ?.depositItemList
                          .length ??
                      0);
            },
          ),
        ),
      );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 92.h,
      leadingWidth: 24.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeftBlack,
        margin: EdgeInsets.only(left: 16.h, top: 44.h, bottom: 24.h),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Deposit",
        margin: EdgeInsets.only(top: 34.h, bottom: 23.h),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Navigates back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }

  // onTapCard(BuildContext context) {
  //   showModalBottomSheet(
  //                       context: context, 
  //                       builder: (_) => DepositBottomsheet(),
  //                       isScrollControlled: true,
  //                       isDismissible: true
  //                     );
  // }

  onTapCard(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.depositScreenTwo);
  }
}

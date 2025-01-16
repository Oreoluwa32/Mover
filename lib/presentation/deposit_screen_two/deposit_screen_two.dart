import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/deposit_item_two_model.dart';
import 'notifier/deposit_two_notifier.dart';
import 'widgets/deposit_item_two_widget.dart';

class DepositScreenTwo extends ConsumerStatefulWidget {
  const DepositScreenTwo({Key? key}) : super(key: key);

  @override
  DepositScreenTwoState createState() => DepositScreenTwoState();
}

class DepositScreenTwoState extends ConsumerState<DepositScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppbar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 16.h, top: 22.h, right: 16.h),
                child: Column(
                  children: [
                    _buildAmount(context),
                    SizedBox(
                      height: 70.h,
                    ),
                    _buildDivider(context),
                    SizedBox(
                      height: 4.h,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: _buildButtonnav(context),
      ),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 92.h,
      leadingWidth: 24.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeft,
        margin: EdgeInsets.only(left: 16.h, top: 44.h, bottom: 24.h),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Debit/Credit Card",
        margin: EdgeInsets.only(top: 44.h, bottom: 23.h),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildAmount(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Amount",
            style: CustomTextStyles.labelLargeGray600,
          ),
          SizedBox(
            height: 4.h,
          ),
          Consumer(
            builder: (context, ref, _) {
              return CustomTextFormField(
                controller: ref.watch(depositTwoNotifier).amountController,
                hintText: "NGN",
                hintStyle: theme.textTheme.bodySmall!,
                textInputAction: TextInputAction.done,
                contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
              );
            },
          )
        ],
      ),
    );
  }

  // Section Wigdet
  Widget _buildDivider(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Divider(
                      thickness: 1.h,
                      color: appTheme.blueGray10002,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Choose payment card",
                    style: CustomTextStyles.labelLargeGray800,
                  ),
                ),
                SizedBox(
                  width: 10.h,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Divider(
                      thickness: 1.h,
                      color: appTheme.blueGray10002,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 22.h,
          ),
          Consumer(
            builder: (context, ref, _) {
              return ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DepositItemTwoModel model = ref
                            .watch(depositTwoNotifier)
                            .depositModelTwoObj
                            ?.depositItemTwoList[index] ??
                        DepositItemTwoModel();
                    return DepositItemTwoWidget(
                      model,
                      changeRadioBtn: (value) {
                        ref
                            .read(depositTwoNotifier.notifier)
                            .changeRadioBtn(index, value);
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 16.h,
                    );
                  },
                  itemCount: ref
                          .watch(depositTwoNotifier)
                          .depositModelTwoObj
                          ?.depositItemTwoList
                          .length ??
                      0);
            },
          ),
          SizedBox(
            height: 22.h,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgPurplePlus,
                  height: 18.h,
                  width: 18.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "Add Debit/Credit Card",
                    style: CustomTextStyles.labelLargePurple900,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildButtonnav(BuildContext context) {
    return Container(
      height: 98.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 24.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: appTheme.blueGray10002,
            width: 1.h,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomElevatedButton(
            text: "Deposit",
            buttonStyle: CustomButtonStyles.fillBlueGray,
          )
        ],
      ),
    );
  }

  // Navigates back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }
}

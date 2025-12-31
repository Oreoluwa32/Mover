import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../presentation/quick_deposit_bottomsheet/quick_deposit_bottomsheet.dart';
import 'models/balance_item_model.dart';
import 'models/month_trans_item_model.dart';
import 'models/transaction_item_model.dart';
import 'notifier/trans_history_notifier.dart';
import 'widgets/balance_item_widget.dart';
import 'widgets/month_trans_item_widget.dart';
import 'widgets/transaction_item_widget.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget{
  const TransactionHistoryScreen({Key? key})
    : super(key: key);

  @override
  TransactionHistoryScreenState createState() => TransactionHistoryScreenState();
}

class TransactionHistoryScreenState extends ConsumerState<TransactionHistoryScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: _buildAppbar(context),
      body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  _buildBalance(context),
                  SizedBox(height: 24.h),
                  _buildButtons(context),
                  SizedBox(height: 26.h),
                  _buildMonthTrans(context),
                  SizedBox(height: 14.h,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.h),
                      child: Text(
                        "Dec 2024",
                        style: CustomTextStyles.bodySmallErrorContainer,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  _buildTrans(context),
                ],
              ),
            ),
          ),
        ),
      );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 55.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeftBlack,
        margin: EdgeInsets.only(
          left: 16.h
        ),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Wallet",
        margin: EdgeInsets.only(
          top: 20.h,
          bottom: 30.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildBalance(BuildContext context) {
    return Container(
      height: 146.h,
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Consumer(
            builder: (context, ref, _) {
              return CarouselSlider.builder(
                options: CarouselOptions(
                  height: 146.h,
                  initialPage: 0,
                  viewportFraction: 1.0,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    ref.read(transHistoryNotifier.notifier).changeSliderIndex(index);
                  },
                ),
                itemCount: ref.watch(transHistoryNotifier).transactionHistoryModelObj?.balanceList.length ?? 0,
                itemBuilder: (context, index, realIndex) {
                  BalanceItemModel model = ref.watch(transHistoryNotifier).transactionHistoryModelObj?.balanceList[index] ?? BalanceItemModel();
                  return BalanceItemWidget(model);
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Consumer(builder: (context, ref, _) {
              return Container(
                height: 6.h,
                margin: EdgeInsets.only(bottom: 24.h),
                child: AnimatedSmoothIndicator(
                  activeIndex: ref.watch(transHistoryNotifier).sliderIndex,
                  count: ref.watch(transHistoryNotifier).transactionHistoryModelObj?.balanceList.length ?? 0,
                  axisDirection: Axis.horizontal,
                  effect: ScrollingDotsEffect(
                    spacing: 4,
                    activeDotColor: theme.colorScheme.onPrimary,
                    dotColor: theme.colorScheme.onPrimary.withValues(alpha: 0.4),
                    dotHeight: 6.h,
                    dotWidth: 6.h,
                  ),
                ),
              );
            },),
          )
        ],
      )
    );
  }

  // Section Widget
  Widget _buildMonthTrans(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: Text(
              "Transactions",
              style: CustomTextStyles.bodySmallErrorContainer,
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: Text(
              "Jan",
              style: CustomTextStyles.bodySmallErrorContainer,
            ),
          ),
          SizedBox(height: 4.h),
          Consumer(
            builder: (context, ref, _) {
              return ListView.separated(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  MonthTransItemModel model = ref.watch(transHistoryNotifier).transactionHistoryModelObj?.monthTransList[index] ?? MonthTransItemModel();
                  return MonthTransItemWidget(
                    model,
                  );
                }, 
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8.h);
                }, 
                itemCount: ref.watch(transHistoryNotifier).transactionHistoryModelObj?.monthTransList.length ?? 0,
              );
            }
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildTrans(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            TransactionItemModel model = ref.watch(transHistoryNotifier).transactionHistoryModelObj?.transactionList[index] ?? TransactionItemModel();
            return TransactionItemWidget(
              model,
            );
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0.h),
              child: Divider(
                height: 1.h,
                thickness: 1.h,
                color: appTheme.gray200,
              ),
            );
          },
          itemCount: ref.watch(transHistoryNotifier).transactionHistoryModelObj?.transactionList.length ?? 0,
        );
      },
    );
  }

  // Section Widget
  Widget _buildButtons(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
        children: [
          Expanded(
            child: CustomElevatedButton(
              text: "Deposit",
              leftIcon: Container(
                padding: EdgeInsets.all(8.h),
                margin: EdgeInsets.only(right: 8.h),
                decoration: BoxDecoration(
                  color: appTheme.deepPurple50,
                  borderRadius: BorderRadius.circular(16.h)
                ),
                child: CustomImageView(
                  imagePath: ImageConstant.imgPurpleCirclePlus,
                  height: 14.h,
                  width: 14.h,
                  fit: BoxFit.contain,
                ),
              ),
              buttonStyle: CustomButtonStyles.fillGray,
              buttonTextStyle: CustomTextStyles.titleSmallInterPrimary,
              onPressed: () {
                // ✅ NEW: Show quick deposit bottom sheet immediately
                _showQuickDepositSheet(context);
              },
            ),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: CustomElevatedButton(
              text: "Withdraw",
              leftIcon: Container(
                padding: EdgeInsets.all(8.h),
                margin: EdgeInsets.only(right: 8.h),
                decoration: BoxDecoration(
                  color: appTheme.indigo5002,
                  borderRadius: BorderRadius.circular(16.h)
                ),
                child: CustomImageView(
                  imagePath: ImageConstant.imgBlueCirclePLus,
                  height: 14.h,
                  width: 14.h,
                  fit: BoxFit.contain,
                ),
              ),
              buttonStyle: CustomButtonStyles.fillGrayTL8,
              buttonTextStyle: CustomTextStyles.titleSmallInterPrimaryIndigo500,
              onPressed: () {
                NavigatorService.pushNamed(AppRoutes.depositScreen);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Navigates back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }

  /// ✅ NEW: Show quick deposit bottom sheet
  /// Displays amount and email input, then navigates directly to payment WebView
  void _showQuickDepositSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const QuickDepositBottomsheet(),
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
    );
  }
}
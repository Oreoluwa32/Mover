import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
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
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(top: 8.h),
              child: Column(
                children: [
                  SizedBox(height: 14.h),
                  _buildBalance(context),
                  SizedBox(height: 12.h),
                  _buildMonthTrans(context),
                  SizedBox(height: 12.h),
                  _buildTrans(context)
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildButtons(context),
      ),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 92.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeftBlack,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 44.h,
          bottom: 24.h,
        ),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Wallet",
        margin: EdgeInsets.only(
          top: 44.h,
          bottom: 23.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildBalance(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            child: Consumer(
              builder: (context, ref, _) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 12.h,
                    children: List.generate(
                      ref.watch(transHistoryNotifier).transactionHistoryModelObj?.balanceList.length ?? 0,
                      (index) {
                        BalanceItemModel model = ref.watch(transHistoryNotifier).transactionHistoryModelObj?.balanceList[index] ?? BalanceItemModel();
                        return BalanceItemWidget(
                          model,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 26.h),
          Text(
            "Transactions",
            style: CustomTextStyles.bodySmallErrorContainer,
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildMonthTrans(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jan 2025",
                  style: CustomTextStyles.bodySmallErrorContainer,
                )
              ],
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
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dec 2024",
                  style: CustomTextStyles.bodySmallErrorContainer,
                )
              ],
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
                  TransactionItemModel model = ref.watch(transHistoryNotifier).transactionHistoryModelObj?.transactionList[index] ?? TransactionItemModel();
                  return TransactionItemWidget(
                    model,
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8.h);
                },
                itemCount: ref.watch(transHistoryNotifier).transactionHistoryModelObj?.transactionList.length ?? 0,
              );
            },
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildButtons(BuildContext context) {
    return Container(
      height: 92.h,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 24.h
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: appTheme.blueGray10002,
            width: 1.h,
          ),
        ),
      ),
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(
            child: CustomElevatedButton(
              height: 44.h,
              text: "Deposit",
              onPressed: () {
                NavigatorService.pushNamed(AppRoutes.depositScreen);
              },
            ),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: CustomElevatedButton(
              height: 44.h,
              text: "Withdraw",
            ),
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
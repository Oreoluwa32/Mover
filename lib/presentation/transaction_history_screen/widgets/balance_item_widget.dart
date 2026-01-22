import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/balance_item_model.dart';
import '../notifier/trans_history_notifier.dart';

// ignore for file, class must be immutable
class BalanceItemWidget extends ConsumerWidget {
  BalanceItemWidget(this.balanceItemModelObj, {Key? key})
    : super(
      key: key,
    );

  final BalanceItemModel balanceItemModelObj;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(transHistoryNotifier.select((s) => s.isBalanceVisible));
    
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      padding: EdgeInsets.symmetric(
        vertical: 24.h
      ),
      decoration: AppDecoration.fillBlack900.copyWith(borderRadius: BorderRadiusStyle.circleBorder14),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                balanceItemModelObj.title!,
                style: CustomTextStyles.bodyMediumWhiteA700,
              ),
              SizedBox(width: 8.h),
              CustomImageView(
                imagePath: isVisible ? ImageConstant.imgEye : ImageConstant.imgEyeClosed,
                height: 16.h,
                width: 16.h,
                onTap: () {
                  ref.read(transHistoryNotifier.notifier).toggleBalanceVisibility();
                },
              )
            ],
          ),
          Text(
            isVisible ? balanceItemModelObj.balance! : "****",
            style: CustomTextStyles.headlineLargeOnPrimary,
          ),
          SizedBox(height: 15.h,)
        ],
      ),
    );
  }
}
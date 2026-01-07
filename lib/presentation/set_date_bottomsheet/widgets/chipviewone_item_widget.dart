import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/days_item_model.dart';

class ChipviewoneItemWidget extends StatelessWidget {
  ChipviewoneItemWidget(this.daysItemModelObj, {Key? key, this.onSelectedDay})
      : super(
          key: key,
        );

  DaysItemModel daysItemModelObj;

  Function(bool)? onSelectedDay;

  @override
  Widget build(BuildContext context) {
    final isSelected = daysItemModelObj.isSelected ?? false;
    
    return GestureDetector(
      onTap: () {
        onSelectedDay?.call(!isSelected);
      },
      child: Container(
        width: 40.h,
        height: 40.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? appTheme.deepPurple600
              : appTheme.gray200,
        ),
        child: Center(
          child: Text(
            daysItemModelObj.days!,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : appTheme.blueGray800,
              fontSize: 14.fSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

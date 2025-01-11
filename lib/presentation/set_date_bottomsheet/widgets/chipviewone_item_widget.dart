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
    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
      ),
      child: RawChip(
        showCheckmark: false,
        labelPadding: EdgeInsets.zero,
        label: Text(
          daysItemModelObj.days!,
          style: TextStyle(
            color: appTheme.blueGray800,
            fontSize: 14.fSize,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        selected: (daysItemModelObj.isSelected ?? false),
        backgroundColor: Colors.transparent,
        selectedColor: Colors.transparent,
        side: BorderSide.none,
        onSelected: (value) {
          onSelectedDay?.call(value);
        },
      ),
    );
  }
}

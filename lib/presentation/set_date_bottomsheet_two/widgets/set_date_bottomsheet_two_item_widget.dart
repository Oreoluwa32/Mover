import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class SetDateBottomsheetTwoItemWidget extends StatelessWidget{
  const SetDateBottomsheetTwoItemWidget({Key? key})
    : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 14.h,
        right: 4.h,
      ),
      decoration: BoxDecoration(borderRadius: BorderRadiusStyle.roundedBorder8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "2",
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            "3",
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            "4",
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            "5",
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            "6",
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            "7",
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            "8",
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
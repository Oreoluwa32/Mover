import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class ChipviewoneItemWidget extends StatelessWidget{
  const ChipviewoneItemWidget({Key? key})
    : super(key: key,);

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
          "S",
          style: TextStyle(
            color: appTheme.blueGray800,
            fontSize: 14.fSize,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        selected: false,
        backgroundColor: Colors.transparent,
        selectedColor: Colors.transparent,
        side: BorderSide.none,
        onSelected: (value) {},
      ),
    );
  }
}
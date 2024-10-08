import 'package:flutter/material.dart';
import 'package:new_project/widgets/custom_bottom_bar.dart';
import '../../core/app_export.dart';

class AppbarTitle extends StatelessWidget{
  AppbarTitle({Key? key, required this.text, this.margin, this.onTap})
    : super(
        key: key,
    );

  final String text;
  final EdgeInsetsGeometry? margin;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Text(
          text,
          style: theme.textTheme.titleMedium!.copyWith(
            color: appTheme.gray80001,
          ),
        ),
      ),
    );
  }
}
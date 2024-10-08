import 'package:flutter/material.dart';
import 'package:new_project/widgets/custom_bottom_bar.dart';
import '../../core/app_export.dart';

class AppbarSubtitle extends StatelessWidget{
  AppbarSubtitle({Key? key, required this.text, this.margin, this.onTap})
    : super(
        key: key,
    );

  final String text;
  final EdgeInsetsGeometry? margin;
  final Function? onTap;

  @override
  Widget build (BuildContext context){
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Text(
          text,
          style: CustomTextStyles.titleMediumOnPrimaryContainer.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
          ),
        ),
      ),
    );
  }
}
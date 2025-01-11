import 'package:flutter/material.dart';
import '../../core/app_export.dart';

enum Style {bgOutline_1, bgOutline, bgFill}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  CustomAppBar(
    {
      Key? key,
      this.height,
      this.styleType,
      this.leadingWidth,
      this.leading,
      this.title,
      this.centerTitle,
      this.actions
    }
  ) : super(key: key,);

  final double? height;
  final Style? styleType;
  final double? leadingWidth;
  final Widget? leading;
  final Widget? title;
  final bool? centerTitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: height ?? 24.h,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: _getStyle(),
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
    SizeUtils.width,
    height ?? 24.h,
  );
  _getStyle(){
    switch (styleType){
      case Style.bgOutline_1:
        return Container(
          height: 92.h,
          width: 374.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withOpacity(1),
            border: Border(
              bottom: BorderSide(
                color: appTheme.gray20001,
                width: 1.h,
              ),
            ),
          ),
        );
      case Style.bgOutline:
        return Container(
          height: 90.h,
          width: 374.h,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: appTheme.gray20001,
                width: 1.h,
              ),
            ),
          ),
        );
      case Style.bgFill:
        return Container(
          height: 90.h,
          width: 374.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withOpacity(1)
          ),
        );
      default:
        return null;
    }
  }
}
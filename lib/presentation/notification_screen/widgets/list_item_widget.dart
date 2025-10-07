import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/list_item_model.dart';

// ignore : must_be_immutable
class ListItemWidget extends StatelessWidget {
    ListItemWidget(this.listItemModelObj, {Key? key}) : super(key: key);

    ListItemModel listItemModelObj;

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
                horizontal: 10.h,
                vertical: 12.h
            ),
            decoration: AppDecoration.blue500.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder8
            ),
            child: Column(
                spacing: 6,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    SizedBox(height: 2.h,),
                    SizedBox(
                        width: double.maxFinite,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        listItemModelObj.time!,
                                        style: CustomTextStyles.bodySmallBlack90010,
                                    ),
                                ),
                                Container(
                                    height: 6.h,
                                    width: 6.h,
                                    decoration: BoxDecoration(
                                        color: appTheme.redA700,
                                        borderRadius: BorderRadius.circular(3.h),
                                    ),
                                ),
                            ],
                        ),
                    ),
                    Text(
                        listItemModelObj.title!,
                        style: CustomTextStyles.labelLargeBlack900,
                    ),
                    SizedBox(
                        width: double.maxFinite,
                        child: Text(
                            listItemModelObj.message!,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.bodySmallBluegray400,
                        ),
                    ),
                ],
            ),
        );
    }
}
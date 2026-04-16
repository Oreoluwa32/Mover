import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/list_item_model.dart';

// ignore : must_be_immutable
class ListItemWidget extends StatelessWidget {
    ListItemWidget(
      this.listItemModelObj, {
      Key? key,
      this.onTap,
    }) : super(key: key);

    ListItemModel listItemModelObj;
    final VoidCallback? onTap;

    @override
    Widget build(BuildContext context) {
        final isUnread = listItemModelObj.isRead != true;

        return Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16.h),
                child: Ink(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.h,
                        vertical: 18.h,
                    ),
                    decoration: BoxDecoration(
                        color: isUnread ? const Color(0xFFF3EEFF) : Colors.white,
                        borderRadius: BorderRadius.circular(16.h),
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Expanded(
                                        child: Text(
                                            listItemModelObj.time ?? '',
                                            style: TextStyle(
                                                fontSize: 12.fSize,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xFF3D3D3D),
                                                height: 1.33,
                                            ),
                                        ),
                                    ),
                                    if (isUnread)
                                        Container(
                                            width: 10.h,
                                            height: 10.h,
                                            margin: EdgeInsets.only(top: 3.h),
                                            decoration: BoxDecoration(
                                                color: const Color(0xFFE62222),
                                                shape: BoxShape.circle,
                                            ),
                                        ),
                                ],
                            ),
                            SizedBox(height: 14.h),
                            Text(
                                listItemModelObj.title ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18.fSize,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1D1D1F),
                                    height: 1.22,
                                ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                                listItemModelObj.message ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14.fSize,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF666666),
                                    height: 1.43,
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}

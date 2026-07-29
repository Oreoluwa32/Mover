import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../models/saved_route_model.dart';

// Design tokens taken from Figma node 916:4061 so the card matches spec
// regardless of any drift in the shared theme.
class _RouteCardTokens {
  static const Color textPrimary = Color(0xFF414141); // Black/800
  static const Color textSecondary = Color(0xFF6D6D6D); // Black/500
  static const Color border = Color(0xFFE7E7E7); // Black/100
  static const Color liveRed = Color(0xFFE41212); // Red/Primary
}

class SavedrouteItemWidget extends StatelessWidget {
  SavedrouteItemWidget(
    this.savedrouteItemModelObj, {
    Key? key,
    this.onDelete,
    this.onTap,
  }) : super(key: key);

  final SavedRouteModel savedrouteItemModelObj;
  final Future<bool> Function()? onDelete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(savedrouteItemModelObj.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        if (onDelete == null) {
          return false;
        }
        final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Delete route?'),
              content: const Text(
                'This scheduled route will be removed from My Route.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
        if (shouldDelete != true) {
          return false;
        }
        return await onDelete!.call();
      },
      background: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: _RouteCardTokens.liveRed,
          borderRadius: BorderRadius.circular(8.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 20.h),
            SizedBox(width: 8.h),
            Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'Mulish',
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14.fSize,
              ),
            ),
          ],
        ),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.h),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.h),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.h),
              border: Border.all(color: _RouteCardTokens.border, width: 1.h),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitleRow(),
                SizedBox(height: 10.h),
                _buildDetailsRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            savedrouteItemModelObj.routetitle ?? '',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontWeight: FontWeight.w600,
              fontSize: 12.fSize,
              color: _RouteCardTokens.textPrimary,
              height: 1.2,
            ),
          ),
        ),
        if (savedrouteItemModelObj.islive ?? false) _buildLiveChip(),
      ],
    );
  }

  Widget _buildLiveChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 6.h,
            height: 6.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _RouteCardTokens.liveRed,
            ),
          ),
          SizedBox(width: 4.h),
          Text(
            'Live',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 10.fSize,
              color: _RouteCardTokens.liveRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                savedrouteItemModelObj.address ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w400,
                  fontSize: 10.fSize,
                  color: _RouteCardTokens.textSecondary,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  _buildMeta(
                    icon: ImageConstant.imgClock,
                    text: savedrouteItemModelObj.time ?? '',
                  ),
                  SizedBox(width: 10.h),
                  _buildMeta(
                    icon: ImageConstant.imgCalendar,
                    text: savedrouteItemModelObj.days ?? '',
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 8.h),
        CustomImageView(
          imagePath: ImageConstant.imgChevronRightBlack,
          height: 16.h,
          width: 16.h,
          color: _RouteCardTokens.textSecondary,
        ),
      ],
    );
  }

  Widget _buildMeta({required String icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: icon,
          height: 12.h,
          width: 12.h,
          color: _RouteCardTokens.textSecondary,
        ),
        SizedBox(width: 8.h),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Mulish',
            fontWeight: FontWeight.w400,
            fontSize: 10.fSize,
            color: _RouteCardTokens.textSecondary,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

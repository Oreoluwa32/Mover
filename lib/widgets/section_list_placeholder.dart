import 'package:flutter/material.dart';
import 'package:movr/core/app_export.dart';

class SectionListPlaceholder extends StatelessWidget {
  const SectionListPlaceholder({
    super.key,
    this.itemCount = 3,
    this.topSpacing,
  });

  final int itemCount;
  final double? topSpacing;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: topSpacing ?? 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (_, __) => Container(
        height: 118.h,
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: appTheme.gray10001,
          borderRadius: BorderRadius.circular(16.h),
          border: Border.all(
            color: appTheme.blueGray10001.withValues(alpha: 0.55),
            width: 1.h,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBar(widthFactor: 0.54),
            SizedBox(height: 14.h),
            _buildBar(widthFactor: 0.88),
            SizedBox(height: 10.h),
            _buildBar(widthFactor: 0.7),
            const Spacer(),
            Row(
              children: [
                Expanded(child: _buildBar(widthFactor: 1)),
                SizedBox(width: 12.h),
                SizedBox(
                  width: 76.h,
                  child: _buildBar(widthFactor: 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar({required double widthFactor}) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 12.h,
        decoration: BoxDecoration(
          color: appTheme.blueGray10001.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(999.h),
        ),
      ),
    );
  }
}

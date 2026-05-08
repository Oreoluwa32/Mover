import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/app_export.dart';

class MovrLoadingIndicator extends StatefulWidget {
  const MovrLoadingIndicator({
    super.key,
    this.size,
    this.label,
    this.labelStyle,
    this.alignment = MainAxisAlignment.center,
    this.spacing,
    this.colorFilter,
  });

  final double? size;
  final String? label;
  final TextStyle? labelStyle;
  final MainAxisAlignment alignment;
  final double? spacing;
  final ColorFilter? colorFilter;

  @override
  State<MovrLoadingIndicator> createState() => _MovrLoadingIndicatorState();
}

class _MovrLoadingIndicatorState extends State<MovrLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final indicator = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: SvgPicture.asset(
        ImageConstant.imgMovrLoader,
        height: widget.size ?? 64.h,
        width: widget.size ?? 64.h,
        fit: BoxFit.contain,
        colorFilter: widget.colorFilter,
      ),
    );

    if (widget.label == null || widget.label!.isEmpty) {
      return indicator;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.alignment,
      children: [
        indicator,
        SizedBox(height: widget.spacing ?? 12.h),
        Text(
          widget.label!,
          textAlign: TextAlign.center,
          style: widget.labelStyle ?? theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

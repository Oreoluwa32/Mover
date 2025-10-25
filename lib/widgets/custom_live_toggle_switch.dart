import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLiveToggleSwitch extends StatefulWidget {
  final bool value;
  final Function(bool) onChanged;
  final bool isDisabled;
  final Duration animationDuration;

  const CustomLiveToggleSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.isDisabled = false,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<CustomLiveToggleSwitch> createState() => _CustomLiveToggleSwitchState();
}

class _CustomLiveToggleSwitchState extends State<CustomLiveToggleSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );

    _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: Colors.grey.withValues(alpha: 0.3),
      end: const Color(0xFF6A19D3),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CustomLiveToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isDisabled) {
      widget.onChanged(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_slideAnimation, _colorAnimation]),
        builder: (context, child) {
          return Container(
            width: 56.h,
            height: 32.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.h),
              color: _colorAnimation.value ?? Colors.grey.withValues(alpha: 0.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4.h,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // OFF/ON Text background
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // OFF text (left side)
                      Opacity(
                        opacity: 1 - _slideAnimation.value,
                        child: Text(
                          'OFF',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6A19D3),
                          ),
                        ),
                      ),
                      // ON text (right side)
                      Opacity(
                        opacity: _slideAnimation.value,
                        child: Text(
                          'ON',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Sliding thumb
                Positioned(
                  left: 2.h + (_slideAnimation.value * (56.h - 34.h - 4.h)),
                  child: Container(
                    width: 28.h,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: _slideAnimation.value > 0.5 ? Colors.white : const Color(0xFF6A19D3),
                      borderRadius: BorderRadius.circular(14.h),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4.h,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
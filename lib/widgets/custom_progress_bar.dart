import 'dart:async';
import 'package:flutter/material.dart';

class CustomProgressBar extends StatefulWidget {
  final Duration duration;
  final Color backgroundColor;
  final Color valueColor;
  final VoidCallback? onCompleted; // Callback when animation completes

  const CustomProgressBar({
    Key? key,
    required this.duration,
    required this.backgroundColor,
    required this.valueColor,
    this.onCompleted,
  }) : super(key: key);

  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  double _progress = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        Duration(milliseconds: (widget.duration.inMilliseconds / 100).round()),
        (timer) {
      setState(() {
        _progress += 0.1;
        if (_progress >= 1.0) {
          timer.cancel();
          widget.onCompleted?.call();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: _progress,
      backgroundColor: widget.backgroundColor,
      valueColor: AlwaysStoppedAnimation<Color>(widget.valueColor),
    );
  }
}

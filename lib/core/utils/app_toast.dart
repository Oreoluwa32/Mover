import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum AppToastType {
  info,
  success,
  error,
}

class AppToast {
  static void show(
    String message, {
    AppToastType type = AppToastType.info,
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    final normalizedMessage = message.trim();
    if (normalizedMessage.isEmpty) {
      return;
    }

    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: normalizedMessage,
      toastLength: toastLength,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: _backgroundColor(type),
      textColor: Colors.white,
      fontSize: 14,
      timeInSecForIosWeb: toastLength == Toast.LENGTH_LONG ? 4 : 2,
    );
  }

  static void info(String message, {Toast toastLength = Toast.LENGTH_SHORT}) {
    show(
      message,
      type: AppToastType.info,
      toastLength: toastLength,
    );
  }

  static void success(
    String message, {
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    show(
      message,
      type: AppToastType.success,
      toastLength: toastLength,
    );
  }

  static void error(String message, {Toast toastLength = Toast.LENGTH_SHORT}) {
    show(
      message,
      type: AppToastType.error,
      toastLength: toastLength,
    );
  }

  static Color _backgroundColor(AppToastType type) {
    switch (type) {
      case AppToastType.success:
        return const Color(0xFF15803D);
      case AppToastType.error:
        return const Color(0xFFB42318);
      case AppToastType.info:
        return const Color(0xFF2B2F38);
    }
  }
}

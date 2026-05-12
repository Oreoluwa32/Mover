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

    Fluttertoast.showToast(
      msg: normalizedMessage,
      toastLength: toastLength,
      gravity: ToastGravity.BOTTOM,
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
}

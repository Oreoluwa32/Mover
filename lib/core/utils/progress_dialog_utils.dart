import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore for file, class must be immutable
class ProgressDialogUtils {
  static bool isProgressVisible = false;

  static String lottiePath = 'assets/lottieFiles/img_movr.json';

  // Displays a progress dialog with a lottie animation 
  // The [isCancellable] parameter is used to determine if the dialog can be cancelled by tapping outside the dialog area. If set to true, the dialog can be cancelled by tapping outside the dialog area, otherwise, the dialog cannot be cancelled by tapping outside the dialog area.
  // If the progress dialog is already visible, it will not be displayed again.
  // The lottie animation used in the dialog is loaded from the specified path
  // This method uses the `showDialog` function from the flutter framework to display the dialog
  static void showProgressDialog({bool isCancellable = false}) {}

  // Hides the progress dialog if it is visible
  // If a progress dialog is visible, the function dismisses it by calling Navigator.Pop with the overlay context obtained from the NavigatorService.navigatorKey

  // After hiding the dialog, the isProgressVisible flag is set to false.
  static void hideProgressDialog() {
    if (isProgressVisible) {}
    isProgressVisible = false;
  }
}
part of 'scan_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class ScanState extends Equatable {
  ScanState({this.codeController, this.scanModelObj});

  TextEditingController? codeController;

  ScanModel? scanModelObj;

  @override
  List<Object?> get props => [codeController, scanModelObj];
  ScanState copyWith({
    TextEditingController? codeController,
    ScanModel? scanModelObj,
  }) {
    return ScanState(
      codeController: codeController ?? this.codeController,
      scanModelObj: scanModelObj ?? this.scanModelObj,
    );
  }

}
part of 'scan_notifier.dart';

// Represents the state of the scan in the app
// ignore for file, class must be immutable
class ScanState extends Equatable {
  ScanState({this.scanModelObj});

  ScanModel? scanModelObj;

  @override
  List<Object?> get props => [scanModelObj];
  ScanState copyWith({ScanModel? scanModelObj}) {
    return ScanState(scanModelObj: scanModelObj ?? this.scanModelObj);
  }
}

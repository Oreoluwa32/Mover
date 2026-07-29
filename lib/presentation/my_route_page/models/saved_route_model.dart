import '../../../core/app_export.dart';

// This class is used in the screen
// ignore for file, class must be immutable
class SavedRouteModel {
  SavedRouteModel(
      {this.routetitle,
      this.liveDot,
      this.islive,
      this.status,
      this.address,
      this.time,
      this.days,
      this.id,
      this.departureTime}) {
    routetitle = routetitle ?? "";
    liveDot = liveDot ?? false;
    islive = islive ?? false;
    status = status ?? "";
    address = address ?? "";
    time = time ?? "";
    days = days ?? "";
    id = id ?? "";
  }

  String? routetitle;
  bool? islive;
  bool? liveDot;
  String? status;
  String? address;
  String? time;
  String? days;
  String? id;
  // Raw departure DateTime kept so the edit sheet can preselect the current
  // value and preserve the original date when only the time changes.
  DateTime? departureTime;
}

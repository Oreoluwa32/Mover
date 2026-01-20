import '../../../core/app_export.dart';

// This class is used in the screen
// ignore for file, class must be immutable
class SavedRouteModel {
  SavedRouteModel(
      {this.routetitle,
      this.liveDot,
      this.islive,
      this.address,
      this.time,
      this.days,
      this.id}) {
    routetitle = routetitle ?? "";
    liveDot = liveDot ?? false;
    islive = islive ?? false;
    address = address ?? "";
    time = time ?? "";
    days = days ?? "";
    id = id ?? "";
  }

  String? routetitle;
  bool? islive;
  bool? liveDot;
  String? address;
  String? time;
  String? days;
  String? id;
}

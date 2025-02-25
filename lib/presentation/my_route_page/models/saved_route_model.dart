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
    routetitle = routetitle ?? "Work Route";
    liveDot = liveDot ?? true;
    islive = islive ?? true;
    address = address ?? "Gateway Zone, Magodo Phase II, GRA Lagos State";
    time = time ?? "7:30AM";
    days = days ?? "Mon - Fri";
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

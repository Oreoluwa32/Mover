import '../../../core/app_export.dart';

// This class is used in the screen
// ignore for file, class must be immuatble
class MoversItemModel {
  MoversItemModel(
      {this.name,
      this.time,
      this.distance,
      this.vehicle,
      this.plateNum,
      this.seats,
      this.price,
      this.id}) {
    name = name ?? "Jane Doe";
    time = time ?? "Leaving 7:30 AM";
    distance = distance ?? "4km away";
    vehicle = vehicle ?? "Toyota Camry";
    plateNum = plateNum ?? "EKY453YB";
    seats = seats ?? "3 passengers capacity";
    price = price ?? "₦700";
    id = id ?? "";
  }

  String? name;
  String? time;
  String? distance;
  String? vehicle;
  String? plateNum;
  String? seats;
  String? price;
  String? id;
}

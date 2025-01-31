import '../../../core/app_export.dart';

// This class is used in the activity in progress page to define the properties of the progress item model and is used to hold data that is passed between the different layers of the application
// ignore for file, class must be immutable
class ProgressItemModel {
  ProgressItemModel({
    this.icon,
    this.address,
    this.date,
    this.time,
    this.status,
    this.moverName,
    this.rating,
    this.price,
    this.id
  }) {
    icon = icon ?? ImageConstant.imgPackageBlack;
    address = address ?? "Lagos, Nigeria";
    date = date ?? "13 Jan";
    time = time ?? "12:00";
    status = status ?? "In progress";
    moverName = moverName ?? "John Doe";
    rating = rating ?? "No ratings or reviews";
    price = price ?? "₦2000.00";
    id = id ?? "";
  }

  String? icon;
  String? address;
  String? date;
  String? time;
  String? status;
  String? moverName;
  String? rating;
  String? price;
  String? id;
}
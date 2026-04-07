import '../../../core/app_export.dart';

class ScheduledItemModel {
  ScheduledItemModel({
    this.icon,
    this.address,
    this.pickupLocation,
    this.destinationLocation,
    this.date,
    this.time,
    this.status,
    this.moverName,
    this.rating,
    this.price,
    this.id,
    this.requestId,
    this.requestType,
    this.scheduledAt,
  }) {
    icon = icon ?? ImageConstant.imgPackageBlack;
    address = address ?? "Lagos, Nigeria";
    pickupLocation = pickupLocation ?? "Pickup";
    destinationLocation = destinationLocation ?? "Destination";
    date = date ?? "13 Jan";
    time = time ?? "12:00";
    status = status ?? "Scheduled";
    moverName = moverName ?? "John Doe";
    rating = rating ?? "No ratings or reviews";
    price = price ?? "NGN 2000.00";
    id = id ?? "";
    requestId = requestId ?? "";
    requestType = requestType ?? "delivery";
    scheduledAt = scheduledAt ?? "";
  }

  String? icon;
  String? address;
  String? pickupLocation;
  String? destinationLocation;
  String? date;
  String? time;
  String? status;
  String? moverName;
  String? rating;
  String? price;
  String? id;
  String? requestId;
  String? requestType;
  String? scheduledAt;
}

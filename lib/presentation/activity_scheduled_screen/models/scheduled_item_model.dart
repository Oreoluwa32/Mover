import '../../../core/app_export.dart';

class ScheduledItemModel {
  ScheduledItemModel({
    this.icon,
    this.address,
    this.pickupLocation,
    this.destinationLocation,
    this.pickupLatitude,
    this.pickupLongitude,
    this.destinationLatitude,
    this.destinationLongitude,
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
    this.hasPricedOffers,
    this.hasAcceptedMover,
    this.offerCount,
    this.requestData,
    this.matchId,
    this.matchStatus,
    this.isMoverSide,
  }) {
    icon = icon ?? ImageConstant.imgPackageBlack;
    address = address ?? "Lagos, Nigeria";
    pickupLocation = pickupLocation ?? "Pickup";
    destinationLocation = destinationLocation ?? "Destination";
    pickupLatitude = pickupLatitude ?? 0;
    pickupLongitude = pickupLongitude ?? 0;
    destinationLatitude = destinationLatitude ?? 0;
    destinationLongitude = destinationLongitude ?? 0;
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
    hasPricedOffers = hasPricedOffers ?? false;
    hasAcceptedMover = hasAcceptedMover ?? false;
    offerCount = offerCount ?? 0;
    requestData = requestData ?? const <String, dynamic>{};
    matchId = matchId ?? "";
    matchStatus = matchStatus ?? "";
    isMoverSide = isMoverSide ?? false;
  }

  String? icon;
  String? address;
  String? pickupLocation;
  String? destinationLocation;
  double? pickupLatitude;
  double? pickupLongitude;
  double? destinationLatitude;
  double? destinationLongitude;
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
  bool? hasPricedOffers;
  bool? hasAcceptedMover;
  int? offerCount;
  Map<String, dynamic>? requestData;
  String? matchId;
  String? matchStatus;
  bool? isMoverSide;
}

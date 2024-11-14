import '../../../core/app_export.dart';

// This class is used in the screen
// ignore for file, must be immutable
class MoverItemModel {
  MoverItemModel({
    this.profileImage,
    this.moverName,
    this.homeAway,
    this.distance,
    this.vehicleType,
    this.price,
    this.id
  }) {
    profileImage = profileImage ?? ImageConstant.imgProfile;
    moverName = moverName ?? "John Doe";
    homeAway = homeAway ?? ImageConstant.imgHomeIcon;
    distance = distance ?? "2km away";
    vehicleType = vehicleType ?? ImageConstant.imgBike;
    price = price ?? "₦1000";
    id = id ?? "";
  }

  String? profileImage;
  String? moverName;
  String? homeAway;
  String? distance;
  String? vehicleType;
  String? price;
  String? id;
}
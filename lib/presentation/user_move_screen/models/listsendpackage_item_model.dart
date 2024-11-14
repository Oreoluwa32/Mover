import '../../../core/app_export.dart';

// This class is used in the list send package item widget screen
// ignore for file, must be immutable
class ListsendpackageItemModel {
  ListsendpackageItemModel({
    this.title,
    this.description,
    this.titleImg,
    this.id
  }) {
    title = title ?? "Send a package";
    description = description ?? "Use the power of people's daily journeys to ensure swift and reliable deliveries.";
    titleImg = titleImg ?? ImageConstant.imgDeliveryBike;
    id = id ?? "";
  }

  String? title;
  String? description;
  String? titleImg;
  String? id;
}
import '../../../core/app_export.dart';

// This class is used in the screen
// ignore for file, class must be immutable
class DeliveryPickupItemModel {
  DeliveryPickupItemModel({this.icon, this.iconTitle, this.id}) {
    icon = icon ?? ImageConstant.imgChatSquare;
    iconTitle = iconTitle ?? "Chat";
    id = id ?? "";
  }

  String? icon;
  String? iconTitle;
  String? id;
}
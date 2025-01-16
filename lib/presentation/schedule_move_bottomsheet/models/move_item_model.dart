import '../../../core/app_export.dart';

// This class is used in the screen
// ignore for file, class must be immutable
class MoveItemModel {
  MoveItemModel(
      {this.serviceIcon, this.serviceTitle, this.serviceText, this.id}) {
    serviceIcon = serviceIcon ?? ImageConstant.imgDeliveryCar;
    serviceTitle = serviceTitle ?? "Delivery";
    serviceText = serviceText ??
        "Use people's daily journeys to ensure swift and reliable deliveries.";
    id = id ?? "";
  }

  String? serviceIcon;
  String? serviceTitle;
  String? serviceText;
  String? id;
}

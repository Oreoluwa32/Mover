import '../../../core/app_export.dart';

// This class is used in the screen
// ignore for file, class must be immutable
class AddRouteOneItemModel {
  AddRouteOneItemModel({
    this.meansImage,
    this.meansTitle,
    this.id,
    this.isSelected = false,
  }) {
    meansImage = meansImage ?? ImageConstant.imgWalkingMan;
    meansTitle = meansTitle ?? "Public";
    id = id ?? "";
  }

  String? meansImage;
  String? meansTitle;
  String? id;
  bool isSelected;
}
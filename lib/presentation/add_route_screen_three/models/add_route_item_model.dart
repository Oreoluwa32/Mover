import '../../../core/app_export.dart';

// This class is used in the screen
// ignore for file, class must be immutable
class AddRouteItemModel {
  AddRouteItemModel(
      {this.tabImage, this.tabTitle, this.id, this.isSelected = false}) {
    tabImage = tabImage ?? ImageConstant.imgWalkingMan;
    tabTitle = tabTitle ?? "Public";
    id = id ?? "";
  }

  String? tabImage;
  String? tabTitle;
  String? id;
  bool isSelected;
}

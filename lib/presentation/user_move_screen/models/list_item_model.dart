import '../../../core/app_export.dart';

// This class is used in the list item widget screen
// ignore for file, class must be immutable
class ListItemModel {
  ListItemModel({this.image, this.id}) {
    image = image ?? ImageConstant.imgAds1;
    id = id ?? "";
  }

  String? image;
  String? id;
}
import '../../../core/app_export.dart';

// This class is used in this screen
// ignore for file, class must be immutable
class DeliveryTaskItemModel {
  DeliveryTaskItemModel({this.selectPrice, this.id}) {
    selectPrice = selectPrice ?? "400";
    id = id ?? "";
  }

  String? selectPrice;
  String? id;
}

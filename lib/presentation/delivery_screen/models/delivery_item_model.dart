import '../../../core/app_export.dart';

// This class is used in the screen
// ignore for file, class must be immutable
class DeliveryItemModel {
  DeliveryItemModel({this.name, this.star, this.time, this.review, this.id}) {
    name = name ?? "Jessica Grace";
    star = star ?? "5.0";
    time = time ?? "1 hour ago";
    review = review ??
        "Prompt delivery and top-notch quality. Impressed with the speed and accuracy. The efficiency and speed at which he delivered the package was impressive.";
    id = id ?? "";
  }

  String? name;
  String? star;
  String? time;
  String? review;
  String? id;
}

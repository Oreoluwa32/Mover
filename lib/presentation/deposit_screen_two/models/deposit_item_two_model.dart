import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';

// This class is used in the screen
// ignore for file, class must be immutable
class DepositItemTwoModel extends Equatable {
  DepositItemTwoModel(
      {this.image, this.cardNum, this.cardType, this.radioBtn, this.id}) {
    image = image ?? ImageConstant.imgMastercard;
    cardNum = cardNum ?? "**** **** **** 1234";
    cardType = cardType ?? "Mastercard";
    radioBtn = radioBtn ?? false;
    id = id ?? "";
  }

  String? image;
  String? cardNum;
  String? cardType;
  bool? radioBtn;
  String? id;

  DepositItemTwoModel copyWith(
      {String? image,
      String? cardNum,
      String? cardType,
      bool? radioBtn,
      String? id}) {
    return DepositItemTwoModel(
        image: image ?? this.image,
        cardNum: cardNum ?? this.cardNum,
        cardType: cardType ?? this.cardType,
        radioBtn: radioBtn ?? this.radioBtn,
        id: id ?? this.id);
  }

  @override
  List<Object?> get props => [image, cardNum, cardType, radioBtn, id];
}

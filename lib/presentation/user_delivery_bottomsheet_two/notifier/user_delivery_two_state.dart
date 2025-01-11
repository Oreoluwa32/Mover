part of 'user_delivery_two_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class UserDeliveryTwoState extends Equatable {
  UserDeliveryTwoState(
      {this.userDeliveryTwoPinModelObj,
      this.userDeliveryTwoQrModelObj,
      this.userDeliveryTwoModelObj});

  UserDeliveryTwoPinModel? userDeliveryTwoPinModelObj;

  UserDeliveryTwoQrModel? userDeliveryTwoQrModelObj;

  UserDeliveryTwoModel? userDeliveryTwoModelObj;

  @override
  List<Object?> get props => [
        userDeliveryTwoPinModelObj,
        userDeliveryTwoQrModelObj,
        userDeliveryTwoModelObj
      ];
  UserDeliveryTwoState copyWith(
      {UserDeliveryTwoPinModel? userDeliveryTwoPinModelObj,
      UserDeliveryTwoQrModel? userDeliveryTwoQrModelObj,
      UserDeliveryTwoModel? userDeliveryTwoModelObj}) {
    return UserDeliveryTwoState(
        userDeliveryTwoPinModelObj:
            userDeliveryTwoPinModelObj ?? this.userDeliveryTwoPinModelObj,
        userDeliveryTwoQrModelObj:
            userDeliveryTwoQrModelObj ?? this.userDeliveryTwoQrModelObj,
        userDeliveryTwoModelObj:
            userDeliveryTwoModelObj ?? this.userDeliveryTwoModelObj);
  }
}

part of 'user_delivery_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class UserDeliveryState extends Equatable {
  UserDeliveryState(
      {this.userdeliveryqrTabModelObj,
      this.userdeliverypinTabModelObj,
      this.userDeliveryModelObj});

  UserDeliveryModel? userDeliveryModelObj;

  UserDeliveryQrtabModel? userdeliveryqrTabModelObj;

  UserDeliveryPintabModel? userdeliverypinTabModelObj;

  @override
  List<Object?> get props => [userdeliveryqrTabModelObj, userdeliverypinTabModelObj, userDeliveryModelObj];
  UserDeliveryState copyWith(
      {UserDeliveryQrtabModel? userdeliveryqrTabModelObj, 
      UserDeliveryPintabModel? userdeliverypinTabModelObj,
      UserDeliveryModel? userDeliveryModelObj}) {
    return UserDeliveryState(
        userdeliveryqrTabModelObj:
            userdeliveryqrTabModelObj ?? this.userdeliveryqrTabModelObj,
        userdeliverypinTabModelObj:
            userdeliverypinTabModelObj ?? this.userdeliverypinTabModelObj,
        userDeliveryModelObj:
            userDeliveryModelObj ?? this.userDeliveryModelObj);
  }
}

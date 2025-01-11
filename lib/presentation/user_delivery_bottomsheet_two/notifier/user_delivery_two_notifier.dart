import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/user_delivery_two_model.dart';
import '../models/user_delivery_two_pin_model.dart';
import '../models/user_delivery_two_qr_model.dart';
part 'user_delivery_two_state.dart';

final userDeliveryTwoNotifier = StateNotifierProvider.autoDispose<
    UserDeliveryTwoNotifier, UserDeliveryTwoState>(
  (ref) => UserDeliveryTwoNotifier(UserDeliveryTwoState(
    userDeliveryTwoPinModelObj: UserDeliveryTwoPinModel(),
    userDeliveryTwoQrModelObj: UserDeliveryTwoQrModel(),
  )),
);

// A notifier that manages the state of the screem according to the event that is dispatched to it
class UserDeliveryTwoNotifier extends StateNotifier<UserDeliveryTwoState> {
  UserDeliveryTwoNotifier(UserDeliveryTwoState state) : super(state);
}

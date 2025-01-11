import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/user_delivery_model.dart';
import '../models/user_delivery_qrtab_model.dart';
import '../models/user_delivery_pintab_model.dart';
part 'user_delivery_state.dart';

final userDeliveryNotifer =
    StateNotifierProvider.autoDispose<UserDeliveryNotifier, UserDeliveryState>(
  (ref) => UserDeliveryNotifier(UserDeliveryState(
    userdeliveryqrTabModelObj: UserDeliveryQrtabModel(),
    userdeliverypinTabModelObj: UserDeliveryPintabModel(),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class UserDeliveryNotifier extends StateNotifier<UserDeliveryState> {
  UserDeliveryNotifier(UserDeliveryState state) : super(state);
}

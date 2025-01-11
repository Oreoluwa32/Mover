import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/share_ride_payment_model.dart';
part 'share_ride_payment_state.dart';

final shareRidePaymentNotifier = StateNotifierProvider.autoDispose<
        ShareRidePaymentNotifier, ShareRidePaymentState>(
    (ref) => ShareRidePaymentNotifier(ShareRidePaymentState()));

// A notifier that manages the state of the screen according to the event that is dispatched to it
class ShareRidePaymentNotifier extends StateNotifier<ShareRidePaymentState> {
  ShareRidePaymentNotifier(ShareRidePaymentState state) : super(state);
}

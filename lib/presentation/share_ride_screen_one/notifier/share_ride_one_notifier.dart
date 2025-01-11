import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/share_ride_one_model.dart';
part 'share_ride_one_state.dart';

final shareRideOneNotifier =
    StateNotifierProvider.autoDispose<ShareRideOneNotifier, ShareRideOneState>(
        (ref) => ShareRideOneNotifier(ShareRideOneState()));

// A notifier that manages the state of the state according to the event that is dispatched to it
class ShareRideOneNotifier extends StateNotifier<ShareRideOneState> {
  ShareRideOneNotifier(ShareRideOneState state) : super(state);
}

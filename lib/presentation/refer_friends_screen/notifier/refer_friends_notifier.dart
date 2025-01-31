import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/refer_friends_model.dart';
part 'refer_friends_state.dart';

final referFriendsNotifier = StateNotifierProvider.autoDispose<ReferFriendsNotifier, ReferFriendsState>(
  (ref) => ReferFriendsNotifier(ReferFriendsState(
    codeController: TextEditingController()
  )),
);

// A notifier that manages the state of the refer friends screen
class ReferFriendsNotifier extends StateNotifier<ReferFriendsState>{
  ReferFriendsNotifier(ReferFriendsState state) : super(state);
}
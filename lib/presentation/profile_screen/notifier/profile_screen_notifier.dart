import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/profile_screen_model.dart';
part 'profile_screen_state.dart';

final profileScreenNotifier = StateNotifierProvider.autoDispose<ProfileScreenNotifier, ProfileScreenState>(
  (ref) => ProfileScreenNotifier(ProfileScreenState()),
);

// A notifier class that is used to manage the state of the profile screen according to the event that is dispatched to it
class ProfileScreenNotifier extends StateNotifier<ProfileScreenState>{
  ProfileScreenNotifier(ProfileScreenState state) : super(state);
}
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/identification_model.dart';
part 'identification_state.dart';

final identificationNotifier =
    StateNotifierProvider.autoDispose<IdentificationNotifier, IdentificationState>(
  (ref) => IdentificationNotifier(IdentificationState(
    ninController: TextEditingController(),
    bvnController: TextEditingController(),
  )),
);

class IdentificationNotifier extends StateNotifier<IdentificationState> {
  IdentificationNotifier(IdentificationState state) : super(state);
}

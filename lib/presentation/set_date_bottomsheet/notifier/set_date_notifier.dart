import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../models/days_item_model.dart';
import '../models/set_date_model.dart';
part 'set_date_state.dart';

final setDateNotifier =
    StateNotifierProvider.autoDispose<SetDateNotifier, SetDateState>(
  (ref) => SetDateNotifier(SetDateState(
    startDateController: TextEditingController(),
    endDateController: TextEditingController(),
    numberController: TextEditingController(),
    repeatDropdownValue: SelectionPopupModel(title: ''),
    setDateModelObj: SetDateModel(repeatDropdown: [
      SelectionPopupModel(id: 1, title: "Day", isSelected: true),
      SelectionPopupModel(
        id: 1,
        title: "Week",
      )
    ], daysOfWeek: [
      DaysItemModel(days: "S"),
      DaysItemModel(days: "M"),
      DaysItemModel(days: "T"),
      DaysItemModel(days: "W"),
      DaysItemModel(days: "T"),
      DaysItemModel(days: "F"),
      DaysItemModel(days: "S"),
    ]),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class SetDateNotifier extends StateNotifier<SetDateState> {
  SetDateNotifier(SetDateState state) : super(state);

  void onSelectedDays(int index, bool value) {
    List<DaysItemModel> daysList =
        List<DaysItemModel>.from(state.setDateModelObj!.daysOfWeek);
    daysList[index] = daysList[index].copyWith(isSelected: value);
    state = state.copyWith(
        setDateModelObj: state.setDateModelObj?.copyWith(daysOfWeek: daysList));
  }
}

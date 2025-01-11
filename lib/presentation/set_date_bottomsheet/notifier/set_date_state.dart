part of 'set_date_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class SetDateState extends Equatable {
  SetDateState(
      {this.startDateController,
      this.endDateController,
      this.numberController,
      this.repeatDropdownValue,
      this.setDateModelObj});

  TextEditingController? startDateController;
  TextEditingController? endDateController;
  TextEditingController? numberController;
  SelectionPopupModel? repeatDropdownValue;
  SetDateModel? setDateModelObj;

  @override
  List<Object?> get props => [
        startDateController,
        endDateController,
        numberController,
        repeatDropdownValue,
        setDateModelObj
      ];
  SetDateState copyWith({
    TextEditingController? startDateController,
    TextEditingController? endDateController,
    TextEditingController? numberController,
    SelectionPopupModel? repeatDropdownValue,
    SetDateModel? setDateModelObj,
  }) {
    return SetDateState(
        startDateController: startDateController ?? this.startDateController,
        endDateController: endDateController ?? this.endDateController,
        numberController: numberController ?? this.numberController,
        repeatDropdownValue: repeatDropdownValue ?? this.repeatDropdownValue,
        setDateModelObj: setDateModelObj ?? this.setDateModelObj);
  }
}

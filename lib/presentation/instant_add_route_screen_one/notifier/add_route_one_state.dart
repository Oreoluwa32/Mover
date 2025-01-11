part of 'add_route_one_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class AddRouteOneState extends Equatable {
  AddRouteOneState(
      {this.serviceTypeDropDownValue,
      this.setTimeController,
      this.radioGroup = "",
      this.setTime,
      this.addRouteOneModelObj});

  SelectionPopupModel? serviceTypeDropDownValue;
  TextEditingController? setTimeController;
  AddRouteOneModel? addRouteOneModelObj;
  String radioGroup;
  TimeOfDay? setTime;

  @override
  List<Object?> get props => [
        serviceTypeDropDownValue,
        setTimeController,
        radioGroup,
        setTime,
        addRouteOneModelObj
      ];
  AddRouteOneState copyWith({
    SelectionPopupModel? serviceTypeDropDownValue,
    TextEditingController? setTimeController,
    String? radioGroup,
    AddRouteOneModel? addRouteOneModelObj,
    TimeOfDay? setTime,
  }) {
    return AddRouteOneState(
        serviceTypeDropDownValue:
            serviceTypeDropDownValue ?? this.serviceTypeDropDownValue,
        setTimeController: setTimeController ?? this.setTimeController,
        radioGroup: radioGroup ?? this.radioGroup,
        setTime: setTime ?? this.setTime,
        addRouteOneModelObj: addRouteOneModelObj ?? this.addRouteOneModelObj);
  }
}

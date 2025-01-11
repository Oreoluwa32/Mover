part of 'add_route_one_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class AddRouteOneState extends Equatable{
  AddRouteOneState({
    this.serviceTypeDropDownValue,
    this.departureDropDownValue,
    this.radioGroup = "",
    this.addRouteOneModelObj
  });

  SelectionPopupModel? serviceTypeDropDownValue;
  SelectionPopupModel? departureDropDownValue;
  AddRouteOneModel? addRouteOneModelObj;
  String radioGroup;

  @override
  List<Object?> get props => [
    serviceTypeDropDownValue,
    departureDropDownValue,
    radioGroup,
    addRouteOneModelObj
  ];
  AddRouteOneState copyWith({
    SelectionPopupModel? serviceTypeDropDownValue,
    SelectionPopupModel? departureDropDownValue,
    String? radioGroup,
    AddRouteOneModel? addRouteOneModelObj,
  }) {
    return AddRouteOneState(
      serviceTypeDropDownValue: serviceTypeDropDownValue ?? this.serviceTypeDropDownValue,
      departureDropDownValue: departureDropDownValue ?? this.departureDropDownValue,
      radioGroup: radioGroup ?? this.radioGroup,
      addRouteOneModelObj: addRouteOneModelObj ?? this.addRouteOneModelObj
    );
  }
}
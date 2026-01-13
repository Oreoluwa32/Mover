part of 'add_route_one_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class AddRouteOneState extends Equatable {
  AddRouteOneState(
      {this.locationController,
      this.stopController,
      this.destinationController,
      this.serviceTypeDropDownValue,
      this.setTimeController,
      this.radioGroup = "",
      this.setTime,
      this.showStopField = false,
      this.addRouteOneModelObj,
      this.locationLat,
      this.locationLng,
      this.destinationLat,
      this.destinationLng});

  TextEditingController? locationController;
  TextEditingController? stopController;
  TextEditingController? destinationController;
  SelectionPopupModel? serviceTypeDropDownValue;
  TextEditingController? setTimeController;
  AddRouteOneModel? addRouteOneModelObj;
  String radioGroup;
  TimeOfDay? setTime;
  bool showStopField;
  double? locationLat;
  double? locationLng;
  double? destinationLat;
  double? destinationLng;

  @override
  List<Object?> get props => [
        locationController,
        stopController,
        destinationController,
        serviceTypeDropDownValue,
        setTimeController,
        radioGroup,
        setTime,
        showStopField,
        addRouteOneModelObj,
        locationLat,
        locationLng,
        destinationLat,
        destinationLng
      ];
  AddRouteOneState copyWith({
    TextEditingController? locationController,
    TextEditingController? stopController,
    TextEditingController? destinationController,
    SelectionPopupModel? serviceTypeDropDownValue,
    TextEditingController? setTimeController,
    String? radioGroup,
    AddRouteOneModel? addRouteOneModelObj,
    TimeOfDay? setTime,
    bool? showStopField,
    double? locationLat,
    double? locationLng,
    double? destinationLat,
    double? destinationLng,
  }) {
    return AddRouteOneState(
        locationController: locationController ?? this.locationController,
        stopController: stopController ?? this.stopController,
        destinationController: destinationController ?? this.destinationController,
        serviceTypeDropDownValue:
            serviceTypeDropDownValue ?? this.serviceTypeDropDownValue,
        setTimeController: setTimeController ?? this.setTimeController,
        radioGroup: radioGroup ?? this.radioGroup,
        setTime: setTime ?? this.setTime,
        showStopField: showStopField ?? this.showStopField,
        addRouteOneModelObj: addRouteOneModelObj ?? this.addRouteOneModelObj,
        locationLat: locationLat ?? this.locationLat,
        locationLng: locationLng ?? this.locationLng,
        destinationLat: destinationLat ?? this.destinationLat,
        destinationLng: destinationLng ?? this.destinationLng);
  }
}

part of 'ride_sharing_details_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class RideSharingDetailsState extends Equatable {
  RideSharingDetailsState(
      {this.selectedDropDownValue,
      this.originController,
      this.destinationController,
      this.radioGroup = "origin",
      this.destination = "",
      this.originLatitude,
      this.originLongitude,
      this.destinationLatitude,
      this.destinationLongitude,
      this.isFetchingLocation = false,
      this.rideSharingDetailsModelObj});

  SelectionPopupModel? selectedDropDownValue;
  TextEditingController? originController;
  TextEditingController? destinationController;
  RideSharingDetailsModel? rideSharingDetailsModelObj;
  String radioGroup;
  String destination;
  double? originLatitude;
  double? originLongitude;
  double? destinationLatitude;
  double? destinationLongitude;
  bool isFetchingLocation;

  @override
  List<Object?> get props =>
      [
        selectedDropDownValue,
        originController,
        destinationController,
        radioGroup,
        destination,
        originLatitude,
        originLongitude,
        destinationLatitude,
        destinationLongitude,
        isFetchingLocation,
        rideSharingDetailsModelObj,
      ];
  RideSharingDetailsState copyWith(
      {SelectionPopupModel? selectedDropDownValue,
      TextEditingController? originController,
      TextEditingController? destinationController,
      String? radioGroup,
      String? destination,
      double? originLatitude,
      double? originLongitude,
      double? destinationLatitude,
      double? destinationLongitude,
      bool? isFetchingLocation,
      RideSharingDetailsModel? rideSharingDetailsModelObj}) {
    return RideSharingDetailsState(
        selectedDropDownValue:
            selectedDropDownValue ?? this.selectedDropDownValue,
        originController: originController ?? this.originController,
        destinationController: destinationController ?? this.destinationController,
        radioGroup: radioGroup ?? this.radioGroup,
        destination: destination ?? this.destination,
        originLatitude: originLatitude ?? this.originLatitude,
        originLongitude: originLongitude ?? this.originLongitude,
        destinationLatitude: destinationLatitude ?? this.destinationLatitude,
        destinationLongitude: destinationLongitude ?? this.destinationLongitude,
        isFetchingLocation: isFetchingLocation ?? this.isFetchingLocation,
        rideSharingDetailsModelObj:
            rideSharingDetailsModelObj ?? this.rideSharingDetailsModelObj);
  }
}

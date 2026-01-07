part of 'ride_sharing_details_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class RideSharingDetailsState extends Equatable {
  RideSharingDetailsState(
      {this.selectedDropDownValue,
      this.destination = "",
      this.rideSharingDetailsModelObj});

  SelectionPopupModel? selectedDropDownValue;
  RideSharingDetailsModel? rideSharingDetailsModelObj;
  String destination;

  @override
  List<Object?> get props =>
      [selectedDropDownValue, destination, rideSharingDetailsModelObj];
  RideSharingDetailsState copyWith(
      {SelectionPopupModel? selectedDropDownValue,
      String? destination,
      RideSharingDetailsModel? rideSharingDetailsModelObj}) {
    return RideSharingDetailsState(
        selectedDropDownValue:
            selectedDropDownValue ?? this.selectedDropDownValue,
        destination: destination ?? this.destination,
        rideSharingDetailsModelObj:
            rideSharingDetailsModelObj ?? this.rideSharingDetailsModelObj);
  }
}

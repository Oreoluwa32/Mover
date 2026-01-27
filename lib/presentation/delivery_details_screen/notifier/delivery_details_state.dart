part of 'delivery_details_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immuatble
class DeliveryDetailsState extends Equatable {
  DeliveryDetailsState(
      {this.pickupController,
      this.destinationController,
      this.itemDescrController,
      this.nameController,
      this.phoneController,
      this.radioGroup = "",
      this.itemWeight = "",
      this.imagePath,
      this.pickupLatitude,
      this.pickupLongitude,
      this.destinationLatitude,
      this.destinationLongitude,
      this.isFetchingLocation = false,
      this.deliveryDetailsModelObj});

  TextEditingController? pickupController;
  TextEditingController? destinationController;
  TextEditingController? itemDescrController;
  TextEditingController? nameController;
  TextEditingController? phoneController;
  DeliveryDetailsModel? deliveryDetailsModelObj;
  String radioGroup;
  String itemWeight;
  String? imagePath;
  double? pickupLatitude;
  double? pickupLongitude;
  double? destinationLatitude;
  double? destinationLongitude;
  bool isFetchingLocation;

  @override
  List<Object?> get props => [
        pickupController,
        destinationController,
        itemDescrController,
        nameController,
        phoneController,
        radioGroup,
        itemWeight,
        imagePath,
        pickupLatitude,
        pickupLongitude,
        destinationLatitude,
        destinationLongitude,
        isFetchingLocation,
        deliveryDetailsModelObj
      ];
  DeliveryDetailsState copyWith({
    TextEditingController? pickupController,
    TextEditingController? destinationController,
    TextEditingController? itemDescrController,
    TextEditingController? nameController,
    TextEditingController? phoneController,
    String? radioGroup,
    String? itemWeight,
    String? imagePath,
    double? pickupLatitude,
    double? pickupLongitude,
    double? destinationLatitude,
    double? destinationLongitude,
    bool? isFetchingLocation,
    DeliveryDetailsModel? deliveryDetailsModelObj,
  }) {
    return DeliveryDetailsState(
      pickupController: pickupController ?? this.pickupController,
      destinationController:
          destinationController ?? this.destinationController,
      itemDescrController: itemDescrController ?? this.itemDescrController,
      nameController: nameController ?? this.nameController,
      phoneController: phoneController ?? this.phoneController,
      radioGroup: radioGroup ?? this.radioGroup,
      itemWeight: itemWeight ?? this.itemWeight,
      imagePath: imagePath ?? this.imagePath,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      destinationLatitude: destinationLatitude ?? this.destinationLatitude,
      destinationLongitude: destinationLongitude ?? this.destinationLongitude,
      isFetchingLocation: isFetchingLocation ?? this.isFetchingLocation,
      deliveryDetailsModelObj:
          deliveryDetailsModelObj ?? this.deliveryDetailsModelObj,
    );
  }
}

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
      deliveryDetailsModelObj:
          deliveryDetailsModelObj ?? this.deliveryDetailsModelObj,
    );
  }
}

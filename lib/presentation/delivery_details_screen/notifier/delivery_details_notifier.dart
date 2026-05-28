import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import '../../../core/app_export.dart';
import '../../../services/google_places_service.dart';
import '../../../services/google_places_service_provider.dart';
import '../models/delivery_details_model.dart';
import 'places_autocomplete_notifier.dart';
part 'delivery_details_state.dart';

final deliveryDetailsNotifier = StateNotifierProvider.autoDispose<
    DeliveryDetailsNotifier, DeliveryDetailsState>(
  (ref) {
    final placesService = ref.watch(googlePlacesServiceProvider);
    return DeliveryDetailsNotifier(
      DeliveryDetailsState(
        pickupController: TextEditingController(),
        destinationController: TextEditingController(),
        itemDescrController: TextEditingController(),
        nameController: TextEditingController(),
        phoneController: TextEditingController(),
        radioGroup: "",
        itemWeight: "",
      ),
      placesService,
    );
  },
);

// A notifier that manages the state of delivery details according to the event that is dispatched to it
class DeliveryDetailsNotifier extends StateNotifier<DeliveryDetailsState> {
  final GooglePlacesService _placesService;

  DeliveryDetailsNotifier(DeliveryDetailsState state, this._placesService)
      : super(state);

  void changeRadioButton(String value) {
    state = state.copyWith(radioGroup: value);
  }

  void changeRadioBtn(String value) {
    state = state.copyWith(radioGroup: value);
  }

  void changeRadioButton1(String value) {
    state = state.copyWith(itemWeight: value);
  }

  void onPickupChange(String value) {
    state = state.copyWith(pickupLatitude: null, pickupLongitude: null);
  }

  void onDestinationChange(String value) {
    state = state.copyWith(destinationLatitude: null, destinationLongitude: null);
  }

  void updateState() {
    state = state.copyWith();
  }

  // Update the state with the image path
  void uploadImage(String imagePath) {
    state = state.copyWith(imagePath: imagePath);
  }

  void setPickupLocation(String address, double lat, double lng) {
    state.pickupController?.text = address;
    state = state.copyWith(
      pickupLatitude: lat,
      pickupLongitude: lng,
    );
  }

  void setDestinationLocation(String address, double lat, double lng) {
    state.destinationController?.text = address;
    state = state.copyWith(
      destinationLatitude: lat,
      destinationLongitude: lng,
    );
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Set temporary text while fetching and set fetching state
    state.pickupController?.text = "Fetching current location...";
    state = state.copyWith(isFetchingLocation: true);

    locationData = await location.getLocation();

    if (locationData.latitude != null && locationData.longitude != null) {
      try {
        final address = await _placesService.getAddressFromLatLng(
          locationData.latitude!,
          locationData.longitude!,
        );

        if (address != null) {
          setPickupLocation(
            address,
            locationData.latitude!,
            locationData.longitude!,
          );
        } else {
          setPickupLocation(
            "Current Location",
            locationData.latitude!,
            locationData.longitude!,
          );
        }
      } catch (e) {
        setPickupLocation(
          "Current Location",
          locationData.latitude!,
          locationData.longitude!,
        );
      } finally {
        state = state.copyWith(isFetchingLocation: false);
      }
    } else {
      state = state.copyWith(isFetchingLocation: false);
    }
  }

  bool get isFormComplete {
    return !state.isFetchingLocation &&
        state.pickupController?.text.isNotEmpty == true &&
        state.pickupController?.text != "Fetching current location..." &&
        state.destinationController?.text.isNotEmpty == true &&
        state.itemDescrController?.text.isNotEmpty == true &&
        state.nameController?.text.isNotEmpty == true &&
        state.phoneController?.text.isNotEmpty == true &&
        state.itemWeight.isNotEmpty;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  void _resetPickupField({String? errorMessage}) {
    if (state.pickupController?.text == "Fetching current location...") {
      state.pickupController?.text = "";
    }
    state = state.copyWith(isFetchingLocation: false);
    if (errorMessage != null) {
      Fluttertoast.showToast(msg: errorMessage);
    }
  }

  Future<void> getCurrentLocation() async {
    final location = Location();

    try {
      var serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          _resetPickupField(
            errorMessage: "Turn on location services and try again.",
          );
          return;
        }
      }

      var permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
      }
      if (permissionGranted != PermissionStatus.granted) {
        _resetPickupField(
          errorMessage:
              "Location permission is required. Enable it in Settings.",
        );
        return;
      }

      // Nudge the location plugin toward a fast-ish fix so emulators and
      // low-power devices don't hang waiting for a high-accuracy reading.
      await location.changeSettings(
        accuracy: LocationAccuracy.balanced,
        interval: 1000,
      );

      state.pickupController?.text = "Fetching current location...";
      state = state.copyWith(isFetchingLocation: true);

      final locationData = await location.getLocation().timeout(
        const Duration(seconds: 12),
      );

      final lat = locationData.latitude;
      final lng = locationData.longitude;
      if (lat == null || lng == null) {
        _resetPickupField(
          errorMessage: "Couldn't read your location. Try again.",
        );
        return;
      }

      try {
        final address = await _placesService
            .getAddressFromLatLng(lat, lng)
            .timeout(const Duration(seconds: 8));
        setPickupLocation(address ?? "Current Location", lat, lng);
      } on TimeoutException {
        setPickupLocation("Current Location", lat, lng);
      } catch (_) {
        setPickupLocation("Current Location", lat, lng);
      } finally {
        state = state.copyWith(isFetchingLocation: false);
      }
    } on TimeoutException {
      _resetPickupField(
        errorMessage:
            "Location timed out. On an emulator, use ⏯ Extended Controls → Location → Set Location.",
      );
    } catch (e) {
      _resetPickupField(errorMessage: "Location error: $e");
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

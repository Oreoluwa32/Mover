import 'dart:async';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import '../../../core/app_export.dart';
import '../../../core/utils/location_manager.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../../services/google_places_service_provider.dart';
import '../models/add_route_one_item_model.dart';
import '../models/add_route_one_model.dart';
import 'places_autocomplete_notifier.dart';
part 'add_route_one_state.dart';

final addRouteOneNotifier =
    StateNotifierProvider.autoDispose<AddRouteOneNotifier, AddRouteOneState>(
  (ref) => AddRouteOneNotifier(ref, AddRouteOneState(
    locationController: TextEditingController(),
    stopController: TextEditingController(),
    destinationController: TextEditingController(),
    serviceTypeDropDownValue: SelectionPopupModel(title: ''),
    setTimeController: TextEditingController(),
    radioGroup: "",
    showStopField: false,
    addRouteOneModelObj: AddRouteOneModel(transportMeansList: [
      AddRouteOneItemModel(
          meansImage: ImageConstant.imgWalkingMan, meansTitle: "Public"),
      AddRouteOneItemModel(
          meansImage: ImageConstant.img3DBike, meansTitle: "Bike"),
      AddRouteOneItemModel(
          meansImage: ImageConstant.img3DCar, meansTitle: "Car"),
      AddRouteOneItemModel(
          meansImage: ImageConstant.img3DBus, meansTitle: "Bus"),
      AddRouteOneItemModel(
          meansImage: ImageConstant.img3DPlane, meansTitle: "Airplane"),
      AddRouteOneItemModel(
          meansImage: ImageConstant.img3DTrain, meansTitle: "Train"),
      AddRouteOneItemModel(
          meansImage: ImageConstant.img3DTruck, meansTitle: "Truck")
    ], serviceTypeDropdown: [
      SelectionPopupModel(
        id: 1,
        title: "Ride",
        isSelected: true,
      ),
      SelectionPopupModel(
        id: 2,
        title: "Delivery",
      )
    ]),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class AddRouteOneNotifier extends StateNotifier<AddRouteOneState> {
  final Ref _ref;
  AddRouteOneNotifier(this._ref, AddRouteOneState state) : super(state);

  // Address strings that produced the current lat/lng values. Used at
  // submit time to detect stale coords when the user has typed a new
  // pickup/destination without picking from the autocomplete
  // suggestions - the text field would show one thing while the stored
  // coords still pointed at the previous selection (or worse, the
  // device's GPS from the initial "current location" fetch).
  String? _locationAnchorText;
  String? _destinationAnchorText;
  String? _stopAnchorText;

  void changeRadioButton(String value) {
    state = state.copyWith(radioGroup: value);
  }

  void changeRadioBtn(String value) {
    state = state.copyWith(radioGroup: value);
  }

  void selectTransportMode(int index) {
    final updatedModes =
        state.addRouteOneModelObj?.transportMeansList.map((item) {
      // Update `isSelected` for the selected index
      final isSelected =
          state.addRouteOneModelObj?.transportMeansList.indexOf(item) == index;
      return AddRouteOneItemModel(
        meansImage: item.meansImage,
        meansTitle: item.meansTitle,
        id: item.id,
        isSelected: isSelected,
      );
    }).toList();

    state = state.copyWith(
      addRouteOneModelObj: state.addRouteOneModelObj?.copyWith(
        transportMeansList: updatedModes,
      ),
    );
  }

  void toggleStopField() {
    state = state.copyWith(showStopField: !state.showStopField);
  }

  void selectServiceType(SelectionPopupModel service) {
    state = state.copyWith(serviceTypeDropDownValue: service);
  }

  void updateTimeField(String timeText) {
    state.setTimeController?.text = timeText;
    state = state.copyWith();
  }

  void setLocationCoordinates(double lat, double lng) {
    _locationAnchorText = state.locationController?.text.trim();
    state = state.copyWith(
      locationLat: lat,
      locationLng: lng,
    );
  }

  void setDestinationCoordinates(double lat, double lng) {
    _destinationAnchorText = state.destinationController?.text.trim();
    state = state.copyWith(
      destinationLat: lat,
      destinationLng: lng,
    );
  }

  void setStopCoordinates(double lat, double lng) {
    _stopAnchorText = state.stopController?.text.trim();
    state = state.copyWith(
      stopLat: lat,
      stopLng: lng,
    );
  }

  Future<void> fetchCurrentLocation() async {
    try {
      final hasPermission =
          await LocationManager.checkAndRequestLocationPermission();
      if (!hasPermission) {
        Fluttertoast.showToast(
          msg: "Location permission is required. Enable it in Settings.",
        );
        return;
      }

      final location = Location();
      await location.changeSettings(
        accuracy: LocationAccuracy.balanced,
        interval: 1000,
      );
      final locationData = await location.getLocation().timeout(
        const Duration(seconds: 12),
      );

      final lat = locationData.latitude;
      final lng = locationData.longitude;
      if (lat == null || lng == null) {
        Fluttertoast.showToast(msg: "Couldn't read your location. Try again.");
        return;
      }

      final placesService = _ref.read(googlePlacesServiceProvider);
      String? address;
      try {
        address = await placesService
            .getAddressFromLatLng(lat, lng)
            .timeout(const Duration(seconds: 8));
      } catch (_) {
        address = null;
      }

      state.locationController?.text = address ?? "Current Location";
      _locationAnchorText = (address ?? "Current Location").trim();
      state = state.copyWith(locationLat: lat, locationLng: lng);
    } on TimeoutException {
      Fluttertoast.showToast(
        msg:
            "Location timed out. On an emulator, use Extended Controls → Location → Set Location.",
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Location error: $e");
    }
  }

  /// Ensure the pickup, destination and (optional) stop coordinates match
  /// the text currently in each field. Called before submitting the route
  /// so a user who typed an address without picking from the autocomplete
  /// suggestions still ends up with coordinates that actually match what
  /// they typed (rather than the last-selected location or the phone's
  /// GPS). Returns true when every non-empty field has fresh coords.
  Future<bool> resolveCoordinatesIfNeeded() async {
    final placesService = _ref.read(googlePlacesServiceProvider);
    var ok = true;

    final pickup = state.locationController?.text.trim() ?? '';
    if (pickup.isNotEmpty &&
        (_locationAnchorText != pickup ||
            state.locationLat == null ||
            state.locationLng == null)) {
      final resolved = await placesService.getLatLngFromAddress(pickup);
      if (resolved != null) {
        _locationAnchorText = pickup;
        state = state.copyWith(
          locationLat: resolved.latitude,
          locationLng: resolved.longitude,
        );
      } else {
        ok = false;
      }
    }

    final destination = state.destinationController?.text.trim() ?? '';
    if (destination.isNotEmpty &&
        (_destinationAnchorText != destination ||
            state.destinationLat == null ||
            state.destinationLng == null)) {
      final resolved = await placesService.getLatLngFromAddress(destination);
      if (resolved != null) {
        _destinationAnchorText = destination;
        state = state.copyWith(
          destinationLat: resolved.latitude,
          destinationLng: resolved.longitude,
        );
      } else {
        ok = false;
      }
    }

    final stop = state.stopController?.text.trim() ?? '';
    if (stop.isNotEmpty &&
        (_stopAnchorText != stop ||
            state.stopLat == null ||
            state.stopLng == null)) {
      final resolved = await placesService.getLatLngFromAddress(stop);
      if (resolved != null) {
        _stopAnchorText = stop;
        state = state.copyWith(
          stopLat: resolved.latitude,
          stopLng: resolved.longitude,
        );
      } else {
        ok = false;
      }
    }

    return ok;
  }
}

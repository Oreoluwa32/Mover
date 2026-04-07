import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../delivery_details_screen/notifier/places_autocomplete_notifier.dart';
import '../../../services/google_places_service.dart';
import '../models/ride_sharing_details_model.dart';
part 'ride_sharing_details_state.dart';

final rideSharingDetailsNotifier = StateNotifierProvider.autoDispose<
    RideSharingDetailsNotifier, RideSharingDetailsState>(
  (ref) {
    final placesService = ref.watch(googlePlacesServiceProvider);
    final passengerOptions = [
      SelectionPopupModel(id: 1, title: "1 passenger", value: 1, isSelected: true),
      SelectionPopupModel(id: 2, title: "2 passengers", value: 2),
      SelectionPopupModel(id: 3, title: "3 passengers", value: 3),
    ];

    return RideSharingDetailsNotifier(
      RideSharingDetailsState(
        selectedDropDownValue: passengerOptions.first,
        originController: TextEditingController(),
        destinationController: TextEditingController(),
        radioGroup: "origin",
        rideSharingDetailsModelObj: RideSharingDetailsModel(
          dropdownItemList: passengerOptions,
        ),
      ),
      placesService,
    );
  },
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class RideSharingDetailsNotifier
    extends StateNotifier<RideSharingDetailsState> {
  RideSharingDetailsNotifier(super.state, this._placesService);

  final GooglePlacesService _placesService;

  void changeRadioBtn(String value) {
    state = state.copyWith(radioGroup: value);
  }

  void onOriginChange(String value) {
    state = state.copyWith(originLatitude: null, originLongitude: null);
  }

  void updateDestination(String value) {
    state = state.copyWith(
      destination: value,
      destinationLatitude: null,
      destinationLongitude: null,
    );
  }

  void setOriginLocation(String address, double lat, double lng) {
    state.originController?.text = address;
    state = state.copyWith(
      originLatitude: lat,
      originLongitude: lng,
    );
  }

  void setDestinationLocation(String address, double lat, double lng) {
    state.destinationController?.text = address;
    state = state.copyWith(
      destination: address,
      destinationLatitude: lat,
      destinationLongitude: lng,
    );
  }

  void updatePassengerCount(String selectedTitle) {
    final items =
        state.rideSharingDetailsModelObj?.dropdownItemList ?? <SelectionPopupModel>[];
    final selected = items.firstWhere(
      (item) => item.title == selectedTitle,
      orElse: () =>
          state.selectedDropDownValue ??
          SelectionPopupModel(title: '1 passenger', value: 1),
    );

    state = state.copyWith(selectedDropDownValue: selected);
  }

  Future<void> getCurrentLocation() async {
    final location = Location();
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    state.originController?.text = "Fetching current location...";
    state = state.copyWith(isFetchingLocation: true);

    final locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      state = state.copyWith(isFetchingLocation: false);
      return;
    }

    try {
      final address = await _placesService.getAddressFromLatLng(
        locationData.latitude!,
        locationData.longitude!,
      );

      setOriginLocation(
        address ?? "Current Location",
        locationData.latitude!,
        locationData.longitude!,
      );
    } catch (_) {
      setOriginLocation(
        "Current Location",
        locationData.latitude!,
        locationData.longitude!,
      );
    } finally {
      state = state.copyWith(isFetchingLocation: false);
    }
  }

  int get selectedPassengers {
    final selected = state.selectedDropDownValue;
    if (selected?.value is int) {
      return selected!.value as int;
    }
    return selected?.id ?? 1;
  }

  bool get isFormComplete {
    return !state.isFetchingLocation &&
        state.originController?.text.isNotEmpty == true &&
        state.originController?.text != "Fetching current location..." &&
        state.destinationController?.text.isNotEmpty == true;
  }
}

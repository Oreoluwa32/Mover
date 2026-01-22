import 'package:location/location.dart';

class LocationManager {
  /// Checks if location service is enabled and if location permission is granted.
  /// If not, it requests them from the user.
  /// Returns [true] if both are enabled/granted, [false] otherwise.
  static Future<bool> checkAndRequestLocationPermission() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    // Check if location permission is granted
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    if (permissionGranted == PermissionStatus.deniedForever) {
      return false;
    }

    return true;
  }
}

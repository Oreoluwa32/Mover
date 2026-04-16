import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as polyline;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../core/app_export.dart';
import '../core/utils/constants.dart';
import 'custom_icon_button.dart';

class TaskRouteMap extends StatefulWidget {
  const TaskRouteMap({
    Key? key,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    this.moverLatitude,
    this.moverLongitude,
    this.overlayIconPath,
    this.routeColor,
    this.showMoverRadius = false,
    this.pickupMarkerHue = BitmapDescriptor.hueViolet,
    this.destinationMarkerHue = BitmapDescriptor.hueRed,
    this.height,
    this.width,
  }) : super(key: key);

  final double pickupLatitude;
  final double pickupLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final double? moverLatitude;
  final double? moverLongitude;
  final String? overlayIconPath;
  final Color? routeColor;
  final bool showMoverRadius;
  final double pickupMarkerHue;
  final double destinationMarkerHue;
  final double? height;
  final double? width;

  @override
  State<TaskRouteMap> createState() => _TaskRouteMapState();
}

class _TaskRouteMapState extends State<TaskRouteMap> {
  GoogleMapController? _controller;
  Set<Marker> _markers = const <Marker>{};
  Set<Polyline> _polylines = const <Polyline>{};
  Set<Circle> _circles = const <Circle>{};

  bool get _hasValidCoordinates {
    return widget.pickupLatitude != 0 &&
        widget.pickupLongitude != 0 &&
        widget.destinationLatitude != 0 &&
        widget.destinationLongitude != 0;
  }

  LatLng get _pickupPosition =>
      LatLng(widget.pickupLatitude, widget.pickupLongitude);

  LatLng get _destinationPosition =>
      LatLng(widget.destinationLatitude, widget.destinationLongitude);

  LatLng? get _moverPosition {
    if ((widget.moverLatitude ?? 0) == 0 || (widget.moverLongitude ?? 0) == 0) {
      return null;
    }
    return LatLng(widget.moverLatitude!, widget.moverLongitude!);
  }

  CameraPosition get _initialCameraPosition {
    if (_hasValidCoordinates) {
      final centerLat =
          (widget.pickupLatitude + widget.destinationLatitude) / 2;
      final centerLng =
          (widget.pickupLongitude + widget.destinationLongitude) / 2;
      return CameraPosition(
        target: LatLng(centerLat, centerLng),
        zoom: 13.8,
      );
    }

    return const CameraPosition(
      target: LatLng(6.5244, 3.3792),
      zoom: 12.5,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRoutePreview();
  }

  @override
  void didUpdateWidget(covariant TaskRouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pickupLatitude != widget.pickupLatitude ||
        oldWidget.pickupLongitude != widget.pickupLongitude ||
        oldWidget.destinationLatitude != widget.destinationLatitude ||
        oldWidget.destinationLongitude != widget.destinationLongitude ||
        oldWidget.moverLatitude != widget.moverLatitude ||
        oldWidget.moverLongitude != widget.moverLongitude) {
      _loadRoutePreview();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) {
              _controller = controller;
              _fitBounds();
            },
            zoomControlsEnabled: false,
            zoomGesturesEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            markers: _markers,
            polylines: _polylines,
            circles: _circles,
          ),
          if ((widget.overlayIconPath ?? '').isNotEmpty)
            Positioned(
              top: 12.h,
              right: 10.h,
              child: CustomIconButton(
                height: 40.h,
                width: 40.h,
                padding: EdgeInsets.all(10.h),
                decoration: IconButtonStyleHelper.outlineBlackTL201,
                child: CustomImageView(
                  imagePath: widget.overlayIconPath!,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _loadRoutePreview() async {
    if (!_hasValidCoordinates) {
      if (!mounted) {
        return;
      }
      setState(() {
        _markers = const <Marker>{};
        _polylines = const <Polyline>{};
        _circles = const <Circle>{};
      });
      return;
    }

    final pickup = _pickupPosition;
    final destination = _destinationPosition;
    final mover = _moverPosition;

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickup,
        icon: BitmapDescriptor.defaultMarkerWithHue(widget.pickupMarkerHue),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: destination,
        icon: BitmapDescriptor.defaultMarkerWithHue(widget.destinationMarkerHue),
      ),
    };

    final circles = <Circle>{};
    if (mover != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('mover'),
          position: mover,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
        ),
      );
      if (widget.showMoverRadius) {
        circles.add(
          Circle(
            circleId: const CircleId('mover-radius'),
            center: mover,
            radius: 100,
            fillColor: theme.colorScheme.primary.withValues(alpha: 0.18),
            strokeColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            strokeWidth: 1,
          ),
        );
      }
    }

    final routePoints = await _getRoutePoints(
      origin: pickup,
      destination: destination,
    );
    final points = <LatLng>[
      if (mover != null) mover,
      if (mover != null && (mover.latitude != pickup.latitude || mover.longitude != pickup.longitude))
        pickup,
      ...routePoints.isNotEmpty
          ? (mover != null ? routePoints.skip(1) : routePoints)
          : <LatLng>[pickup, destination],
    ];

    final polylines = <Polyline>{
      if (points.length >= 2)
        Polyline(
          polylineId: const PolylineId('task-route'),
          color: widget.routeColor ?? theme.colorScheme.primary,
          width: 4,
          points: points,
        ),
    };

    if (!mounted) {
      return;
    }
    setState(() {
      _markers = markers;
      _polylines = polylines;
      _circles = circles;
    });
    _fitBounds(points: points);
  }

  Future<List<LatLng>> _getRoutePoints({
    required LatLng origin,
    required LatLng destination,
  }) async {
    if (Constants.googleMapsApiKey.isEmpty) {
      return <LatLng>[origin, destination];
    }

    try {
      final polylinePoints =
          polyline.PolylinePoints(apiKey: Constants.googleMapsApiKey);
      final request = polyline.RoutesApiRequest(
        origin: polyline.PointLatLng(origin.latitude, origin.longitude),
        destination: polyline.PointLatLng(
          destination.latitude,
          destination.longitude,
        ),
        travelMode: polyline.TravelMode.driving,
      );
      final response =
          await polylinePoints.getRouteBetweenCoordinatesV2(request: request);
      if (response.routes.isEmpty) {
        return <LatLng>[origin, destination];
      }

      final route = response.routes.first;
      final points = <LatLng>[];
      for (final point in route.polylinePoints ?? const <polyline.PointLatLng>[]) {
        points.add(LatLng(point.latitude, point.longitude));
      }
      return points.isNotEmpty ? points : <LatLng>[origin, destination];
    } catch (_) {
      return <LatLng>[origin, destination];
    }
  }

  Future<void> _fitBounds({List<LatLng>? points}) async {
    final controller = _controller;
    final routePoints = points ??
        <LatLng>[
          if (_moverPosition != null) _moverPosition!,
          if (_hasValidCoordinates) _pickupPosition,
          if (_hasValidCoordinates) _destinationPosition,
        ];

    if (controller == null || routePoints.length < 2) {
      return;
    }

    double minLat = routePoints.first.latitude;
    double maxLat = routePoints.first.latitude;
    double minLng = routePoints.first.longitude;
    double maxLng = routePoints.first.longitude;

    for (final point in routePoints.skip(1)) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    try {
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          60,
        ),
      );
    } catch (_) {
      // Ignore fit failures during initial layout pass.
    }
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_polyline_points/flutter_polyline_points.dart'
    as polyline;
import 'package:movr/presentation/delivery_pickup_screen_one/delivery_pickup_screen_one.dart';
import 'package:movr/presentation/delivery_task_one_bottomsheet/delivery_task_one_bottomsheet.dart';
import 'package:movr/presentation/ride_sharing_task_bottomsheet_one/ride_sharing_task_bottomsheet_one.dart';
import 'package:movr/presentation/ride_sharing_pickup_one/ride_sharing_pickup_one.dart';
import 'package:movr/presentation/ride_sharing_pickup_two/ride_sharing_pickup_two.dart';
import '../../core/app_export.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/location_manager.dart';
import '../../core/utils/map_utils.dart';
import '../../data/services/mobility_api_service.dart';
import '../../data/services/mobility_realtime_service.dart';
import '../notification_screen/notifier/notification_notifier.dart';
import '../search_mover_bottomsheet/search_mover_bottomsheet.dart';
import '../../widgets/custom_floating_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_switch.dart';
import 'notifier/home_notifier.dart';

class HomeOneInitialPage extends ConsumerStatefulWidget {
  const HomeOneInitialPage({super.key});

  @override
  HomeOneInitialPageState createState() => HomeOneInitialPageState();
}

// ignore for file: must be immutabel
class HomeOneInitialPageState extends ConsumerState<HomeOneInitialPage>
    with TickerProviderStateMixin {
  final loc.Location locationController = loc.Location();
  final MobilityApiService _mobilityApiService = MobilityApiService();
  final MobilityRealtimeService _realtimeService = MobilityRealtimeService();
  LatLng? currentPosition;
  double userHeading = 0.0;
  ImageDescriptor customMarkerIcon = ImageDescriptor.defaultImage;
  DateTime? _lastRealtimeBroadcast;
  String? _liveTravelPlanId;

  static const LatLng defaultLocation =
      LatLng(latitude: 6.6085, longitude: 3.2881);
  static const LatLng sourceLocation =
      LatLng(latitude: 6.6085, longitude: 3.2881);
  static const LatLng destinationLocation =
      LatLng(latitude: 6.5243, longitude: 3.3792);

  late Completer<GoogleNavigationViewController> googleMapController;
  late Completer<GoogleNavigationViewController> googleMapController1;

  static const googleMapsApiKey = Constants.googleMapsApiKey;

  // Animation controllers and variables
  late AnimationController _sidebarAnimationController;
  late AnimationController _filterButtonAnimationController;
  late AnimationController _nearbySearchAnimationController;
  late AnimationController _taskRequestCountdownController;
  late Animation<Offset> _sidebarSlideAnimation;
  late Animation<double> _filterButtonRotationAnimation;
  bool _isSidebarVisible = false;

  // Location stream subscription
  StreamSubscription? _locationSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;
  Timer? _motionSmoothingTimer;
  LatLng? _targetPosition;
  double? _targetHeading;
  int _motionTickCount = 0;

  // Polyline variables
  List<LatLng> polylineCoordinates = [];
  List<PolylineOptions> polylines = [];
  LatLng? routeSourceLocation;
  LatLng? routeDestinationLocation;
  String? _lastPresentedPendingTaskId;
  String? _openTaskCountdownKey;
  String? _dismissedOpenTaskKey;
  bool _hasHandledInitialPendingTaskSnapshot = false;

  @override
  void initState() {
    super.initState();

    googleMapController = Completer();
    googleMapController1 = Completer();

    // Initialize animation controllers with reduced durations for better performance
    _sidebarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _filterButtonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _nearbySearchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _taskRequestCountdownController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed && mounted) {
          setState(() {
            _dismissedOpenTaskKey = _openTaskCountdownKey;
          });
        }
      });

    // Initialize animations
    _sidebarSlideAnimation = Tween<Offset>(
      begin: const Offset(-3.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _sidebarAnimationController,
      curve: Curves.easeInOut,
    ));

    _filterButtonRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _filterButtonAnimationController,
      curve: Curves.easeInOut,
    ));

    _initializeLocationAndPolyline();
    _initializeNavigation();
  }

  Future<void> _initializeNavigation() async {
    try {
      if (!await GoogleMapsNavigator.isInitialized()) {
        await GoogleMapsNavigator.initializeNavigationSession();
      }

      // Check if terms are accepted, if not show dialog
      if (!await GoogleMapsNavigator.areTermsAccepted()) {
        await GoogleMapsNavigator.showTermsAndConditionsDialog(
          'Google Maps Navigation',
          'Movr',
        );
      }

      // Set arrival listener
      GoogleMapsNavigator.setOnArrivalListener((event) {
        if (mounted) {
          ref.read(homeNotifier.notifier).stopNavigation();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('You have arrived at your destination')),
          );
        }
      });
    } catch (e) {
      // Log error silently in production
    }
  }

  Future<void> _initializeLocationAndPolyline() async {
    try {
      final ByteData data =
          await rootBundle.load(ImageConstant.imgCustomMarker);
      final icon = await registerBitmapImage(
        bitmap: data,
        width: 40, // Set logical width for custom marker
      );
      setState(() {
        customMarkerIcon = icon;
      });
    } catch (e) {
      // Error loading custom marker from asset
    }

    try {
      final bytes = await MapUtils.getBeamBytes(
        width: 150,
      );
      if (bytes != null) {
        final icon = await registerBitmapImage(
          bitmap: ByteData.view(bytes.buffer),
          width:
              60, // Set logical width for beam marker (larger to accommodate the cone)
        );
        setState(() {
          customMarkerIcon = icon;
        });

        // Update markers immediately if map is ready
        if (googleMapController.isCompleted) {
          final controller = await googleMapController.future;
          _updateMarkers(controller);
        }
      }
    } catch (e) {
      // Error loading custom marker
    }

    try {
      await getLocationUpdates();
    } catch (e) {
      // Error getting location updates
    }

    try {
      await _startCompassUpdates();
    } catch (e) {
      // Error getting compass updates
    }

    try {
      await getPolylinePoints();
    } catch (e) {
      // Error getting polyline points
    }
  }

  @override
  void dispose() {
    _sidebarAnimationController.dispose();
    _filterButtonAnimationController.dispose();
    _nearbySearchAnimationController.dispose();
    _taskRequestCountdownController.dispose();
    _locationSubscription?.cancel();
    _compassSubscription?.cancel();
    _motionSmoothingTimer?.cancel();
    unawaited(_realtimeService.dispose());
    super.dispose();
  }

  // Method to toggle sidebar visibility
  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });

    if (_isSidebarVisible) {
      _sidebarAnimationController.forward();
      _filterButtonAnimationController.forward();
    } else {
      _sidebarAnimationController.reverse();
      _filterButtonAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(themeNotifier.select((state) => state.themeType),
        (previous, next) {
      if (googleMapController.isCompleted) {
        googleMapController.future.then((controller) {
          _applyNavigationMapTheme(controller, next);
        });
      }
    });
    ref.listen(homeNotifier.select((s) => s.isNavigationActive),
        (previous, next) {
      if (next == true) {
        _startNavigation();
      } else if (next == false && previous == true) {
        _stopNavigation();
      }
    });
    ref.listen(homeNotifier.select((s) => s.isLive), (previous, next) {
      if (next == true) {
        _startLiveTracking();
      } else if (previous == true && next == false) {
        _stopLiveTracking();
      }
    });
    ref.listen(homeNotifier.select((s) => s.isSearchingNearbyMovers),
        (previous, next) {
      if (next == true) {
        _nearbySearchAnimationController.repeat();
      } else {
        _nearbySearchAnimationController.stop();
        _nearbySearchAnimationController.reset();
      }
    });
    ref.listen(homeNotifier.select((s) => s.pendingTaskData), (previous, next) {
      final homeState = ref.read(homeNotifier);
      if (!homeState.isLive || next == null) {
        return;
      }

      final taskId = next['id']?.toString();
      final taskPhase = homeState.pendingTaskPhase ?? 'open';
      final taskKey = '$taskId:$taskPhase';
      if (taskId == null ||
          taskId.isEmpty ||
          taskKey == _lastPresentedPendingTaskId) {
        return;
      }

      if (!_hasHandledInitialPendingTaskSnapshot) {
        _hasHandledInitialPendingTaskSnapshot = true;
        _lastPresentedPendingTaskId = taskKey;
        if (taskPhase == 'open') {
          _startOpenTaskCountdown(taskKey);
        } else {
          _openTaskCountdownKey = null;
          _dismissedOpenTaskKey = null;
          _taskRequestCountdownController.stop();
          _highlightPendingTaskRoute(
            pendingTask: next,
            pendingTaskType: homeState.pendingTaskType ?? 'delivery',
            pendingTaskPhase: taskPhase,
          );
        }
        return;
      }

      _lastPresentedPendingTaskId = taskKey;
      if (taskPhase == 'open') {
        _startOpenTaskCountdown(taskKey);
        return;
      }
      _openTaskCountdownKey = null;
      _dismissedOpenTaskKey = null;
      _taskRequestCountdownController.stop();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _highlightPendingTaskRoute(
          pendingTask: next,
          pendingTaskType: homeState.pendingTaskType ?? 'delivery',
          pendingTaskPhase: taskPhase,
        );
        _openPendingTaskBottomsheet(
          context,
          pendingTask: next,
          pendingTaskType: homeState.pendingTaskType ?? 'delivery',
          pendingTaskPhase: taskPhase,
        );
      });
    });
    return Scaffold(
      body: Stack(
        children: [
          // Google Map as background - full screen
          _buildMaps(context),

          // Static UI overlays
          _buildTopRightNotificationButton(context),
          _buildIsLiveToggleSwitch(context),
          _buildLeftSidebar(context),
          _buildFilterButton(context),
          _buildTopNotificationBar(context),
          _buildNavigationPanel(context),
          _buildTaskNotification(context),
          _buildNearbyMoverRipple(context),
          _buildNearbyMoverSearchAction(context),
          // _buildBottomNavigation(context),
          _buildStartRideButton(context),
          _buildEmergencyButton(context),
          _buildFloatingactionb(context),
          // Temporary notification for isLive status with fade animation
          Consumer(
            builder: (context, ref, child) {
              final homeState = ref.watch(homeNotifier);
              return Positioned(
                top: 160.h,
                left: 16.h,
                right: 16.h,
                child: IgnorePointer(
                  ignoring: !homeState.showLiveNotification,
                  child: AnimatedOpacity(
                    opacity: homeState.showLiveNotification ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: _buildLiveRouteNotificationContent(
                        context, homeState.isLive),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _updateMarkers(GoogleNavigationViewController controller) {
    final homeState = ref.read(homeNotifier);
    List<MarkerOptions> markerOptions = [];

    if (currentPosition != null) {
      markerOptions.add(
        MarkerOptions(
          position: currentPosition!,
          rotation: userHeading,
          anchor: const MarkerAnchor(u: 0.5, v: 0.5),
          icon: customMarkerIcon,
        ),
      );
    }

    if (homeState.highlightRoute &&
        homeState.routeLocationLat != null &&
        homeState.routeLocationLng != null &&
        homeState.routeDestinationLat != null &&
        homeState.routeDestinationLng != null) {
      final source = LatLng(
          latitude: homeState.routeLocationLat!,
          longitude: homeState.routeLocationLng!);
      final destination = LatLng(
          latitude: homeState.routeDestinationLat!,
          longitude: homeState.routeDestinationLng!);

      markerOptions.add(
        MarkerOptions(
          position: source,
        ),
      );
      markerOptions.add(
        MarkerOptions(
          position: destination,
        ),
      );
    }

    controller.clearMarkers();
    controller.addMarkers(markerOptions);
  }

  Future<void> _applyNavigationMapTheme(
    GoogleNavigationViewController controller,
    String themeType,
  ) async {
    final isDark = ThemeHelper.isDarkThemeType(themeType);
    try {
      await controller.setMapColorScheme(
        isDark ? MapColorScheme.dark : MapColorScheme.light,
      );
    } catch (_) {
      // The Navigation SDK ignores mapColorScheme when navigation UI is active.
    }

    try {
      await controller.setForceNightMode(
        isDark
            ? NavigationForceNightMode.forceNight
            : NavigationForceNightMode.forceDay,
      );
    } catch (_) {
      // Keep the app usable if a platform SDK version does not support this.
    }
  }

  Widget _buildMaps(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final themeType =
            ref.watch(themeNotifier.select((state) => state.themeType));
        final homeState = ref.watch(homeNotifier);

        return GoogleMapsNavigationView(
          initialMapColorScheme: ThemeHelper.isDarkThemeType(themeType)
              ? MapColorScheme.dark
              : MapColorScheme.light,
          initialForceNightMode: ThemeHelper.isDarkThemeType(themeType)
              ? NavigationForceNightMode.forceNight
              : NavigationForceNightMode.forceDay,
          initialZoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: currentPosition ?? defaultLocation,
            zoom: 18.0,
          ),
          onViewCreated: (GoogleNavigationViewController controller) {
            if (!googleMapController.isCompleted) {
              googleMapController.complete(controller);
            }
            _applyNavigationMapTheme(controller, themeType);
            _updateMarkers(controller);

            if (homeState.highlightRoute &&
                homeState.routeLocationLat != null &&
                homeState.routeLocationLng != null &&
                homeState.routeDestinationLat != null &&
                homeState.routeDestinationLng != null) {
              _loadAndDisplayRoute(
                LatLng(
                    latitude: homeState.routeLocationLat!,
                    longitude: homeState.routeLocationLng!),
                LatLng(
                    latitude: homeState.routeDestinationLat!,
                    longitude: homeState.routeDestinationLng!),
                controller,
              );
            }
          },
        );
      },
    );
  }

  Future<void> _loadAndDisplayRoute(LatLng source, LatLng destination,
      GoogleNavigationViewController controller) async {
    try {
      final coordinates = await getPolylinePoints(
        origin: source,
        destination: destination,
      );

      setState(() {
        polylineCoordinates = coordinates;
        polylines = [
          PolylineOptions(
            points: coordinates,
            strokeColor: theme.colorScheme.primary,
            strokeWidth: 5,
          )
        ];
      });

      controller.addPolylines(polylines);
      _updateMarkers(controller);

      if (coordinates.isNotEmpty) {
        await _animateCameraToShowRoute(source, destination, controller);
      }
    } catch (e) {
      // Error loading route
    }
  }

  Future<void> _animateCameraToShowRoute(LatLng source, LatLng destination,
      GoogleNavigationViewController controller) async {
    final sw = LatLng(
      latitude: source.latitude < destination.latitude
          ? source.latitude
          : destination.latitude,
      longitude: source.longitude < destination.longitude
          ? source.longitude
          : destination.longitude,
    );
    final ne = LatLng(
      latitude: source.latitude > destination.latitude
          ? source.latitude
          : destination.latitude,
      longitude: source.longitude > destination.longitude
          ? source.longitude
          : destination.longitude,
    );

    final bounds = LatLngBounds(southwest: sw, northeast: ne);
    await controller
        .animateCamera(CameraUpdate.newLatLngBounds(bounds, padding: 100));
  }

  Future<void> cameraToPosition(LatLng position) async {
    final GoogleNavigationViewController controller =
        await googleMapController.future;
    final bool isNavigating = ref.read(homeNotifier).isNavigationActive;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: isNavigating ? 18.5 : 18.0,
          bearing: isNavigating ? userHeading : 0,
          tilt: isNavigating ? 45.0 : 0,
        ),
      ),
    );
  }

  Future<void> _startNavigation() async {
    final homeState = ref.read(homeNotifier);

    if (homeState.routeDestinationLat != null &&
        homeState.routeDestinationLng != null) {
      final destination = LatLng(
        latitude: homeState.routeDestinationLat!,
        longitude: homeState.routeDestinationLng!,
      );

      await GoogleMapsNavigator.setDestinations(
        Destinations(
          waypoints: [
            NavigationWaypoint(
              target: destination,
              title: homeState.routeDestinationName ?? 'Destination',
            ),
          ],
          displayOptions: NavigationDisplayOptions(
            showDestinationMarkers: true,
            showStopSigns: true,
            showTrafficLights: true,
          ),
        ),
      );

      await GoogleMapsNavigator.startGuidance();
    }
  }

  Future<void> _stopNavigation() async {
    await GoogleMapsNavigator.stopGuidance();
    await GoogleMapsNavigator.clearDestinations();
  }

  Future<void> getLocationUpdates() async {
    try {
      bool hasPermission =
          await LocationManager.checkAndRequestLocationPermission();

      if (!hasPermission) {
        return;
      }

      // Configure location settings for better tracking during transit
      await locationController.changeSettings(
        accuracy: loc.LocationAccuracy.high,
        interval: 700, // Faster updates for smoother transit feedback
        distanceFilter: 1, // Capture small movements while in motion
      );

      _locationSubscription?.cancel();
      _locationSubscription = locationController.onLocationChanged.listen(
          (loc.LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null &&
            mounted) {
          final newPosition = LatLng(
            latitude: currentLocation.latitude!,
            longitude: currentLocation.longitude!,
          );

          final double fallbackHeading = currentLocation.heading ?? userHeading;
          final double newHeading = _isValidHeading(_targetHeading)
              ? _normalizeHeading(_targetHeading!)
              : fallbackHeading;

          final bool isFirstLocation = currentPosition == null;
          final bool isNavigating = ref.read(homeNotifier).isNavigationActive;

          // Use smaller threshold when navigating to keep focus on custom marker
          final double threshold = isNavigating ? 0.00002 : 0.0001;

          if (isFirstLocation ||
              (currentPosition!.latitude - newPosition.latitude).abs() >
                  threshold ||
              (currentPosition!.longitude - newPosition.longitude).abs() >
                  threshold ||
              _angleDifference(userHeading, newHeading).abs() > 1.0) {
            if (isFirstLocation) {
              setState(() {
                currentPosition = newPosition;
                _targetPosition = newPosition;
                userHeading = _normalizeHeading(newHeading);
                _targetHeading = _normalizeHeading(newHeading);
              });

              if (googleMapController.isCompleted) {
                googleMapController.future.then((controller) {
                  _updateMarkers(controller);
                });
              }

              cameraToPosition(newPosition);
            } else {
              _targetPosition = newPosition;
              if (_isValidHeading(newHeading)) {
                _targetHeading = _normalizeHeading(newHeading);
              }
              _startMotionSmoothing();
            }

            if (isNavigating && polylineCoordinates.isNotEmpty) {
              _trimPolyline(newPosition);
            }

            if (ref.read(homeNotifier).isLive) {
              unawaited(_broadcastLiveLocation(newPosition));
            }
          }
        }
      }, onError: (e) {
        // Handle location error
      });
    } catch (e) {
      // Handle error in getLocationUpdates
    }
  }

  Future<void> _startCompassUpdates() async {
    _compassSubscription?.cancel();
    _compassSubscription = FlutterCompass.events?.listen((event) {
      final heading = event.heading;
      if (!mounted || !_isValidHeading(heading)) {
        return;
      }

      final normalizedHeading = _normalizeHeading(heading!);
      if (_angleDifference(userHeading, normalizedHeading).abs() < 0.5) {
        return;
      }

      _targetHeading = normalizedHeading;
      _startMotionSmoothing();
    });
  }

  void _startMotionSmoothing() {
    if (!mounted) {
      return;
    }

    if (_motionSmoothingTimer == null) {
      _motionTickCount = 0;
    }

    _motionSmoothingTimer ??=
        Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (!mounted) {
        timer.cancel();
        _motionSmoothingTimer = null;
        return;
      }

      final positionChanged = _stepTowardTargetPosition();
      final headingChanged = _stepTowardTargetHeading();

      if (!positionChanged && !headingChanged) {
        timer.cancel();
        _motionSmoothingTimer = null;
        _motionTickCount = 0;
        return;
      }

      _motionTickCount++;

      if (googleMapController.isCompleted) {
        googleMapController.future.then((controller) {
          _updateMarkers(controller);
        });
      }

      final shouldFollowMap = ref.read(homeNotifier).isNavigationActive;
      if (shouldFollowMap &&
          currentPosition != null &&
          (_motionTickCount % 3 == 0 || positionChanged)) {
        unawaited(cameraToPosition(currentPosition!));
      }
    });
  }

  bool _stepTowardTargetPosition() {
    if (currentPosition == null || _targetPosition == null) {
      return false;
    }

    final latDiff = _targetPosition!.latitude - currentPosition!.latitude;
    final lngDiff = _targetPosition!.longitude - currentPosition!.longitude;

    if (latDiff.abs() < 0.000001 && lngDiff.abs() < 0.000001) {
      if (currentPosition != _targetPosition) {
        setState(() {
          currentPosition = _targetPosition;
        });
      }
      return false;
    }

    final nextPosition = LatLng(
      latitude: currentPosition!.latitude + (latDiff * 0.28),
      longitude: currentPosition!.longitude + (lngDiff * 0.28),
    );

    setState(() {
      currentPosition = nextPosition;
    });
    return true;
  }

  bool _stepTowardTargetHeading() {
    if (!_isValidHeading(_targetHeading)) {
      return false;
    }

    final delta = _angleDifference(userHeading, _targetHeading!);
    if (delta.abs() < 0.6) {
      if (userHeading != _targetHeading) {
        setState(() {
          userHeading = _targetHeading!;
        });
      }
      return false;
    }

    setState(() {
      userHeading = _normalizeHeading(userHeading + (delta * 0.22));
    });
    return true;
  }

  bool _isValidHeading(double? heading) {
    return heading != null && heading.isFinite && heading >= 0;
  }

  double _normalizeHeading(double heading) {
    final normalized = heading % 360;
    return normalized < 0 ? normalized + 360 : normalized;
  }

  double _angleDifference(double from, double to) {
    return ((to - from + 540) % 360) - 180;
  }

  Future<void> _startLiveTracking() async {
    try {
      final latestTravelPlan = await _mobilityApiService.getLatestTravelPlan();
      final travelPlanId = latestTravelPlan?['id']?.toString();
      if (travelPlanId == null || travelPlanId.isEmpty) {
        return;
      }

      _liveTravelPlanId = travelPlanId;
      await _realtimeService.connect(travelPlanId);
      await _realtimeService.sendEvent(
        eventType: 'status',
        note: 'Live tracking started',
        payload: {'is_live': true},
      );

      if (currentPosition != null) {
        await _broadcastLiveLocation(currentPosition!, force: true);
      }
    } catch (_) {
      // Keep the live toggle UX responsive even if realtime setup fails.
    }
  }

  Future<void> _stopLiveTracking() async {
    try {
      if (_realtimeService.isConnected) {
        await _realtimeService.sendEvent(
          eventType: 'status',
          note: 'Live tracking stopped',
          payload: {'is_live': false},
        );
      }
    } catch (_) {
      // Ignore stop event failures.
    } finally {
      _lastRealtimeBroadcast = null;
      _liveTravelPlanId = null;
      await _realtimeService.disconnect();
    }
  }

  Future<void> _broadcastLiveLocation(LatLng position,
      {bool force = false}) async {
    final now = DateTime.now();
    if (!force &&
        _lastRealtimeBroadcast != null &&
        now.difference(_lastRealtimeBroadcast!) < const Duration(seconds: 3)) {
      return;
    }

    if (!_realtimeService.isConnected) {
      await _startLiveTracking();
      if (!_realtimeService.isConnected) {
        return;
      }
    }

    await _realtimeService.sendEvent(
      eventType: 'location',
      latitude: position.latitude,
      longitude: position.longitude,
      payload: {'heading': userHeading},
    );
    _lastRealtimeBroadcast = now;
  }

  Future<void> _sendEmergencyAlert() async {
    try {
      if (currentPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Current location is not available yet.')),
        );
        return;
      }

      await _mobilityApiService.createEmergencyAlert(
        travelPlanId: _liveTravelPlanId,
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
        message: 'SOS triggered from live route screen.',
      );

      if (_realtimeService.isConnected) {
        await _realtimeService.sendEvent(
          eventType: 'sos',
          latitude: currentPosition!.latitude,
          longitude: currentPosition!.longitude,
          note: 'SOS triggered from app.',
          payload: {'travel_plan_id': _liveTravelPlanId},
        );
      }

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Emergency alert sent.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      final message = _mobilityApiService.extractErrorMessage(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _trimPolyline(LatLng currentPos) {
    if (polylineCoordinates.isEmpty) return;

    int closestIndex = -1;
    double minDistance = double.infinity;

    // Find the closest point on the polyline to the current position
    // We only look ahead to avoid jumping back if GPS jitters
    for (int i = 0; i < polylineCoordinates.length; i++) {
      final double distance = MapUtils.calculateDistance(
        currentPos.latitude,
        currentPos.longitude,
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }

      // If we find a point very close (within 20m), we stop searching to save performance
      if (distance < 0.02) {
        closestIndex = i;
        break;
      }
    }

    // If we found a point and it's not the first one, trim the polyline
    if (closestIndex != -1 && closestIndex > 0) {
      setState(() {
        // Keep points from closestIndex onwards
        polylineCoordinates = polylineCoordinates.sublist(closestIndex);

        // Update the polyline on the map
        polylines = [
          PolylineOptions(
            points: polylineCoordinates,
            strokeColor: theme.colorScheme.primary,
            strokeWidth: 5,
          )
        ];
      });

      googleMapController.future.then((controller) {
        controller.clearPolylines();
        controller.addPolylines(polylines);
      });
    }
  }

  Future<List<LatLng>> getPolylinePoints({
    LatLng? origin,
    LatLng? destination,
  }) async {
    List<LatLng> coordinates = [];
    final source = origin ?? sourceLocation;
    final dest = destination ?? destinationLocation;

    polyline.PolylinePoints polylinePoints =
        polyline.PolylinePoints(apiKey: googleMapsApiKey);
    polyline.RoutesApiRequest request = polyline.RoutesApiRequest(
        origin: polyline.PointLatLng(source.latitude, source.longitude),
        destination: polyline.PointLatLng(dest.latitude, dest.longitude),
        travelMode: polyline.TravelMode.driving);
    polyline.RoutesApiResponse response =
        await polylinePoints.getRouteBetweenCoordinatesV2(request: request);
    if (response.routes.isNotEmpty) {
      polyline.Route route = response.routes.first;
      route.polylinePoints?.forEach((polyline.PointLatLng point) {
        coordinates
            .add(LatLng(latitude: point.latitude, longitude: point.longitude));
      });
    }
    return coordinates;
  }

  Widget _buildTopNotificationBar(BuildContext context) {
    if (currentPosition == null) return const SizedBox.shrink();
    return Positioned(
      top: 65.h,
      left: 72.h,
      child: IgnorePointer(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 6.h),
          decoration: BoxDecoration(
              color: appTheme.gray10001,
              borderRadius: BorderRadius.circular(20.h),
              boxShadow: [
                BoxShadow(
                  color: appTheme.black900.withValues(alpha: 0.08),
                  spreadRadius: 2.h,
                  blurRadius: 2.h,
                  offset: const Offset(0, 0),
                )
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 6.h,
                width: 6.h,
                decoration: BoxDecoration(
                  color: appTheme.redA700,
                  borderRadius: BorderRadius.circular(3.h),
                ),
              ),
              SizedBox(width: 6.h),
              Text(
                "1000+ routes are live",
                style: CustomTextStyles.labelMediumInterPrimary,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Left sidebar with transportation modes
  Widget _buildLeftSidebar(BuildContext context) {
    return Positioned(
      left: 23.h,
      top: 110.h,
      child: SlideTransition(
        position: _sidebarSlideAnimation,
        child: Container(
          width: 34.h,
          padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 10.h),
          decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(alpha: 1.0),
              borderRadius: BorderRadiusStyle.CircleBorder20,
              boxShadow: [
                BoxShadow(
                  color: appTheme.black900.withValues(alpha: 0.1),
                  spreadRadius: 2.h,
                  blurRadius: 2.h,
                  offset: Offset(0, 0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTransportModeItem(ImageConstant.imgWalking, "PT"),
              SizedBox(height: 14.h),
              _buildTransportModeItem(ImageConstant.imgBike, "Bike"),
              SizedBox(height: 14.h),
              _buildTransportModeItem(ImageConstant.imgCar, "Car"),
              SizedBox(height: 14.h),
              _buildTransportModeItem(ImageConstant.imgPlane, "Plane"),
              SizedBox(height: 14.h),
              _buildTransportModeItem(ImageConstant.imgTruck, "Truck"),
              SizedBox(height: 14.h),
              _buildTransportModeItem(ImageConstant.imgBus, "Bus"),
              SizedBox(height: 14.h),
              _buildTransportModeItem(ImageConstant.imgTrain, "Train"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransportModeItem(String imagePath, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomImageView(
          imagePath: imagePath,
          height: 18.h,
          width: 18.h,
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: CustomTextStyles.interErrorContainer,
        ),
      ],
    );
  }

  // Top right notification button
  Widget _buildTopRightNotificationButton(BuildContext context) {
    return Positioned(
      top: 60.h,
      right: 20.h,
      child: Consumer(
        builder: (context, ref, _) {
          final unreadCount = ref.watch(notificationNotifier).unreadCount;
          return GestureDetector(
            onTap: () => onTapNotification(context),
            child: Container(
              width: 40.h,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8.h,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: CustomImageView(
                      imagePath: ImageConstant.imgNotificationBell,
                      height: 20.h,
                      width: 20.h,
                      color: Color(0xFF6D6D6D),
                    ),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      top: -2.h,
                      right: -2.h,
                      child: Container(
                        constraints: BoxConstraints(minWidth: 18.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.h, vertical: 1.5.h),
                        decoration: BoxDecoration(
                          color: appTheme.redA700,
                          borderRadius: BorderRadius.circular(10.h),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.h,
                          ),
                        ),
                        child: Text(
                          unreadCount > 9 ? '9+' : unreadCount.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.fSize,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // IsLive toggle switch positioned below notification button
  Widget _buildIsLiveToggleSwitch(BuildContext context) {
    return Positioned(
      top: 112.h,
      right: 20.h,
      child: Consumer(
        builder: (context, ref, child) {
          final homeState = ref.watch(homeNotifier);
          return CustomSwitch(
            value: homeState.isLive,
            isDisabled: homeState.isToggling,
            onChange: (value) {
              ref
                  .read(homeNotifier.notifier)
                  .toggleIsLive(value)
                  .catchError((error) {
                if (!context.mounted) {
                  return;
                }
                final message =
                    error.toString().replaceFirst('Exception: ', '');
                Fluttertoast.showToast(
                  msg: message,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                );
              });
            },
          );
        },
      ),
    );
  }

  // Live route notification card that displays temporarily with fade effect
  Widget _buildLiveRouteNotificationContent(BuildContext context, bool isLive) {
    final message =
        isLive ? "Your route is now live" : "Your route is now disabled";
    final backgroundColor =
        isLive ? const Color(0xFFD4EDDA) : const Color(0xFFFFE5E5);
    final iconColor =
        isLive ? const Color(0xFF28A745) : const Color(0xFFDC3545);
    final messageColor =
        isLive ? const Color(0xFF28A745) : const Color(0xFFDC3545);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: backgroundColor,
          width: 1.5.h,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            spreadRadius: 0,
            blurRadius: 8.h,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: messageColor.withValues(alpha: 0.15),
            spreadRadius: 0,
            blurRadius: 4.h,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 36.h,
            width: 36.h,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(18.h),
            ),
            child: Center(
              child: Icon(
                isLive ? Icons.check_circle : Icons.cancel_rounded,
                color: iconColor,
                size: 18.h,
              ),
            ),
          ),
          SizedBox(width: 12.h),
          Flexible(
            child: Text(
              message,
              style: CustomTextStyles.bodyMediumBluegray400,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 12.h),
        ],
      ),
    );
  }

  // Filter button positioned above left sidebar
  Widget _buildFilterButton(BuildContext context) {
    return Positioned(
      left: 20.h,
      top: 60.h,
      child: GestureDetector(
        onTap: _toggleSidebar,
        child: AnimatedBuilder(
          animation: _filterButtonRotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _filterButtonRotationAnimation.value * 2 * 3.14159,
              child: Container(
                width: 40.h,
                height: 40.h,
                decoration: BoxDecoration(
                  color: _isSidebarVisible ? Color(0xFF6A19D3) : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8.h,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomImageView(
                    imagePath: ImageConstant.imgFilter,
                    height: 20.h,
                    width: 20.h,
                    color: _isSidebarVisible ? Colors.white : Color(0xFF6D6D6D),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Task notification positioned in center-top area
  Widget _buildTaskNotification(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeNotifier);
        final pendingTask = homeState.pendingTaskData;
        if (homeState.isLoadingPendingTask || pendingTask == null) {
          return const SizedBox.shrink();
        }

        final pendingTaskPhase = homeState.pendingTaskPhase ?? 'open';
        final taskId = pendingTask['id']?.toString();
        final taskKey = taskId == null ? null : '$taskId:$pendingTaskPhase';
        if (pendingTaskPhase == 'open' &&
            taskKey != null &&
            _dismissedOpenTaskKey == taskKey) {
          return const SizedBox.shrink();
        }

        return Positioned(
          top: pendingTaskPhase == 'open' ? 104.h : 140.h,
          left: 16.h,
          right: 16.h,
          child: tasks(
            context,
            pendingTask: pendingTask,
            pendingTaskType: homeState.pendingTaskType ?? 'delivery',
            pendingTaskPhase: pendingTaskPhase,
          ),
        );
      },
    );
  }

  Widget _buildNearbyMoverRipple(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeNotifier);
        if (!homeState.isSearchingNearbyMovers || !homeState.highlightRoute) {
          return const SizedBox.shrink();
        }

        return Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: AnimatedBuilder(
                animation: _nearbySearchAnimationController,
                builder: (context, child) {
                  final value = _nearbySearchAnimationController.value;
                  return Transform.translate(
                    offset: Offset(0, 40.h),
                    child: SizedBox(
                      width: 220.h,
                      height: 220.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _buildRippleCircle(
                              scale: 0.6 + value, opacity: 0.25 * (1 - value)),
                          _buildRippleCircle(
                            scale: 0.35 + ((value + 0.35) % 1),
                            opacity: 0.18 * (1 - ((value + 0.35) % 1)),
                          ),
                          _buildRippleCircle(
                            scale: 0.2 + ((value + 0.65) % 1),
                            opacity: 0.12 * (1 - ((value + 0.65) % 1)),
                          ),
                          Container(
                            width: 54.h,
                            height: 54.h,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.primary,
                                width: 2.h,
                              ),
                            ),
                            child: Center(
                              child: CustomImageView(
                                imagePath: ImageConstant.imgLocationPrimary,
                                height: 22.h,
                                width: 22.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNearbyMoverSearchAction(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeNotifier);
        final searchData = homeState.nearbyMoverSearchData;
        if (searchData == null || searchData.isEmpty) {
          return const SizedBox.shrink();
        }

        final isSearching = homeState.isSearchingNearbyMovers;
        final buttonText = isSearching ? 'Searching movers' : 'View prices';

        return Positioned(
          bottom: 318.h,
          right: 20.h,
          child: CustomFloatingButton(
            height: 48,
            width: 48,
            backgroundColor: theme.colorScheme.onPrimary,
            shape: const CircleBorder(),
            onTap: () {
              AppBottomSheet.show(
                context: context,
                useRootNavigator: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.h),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                builder: (context) => SearchMoverBottomsheet(
                  requestType: homeState.nearbyMoverSearchType,
                  requestData: searchData,
                ),
                isScrollControlled: true,
              );
            },
            child: Tooltip(
              message: buttonText,
              child: Container(
                width: 48.h,
                height: 48.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10.h,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.18),
                    width: 1.h,
                  ),
                ),
                child: Icon(
                  isSearching
                      ? Icons.search_rounded
                      : Icons.local_offer_outlined,
                  color: theme.colorScheme.primary,
                  size: 22.h,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRippleCircle({
    required double scale,
    required double opacity,
  }) {
    final safeOpacity = opacity.clamp(0.0, 1.0).toDouble();
    return Container(
      width: 140.h * scale,
      height: 140.h * scale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: safeOpacity),
          width: 2.h,
        ),
      ),
    );
  }

  // Bottom navigation bar using CustomBottomBar
  Widget _buildBottomNavigation(BuildContext context) {
    return Positioned(
      bottom: 20.h,
      left: 0,
      right: 0,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          // Handle navigation changes here
          switch (type) {
            case BottomBarEnum.Home:
              // Already on home page
              break;
            case BottomBarEnum.Route:
              // Navigate to route page
              break;
            case BottomBarEnum.Move:
              // Handle move action
              break;
            case BottomBarEnum.Activity:
              // Navigate to activity page
              break;
            case BottomBarEnum.Profile:
              // Navigate to profile page
              break;
          }
        },
      ),
    );
  }

  // Section Widget
  Widget liveRoute(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 12.h),
      decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withValues(alpha: 1),
          borderRadius: BorderRadiusStyle.roundedBorder8,
          boxShadow: [
            BoxShadow(
              color: appTheme.gray9000c,
              spreadRadius: 2.h,
              blurRadius: 2.h,
              offset: Offset(0, 4),
            )
          ]),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            decoration: BoxDecoration(
              color: appTheme.lightGreen100,
              borderRadius: BorderRadiusStyle.CircleBorder20,
              border: Border.all(
                color: appTheme.green50,
                width: 6.h,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgCheckCircle,
                  height: 20.h,
                  width: 20.h,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: Text(
              "Your route is now live",
              style: CustomTextStyles.titleSmallInter,
            ),
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgCancel,
            height: 20.h,
            width: 20.h,
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 4.h, right: 4.h),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget tasks(
    BuildContext context, {
    required Map<String, dynamic> pendingTask,
    required String pendingTaskType,
    required String pendingTaskPhase,
  }) {
    if (pendingTaskPhase == 'open') {
      return _buildOpenTaskNotificationCard(
        context,
        pendingTask: pendingTask,
        pendingTaskType: pendingTaskType,
        pendingTaskPhase: pendingTaskPhase,
      );
    }

    final isRide = pendingTaskType == 'ride';
    final title = _pendingTaskTitle(
      isRide: isRide,
      phase: pendingTaskPhase,
    );
    final subtitle = _pendingTaskSubtitle(
      isRide: isRide,
      phase: pendingTaskPhase,
    );
    final actionLabel = _pendingTaskActionLabel(pendingTaskPhase);
    final origin =
        (isRide ? pendingTask['origin_name'] : pendingTask['pickup_name'])
                ?.toString() ??
            "Pickup";
    final destination =
        (isRide ? pendingTask['destination_name'] : pendingTask['dropoff_name'])
                ?.toString() ??
            "Destination";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 12.h),
      decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withValues(alpha: 1.0),
          borderRadius: BorderRadiusStyle.roundedBorder8,
          boxShadow: [
            BoxShadow(
              color: appTheme.gray9000c,
              spreadRadius: 2.h,
              blurRadius: 2.h,
              offset: Offset(0, 4),
            )
          ]),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconButton(
            height: 40.h,
            width: 40.h,
            padding: EdgeInsets.all(10.h),
            decoration: IconButtonStyleHelper.outlineDeepPurple,
            child: CustomImageView(
              imagePath:
                  isRide ? ImageConstant.imgBlackCar : ImageConstant.imgPackage,
            ),
          ),
          SizedBox(width: 16.h),
          SizedBox(
            width: 16.h,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: CustomTextStyles.titleSmallInter,
                    ),
                    Text(
                      subtitle,
                      style: CustomTextStyles.bodySmallErrorContainer,
                    ),
                    Text(
                      '$origin to $destination',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.bodySmallInterGray600,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: GestureDetector(
                        onTap: () {
                          _highlightPendingTaskRoute(
                            pendingTask: pendingTask,
                            pendingTaskType: pendingTaskType,
                            pendingTaskPhase: pendingTaskPhase,
                          );
                          _openPendingTaskBottomsheet(
                            context,
                            pendingTask: pendingTask,
                            pendingTaskType: pendingTaskType,
                            pendingTaskPhase: pendingTaskPhase,
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              actionLabel,
                              style: CustomTextStyles.labelLargePrimary,
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgPurpleRightArrow,
                              height: 14.h,
                              width: 14.h,
                              alignment: Alignment.topCenter,
                              margin: EdgeInsets.only(left: 4.h),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 16.h,
          ),
          SizedBox(
            width: 16.h,
          ),
          GestureDetector(
            onTap: () {
              _handlePendingTaskClose(
                context: context,
                pendingTaskPhase: pendingTaskPhase,
                pendingTaskType: pendingTaskType,
              );
            },
            child: CustomImageView(
              imagePath: ImageConstant.imgCancel,
              height: 20.h,
              width: 20.h,
              margin: EdgeInsets.only(top: 4.h),
            ),
          )
        ],
      ),
    );
  }

  // Navigation panel that appears when a ride is started
  Widget _buildNavigationPanel(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeNotifier);

        if (!homeState.isNavigationActive) {
          return const SizedBox.shrink();
        }

        return Positioned(
          top: 110.h,
          left: 16.h,
          right: 16.h,
          child: Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.h),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10.h,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                width: 1.h,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.navigation,
                        color: theme.colorScheme.primary,
                        size: 20.h,
                      ),
                    ),
                    SizedBox(width: 12.h),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Navigating to",
                            style: CustomTextStyles.bodySmallErrorContainer
                                .copyWith(
                              fontSize: 12.fSize,
                            ),
                          ),
                          Text(
                            homeState.routeDestinationName ?? "Destination",
                            style: CustomTextStyles.titleSmallInter.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        ref.read(homeNotifier.notifier).stopNavigation();
                      },
                    ),
                  ],
                ),
                Divider(height: 24.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 16.h,
                    ),
                    SizedBox(width: 8.h),
                    Text(
                      "On your way...",
                      style: CustomTextStyles.bodySmallErrorContainer,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Start ride button that appears when a route is highlighted
  Widget _buildStartRideButton(BuildContext context) {
    // Keep navigation logic available behind the scenes, but don't expose
    // the manual start/stop CTA until the full navigation flow is ready.
    return const SizedBox.shrink();
  }

  // Floating action button positioned at bottom right
  Widget _buildFloatingactionb(BuildContext context) {
    return Positioned(
      bottom: 256.h, // Above bottom navigation
      right: 20.h,
      child: CustomFloatingButton(
        height: 48,
        width: 48,
        onTap: () {
          // Reset map to current location when floating button is tapped
          if (currentPosition != null) {
            cameraToPosition(currentPosition!);
          }
        },
        // backgroundColor: theme.colorScheme.primary,
        child: CustomImageView(
          imagePath: ImageConstant.imgLocationPrimary,
          height: 24.0.h,
          width: 24.0.h,
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeNotifier);
        if (!homeState.isLive && !homeState.isNavigationActive) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: homeState.highlightRoute ? 190.h : 120.h,
          right: 20.h,
          child: GestureDetector(
            onTap: _sendEmergencyAlert,
            child: Container(
              width: 56.h,
              height: 56.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10.h,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'SOS',
                  style: CustomTextStyles.titleSmallOnPrimary.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOpenTaskNotificationCard(
    BuildContext context, {
    required Map<String, dynamic> pendingTask,
    required String pendingTaskType,
    required String pendingTaskPhase,
  }) {
    final isRide = pendingTaskType == 'ride';
    final taskId = pendingTask['id']?.toString() ?? '';
    final taskKey = '$taskId:$pendingTaskPhase';
    final title = _pendingTaskTitle(
      isRide: isRide,
      phase: pendingTaskPhase,
    );
    final subtitle = _pendingTaskSubtitle(
      isRide: isRide,
      phase: pendingTaskPhase,
    );

    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.h),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A101828),
            offset: Offset(0, 12),
            blurRadius: 16,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Color(0x0D101828),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.h),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.h, 16.h, 16.h, 18.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40.h,
                    height: 40.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDE8FF),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 32.h,
                        height: 32.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDDD4FF),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomImageView(
                            imagePath: isRide
                                ? ImageConstant.imgBlackCar
                                : ImageConstant.imgPackage,
                            height: 18.h,
                            width: 18.h,
                            color: const Color(0xFF6A1AD3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 1.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.fSize,
                              height: 20 / 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF3D3D3D),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12.fSize,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF4F4F4F),
                              letterSpacing: -0.6,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          GestureDetector(
                            onTap: () {
                              _highlightPendingTaskRoute(
                                pendingTask: pendingTask,
                                pendingTaskType: pendingTaskType,
                                pendingTaskPhase: pendingTaskPhase,
                              );
                              _openPendingTaskBottomsheet(
                                context,
                                pendingTask: pendingTask,
                                pendingTaskType: pendingTaskType,
                                pendingTaskPhase: pendingTaskPhase,
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 12.fSize,
                                    height: 1.2,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF6A1AD3),
                                  ),
                                ),
                                SizedBox(width: 4.h),
                                CustomImageView(
                                  imagePath: ImageConstant.imgPurpleRightArrow,
                                  height: 14.h,
                                  width: 14.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.h),
                  GestureDetector(
                    onTap: () => _dismissOpenTask(taskKey),
                    child: Container(
                      width: 20.h,
                      height: 20.h,
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.close_rounded,
                        size: 20.h,
                        color: const Color(0xFF6D6D6D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 2.h,
                color: const Color(0xFFEDE8FF),
                child: AnimatedBuilder(
                  animation: _taskRequestCountdownController,
                  builder: (context, child) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: _taskRequestCountdownController.value
                            .clamp(0.0, 1.0),
                        child: Container(
                          height: 2.h,
                          color: const Color(0xFF6A1AD3),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onTapNotification(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.notificationScreen);
  }

  Future<void> _openPendingTaskBottomsheet(
    BuildContext context, {
    required Map<String, dynamic> pendingTask,
    required String pendingTaskType,
    required String pendingTaskPhase,
  }) async {
    await AppBottomSheet.show(
      context: context,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.h),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      builder: (context) {
        if (pendingTaskType == 'ride' && pendingTaskPhase == 'active') {
          return RideSharingPickupTwo();
        }
        if (pendingTaskType == 'ride' && pendingTaskPhase == 'accepted') {
          return RideSharingPickupOne();
        }
        if (pendingTaskType == 'ride') {
          return RideSharingTaskBottomsheetOne();
        }
        if (pendingTaskPhase == 'accepted' || pendingTaskPhase == 'active') {
          return DeliveryPickupScreenOne();
        }
        return DeliveryTaskOneBottomsheet();
      },
      routeSettings: RouteSettings(
        arguments: {
          'requestType': pendingTaskType,
          'requestData': pendingTask,
          'taskPhase': pendingTaskPhase,
        },
      ),
    );
  }

  String _pendingTaskTitle({
    required bool isRide,
    required String phase,
  }) {
    if (isRide) {
      switch (phase) {
        case 'accepted':
          return 'Ride request accepted';
        case 'active':
          return 'Trip in progress';
        default:
          return 'Ride sharing task';
      }
    }

    switch (phase) {
      case 'accepted':
        return 'Delivery accepted';
      case 'active':
        return 'Delivery in progress';
      default:
        return 'Delivery task';
    }
  }

  String _pendingTaskSubtitle({
    required bool isRide,
    required String phase,
  }) {
    if (isRide) {
      switch (phase) {
        case 'accepted':
          return 'Passenger selected your fare. Proceed to pickup.';
        case 'active':
          return 'The trip is active and ready to resume.';
        default:
          return 'You have a ride sharing request';
      }
    }

    switch (phase) {
      case 'accepted':
        return 'Your delivery offer was selected. Proceed to pickup.';
      case 'active':
        return 'The package is already in transit.';
      default:
        return 'You have a delivery request';
    }
  }

  String _pendingTaskActionLabel(String phase) {
    switch (phase) {
      case 'accepted':
        return 'Open task';
      case 'active':
        return 'Resume task';
      default:
        return 'View details';
    }
  }

  void _highlightPendingTaskRoute({
    required Map<String, dynamic> pendingTask,
    required String pendingTaskType,
    required String pendingTaskPhase,
  }) {
    final isRide = pendingTaskType == 'ride';
    final isActive = pendingTaskPhase == 'active';
    final destinationLat = double.tryParse(
      (isRide
                  ? (isActive
                      ? pendingTask['destination_latitude']
                      : pendingTask['origin_latitude'])
                  : (isActive
                      ? pendingTask['dropoff_latitude']
                      : pendingTask['pickup_latitude']))
              ?.toString() ??
          '',
    );
    final destinationLng = double.tryParse(
      (isRide
                  ? (isActive
                      ? pendingTask['destination_longitude']
                      : pendingTask['origin_longitude'])
                  : (isActive
                      ? pendingTask['dropoff_longitude']
                      : pendingTask['pickup_longitude']))
              ?.toString() ??
          '',
    );
    final destinationName = (isRide
            ? (isActive
                ? pendingTask['destination_name']
                : pendingTask['origin_name'])
            : (isActive
                ? pendingTask['dropoff_name']
                : pendingTask['pickup_name']))
        ?.toString();

    if (destinationLat == null || destinationLng == null) {
      return;
    }

    final sourceLat = currentPosition?.latitude ?? destinationLat;
    final sourceLng = currentPosition?.longitude ?? destinationLng;
    ref.read(homeNotifier.notifier).setRouteCoordinates(
          locationLat: sourceLat,
          locationLng: sourceLng,
          destinationLat: destinationLat,
          destinationLng: destinationLng,
          destinationName: destinationName,
        );
  }

  void _startOpenTaskCountdown(String taskKey) {
    _openTaskCountdownKey = taskKey;
    _dismissedOpenTaskKey = null;
    _taskRequestCountdownController.stop();
    _taskRequestCountdownController.reverse(from: 1.0);
  }

  void _dismissOpenTask(String taskKey) {
    setState(() {
      _dismissedOpenTaskKey = taskKey;
    });
    _taskRequestCountdownController.stop();
  }

  Future<void> _handlePendingTaskClose({
    required BuildContext context,
    required String pendingTaskPhase,
    required String pendingTaskType,
  }) async {
    if (pendingTaskPhase != 'accepted') {
      return;
    }

    final pendingTask = ref.read(homeNotifier).pendingTaskData;
    final matchId = pendingTask?['_match_id']?.toString() ?? '';
    if (matchId.isEmpty) {
      return;
    }

    final cancelled = await NavigatorService.pushNamed(
          AppRoutes.rideCancelScreenOne,
          arguments: {
            'matchId': matchId,
            'requestType': pendingTaskType,
            'source': 'mover_task',
          },
        ) ??
        false;

    if (cancelled == true && mounted) {
      ref.read(homeNotifier.notifier).clearRouteHighlight();
      await ref.read(homeNotifier.notifier).loadPendingTask();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task cancelled. You can receive new requests now.'),
        ),
      );
    }
  }

  // Asks the user for permission to access location
  // requestLocationPermission(BuildContext context) async {
  //   await PermissionManager.askForPermission(Permission.location);
  // }
}

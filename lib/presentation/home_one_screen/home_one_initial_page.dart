import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as polyline;
import 'package:movr/presentation/delivery_task_one_bottomsheet/delivery_task_one_bottomsheet.dart';
import '../../core/app_export.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/location_manager.dart';
import '../../core/utils/map_utils.dart';
import '../../widgets/custom_floating_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_switch.dart';
import 'notifier/home_notifier.dart';

class HomeOneInitialPage extends ConsumerStatefulWidget{
  const HomeOneInitialPage({super.key});

  @override
  HomeOneInitialPageState createState() => HomeOneInitialPageState();
}

// ignore for file: must be immutabel
class HomeOneInitialPageState extends ConsumerState<HomeOneInitialPage> with TickerProviderStateMixin {
  final loc.Location locationController = loc.Location();
  LatLng? currentPosition;
  double userHeading = 0.0;
  gmaps.BitmapDescriptor? customMarkerIcon;

  static const LatLng defaultLocation = LatLng(latitude: 6.6085, longitude: 3.2881);
  static const LatLng sourceLocation = LatLng(latitude: 6.6085, longitude: 3.2881);
  static const LatLng destinationLocation = LatLng(latitude: 6.5243, longitude: 3.3792);

  late Completer<GoogleNavigationViewController> googleMapController;
  late Completer<GoogleNavigationViewController> googleMapController1;

  static const googleMapsApiKey = Constants.googleMapsApiKey;

  // Animation controllers and variables
  late AnimationController _sidebarAnimationController;
  late AnimationController _filterButtonAnimationController;
  late Animation<Offset> _sidebarSlideAnimation;
  late Animation<double> _filterButtonRotationAnimation;
  bool _isSidebarVisible = false;
  
  // Location stream subscription
  StreamSubscription? _locationSubscription;

  // Polyline variables
  List<LatLng> polylineCoordinates = [];
  List<PolylineOptions> polylines = [];
  LatLng? routeSourceLocation;
  LatLng? routeDestinationLocation;

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
            const SnackBar(content: Text('You have arrived at your destination')),
          );
        }
      });
    } catch (e) {
      // Log error silently in production
    }
  }

  Future<void> _initializeLocationAndPolyline() async {
    try {
      customMarkerIcon = await MapUtils.bitmapDescriptorWithBeam(
        width: 150,
      );
      if (mounted) setState(() {});
    } catch (e) {
      // Error loading custom marker
    }

    try {
      await getLocationUpdates();
    } catch (e) {
      // Error getting location updates
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
    _locationSubscription?.cancel();
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
  Widget build(BuildContext context){
    ref.listen(homeNotifier.select((s) => s.isNavigationActive), (previous, next) {
      if (next == true) {
        _startNavigation();
      } else if (next == false && previous == true) {
        _stopNavigation();
      }
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
          // _buildTaskNotification(context),
          // _buildBottomNavigation(context),
          _buildStartRideButton(context),
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
                    child: _buildLiveRouteNotificationContent(context, homeState.isLive),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMaps(BuildContext context){
    return Consumer(
      builder: (context, ref, _) {
        final homeState = ref.watch(homeNotifier);
        
        List<MarkerOptions> markerOptions = [];
        if (currentPosition != null) {
          markerOptions.add(
            MarkerOptions(
              position: currentPosition!,
              rotation: userHeading,
              anchor: const MarkerAnchor(u: 0.5, v: 0.5),
            ),
          );
        }
        
        if (homeState.highlightRoute &&
            homeState.routeLocationLat != null &&
            homeState.routeLocationLng != null &&
            homeState.routeDestinationLat != null &&
            homeState.routeDestinationLng != null) {
          final source = LatLng(latitude: homeState.routeLocationLat!, longitude: homeState.routeLocationLng!);
          final destination = LatLng(latitude: homeState.routeDestinationLat!, longitude: homeState.routeDestinationLng!);
          
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
        
        return GoogleMapsNavigationView(
            initialCameraPosition: CameraPosition(
              target: currentPosition ?? defaultLocation,
              zoom: 18.0,
            ),
            onViewCreated: (GoogleNavigationViewController controller){
              if (!googleMapController.isCompleted) {
                googleMapController.complete(controller);
              }
              
              // Set markers via controller
              controller.addMarkers(markerOptions);
              
              if (homeState.highlightRoute &&
                  homeState.routeLocationLat != null &&
                  homeState.routeLocationLng != null &&
                  homeState.routeDestinationLat != null &&
                  homeState.routeDestinationLng != null) {
                _loadAndDisplayRoute(
                  LatLng(latitude: homeState.routeLocationLat!, longitude: homeState.routeLocationLng!),
                  LatLng(latitude: homeState.routeDestinationLat!, longitude: homeState.routeDestinationLng!),
                  controller,
                );
              }
            },
          );
      },
    );
  }

  Future<void> _loadAndDisplayRoute(LatLng source, LatLng destination, GoogleNavigationViewController controller) async {
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
      
      if (coordinates.isNotEmpty) {
        await _animateCameraToShowRoute(source, destination, controller);
      }
    } catch (e) {
      // Error loading route
    }
  }

  Future<void> _animateCameraToShowRoute(LatLng source, LatLng destination, GoogleNavigationViewController controller) async {
    final sw = LatLng(
      latitude: source.latitude < destination.latitude ? source.latitude : destination.latitude,
      longitude: source.longitude < destination.longitude ? source.longitude : destination.longitude,
    );
    final ne = LatLng(
      latitude: source.latitude > destination.latitude ? source.latitude : destination.latitude,
      longitude: source.longitude > destination.longitude ? source.longitude : destination.longitude,
    );
    
    final bounds = LatLngBounds(southwest: sw, northeast: ne);
    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding: 100));
  }

  Future<void> cameraToPosition(LatLng position) async {
    final GoogleNavigationViewController controller = await googleMapController.future;
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
    
    if (homeState.routeDestinationLat != null && homeState.routeDestinationLng != null) {
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
      bool hasPermission = await LocationManager.checkAndRequestLocationPermission();
      
      if (!hasPermission) {
        return;
      }

      // Configure location settings for better tracking during transit
      await locationController.changeSettings(
        accuracy: loc.LocationAccuracy.high,
        interval: 1000, // Update every second
        distanceFilter: 2, // Update if moved more than 2 meters
      );

      _locationSubscription?.cancel();
      _locationSubscription = locationController.onLocationChanged.listen((loc.LocationData currentLocation) {
        if (currentLocation.latitude != null && currentLocation.longitude != null && mounted) {
          final newPosition = LatLng(
            latitude: currentLocation.latitude!,
            longitude: currentLocation.longitude!,
          );
          
          final double newHeading = currentLocation.heading ?? userHeading;
          
          final bool isFirstLocation = currentPosition == null;
          final bool isNavigating = ref.read(homeNotifier).isNavigationActive;
          
          // Use smaller threshold when navigating to keep focus on custom marker
          final double threshold = isNavigating ? 0.00002 : 0.0001; 
          
          if (isFirstLocation || 
              (currentPosition!.latitude - newPosition.latitude).abs() > threshold ||
              (currentPosition!.longitude - newPosition.longitude).abs() > threshold ||
              (userHeading - newHeading).abs() > 1.0) {
            setState(() {
              currentPosition = newPosition;
              userHeading = newHeading;
            });
            
            if (isFirstLocation || isNavigating) {
              cameraToPosition(newPosition);
              
              // Trim polyline to clear trailing highlight during navigation
              if (isNavigating && polylineCoordinates.isNotEmpty) {
                _trimPolyline(newPosition);
              }
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
    
    polyline.PolylinePoints polylinePoints = polyline.PolylinePoints(apiKey: googleMapsApiKey);
    polyline.RoutesApiRequest request = polyline.RoutesApiRequest(
      origin: polyline.PointLatLng(source.latitude, source.longitude),
      destination: polyline.PointLatLng(dest.latitude, dest.longitude),
      travelMode: polyline.TravelMode.driving
    );
    polyline.RoutesApiResponse response = await polylinePoints.getRouteBetweenCoordinatesV2(request: request);
    if (response.routes.isNotEmpty) {
      polyline.Route route = response.routes.first;
      route.polylinePoints?.forEach((polyline.PointLatLng point) {
        coordinates.add(LatLng(latitude: point.latitude, longitude: point.longitude));
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
            ]
          ),
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
              ]
            ),
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
      child: GestureDetector(
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
            children: [
              Center(
                child: CustomImageView(
                  imagePath: ImageConstant.imgNotificationBell,
                  height: 20.h,
                  width: 20.h,
                  color: Color(0xFF6D6D6D),
                ),
              ),
              // Notification badge
              // Positioned(
              //   top: 8.h,
              //   right: 8.h,
              //   child: Container(
              //     width: 8.h,
              //     height: 8.h,
              //     decoration: BoxDecoration(
              //       color: Colors.red,
              //       shape: BoxShape.circle,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
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
              ref.read(homeNotifier.notifier).toggleIsLive(value);
            },
          );
        },
      ),
    );
  }

  // Live route notification card that displays temporarily with fade effect
  Widget _buildLiveRouteNotificationContent(BuildContext context, bool isLive) {
    final message = isLive ? "Your route is now live" : "Your route is now disabled";
    final backgroundColor = isLive ? const Color(0xFFD4EDDA) : const Color(0xFFFFE5E5);
    final iconColor = isLive ? const Color(0xFF28A745) : const Color(0xFFDC3545);
    final messageColor = isLive ? const Color(0xFF28A745) : const Color(0xFFDC3545);
    
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
    return Positioned(
      top: 140.h,
      left: 100.h,
      right: 20.h,
      child: Column(
        children: [
          liveRoute(context),
          SizedBox(height: 16.h),
          tasks(context),
        ],
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
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 12.h
      ),
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
        ]
      ),
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
            margin: EdgeInsets.only(
              top: 4.h, 
              right: 4.h
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget tasks(BuildContext context) {
    return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
              vertical: 12.h
            ),
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
              ]
            ),
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
                  child: CustomImageView(imagePath: ImageConstant.imgPackage,),
                ),
                SizedBox(width: 16.h),
                SizedBox(width: 16.h,),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delivery task",
                            style: CustomTextStyles.titleSmallInter,
                          ),
                          Text(
                            "You have a delivery request",
                            style: CustomTextStyles.bodySmallErrorContainer,
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context, 
                                  builder: (_) => DeliveryTaskOneBottomsheet(),
                                  isScrollControlled: true,
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "View details",
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
                SizedBox(width: 16.h,),
                SizedBox(width: 16.h,),
                CustomImageView(
                  imagePath: ImageConstant.imgCancel,
                  height: 20.h,
                  width: 20.h,
                  margin: EdgeInsets.only(
                    top: 4.h
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
                            style: CustomTextStyles.bodySmallErrorContainer.copyWith(
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
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeNotifier);
        
        if (!homeState.highlightRoute) {
          return const SizedBox.shrink();
        }
        
        return Positioned(
          bottom: 120.h,
          left: 20.h,
          right: 20.h,
          child: GestureDetector(
            onTap: () {
              if (homeState.isNavigationActive) {
                ref.read(homeNotifier.notifier).stopNavigation();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ride ended')),
                );
              } else {
                ref.read(homeNotifier.notifier).startNavigation();
                // Immediately focus on current position when navigation starts
                if (currentPosition != null) {
                  cameraToPosition(currentPosition!);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigation started')),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: homeState.isNavigationActive ? Colors.red : theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12.h),
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
                  homeState.isNavigationActive ? "Stop Ride" : "Start Ride",
                  style: CustomTextStyles.titleMediumOnPrimary.copyWith(
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

  // Floating action button positioned at bottom right
  Widget _buildFloatingactionb(BuildContext context){
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

  onTapNotification(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.notificationScreen);
  }

  // Asks the user for permission to access location
  // requestLocationPermission(BuildContext context) async {
  //   await PermissionManager.askForPermission(Permission.location);
  // }
}
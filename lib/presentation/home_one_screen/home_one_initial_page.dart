import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as polyline;
import 'package:new_project/presentation/delivery_task_one_bottomsheet/delivery_task_one_bottomsheet.dart';
import '../../core/app_export.dart';
import '../../core/utils/constants.dart';
import '../../widgets/custom_floating_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_switch.dart';
import 'notifier/home_notifier.dart';

class HomeOneInitialPage extends StatefulWidget{
  const HomeOneInitialPage({super.key});

  @override
  HomeOneInitialPageState createState() => HomeOneInitialPageState();
}

// ignore for file: must be immutabel
class HomeOneInitialPageState extends State<HomeOneInitialPage> with TickerProviderStateMixin {
  final Location locationController = Location();
  LatLng? currentPosition;

  static const LatLng defaultLocation = LatLng(6.6085, 3.2881);
  static const LatLng sourceLocation = LatLng(6.6085, 3.2881);
  static const LatLng destinationLocation = LatLng(6.5243, 3.3792);

  late Completer<GoogleMapController> googleMapController;
  late Completer<GoogleMapController> googleMapController1;

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
  Set<Polyline> polylines = {};
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
  }

  Future<void> _initializeLocationAndPolyline() async {
    try {
      await getLocationUpdates();
    } catch (e) {
      print('Error getting location updates: $e');
    }
    
    try {
      await getPolylinePoints();
    } catch (e) {
      print('Error getting polyline points: $e');
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
          // _buildTaskNotification(context),
          // _buildBottomNavigation(context),
          _buildFloatingactionb(context),
          // Temporary notification for isLive status with fade animation
          IgnorePointer(
            child: Consumer(
              builder: (context, ref, child) {
                final homeState = ref.watch(homeNotifier);
                return Positioned(
                  top: 160.h,
                  left: 16.h,
                  child: AnimatedOpacity(
                    opacity: homeState.showLiveNotification ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: _buildLiveRouteNotificationContent(context, homeState.isLive),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaps(BuildContext context){
    return Consumer(
      builder: (context, ref, _) {
        final homeState = ref.watch(homeNotifier);
        
        Set<Marker> markers = {};
        if (currentPosition != null) {
          markers.add(
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: currentPosition!,
              infoWindow: const InfoWindow(title: 'My Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            ),
          );
        }
        
        if (homeState.highlightRoute &&
            homeState.routeLocationLat != null &&
            homeState.routeLocationLng != null &&
            homeState.routeDestinationLat != null &&
            homeState.routeDestinationLng != null) {
          final source = LatLng(homeState.routeLocationLat!, homeState.routeLocationLng!);
          final destination = LatLng(homeState.routeDestinationLat!, homeState.routeDestinationLng!);
          
          markers.add(
            Marker(
              markerId: const MarkerId('routeSource'),
              position: source,
              infoWindow: const InfoWindow(title: 'Pick-up'),
            ),
          );
          markers.add(
            Marker(
              markerId: const MarkerId('routeDestination'),
              position: destination,
              infoWindow: const InfoWindow(title: 'Destination'),
            ),
          );
        }
        
        return RepaintBoundary(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: currentPosition ?? defaultLocation,
              zoom: 18.0,
            ),
            markers: markers,
            polylines: polylines,
            onMapCreated: (GoogleMapController controller){
              if (!googleMapController.isCompleted) {
                googleMapController.complete(controller);
              }
              
              if (homeState.highlightRoute &&
                  homeState.routeLocationLat != null &&
                  homeState.routeLocationLng != null &&
                  homeState.routeDestinationLat != null &&
                  homeState.routeDestinationLng != null) {
                _loadAndDisplayRoute(
                  LatLng(homeState.routeLocationLat!, homeState.routeLocationLng!),
                  LatLng(homeState.routeDestinationLat!, homeState.routeDestinationLng!),
                  controller,
                );
              }
            },
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            tiltGesturesEnabled: false,
            rotateGesturesEnabled: false,
          ),
        );
      },
    );
  }

  Future<void> _loadAndDisplayRoute(LatLng source, LatLng destination, GoogleMapController controller) async {
    try {
      final coordinates = await getPolylinePoints(
        origin: source,
        destination: destination,
      );
      
      setState(() {
        polylineCoordinates = coordinates;
        polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            color: theme.colorScheme.primary,
            width: 5,
            points: coordinates,
          )
        };
      });
      
      if (coordinates.isNotEmpty) {
        await _animateCameraToShowRoute(source, destination, controller);
      }
    } catch (e) {
      print('Error loading route: $e');
    }
  }

  Future<void> _animateCameraToShowRoute(LatLng source, LatLng destination, GoogleMapController controller) async {
    final sw = LatLng(
      source.latitude < destination.latitude ? source.latitude : destination.latitude,
      source.longitude < destination.longitude ? source.longitude : destination.longitude,
    );
    final ne = LatLng(
      source.latitude > destination.latitude ? source.latitude : destination.latitude,
      source.longitude > destination.longitude ? source.longitude : destination.longitude,
    );
    
    final bounds = LatLngBounds(southwest: sw, northeast: ne);
    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  Future<void> cameraToPosition(LatLng position) async {
    final GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 18.0,
        ),
      ),
    );
  }

  Future<void> getLocationUpdates() async {
    try {
      bool isServiceEnabled = await locationController.serviceEnabled();
      PermissionStatus permissionGranted;
      
      if(!isServiceEnabled) {
        print('Location service not enabled');
        return;
      }

      permissionGranted = await locationController.hasPermission();
      if(permissionGranted == PermissionStatus.denied) {
        print('Location permission denied');
        return;
      }

      _locationSubscription?.cancel();
      _locationSubscription = locationController.onLocationChanged.listen((LocationData currentLocation) {
        if (currentLocation.latitude != null && currentLocation.longitude != null && mounted) {
          final newPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
          
          final bool isFirstLocation = currentPosition == null;
          
          if (isFirstLocation || 
              (currentPosition!.latitude - newPosition.latitude).abs() > 0.0001 ||
              (currentPosition!.longitude - newPosition.longitude).abs() > 0.0001) {
            setState(() {
              currentPosition = newPosition;
            });
            
            if (isFirstLocation) {
              cameraToPosition(newPosition);
            }
          }
        }
      }, onError: (e) {
        print('Location error: $e');
      });
    } catch (e) {
      print('Error in getLocationUpdates: $e');
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
        coordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    return coordinates;
  }

  Widget _buildTopNotificationBar(BuildContext context) {
    return currentPosition == null 
      ? const SizedBox.shrink()
      : IgnorePointer(
          child: Positioned(
            top: MediaQuery.of(context).size.height / 2 - 20.h,
            left: MediaQuery.of(context).size.width / 2 - 80.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 6.h),
              decoration: BoxDecoration(
                color: appTheme.gray10001,
                borderRadius: BorderRadiusStyle.CircleBorder20,
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
      child: RepaintBoundary(
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
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeNotifier);
        return Positioned(
          top: 112.h,
          right: 20.h,
          child: CustomSwitch(
            value: homeState.isLive,
            isDisabled: homeState.isToggling,
            onChange: (value) {
              ref.read(homeNotifier.notifier).toggleIsLive(value);
            },
          ),
        );
      },
    );
  }

  // Live route notification card that displays temporarily with fade effect
  Widget _buildLiveRouteNotificationContent(BuildContext context, bool isLive) {
    final message = isLive ? "Your route is now live" : "Your route is now disabled";
    final backgroundColor = isLive ? const Color(0xFFD4EDDA) : const Color(0xFFFFE5E5);
    final iconColor = isLive ? const Color(0xFF28A745) : const Color(0xFFDC3545);
    final messageColor = isLive ? const Color(0xFF28A745) : const Color(0xFFDC3545);
    
    return Container(
      margin: EdgeInsets.only(top: 160.h, right: 16.h, left: 16.h),
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
        child: RepaintBoundary(
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
    Navigator.pushNamed(context, AppRoutes.notificationScreen);
  }

  // Asks the user for permission to access location
  // requestLocationPermission(BuildContext context) async {
  //   await PermissionManager.askForPermission(Permission.location);
  // }
}
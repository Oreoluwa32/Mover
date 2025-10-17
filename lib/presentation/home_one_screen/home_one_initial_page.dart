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
import 'models/home_initial_model.dart';
import 'notifier/home_notifier.dart';

class HomeOneInitialPage extends StatefulWidget{
  const HomeOneInitialPage({Key? key})
    :super(key: key,
    );

  @override
  HomeOneInitialPageState createState() => HomeOneInitialPageState();
}

// ignore for file: must be immutabel
class HomeOneInitialPageState extends State<HomeOneInitialPage> with TickerProviderStateMixin {
  final Location locationController = Location();
  LatLng? currentPosition;

  static const LatLng sourceLocation = LatLng(6.6085, 3.2881);
  static const LatLng destinationLocation = LatLng(6.5243, 3.3792);

  late Completer<GoogleMapController> googleMapController;
  late Completer<GoogleMapController> googleMapController1;

  static const googleMapsApiKey = Constants.GOOGLE_MAPS_API_KEY;

  // Animation controllers and variables
  late AnimationController _sidebarAnimationController;
  late AnimationController _filterButtonAnimationController;
  late Animation<Offset> _sidebarSlideAnimation;
  late Animation<double> _filterButtonRotationAnimation;
  bool _isSidebarVisible = false;
  
  // Location stream subscription
  StreamSubscription? _locationSubscription;

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
      await getPolylinePoints();
    } catch (e) {
      print('Error initializing location: $e');
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
          _buildTopNotificationBar(context),
          _buildTopRightNotificationButton(context),
          _buildLeftSidebar(context),
          _buildFilterButton(context),
          // _buildTaskNotification(context),
          // _buildBottomNavigation(context),
          _buildFloatingactionb(context),
        ],
      ),
    );
  }

  // Section widget - Full screen Google Map
  Widget _buildMaps(BuildContext context){
    return currentPosition == null 
      ? const Center(child: CircularProgressIndicator()) 
      : GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(6.6085, 3.2881),
            zoom: 20.0,
          ),
          markers: {
            Marker(
              markerId: MarkerId('currentLocation'),
              position: currentPosition!
            ),
            Marker(
              markerId: MarkerId('sourceLocation'),
              position: sourceLocation
            ),
            Marker(
              markerId: MarkerId('destinationLocation'),
              position: destinationLocation
            )
          },
          onMapCreated: (GoogleMapController controller){
            googleMapController.complete(controller);
          },
          zoomControlsEnabled: false, // Disable default controls
          zoomGesturesEnabled: true,
          myLocationButtonEnabled: false, // We'll add custom button
          myLocationEnabled: true,
        );
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
    bool isServiceEnabled = await locationController.serviceEnabled();
    PermissionStatus permissionGranted;
    
    if(isServiceEnabled) {
      isServiceEnabled = await locationController.requestService();
    }
    else{
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if(permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if(permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription?.cancel();
    _locationSubscription = locationController.onLocationChanged.listen((LocationData currentLocation) {
      // Handle location updates here
      if (currentLocation.latitude != null && currentLocation.longitude != null && mounted) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
          cameraToPosition(currentPosition!);
        });
      }
    }, onError: (e) {
      print('Location error: $e');
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    polyline.PolylinePoints polylinePoints = polyline.PolylinePoints(apiKey: googleMapsApiKey);
    polyline.RoutesApiRequest request = polyline.RoutesApiRequest(
      origin: polyline.PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      destination: polyline.PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
      travelMode: polyline.TravelMode.driving
    );
    polyline.RoutesApiResponse response = await polylinePoints.getRouteBetweenCoordinatesV2(request: request);
    if (response.routes.isNotEmpty) {
      polyline.Route route = response.routes.first;
      route.polylinePoints?.forEach((polyline.PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    return polylineCoordinates;
  }

  // Top notification bar with "1000+ routes are live"
  Widget _buildTopNotificationBar(BuildContext context) {
    return Positioned(
      top: 65.h,
      left: 70.h,
      // right: 20.h,
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
              offset: Offset(0, 0),
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
              angle: _filterButtonRotationAnimation.value * 2 * 3.14159, // Convert to radians
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

  // Floating action button positioned at bottom right
  Widget _buildFloatingactionb(BuildContext context){
    return Positioned(
      bottom: 256.h, // Above bottom navigation
      right: 20.h,
      child: CustomFloatingButton(
        height: 48,
        width: 48,
        // backgroundColor: theme.colorScheme.primary,
        child: CustomImageView(
          imagePath: ImageConstant.imgLocationPrimary,
          height: 25.0.h,
          width: 25.0.h,
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
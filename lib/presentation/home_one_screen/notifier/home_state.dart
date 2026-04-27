part of 'home_notifier.dart';

// Represents the state of the home screen in the app
// ignore for file, class must be immutable
class HomeState extends Equatable {
  HomeState({
    this.isSelectedSwitch = false,
    this.homeInitialModelObj,
    this.homeModelObj,
    this.isLive = false,
    this.showLiveNotification = false,
    this.isToggling = false,
    this.highlightRoute = false,
    this.isNavigationActive = false,
    this.routeLocationLat,
    this.routeLocationLng,
    this.routeDestinationLat,
    this.routeDestinationLng,
    this.routeDestinationName,
    this.pendingTaskType,
    this.pendingTaskPhase,
    this.pendingTaskData,
    this.isLoadingPendingTask = false,
    this.isSearchingNearbyMovers = false,
    this.nearbyMoverSearchType,
    this.nearbyMoverSearchData,
    this.nearbyMoverSearchEndsAt,
    this.nearbyMovers = const <Map<String, dynamic>>[],
    this.nearbyMoverLastUpdatedAt,
  });

  bool isSelectedSwitch;
  HomeModel? homeModelObj;
  HomeInitialModel? homeInitialModelObj;
  bool isLive;
  bool showLiveNotification;
  bool isToggling;
  bool highlightRoute;
  bool isNavigationActive;
  double? routeLocationLat;
  double? routeLocationLng;
  double? routeDestinationLat;
  double? routeDestinationLng;
  String? routeDestinationName;
  String? pendingTaskType;
  String? pendingTaskPhase;
  Map<String, dynamic>? pendingTaskData;
  bool isLoadingPendingTask;
  bool isSearchingNearbyMovers;
  String? nearbyMoverSearchType;
  Map<String, dynamic>? nearbyMoverSearchData;
  DateTime? nearbyMoverSearchEndsAt;
  List<Map<String, dynamic>> nearbyMovers;
  DateTime? nearbyMoverLastUpdatedAt;

  @override
  List<Object?> get props => [
        isSelectedSwitch,
        homeModelObj,
        homeInitialModelObj,
        isLive,
        showLiveNotification,
        isToggling,
        highlightRoute,
        isNavigationActive,
        routeLocationLat,
        routeLocationLng,
        routeDestinationLat,
        routeDestinationLng,
        routeDestinationName,
        pendingTaskType,
        pendingTaskPhase,
        pendingTaskData,
        isLoadingPendingTask,
        isSearchingNearbyMovers,
        nearbyMoverSearchType,
        nearbyMoverSearchData,
        nearbyMoverSearchEndsAt,
        nearbyMovers,
        nearbyMoverLastUpdatedAt,
      ];

  HomeState copyWith({
    bool? isSelectedSwitch,
    HomeModel? homeModelObj,
    HomeInitialModel? homeInitialModelObj,
    bool? isLive,
    bool? showLiveNotification,
    bool? isToggling,
    bool? highlightRoute,
    bool? isNavigationActive,
    double? routeLocationLat,
    double? routeLocationLng,
    double? routeDestinationLat,
    double? routeDestinationLng,
    String? routeDestinationName,
    String? pendingTaskType,
    String? pendingTaskPhase,
    Map<String, dynamic>? pendingTaskData,
    bool? isLoadingPendingTask,
    bool? isSearchingNearbyMovers,
    String? nearbyMoverSearchType,
    Map<String, dynamic>? nearbyMoverSearchData,
    DateTime? nearbyMoverSearchEndsAt,
    List<Map<String, dynamic>>? nearbyMovers,
    DateTime? nearbyMoverLastUpdatedAt,
    bool clearPendingTask = false,
    bool clearNearbyMoverSearch = false,
    bool clearRouteHighlight = false,
  }) {
    return HomeState(
      isSelectedSwitch: isSelectedSwitch ?? this.isSelectedSwitch,
      homeModelObj: homeModelObj ?? this.homeModelObj,
      homeInitialModelObj: homeInitialModelObj ?? this.homeInitialModelObj,
      isLive: isLive ?? this.isLive,
      showLiveNotification: showLiveNotification ?? this.showLiveNotification,
      isToggling: isToggling ?? this.isToggling,
      highlightRoute: highlightRoute ?? this.highlightRoute,
      isNavigationActive: isNavigationActive ?? this.isNavigationActive,
      routeLocationLat: clearRouteHighlight
          ? null
          : (routeLocationLat ?? this.routeLocationLat),
      routeLocationLng: clearRouteHighlight
          ? null
          : (routeLocationLng ?? this.routeLocationLng),
      routeDestinationLat: clearRouteHighlight
          ? null
          : (routeDestinationLat ?? this.routeDestinationLat),
      routeDestinationLng: clearRouteHighlight
          ? null
          : (routeDestinationLng ?? this.routeDestinationLng),
      routeDestinationName: clearRouteHighlight
          ? null
          : (routeDestinationName ?? this.routeDestinationName),
      pendingTaskType:
          clearPendingTask ? null : (pendingTaskType ?? this.pendingTaskType),
      pendingTaskPhase:
          clearPendingTask ? null : (pendingTaskPhase ?? this.pendingTaskPhase),
      pendingTaskData:
          clearPendingTask ? null : (pendingTaskData ?? this.pendingTaskData),
      isLoadingPendingTask: isLoadingPendingTask ?? this.isLoadingPendingTask,
      isSearchingNearbyMovers:
          isSearchingNearbyMovers ?? this.isSearchingNearbyMovers,
      nearbyMoverSearchType: clearNearbyMoverSearch
          ? null
          : (nearbyMoverSearchType ?? this.nearbyMoverSearchType),
      nearbyMoverSearchData: clearNearbyMoverSearch
          ? null
          : (nearbyMoverSearchData ?? this.nearbyMoverSearchData),
      nearbyMoverSearchEndsAt: clearNearbyMoverSearch
          ? null
          : (nearbyMoverSearchEndsAt ?? this.nearbyMoverSearchEndsAt),
      nearbyMovers: clearNearbyMoverSearch
          ? const <Map<String, dynamic>>[]
          : (nearbyMovers ?? this.nearbyMovers),
      nearbyMoverLastUpdatedAt: clearNearbyMoverSearch
          ? null
          : (nearbyMoverLastUpdatedAt ?? this.nearbyMoverLastUpdatedAt),
    );
  }
}

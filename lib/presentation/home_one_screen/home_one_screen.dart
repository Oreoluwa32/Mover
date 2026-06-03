import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../services/device_memory_service.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../activity_in_progress_page/activity_in_progress_page.dart';
import '../my_route_page/my_route_page.dart';
import '../profile_screen/profile_screen.dart';
import '../search_mover_bottomsheet/search_mover_bottomsheet.dart';
import '../user_move_screen/user_move_screen.dart';
import '../save_your_route_dialog/save_your_route_dialog.dart';
import 'home_one_initial_page.dart';
import 'notifier/home_notifier.dart';

// ignore for file, must be immutable
class HomeOneScreen extends ConsumerStatefulWidget {
  const HomeOneScreen({Key? key})
      : super(
          key: key,
        );

  @override
  HomeOneScreenState createState() => HomeOneScreenState();
}

// ignore for file, must be immutable
class HomeOneScreenState extends ConsumerState<HomeOneScreen> {
  bool _hideBottomBar = false;
  bool _dialogShown = false;
  bool _searchSheetShown = false;
  int _selectedTabIndex = 0;
  final Map<int, Widget> _pageCache = <int, Widget>{};

  @override
  void initState() {
    super.initState();
    _pageCache[0] = _buildPageForIndex(0);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasActiveSession = await DeviceMemoryService().syncSessionState();
      if (!mounted) {
        return;
      }
      if (!hasActiveSession) {
        NavigatorService.pushNamedAndRemoveUntil(AppRoutes.signInScreen);
        return;
      }

      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        if (args['highlightRoute'] == true &&
            args['locationLat'] != null &&
            args['locationLng'] != null &&
            args['destinationLat'] != null &&
            args['destinationLng'] != null) {
          ref.read(homeNotifier.notifier).setRouteCoordinates(
                locationLat: args['locationLat'] as double,
                locationLng: args['locationLng'] as double,
                destinationLat: args['destinationLat'] as double,
                destinationLng: args['destinationLng'] as double,
                destinationName: args['destinationName'] as String?,
              );
        }
        if (args['showDialog'] == true && !_dialogShown) {
          _dialogShown = true;
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => SaveYourRouteDialog(),
          );
        }
        if (args['autoEnableLive'] == true) {
          final routeId = args['autoEnableLiveRouteId']?.toString();
          unawaited(
            ref.read(homeNotifier.notifier).enableLiveIfNeeded(
                  routeId: routeId,
                ),
          );
        }
        if (args['searchNearbyMovers'] == true && !_searchSheetShown) {
          final searchType =
              args['searchRequestType']?.toString() ?? 'delivery';
          final searchData = Map<String, dynamic>.from(
            args['searchRequestData'] as Map? ?? const <String, dynamic>{},
          );
          _searchSheetShown = true;
          ref.read(homeNotifier.notifier).startNearbyMoverSearch(
                searchType: searchType,
                searchData: searchData,
              );
          AppBottomSheet.show(
            context: context,
            useRootNavigator: true,
            backgroundColor: Colors.transparent,
            builder: (context) => SearchMoverBottomsheet(
              requestType: searchType,
              requestData: searchData,
            ),
            isScrollControlled: true,
          ).whenComplete(() {
            _searchSheetShown = false;
          });
        }
      }
    });
  }

  void _setBottomBarVisibility(bool hide) {
    setState(() {
      _hideBottomBar = hide;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: IndexedStack(
        index: _selectedTabIndex,
        children: List<Widget>.generate(
          5,
          (index) => _pageCache[index] ?? const SizedBox.shrink(),
        ),
      ),
      bottomNavigationBar: _hideBottomBar
          ? null
          : Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: _buildBottombar(context),
            ),
    );
  }

  void _onBottomBarChanged(BottomBarEnum type) {
    final newIndex = switch (type) {
      BottomBarEnum.Home => 0,
      BottomBarEnum.Route => 1,
      BottomBarEnum.Move => 2,
      BottomBarEnum.Activity => 3,
      BottomBarEnum.Profile => 4,
    };

    if (_selectedTabIndex == newIndex) {
      return;
    }

    _pageCache.putIfAbsent(newIndex, () => _buildPageForIndex(newIndex));

    setState(() {
      _selectedTabIndex = newIndex;
    });
  }

  Widget _buildPageForIndex(int index) {
    return switch (index) {
      0 => const HomeOneInitialPage(),
      1 => MyRoutePage(
          onOverlayChanged: _setBottomBarVisibility,
        ),
      2 => UserMoveScreen(
          onOverlayChanged: _setBottomBarVisibility,
        ),
      3 => const ActivityInProgressPage(),
      4 => const ProfileScreen(),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildBottombar(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        currentIndex: _selectedTabIndex,
        onChanged: _onBottomBarChanged,
      ),
    );
  }
}

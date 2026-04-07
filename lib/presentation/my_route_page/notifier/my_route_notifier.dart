import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/services/mobility_api_service.dart';
import '../models/my_route_model.dart';
import '../models/saved_route_model.dart';
part 'my_route_state.dart';

final myRouteNotifier =
    StateNotifierProvider.autoDispose<MyRouteNotifier, MyRouteState>(
  (ref) => MyRouteNotifier(MyRouteState(
      myRouteModelObj: MyRouteModel(savedrouteItemList: []))),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class MyRouteNotifier extends StateNotifier<MyRouteState> {
  MyRouteNotifier(MyRouteState state) : super(state) {
    fetchScheduledRoutes();
  }

  final MobilityApiService _mobilityApiService = MobilityApiService();

  Future<void> fetchScheduledRoutes() async {
    try {
      final data = await _mobilityApiService.getMyTravelPlans();
      final routes = data.where((item) {
        final metadata = (item['metadata'] as Map?)?.cast<String, dynamic>() ?? {};
        return metadata['route_kind']?.toString() != 'instant';
      }).map((item) {
        final metadata = (item['metadata'] as Map?)?.cast<String, dynamic>() ?? {};
        final departureTime = _formatTime(item['departure_time']?.toString());
        final departureDate =
            metadata['display_date_range']?.toString() ??
            _formatDate(item['departure_time']?.toString());
        return SavedRouteModel(
          id: item['id']?.toString(),
          routetitle: item['title']?.toString() ?? 'My route',
          address:
              '${item['origin_name']?.toString() ?? ''} -> ${item['destination_name']?.toString() ?? ''}',
          time: departureTime,
          days: departureDate,
          islive: item['is_live'] == true,
          status: item['status']?.toString() ?? '',
        );
      }).toList();

      state = state.copyWith(
        myRouteModelObj: state.myRouteModelObj?.copyWith(
          savedrouteItemList: routes,
        ),
      );
    } catch (_) {
      state = state.copyWith(
        myRouteModelObj: state.myRouteModelObj?.copyWith(
          savedrouteItemList: const [],
        ),
      );
    }
  }

  String _formatDate(String? rawDateTime) {
    final parsed = rawDateTime != null ? DateTime.tryParse(rawDateTime)?.toLocal() : null;
    if (parsed == null) {
      return rawDateTime ?? '';
    }
    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    return '$month/$day/${parsed.year}';
  }

  String _formatTime(String? rawDateTime) {
    final parsed = rawDateTime != null ? DateTime.tryParse(rawDateTime)?.toLocal() : null;
    if (parsed == null) {
      return rawDateTime ?? '';
    }
    final hour = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
    final minute = parsed.minute.toString().padLeft(2, '0');
    final suffix = parsed.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}

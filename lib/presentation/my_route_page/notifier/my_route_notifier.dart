import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/app_export.dart';
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

  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<void> fetchScheduledRoutes() async {
    final token = await getToken();
    if (token == null) return;

    final url = Uri.parse(
        'https://demosystem.pythonanywhere.com/get-scheduled-routes/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final routes = data.map((item) {
          return SavedRouteModel(
            id: item['id']?.toString(),
            routetitle: item['route_name'],
            address: item['destination'],
            time: item['departure_time'],
            days: item['departure_date'], // Adjust if the backend provides days range
            islive: item['is_live'] ?? false,
          );
        }).toList();

        state = state.copyWith(
          myRouteModelObj: state.myRouteModelObj?.copyWith(
            savedrouteItemList: routes,
          ),
        );
      }
    } catch (e) {
      // Silently fail or handle error
    }
  }
}

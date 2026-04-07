import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/config/app_environment.dart';

class MobilityRealtimeService {
  MobilityRealtimeService({
    FlutterSecureStorage? storage,
    String? wsBaseUrl,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _wsBaseUrl = wsBaseUrl ?? AppEnvironment.wsBaseUrl;

  final FlutterSecureStorage _storage;
  final String _wsBaseUrl;

  WebSocket? _socket;
  String? _connectedTravelPlanId;
  final StreamController<Map<String, dynamic>> _eventsController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get events => _eventsController.stream;
  bool get isConnected => _socket != null;
  String? get connectedTravelPlanId => _connectedTravelPlanId;

  Future<void> connect(String travelPlanId) async {
    if (_connectedTravelPlanId == travelPlanId && _socket != null) {
      return;
    }

    await disconnect();

    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found.');
    }

    final uri = Uri.parse(
      '$_wsBaseUrl/ws/tracking/$travelPlanId/?token=${Uri.encodeQueryComponent(token)}',
    );

    final socket = await WebSocket.connect(uri.toString());
    _socket = socket;
    _connectedTravelPlanId = travelPlanId;

    socket.listen(
      (dynamic rawEvent) {
        try {
          final decoded = jsonDecode(rawEvent.toString());
          if (decoded is Map<String, dynamic>) {
            _eventsController.add(decoded);
          } else if (decoded is Map) {
            _eventsController.add(Map<String, dynamic>.from(decoded));
          }
        } catch (_) {
          // Ignore malformed events in the client stream.
        }
      },
      onDone: () {
        _socket = null;
        _connectedTravelPlanId = null;
      },
      onError: (_) {
        _socket = null;
        _connectedTravelPlanId = null;
      },
      cancelOnError: true,
    );
  }

  Future<void> sendEvent({
    required String eventType,
    double? latitude,
    double? longitude,
    String? note,
    Map<String, dynamic>? payload,
  }) async {
    final socket = _socket;
    if (socket == null) {
      return;
    }

    socket.add(jsonEncode({
      'event_type': eventType,
      if (latitude != null) 'latitude': double.parse(latitude.toStringAsFixed(6)),
      if (longitude != null) 'longitude': double.parse(longitude.toStringAsFixed(6)),
      if (note != null && note.isNotEmpty) 'note': note,
      'payload': payload ?? <String, dynamic>{},
    }));
  }

  Future<void> disconnect() async {
    final socket = _socket;
    _socket = null;
    _connectedTravelPlanId = null;
    if (socket != null) {
      await socket.close();
    }
  }

  Future<void> dispose() async {
    await disconnect();
    await _eventsController.close();
  }
}

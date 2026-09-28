import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

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

  // Every N seconds send a ping so the socket keeps flowing bytes and
  // we can detect half-open connections after a NAT/carrier hop.
  static const Duration _pingInterval = Duration(seconds: 25);
  // If we don't hear a pong (or any frame) within this window, treat
  // the socket as dead and reconnect.
  static const Duration _pongTimeout = Duration(seconds: 45);
  // Exponential backoff bounds. Reset to _minBackoff on any clean pong.
  static const Duration _minBackoff = Duration(seconds: 1);
  static const Duration _maxBackoff = Duration(seconds: 30);

  WebSocket? _socket;
  String? _connectedTravelPlanId;
  Timer? _pingTimer;
  Timer? _pongWatchdog;
  DateTime? _lastFrameAt;
  Duration _backoff = _minBackoff;
  bool _disposed = false;
  bool _explicitDisconnect = false;

  final StreamController<Map<String, dynamic>> _eventsController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get events => _eventsController.stream;
  bool get isConnected => _socket != null;
  String? get connectedTravelPlanId => _connectedTravelPlanId;

  Future<void> connect(String travelPlanId) async {
    if (_connectedTravelPlanId == travelPlanId && _socket != null) {
      return;
    }
    _explicitDisconnect = false;
    await _teardownSocket();
    _connectedTravelPlanId = travelPlanId;
    await _open();
  }

  Future<void> _open() async {
    if (_disposed || _explicitDisconnect) return;
    final travelPlanId = _connectedTravelPlanId;
    if (travelPlanId == null) return;

    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found.');
    }

    final uri = Uri.parse('$_wsBaseUrl/ws/tracking/$travelPlanId/');

    try {
      final socket = await WebSocket.connect(
        uri.toString(),
        protocols: ['movr.jwt', token],
      );
      _socket = socket;
      _lastFrameAt = DateTime.now();

      socket.listen(
        (dynamic rawEvent) {
          _lastFrameAt = DateTime.now();
          try {
            final decoded = jsonDecode(rawEvent.toString());
            if (decoded is Map && decoded['type'] == 'pong') {
              // Reset backoff after a successful round-trip.
              _backoff = _minBackoff;
              return;
            }
            if (decoded is Map<String, dynamic>) {
              _eventsController.add(decoded);
            } else if (decoded is Map) {
              _eventsController.add(Map<String, dynamic>.from(decoded));
            }
          } catch (_) {
            // Ignore malformed frames.
          }
        },
        onDone: () => _handleDisconnection(),
        onError: (_) => _handleDisconnection(),
        cancelOnError: true,
      );

      _startHeartbeat();
    } catch (_) {
      _handleDisconnection();
    }
  }

  void _startHeartbeat() {
    _pingTimer?.cancel();
    _pongWatchdog?.cancel();

    _pingTimer = Timer.periodic(_pingInterval, (_) {
      final socket = _socket;
      if (socket == null) return;
      try {
        socket.add(jsonEncode({
          'type': 'ping',
          'sent_at': DateTime.now().toIso8601String(),
        }));
      } catch (_) {
        _handleDisconnection();
      }
    });

    _pongWatchdog = Timer.periodic(const Duration(seconds: 5), (_) {
      final last = _lastFrameAt;
      if (last == null) return;
      if (DateTime.now().difference(last) > _pongTimeout) {
        _handleDisconnection();
      }
    });
  }

  void _handleDisconnection() {
    _pingTimer?.cancel();
    _pongWatchdog?.cancel();
    _pingTimer = null;
    _pongWatchdog = null;
    final socket = _socket;
    _socket = null;
    if (socket != null) {
      // Fire-and-forget close; the socket may already be dead.
      unawaited(socket.close().catchError((_) {}));
    }
    if (_disposed || _explicitDisconnect) return;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    final delay = _backoff;
    // Grow with a little jitter so many clients don't stampede at once.
    final jitter = math.Random().nextInt(500);
    _backoff = Duration(
      milliseconds: math.min(
        _maxBackoff.inMilliseconds,
        (_backoff.inMilliseconds * 2) + jitter,
      ),
    );
    Timer(delay, () {
      if (_disposed || _explicitDisconnect) return;
      unawaited(_open());
    });
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

    try {
      socket.add(jsonEncode({
        'event_type': eventType,
        if (latitude != null)
          'latitude': double.parse(latitude.toStringAsFixed(6)),
        if (longitude != null)
          'longitude': double.parse(longitude.toStringAsFixed(6)),
        if (note != null && note.isNotEmpty) 'note': note,
        'payload': payload ?? <String, dynamic>{},
      }));
    } catch (_) {
      _handleDisconnection();
    }
  }

  Future<void> _teardownSocket() async {
    _pingTimer?.cancel();
    _pongWatchdog?.cancel();
    _pingTimer = null;
    _pongWatchdog = null;
    final socket = _socket;
    _socket = null;
    if (socket != null) {
      await socket.close().catchError((_) {});
    }
  }

  Future<void> disconnect() async {
    _explicitDisconnect = true;
    _connectedTravelPlanId = null;
    _backoff = _minBackoff;
    await _teardownSocket();
  }

  Future<void> dispose() async {
    _disposed = true;
    await disconnect();
    await _eventsController.close();
  }
}

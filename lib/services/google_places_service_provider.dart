import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/constants.dart';
import 'google_places_service.dart';

/// Shared singleton provider for GooglePlacesService.
///
/// Previously every screen that needed places autocomplete (delivery
/// details, instant add-route, add-route step three) declared its own
/// `googlePlacesServiceProvider`, which produced separate Dio clients,
/// separate response caches and separate session-token buckets. They
/// should all read from this single provider instead.
final googlePlacesServiceProvider = Provider<GooglePlacesService>((ref) {
  const apiKey = Constants.googlePlacesApiKey;
  return GooglePlacesService(apiKey: apiKey);
});

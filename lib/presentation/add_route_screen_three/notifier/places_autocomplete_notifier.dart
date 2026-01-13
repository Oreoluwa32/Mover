import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/google_places_service.dart';
import 'places_autocomplete_state.dart';

final googlePlacesServiceProvider = Provider<GooglePlacesService>((ref) {
  const apiKey = String.fromEnvironment(
    'GOOGLE_PLACES_API_KEY',
    defaultValue: '',
  );
  return GooglePlacesService(apiKey: apiKey);
});

final placesAutocompleteProvider =
    StateNotifierProvider<PlacesAutocompleteNotifier, PlacesAutocompleteState>(
  (ref) {
    final placesService = ref.watch(googlePlacesServiceProvider);
    return PlacesAutocompleteNotifier(placesService);
  },
);

class PlacesAutocompleteNotifier extends StateNotifier<PlacesAutocompleteState> {
  final GooglePlacesService _placesService;
  String? _sessionToken;

  PlacesAutocompleteNotifier(this._placesService)
      : super(const PlacesAutocompleteState());

  Future<void> searchPlaces(String query) async {
    print('searchPlaces called with query: "$query"');
    if (query.isEmpty) {
      state = state.copyWith(
        predictions: [],
        showSuggestions: false,
        searchQuery: query,
        error: null,
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      searchQuery: query,
      error: null,
    );

    try {
      print('Fetching predictions for: $query');
      final predictions = await _placesService.getPlacePredictions(
        query,
        sessionToken: _sessionToken,
      );

      print('Received ${predictions.length} predictions');
      state = state.copyWith(
        predictions: predictions,
        isLoading: false,
        showSuggestions: true,
        error: null,
      );
    } catch (e) {
      print('Error searching places: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        predictions: [],
      );
    }
  }

  Future<void> selectPlace(PlacePrediction prediction) async {
    state = state.copyWith(
      isLoading: true,
      selectedPlaceId: prediction.placeId,
      showSuggestions: false,
      error: null,
    );

    try {
      final details = await _placesService.getPlaceDetails(
        prediction.placeId,
        sessionToken: _sessionToken,
      );

      state = state.copyWith(
        selectedPlaceDetails: details,
        selectedPlaceId: prediction.placeId,
        isLoading: false,
        searchQuery: prediction.description,
        predictions: [],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void closeSuggestions() {
    state = state.copyWith(showSuggestions: false);
  }

  void clear() {
    state = const PlacesAutocompleteState();
  }

  void setSessionToken(String token) {
    _sessionToken = token;
  }
}

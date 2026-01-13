import 'package:equatable/equatable.dart';
import '../../../services/google_places_service.dart';

class PlacesAutocompleteState extends Equatable {
  final List<PlacePrediction> predictions;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final bool showSuggestions;
  final String? selectedPlaceId;
  final PlaceDetails? selectedPlaceDetails;

  const PlacesAutocompleteState({
    this.predictions = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.showSuggestions = false,
    this.selectedPlaceId,
    this.selectedPlaceDetails,
  });

  PlacesAutocompleteState copyWith({
    List<PlacePrediction>? predictions,
    bool? isLoading,
    String? error,
    String? searchQuery,
    bool? showSuggestions,
    String? selectedPlaceId,
    PlaceDetails? selectedPlaceDetails,
  }) {
    return PlacesAutocompleteState(
      predictions: predictions ?? this.predictions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      showSuggestions: showSuggestions ?? this.showSuggestions,
      selectedPlaceId: selectedPlaceId ?? this.selectedPlaceId,
      selectedPlaceDetails: selectedPlaceDetails ?? this.selectedPlaceDetails,
    );
  }

  @override
  List<Object?> get props => [
        predictions,
        isLoading,
        error,
        searchQuery,
        showSuggestions,
        selectedPlaceId,
        selectedPlaceDetails,
      ];
}

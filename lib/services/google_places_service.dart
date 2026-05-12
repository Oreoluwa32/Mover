import 'package:dio/dio.dart';

class PlacePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      placeId: json['place_id'] ?? '',
      description: json['description'] ?? '',
      mainText: json['structured_formatting']?['main_text'] ?? '',
      secondaryText: json['structured_formatting']?['secondary_text'] ?? '',
    );
  }
}

class PlaceDetails {
  final String placeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  PlaceDetails({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] ?? {};
    final location = geometry['location'] ?? {};

    return PlaceDetails(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? '',
      address: json['formatted_address'] ?? '',
      latitude: location['lat'] ?? 0.0,
      longitude: location['lng'] ?? 0.0,
    );
  }
}

class GooglePlacesService {
  final String apiKey;
  final Dio dio;
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  static const String _defaultCountryComponents = 'country:ng';
  static const String _defaultRegion = 'ng';
  static const String _defaultLanguage = 'en';

  GooglePlacesService({
    required this.apiKey,
    Dio? dio,
  }) : dio = dio ?? Dio();

  Future<List<PlacePrediction>> getPlacePredictions(
    String input, {
    String? sessionToken,
    String? components,
    String? language,
  }) async {
    try {
      final effectiveComponents =
          (components == null || components.trim().isEmpty)
              ? _defaultCountryComponents
              : components.trim();
      final effectiveLanguage = (language == null || language.trim().isEmpty)
          ? _defaultLanguage
          : language.trim();

      final response = await dio.get(
        '$_baseUrl/autocomplete/json',
        queryParameters: {
          'input': input,
          'key': apiKey,
          if (sessionToken != null) 'sessiontoken': sessionToken,
          'components': effectiveComponents,
          'region': _defaultRegion,
          'language': effectiveLanguage,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final status = data['status'] as String?;

        if (status != 'OK' && status != 'ZERO_RESULTS') {
          return [];
        }

        final predictions = (data['predictions'] as List<dynamic>?)
                ?.map(
                    (p) => PlacePrediction.fromJson(p as Map<String, dynamic>))
                .toList() ??
            [];
        return predictions;
      } else {
        throw Exception('Failed to fetch predictions: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PlaceDetails> getPlaceDetails(
    String placeId, {
    String? sessionToken,
    String? language,
  }) async {
    try {
      final effectiveLanguage = (language == null || language.trim().isEmpty)
          ? _defaultLanguage
          : language.trim();

      final response = await dio.get(
        '$_baseUrl/details/json',
        queryParameters: {
          'place_id': placeId,
          'key': apiKey,
          'fields': 'place_id,name,formatted_address,geometry',
          if (sessionToken != null) 'sessiontoken': sessionToken,
          'region': _defaultRegion,
          'language': effectiveLanguage,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final status = data['status'] as String?;

        if (status != 'OK') {
          throw Exception('API Error: $status');
        }

        final result = data['result'] as Map<String, dynamic>?;
        if (result != null) {
          return PlaceDetails.fromJson(result);
        } else {
          throw Exception('No result found');
        }
      } else {
        throw Exception(
            'Failed to fetch place details: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getAddressFromLatLng(double lat, double lng) async {
    try {
      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'latlng': '$lat,$lng',
          'key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        if (data['status'] == 'OK') {
          final results = data['results'] as List?;
          if (results != null && results.isNotEmpty) {
            final address = results[0]['formatted_address'] as String?;
            return address;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

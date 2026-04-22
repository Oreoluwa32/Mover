import '../../theme/theme_helper.dart';

class MapThemeUtils {
  const MapThemeUtils._();

  static String? googleMapStyleForTheme(String themeType) {
    return ThemeHelper.isDarkThemeType(themeType) ? darkMapStyle : null;
  }

  static const String darkMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#1d1d24"}]},
  {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#d7d2e6"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#17131d"}]},
  {"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#6f6680"}]},
  {"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#f2edf8"}]},
  {"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},
  {"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#f2edf8"}]},
  {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#c4bdd3"}]},
  {"featureType":"poi.business","stylers":[{"visibility":"off"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#163323"}]},
  {"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#8dd88d"}]},
  {"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2b2833"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#bdb6ca"}]},
  {"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#37313f"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#4a3a62"}]},
  {"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#5b447a"}]},
  {"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9f98ad"}]},
  {"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2c2934"}]},
  {"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d6c9ee"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#102a39"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#8fb7cb"}]},
  {"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#10202d"}]}
]
''';
}

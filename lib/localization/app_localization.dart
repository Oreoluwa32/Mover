import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../core/app_export.dart';
import 'english/en_translations.dart';

extension LocalizationExtension on String{
  String get tr => AppLocalization.of().getString(this);
}

// ignore for file, must be immutable
class AppLocalization {
  AppLocalization(this.locale);

  Locale locale;

  static final Map<String, Map<String, String>> _localizedValues = {'en': english};

  static AppLocalization of() {
    return Localizations.of<AppLocalization>(
      NavigatorService.navigatorKey.currentContext!, AppLocalization
    )!;
  }

  static List<String> languages() => _localizedValues.keys.toList();
  String getString(String text) => _localizedValues[locale.languageCode]![text] ?? text;
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
    AppLocalization.languages().contains(locale.languageCode);

  // Returning a synchronous future here
  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture<AppLocalization>(AppLocalization(locale));
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
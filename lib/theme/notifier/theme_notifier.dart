import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
part 'theme_state.dart';

final themeNotifier = StateNotifierProvider<ThemeNotifier, ThemeState>(
  (ref) => ThemeNotifier(
    ThemeState(themeType: PrefUtils().getThemeData()),
  ),
);

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier(ThemeState state) : super(state) {
    ThemeHelper().changeTheme(state.themeType);
    SystemChrome.setSystemUIOverlayStyle(
      ThemeHelper.systemOverlayStyleForTheme(state.themeType),
    );
  }

  changeTheme(String themeType) async {
    final normalizedTheme = ThemeHelper.normalizeThemeType(themeType);
    await PrefUtils().setThemeData(normalizedTheme);
    ThemeHelper().changeTheme(normalizedTheme);
    SystemChrome.setSystemUIOverlayStyle(
      ThemeHelper.systemOverlayStyleForTheme(normalizedTheme),
    );
    state = state.copyWith(themeType: normalizedTheme);
  }
}

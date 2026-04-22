import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app_export.dart';
import 'services/device_memory_service.dart';
import 'services/deep_link_service.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

// Track if deep link service has been initialized
bool _deepLinkInitialized = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable animations on lower-end devices
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    PrefUtils().init(),
    DeviceMemoryService().init(),
    Future(() => SystemChrome.setSystemUIOverlayStyle(
          ThemeHelper.systemOverlayStyleForTheme(PrefUtils().getThemeData()),
        )),
  ]).then((value) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeType =
        ref.watch(themeNotifier.select((state) => state.themeType));
    ThemeHelper().changeTheme(themeType);
    final systemOverlayStyle =
        ThemeHelper.systemOverlayStyleForTheme(themeType);

    return Sizer(
      builder: (context, orientation, deviceType) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: systemOverlayStyle,
          child: MaterialApp(
            theme: theme,
            themeMode: ThemeHelper.isDarkThemeType(themeType)
                ? ThemeMode.dark
                : ThemeMode.light,
            title: 'Movr',
            builder: (context, child) {
              // Initialize deep link service with context (only once)
              if (!_deepLinkInitialized) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  DeepLinkService().setContext(context);
                  DeepLinkService().init();
                  _deepLinkInitialized = true;
                });
              }

              return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(1.0)),
                  child: child!);
            },
            navigatorKey: NavigatorService.navigatorKey,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizationDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [Locale('en', '')],
            initialRoute: AppRoutes.initialRoute,
            routes: AppRoutes.routes,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          ),
        );
      },
    );
  }
}

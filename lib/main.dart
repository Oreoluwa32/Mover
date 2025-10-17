import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app_export.dart';
import 'services/device_memory_service.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Disable animations on lower-end devices
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    PrefUtils().init(),
    DeviceMemoryService().init(),
    Future(() => SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    )),
  ]).then((value) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerWidget {
  const MyApp();
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only watch theme changes, not the entire notifier
    ref.watch(themeNotifier).themeType;
    
    return Sizer(
      builder: (context, orientation, deviceType) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
          ),
          child: MaterialApp(
            theme: theme,
            title: 'Movr',
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(1.0)
                ), 
                child: child!
              );
            },
            navigatorKey: NavigatorService.navigatorKey,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizationDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [
              Locale('en', '')
            ],
            initialRoute: AppRoutes.initialRoute,
            routes: AppRoutes.routes,
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'core/app_export.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  ThemeHelper().changeTheme('primary');
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Sizer(
      builder: (context, orientation, deviceType){
        return MaterialApp(
          theme: theme,
          title: 'Movr',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.initialRoute,
          routes: AppRoutes.routes,
          // home: Scaffold(
          //   appBar: AppBar(title: Text('Test App')),
          //   body: Center(child: Text('Hello,Flutter Web!')),
          // ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
//   print("Hello");
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Hello App'),
//         ),
//         body: Center(
//           child: Text('Hello, Flutter!'),
//         ),
//       ),
//     );
//   }
// }

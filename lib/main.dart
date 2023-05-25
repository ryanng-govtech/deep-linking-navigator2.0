// import 'package:flutter/material.dart';
// import 'routing.dart';

// void main() {
//   runApp(const App());
// }

// class App extends StatelessWidget {
//   const App({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) => MaterialApp.router(
//         routeInformationParser: AppRouteInformationParser(),
//         routerDelegate: AppRouterDelegate(),
//         title: 'Flutter Deep Linking Demo',
//       );
// }

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deep_linking/routing.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uni_links/uni_links.dart';

bool _initialURILinkHandled = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: AppRouteInformationParser(),
        routerDelegate: AppRouterDelegate(),
        title: 'Flutter Deep Linking Demo',
      );
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Uni Links Demo',
  //     theme: ThemeData(
  //         appBarTheme: AppBarTheme(
  //       backgroundColor: Colors.transparent,
  //       elevation: 0,
  //       centerTitle: true,
  //     )),
  //     home: const MyHomePage(title: 'Uni Links Demo'),
  //   );
  // }
}

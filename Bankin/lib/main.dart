import 'package:Bankin/widgets/route_manager.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/login/login.dart';

void main() {
  Provider(create: (_) => new RouteManager());
  runApp(EasyLocalization(
    child: MultiProvider(providers: [
      Provider(create: (_) => new RouteManager()),
    ], child: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bankin',
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

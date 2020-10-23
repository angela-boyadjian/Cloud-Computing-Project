import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:Bankin/pages/login/widgets/user_storage.dart';

import 'package:Bankin/widgets/route_manager.dart';

import 'pages/login/login.dart';

Future<void> main() async {
  Provider(create: (_) => new RouteManager());
  await DotEnv().load('.env');
  runApp(EasyLocalization(
    child: MultiProvider(providers: [
      Provider(create: (_) => new RouteManager()),
      ListenableProvider(create: (_) => new UserData()),
      ListenableProvider(create: (_) => new Storage()),
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

import 'package:dolores/helpers/error_handler/core/error_handler.dart';
import 'package:dolores/routes.dart';
import 'package:dolores/theme.dart';
import 'package:dolores/ui/screens/login/login_view.dart';
import 'package:dolores/ui/screens/splash/splash_view.dart';
import 'package:flutter/material.dart';

class Dolores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: ErrorHandler.navigatorKey,
      title: 'Expiry',
      theme: DoloresTheme.lightThemeData,
      initialRoute: SplashView.routeName,
      onGenerateRoute: routes,
    );
  }
}

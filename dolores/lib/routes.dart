import 'package:dolores/ui/screens/account/account_view.dart';
import 'package:dolores/ui/screens/login/login_screen.dart';
import 'package:dolores/ui/screens/products/products_view.dart';
import 'package:flutter/material.dart';

Route routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return buildRoute(settings, ProductsView());
    case LoginScreen.routeName:
      return buildRoute(settings, LoginScreen());
    case AccountView.routeName:
      return buildRoute(settings, AccountView());

    default:
      return buildRoute(
        settings,
        Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

MaterialPageRoute buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(
    builder: (BuildContext context) => builder,
    settings: settings,
  );
}

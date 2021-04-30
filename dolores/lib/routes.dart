import 'package:dolores/ui/screens/account/account_view.dart';
import 'package:dolores/ui/screens/login/bloc/login.dart';
import 'package:dolores/ui/screens/login/login_view.dart';
import 'package:dolores/ui/screens/products/bloc/products.dart';
import 'package:dolores/ui/screens/products/products_view.dart';
import 'package:dolores/ui/screens/splash/bloc/auto_login_bloc.dart';
import 'package:dolores/ui/screens/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'managers/dialog_manager.dart';

Route routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return buildRoute(
        settings,
        BlocProvider<ProductsBloc>(
          create: (context) => ProductsBloc(),
          child: ProductsView(),
        ),
      );
    case LoginView.routeName:
      return buildRoute(
        settings,
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc()..add(FetchStoredUser()),
          child: LoginView(),
        ),
      );
    case AccountView.routeName:
      return buildRoute(settings, AccountView());
    case SplashView.routeName:
      return buildRoute(
        settings,
        BlocProvider<AutoLoginBloc>(
          create: (context) => AutoLoginBloc()..add(TryAutoLogin()),
          child: SplashView(),
        ),
      );
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
    builder: (BuildContext context) => DialogManager(child: builder),
    settings: settings,
  );
}

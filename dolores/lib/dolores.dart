import 'package:dolores/helpers/error_handler/core/error_handler.dart';
import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/providers/product_provider.dart';
import 'package:dolores/routes.dart';
import 'package:dolores/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dolores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (_) => ProductProvider(),
          update: (context, authProv, productProvider) {
            if (!authProv.isAuth) {
              productProvider.clearStates();
            }
            return productProvider;
          },
        ),
      ],
      child: MaterialApp(
        navigatorKey: ErrorHandler.navigatorKey,
        title: 'Expiry',
        theme: DoloresTheme.lightThemeData,
        onGenerateRoute: routes,
      ),
    );
  }
}

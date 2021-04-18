import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/providers/product_provider.dart';
import 'package:dolores/theme.dart';
import 'package:dolores/ui/screens/login_screen.dart';
import 'package:dolores/ui/screens/products_screen.dart';
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
        title: 'Expiry',
        theme: DoloresTheme.lightThemeData,
        home: Consumer<AuthProvider>(
          builder: (
            context,
            authProv,
            child,
          ) {
            return authProv.isAuth
                ? ProductsScreen()
                : FutureBuilder(
                    future: authProv.tryAutoLogin(),
                    builder: (context, authResultSnap) =>
                        authResultSnap.connectionState ==
                                ConnectionState.waiting
                            ? Scaffold(
                                body: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : LoginScreen(),
                  );
          },
        ),
      ),
    );
  }
}

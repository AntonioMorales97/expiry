import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/providers/product_provider.dart';
import 'package:dolores/theme.dart';
import 'package:dolores/ui/screens/login_screen.dart';
import 'package:dolores/ui/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (_) => ProductProvider(),
          update: (context, authProv, _) =>
              ProductProvider(), //TODO: dont do this
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

class AuthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Expiry',
        theme: DoloresTheme.lightThemeData,
        home: ProductsScreen(),
      ),
    );
  }
}

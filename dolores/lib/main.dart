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
  // This widget is the root of your application.

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
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
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
        ), //MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  } //MyHomePage(title: 'Flutter Demo Home Page'),
}

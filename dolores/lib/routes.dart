import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/ui/screens/account_screen.dart';
import 'package:dolores/ui/screens/login_screen.dart';
import 'package:dolores/ui/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Route routes(RouteSettings settings) {
  switch (settings.name) {
    case AccountScreen.routeName:
      return buildRoute(settings, AccountScreen());
    //Global Notification TODO: Implement argument & create styled bars for success, error, neutral etc
    // case 'notify':
    //   return buildNotification(Flushbar(
    //     flushbarPosition: FlushbarPosition.TOP,
    //     titleText:
    //         Text(settings.arguments, style: TextStyle(color: Colors.white)),
    //     messageText:
    //         Text(settings.arguments, style: TextStyle(color: Colors.white)),
    //     backgroundColor: Colors.green,
    //     duration: const Duration(seconds: 3),
    //   ));
    default:
      return buildRoute(
        settings,
        Consumer<AuthProvider>(
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
      );
  }
}

//TODO: Move this
MaterialPageRoute buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(
    builder: (BuildContext context) => builder,
    settings: settings,
  );
}

//TODO: Move this and improve
// FlushbarRoute buildNotification(Flushbar flushbar) {
//   return FlushbarRoute(
//     flushbar: flushbar,
//     settings: RouteSettings(name: "Hej"),
//   );
// }

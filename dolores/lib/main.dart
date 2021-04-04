import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/providers/product_provider.dart';
import 'package:dolores/repositories/dumbledore_repository.dart';
import 'package:dolores/repositories/filtch_repository.dart';
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
          builder: (context, authProv, child) => authProv.isAuth
              ? ProductsScreen()
              : FutureBuilder(
                  future: authProv.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Scaffold(
                              body: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : LoginScreen(),
                ),
        ),
      ),
    );
  } //MyHomePage(title: 'Flutter Demo Home Page'),

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final FiltchRepository repository = FiltchRepository();
  final DumbledoreRepository drepository = DumbledoreRepository();

  void _incrementCounter() async {
    print("Calling repo");

    await repository.authenticate("admin@admin.se", "admin");
    print(await drepository.getStore('6066413a362bd4211dd66fa4'));

    final token = await repository.getToken();

    final email = await repository.getEmail();

    print(token);
    print(email);

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

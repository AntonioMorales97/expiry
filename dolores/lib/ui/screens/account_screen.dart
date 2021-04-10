import 'package:dolores/models/user.dart';
import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/providers/product_provider.dart';
import 'package:dolores/ui/widgets/app_drawer.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
import 'package:dolores/ui/widgets/dolores_password_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreen createState() => _AccountScreen();
}

class _AccountScreen extends State<AccountScreen> {
  User _user;

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  setUserData() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    setState(() async {
      this._user = await auth.getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final prod = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mitt konto'),
        actions: [],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 40, left: 5, right: 5),
        child: _user == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : Column(
                children: [
                  Icon(Icons.account_circle_rounded,
                      size: 150,
                      color: Theme.of(context).colorScheme.secondary),
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            initialValue: _user.firstName,
                            decoration: new InputDecoration(
                              labelText: 'Förnamn',
                            ),
                            onSaved: (value) => value,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            initialValue: _user.lastName,
                            decoration: new InputDecoration(
                              labelText: 'Efternamn',
                            ),
                            onSaved: (value) => value,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            initialValue: _user.email,
                            decoration: new InputDecoration(
                              labelText: 'E-postadress',
                            ),
                            onSaved: (value) => value,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          DoloresPasswordField(
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              // doLogin();
                            },
                            hintText: 'Lösenord',
                            onSaved: (value) => value,
                            validator: (value) =>
                                value.isEmpty ? 'Ange lösenord' : null,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          DoloresPasswordField(
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              //doLogin();
                            },
                            hintText: 'Skriv lösenord igen',
                            onSaved: (value) => value,
                            validator: (value) =>
                                value.isEmpty ? 'Ange lösenord' : null,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          DoloresButton(
                            child: Text(
                              'SPARA',
                              style: TextStyle(letterSpacing: 2),
                            ),
                            onPressed: () {
                              //TODO ändra endpoint i dumbledore så allt kan updateras.
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<bool> promptConfirm() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.only(bottom: 20),
          title: const Text("Confirm"),
          content: const Text("Are you sure you wish to delete this item?"),
          actions: <Widget>[
            DoloresButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("TA BORT")),
            DoloresButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("AVBRYT"),
            ),
          ],
        );
      },
    );
  }
}

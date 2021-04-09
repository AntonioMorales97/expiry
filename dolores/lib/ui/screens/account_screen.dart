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

class _AccountScreen extends State<AccountScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
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
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: new InputDecoration(
                  hintText: 'Förnamn',
                ),
                onSaved: (value) => value,
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: new InputDecoration(
                  hintText: 'Efternamn',
                ),
                onSaved: (value) => value,
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: new InputDecoration(
                  hintText: 'E-postadress',
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
                validator: (value) => value.isEmpty ? 'Ange lösenord' : null,
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
                validator: (value) => value.isEmpty ? 'Ange lösenord' : null,
              ),
            ],
          ),
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

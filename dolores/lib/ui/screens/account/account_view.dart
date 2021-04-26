import 'package:dolores/ui/screens/account/account_model.dart';
import 'package:dolores/ui/screens/base_model.dart';
import 'package:dolores/ui/screens/base_view.dart';
import 'package:dolores/ui/widgets/app_drawer.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
import 'package:dolores/ui/widgets/dolores_password_field.dart';
import 'package:flutter/material.dart';

class AccountView extends StatefulWidget {
  static const routeName = 'account';

  @override
  _AccountScreen createState() => _AccountScreen();
}

class _AccountScreen extends State<AccountView> {
  final formKey = GlobalKey<FormState>();

  String _rePassword;
  String _password;
  String _oldPassword;

  void doChangePassword(AccountModel model) async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      final success = await model.changePassword(
          model.user.email, _oldPassword, _password, _rePassword);

      if (!mounted) return;

      if (success) {
        setState(() {
          form.reset();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AccountModel>(
      onModelReady: (model) => model.getUser(),
      builder: (context, model, _) => Scaffold(
        appBar: AppBar(
          title: Text('Mitt konto'),
          actions: [],
        ),
        drawer: AppDrawer(active: 'accounts'),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 0, left: 5, right: 5),
          child: model.user == null
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
                        size: 120,
                        color: Theme.of(context).colorScheme.secondary),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              enabled: false,
                              textInputAction: TextInputAction.next,
                              initialValue: model.user.firstName,
                              decoration: new InputDecoration(
                                labelText: 'Förnamn',
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            TextFormField(
                              enabled: false,
                              textInputAction: TextInputAction.next,
                              initialValue: model.user.lastName,
                              decoration: new InputDecoration(
                                labelText: 'Efternamn',
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            TextFormField(
                              enabled: false,
                              textInputAction: TextInputAction.next,
                              initialValue: model.user.email,
                              decoration: new InputDecoration(
                                labelText: 'E-postadress',
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            DoloresPasswordField(
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) {
                                //doLogin();
                              },
                              hintText: 'Skriv in gamla lösenordet',
                              onSaved: (oldPassword) =>
                                  _oldPassword = oldPassword,
                              validator: (oldPassword) => oldPassword.isEmpty
                                  ? 'Ange Gamla lösenordet'
                                  : null,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            DoloresPasswordField(
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) {
                                // doLogin();
                              },
                              hintText: 'Lösenord',
                              onSaved: (password) => _password = password,
                              validator: (password) =>
                                  password.isEmpty ? 'Ange lösenord' : null,
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
                              onSaved: (rePassword) => _rePassword = rePassword,
                              validator: (rePassword) =>
                                  rePassword.isEmpty ? 'Ange lösenord' : null,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            DoloresButton(
                              isLoading: model.state == ViewState.Busy,
                              child: Text(
                                'SPARA',
                                style: TextStyle(letterSpacing: 2),
                              ),
                              onPressed: model.state == ViewState.Busy
                                  ? () {}
                                  : () {
                                      doChangePassword(model);
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

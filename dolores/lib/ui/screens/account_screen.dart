import 'package:dolores/helpers/expiry_helper.dart';
import 'package:dolores/models/user.dart';
import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/ui/widgets/app_drawer.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
import 'package:dolores/ui/widgets/dolores_password_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account';

  @override
  _AccountScreen createState() => _AccountScreen();
}

class _AccountScreen extends State<AccountScreen> {
  final formKey = GlobalKey<FormState>();
  User _user;
  String _rePassword;
  String _password;
  String _oldPassword;

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  setUserData() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final user = await auth.user;

    setState(() {
      this._user = user;
    });
  }

  void doChangePassword() async {
    //TODO: MAYBE ANOTHER PROVIDER? :>
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      await ExpiryHelper.apiCallerWrapper(
          context,
          () => mounted,
          auth.changePassword(
              _user.email, _oldPassword, _password, _rePassword),
          successMessage: 'Lösenordet är uppdaterat!',
          onSuccess: () => form.reset());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mitt konto'),
        actions: [],
      ),
      drawer: AppDrawer(active: 'accounts'),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 0, left: 5, right: 5),
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
                            initialValue: _user.firstName,
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
                            initialValue: _user.lastName,
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
                            initialValue: _user.email,
                            decoration: new InputDecoration(
                              labelText: 'E-postadress',
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
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
                          Consumer<AuthProvider>(
                            builder: (context, auth, _) => DoloresButton(
                              isLoading: auth.isRequesting,
                              child: Text(
                                'SPARA',
                                style: TextStyle(letterSpacing: 2),
                              ),
                              onPressed: auth.isRequesting
                                  ? () {}
                                  : () {
                                      doChangePassword();
                                    },
                            ),
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
}

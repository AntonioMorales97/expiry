import 'package:dolores/helpers/validation.dart';
import 'package:dolores/models/user.dart';
import 'package:dolores/ui/screens/base_model.dart';
import 'package:dolores/ui/screens/base_view.dart';
import 'package:dolores/ui/screens/login/login_model.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
import 'package:dolores/ui/widgets/dolores_checkbox.dart';
import 'package:dolores/ui/widgets/dolores_password_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  String _email;
  String _password;
  bool _rememberMe = false;

  void init(BuildContext context, LoginModel model) async {
    final success = await model.tryAutoLogin();

    if (success) {
      Navigator.of(context).pushReplacementNamed('/');
      return;
    } else {
      //TODO: Fail login
      print("Fail login");
    }

    setEmail(model);
  }

  void setEmail(LoginModel model) async {
    User user = await model.getStoredUser();
    _emailEditingController.text = user?.email;

    bool wasRemembered = _emailEditingController.text != null &&
        _emailEditingController.text.isNotEmpty;

    setState(() {
      _rememberMe = wasRemembered;
    });
  }

  void doLogin(BuildContext context, LoginModel model) async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      final success = await model.doLogin(_email, _password, _rememberMe);

      if (success) {
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        //TODO: Fail login
        print("Fail login");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      onModelReady: (model) => init(context, model),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'EXPIRY',
                      style: TextStyle(
                        height: 1,
                        fontSize: 48,
                        fontFamily: 'Redressed',
                        color: Color.fromRGBO(203, 178, 106, 1),
                      ),
                    ),
                    Text(
                      'Never leave wand',
                      style: TextStyle(
                        height: 2,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 80),
                    model.state == ViewState.Busy
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailEditingController,
                                  decoration: new InputDecoration(
                                    hintText: 'E-postadress',
                                  ),
                                  onSaved: (value) => _email = value,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Ange en e-postadress';
                                    } else if (!Validation.emailValid(value)) {
                                      return 'Ange en giltig e-postadress';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                DoloresPasswordField(
                                  controller: _passwordEditingController,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) {
                                    doLogin(context, model);
                                  },
                                  hintText: 'Lösenord',
                                  onSaved: (value) => _password = value,
                                  validator: (value) =>
                                      value.isEmpty ? 'Ange lösenord' : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: DoloresCheckbox(
                                    value: _rememberMe,
                                    title: 'Kom ihåg mig',
                                    onChange: (value) {
                                      _rememberMe = value;
                                    },
                                  ),
                                ),
                                DoloresButton(
                                  child: Text('LOGGA IN'),
                                  onPressed: () => doLogin(context, model),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

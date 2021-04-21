import 'package:dolores/helpers/expiry_helper.dart';
import 'package:dolores/helpers/validation.dart';
import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
import 'package:dolores/ui/widgets/dolores_checkbox.dart';
import 'package:dolores/ui/widgets/dolores_password_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _emailEditingController = TextEditingController();

  String _email;
  String _password;
  bool _rememberMe = false;
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    setEmail();
  }

  void setEmail() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _emailEditingController.text = (await auth.user)?.email;

    bool wasRemembered = _emailEditingController.text != null &&
        _emailEditingController.text.isNotEmpty;

    setState(() {
      _rememberMe = wasRemembered;
    });
  }

  void doLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _isRequesting = true;
      });

      await ExpiryHelper.callFunctionErrorHandler(
          auth.login(_email, _password, rememberMe: _rememberMe),
          context: context,
          form: form);
      setState(() {
        _isRequesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isRequesting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Form(
                    key: formKey,
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                          ),
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
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              doLogin();
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
                            onPressed: doLogin,
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

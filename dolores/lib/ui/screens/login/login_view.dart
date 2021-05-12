import 'package:dolores/ui/screens/login/bloc/login.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
import 'package:dolores/ui/widgets/dolores_checkbox.dart';
import 'package:dolores/ui/widgets/dolores_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  static const routeName = 'login';

  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc =
        BlocProvider.of<LoginBloc>(context, listen: false);
    return SafeArea(
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
                    'Abracadabra',
                    style: TextStyle(
                      height: 2,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 80),
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state.formStatus == Status.Success) {
                        Navigator.of(context).pushReplacementNamed('/');
                      }
                    },
                    buildWhen: (_, state) {
                      return state.formStatus != Status.Success;
                    },
                    builder: (context, state) => state.formStatus ==
                            Status.Loading
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              if (state.formStatus == Status.Fail)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    state.error != null
                                        ? state.error.detail
                                        : 'Någonting gick fel. Vänligen försök igen.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                initialValue: state.email,
                                decoration: new InputDecoration(
                                  labelText: 'E-postadress',
                                ),
                                onChanged: (value) {
                                  loginBloc.add(EmailChanged(email: value));
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DoloresPasswordField(
                                textInputAction: TextInputAction.done,
                                initialValue: state.password,
                                onSubmitted: (_) {
                                  loginBloc.add(DoLogin());
                                },
                                hintText: 'Lösenord',
                                onChanged: (value) {
                                  loginBloc
                                      .add(PasswordChanged(password: value));
                                },
                                validator: (value) =>
                                    value.isEmpty ? 'Ange lösenord' : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: DoloresCheckbox(
                                  value: state.rememberMe,
                                  title: 'Kom ihåg mig',
                                  onChange: (value) {
                                    loginBloc.add(
                                        RememberMeChanged(rememberMe: value));
                                  },
                                ),
                              ),
                              DoloresButton(
                                child: Text('LOGGA IN'),
                                onPressed: () => loginBloc.add(DoLogin()),
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
    );
  }
}

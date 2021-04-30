import 'package:dolores/ui/screens/login/login_view.dart';
import 'package:dolores/ui/screens/splash/bloc/auto_login_bloc.dart';
import 'package:dolores/ui/widgets/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashView extends StatelessWidget {
  static const routeName = 'splash';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AutoLoginBloc, AutoLoginState>(
      listener: (context, state) {
        if (state is AutoLoginSuccess) {
          Navigator.of(context).pushReplacementNamed('/');
        } else {
          Navigator.of(context).pushReplacementNamed(LoginView.routeName);
        }
      },
      child: Splash(),
    );
  }
}

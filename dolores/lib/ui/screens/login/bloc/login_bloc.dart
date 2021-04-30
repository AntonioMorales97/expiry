import 'package:dolores/helpers/dolores_error.dart';
import 'package:dolores/locator.dart';
import 'package:dolores/models/user.dart';
import 'package:dolores/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthService _authService = locator<AuthService>();

  LoginBloc() : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event);
    } else if (event is RememberMeChanged) {
      yield* _mapRememberMeChangedToState(event);
    } else if (event is FetchStoredUser) {
      yield* _mapFetchStoredUserToState();
    } else if (event is DoLogin) {
      yield* _mapDoLoginToState();
    }
  }

  Stream<LoginState> _mapEmailChangedToState(EmailChanged event) async* {
    yield state.copyWith(email: event.email);
  }

  Stream<LoginState> _mapPasswordChangedToState(PasswordChanged event) async* {
    yield state.copyWith(password: event.password);
  }

  Stream<LoginState> _mapRememberMeChangedToState(
      RememberMeChanged event) async* {
    yield state.copyWith(rememberMe: event.rememberMe);
  }

  Stream<LoginState> _mapFetchStoredUserToState() async* {
    User user = await _authService.user;

    if (user == null) {
      yield state.copyWith(formStatus: Status.Idle);
      return;
    }

    bool wasRemembered = user.email != null && user.email.isNotEmpty;

    yield state.copyWith(
      email: user.email,
      rememberMe: wasRemembered,
    );
  }

  Stream<LoginState> _mapDoLoginToState() async* {
    //TODO: Validate before?

    try {
      yield state.copyWith(formStatus: Status.Loading);
      await _authService.login(state.email, state.password,
          rememberMe: state.rememberMe);
      yield state.copyWith(formStatus: Status.Success);
    } on DoloresError catch (error) {
      yield state.copyWith(formStatus: Status.Fail, error: error);
    }
  }
}

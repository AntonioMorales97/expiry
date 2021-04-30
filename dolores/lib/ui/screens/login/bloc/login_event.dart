abstract class LoginEvent {}

class DoLogin extends LoginEvent {
  @override
  String toString() {
    return 'DoLogin';
  }
}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({this.email});

  @override
  String toString() {
    return 'EmailChanged: {email: $email}';
  }
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({this.password});

  @override
  String toString() {
    return 'PasswordChanged: {password: $password}';
  }
}

class RememberMeChanged extends LoginEvent {
  final bool rememberMe;

  RememberMeChanged({this.rememberMe});

  @override
  String toString() {
    return 'RememberMeChanged: {rememberMe: $rememberMe}';
  }
}

class FetchStoredUser extends LoginEvent {}

import 'package:dolores/helpers/dolores_error.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum Status {
  Idle,
  Loading,
  Success,
  Fail,
}

@immutable
class LoginState extends Equatable {
  final String email;
  final String password;
  final bool rememberMe;

  final formStatus;

  final DoloresError error;

  LoginState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.formStatus = Status.Loading,
    this.error,
  });

  LoginState copyWith({
    String email,
    String password,
    bool rememberMe,
    Status formStatus,
    DoloresError error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      formStatus: formStatus ?? Status.Idle,
      error: error,
    );
  }

  @override
  List<Object> get props => [email, password, rememberMe, formStatus, error];

  @override
  String toString() {
    return 'LoginState: {"email": $email, "password", $password, "rememberMe": $rememberMe, "formStatus": $formStatus, "error": $error}';
  }
}

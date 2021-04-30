import 'package:dolores/locator.dart';
import 'package:dolores/services/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AutoLoginBloc extends Bloc<AutoLoginEvent, AutoLoginState> {
  final AuthService _authService = locator<AuthService>();

  AutoLoginBloc() : super(AutoLoginInit());

  @override
  Stream<AutoLoginState> mapEventToState(AutoLoginEvent event) async* {
    if (event is TryAutoLogin) {
      yield* _mapTryAutoLoginToState();
    }
  }

  Stream<AutoLoginState> _mapTryAutoLoginToState() async* {
    try {
      await Future.delayed(Duration(milliseconds: 1800));
      final res = await _authService.tryAutoLogin();
      if (res) {
        yield AutoLoginSuccess();
      } else {
        yield AutoLoginFail();
      }
    } catch (_) {
      //TODO: Log but still update to fail.
      yield AutoLoginFail();
    }
  }
}

@immutable
abstract class AutoLoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TryAutoLogin extends AutoLoginEvent {}

@immutable
abstract class AutoLoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class AutoLoginInit extends AutoLoginState {}

class AutoLoginSuccess extends AutoLoginState {}

class AutoLoginFail extends AutoLoginState {}

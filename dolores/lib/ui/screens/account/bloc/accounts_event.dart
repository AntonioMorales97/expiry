import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AccountEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangePassword extends AccountEvent {
  final String oldPassword;
  final String password;
  final String rePassword;
  ChangePassword({
    @required this.oldPassword,
    @required this.password,
    @required this.rePassword,
  });
}

class FetchUser extends AccountEvent {
  FetchUser();
}

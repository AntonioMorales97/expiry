import 'package:dolores/helpers/dolores_error.dart';
import 'package:dolores/helpers/status_enum.dart';
import 'package:dolores/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class AccountState extends Equatable {
  final Status changePassStatus;
  final DoloresError error;
  final Status fetchingUserStatus;
  final User user;

  AccountState({
    this.changePassStatus = Status.Idle,
    this.error,
    this.fetchingUserStatus,
    this.user,
  });

  AccountState copyWith({
    User user,
    String email,
    String oldPassword,
    String rePassword,
    String password,
    Status changePassStatus,
    Status fetchingUserStatus,
    DoloresError error,
  }) {
    return AccountState(
        user: user ?? this.user,
        changePassStatus: changePassStatus,
        fetchingUserStatus: fetchingUserStatus,
        error: error);
  }

  @override
  List<Object> get props => [
        user,
        changePassStatus,
        fetchingUserStatus,
        error,
      ];

  @override
  String toString() {
    return "AccountStatus {user: $user, changePassStatus: $changePassStatus, fetchingUserStatus: $fetchingUserStatus,  error: $error}";
  }
}

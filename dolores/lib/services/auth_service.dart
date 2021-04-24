import 'package:dolores/helpers/error_handler/core/error_handler.dart';
import 'package:dolores/models/user.dart';
import 'package:dolores/repositories/dumbledore_repository.dart';
import 'package:dolores/repositories/filtch_repository.dart';
import 'package:dolores/repositories/preference_repository.dart';
import 'package:flutter/material.dart';

class AuthService {
  FiltchRepository filtchRepository = FiltchRepository();
  DumbledoreRepository dumbledoreRepository = DumbledoreRepository();
  PreferenceRepository prefRepo = PreferenceRepository();

  String _token;
  User _user;

  bool _isRequesting = false;
  bool get isRequesting => _isRequesting;

  String get token => _token;

  bool get isAuth => token != null;

  Future<User> get user async => _user ?? await filtchRepository.getUser();

  Future<bool> tryAutoLogin() async {
    User user = await filtchRepository.getUser();
    String token = await filtchRepository.getToken();
    if (token == null) {
      return false;
    }
    _user = user;
    _token = token;
    return true;
  }

  Future<void> logout() async {
    await prefRepo.savePreferenceToBackend();
    await prefRepo.removePreferenceFromLocalStorage();
    await filtchRepository.logout(_user.rememberMe ?? false);

    _token = null;
    if (_user.rememberMe == null || !_user.rememberMe) {
      _user = null;
    }
  }

  Future<void> forceLogout() async {
    await prefRepo.removePreferenceFromLocalStorage();
    await filtchRepository.logout(_user.rememberMe ?? false);

    _token = null;
    if (_user.rememberMe == null || !_user.rememberMe) {
      _user = null;
    }

    final appKey = ErrorHandler.navigatorKey;
    final context = appKey.currentContext;

    Navigator.pushNamedAndRemoveUntil(
        context, '/', (Route<dynamic> route) => false);
  }

  Future<void> login(String email, String password, {bool rememberMe}) async {
    User user = await filtchRepository.authenticate(email, password,
        rememberMe: rememberMe);
    _user = user;
    _token = await filtchRepository.getToken();
  }

  Future<void> changePassword(String email, String oldPassword, String password,
      String rePassword) async {
    _isRequesting = true;

    try {
      await dumbledoreRepository.changePassword(
          email, oldPassword, password, rePassword);
      _isRequesting = false;
    } catch (error) {
      _isRequesting = false;
      throw error;
    }
  }
}

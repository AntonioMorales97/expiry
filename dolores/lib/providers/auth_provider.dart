import 'package:dolores/helpers/api_exception.dart';
import 'package:dolores/models/user.dart';
import 'package:dolores/models/validation_item.dart';
import 'package:dolores/repositories/dumbledore_repository.dart';
import 'package:dolores/repositories/filtch_repository.dart';
import 'package:dolores/repositories/preference_repository.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  FiltchRepository filtchRepository = FiltchRepository();
  DumbledoreRepository dumbledoreRepository = DumbledoreRepository();
  PreferenceRepository prefRepo = PreferenceRepository();

  ValidationItem _errorMessage = ValidationItem(null, null);
  ValidationItem get errorMessage => _errorMessage;

  String _token;
  User _user;
  bool isRequesting = false;

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
    notifyListeners();
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

    notifyListeners();
  }

  Future<void> login(String email, String password, {bool rememberMe}) async {
    try {
      User user = await filtchRepository.authenticate(email, password,
          rememberMe: rememberMe);
      _user = user;
      _token = await filtchRepository.getToken();
      isRequesting = false;
      notifyListeners();
    } on ApiException catch (apiException) {
      throw apiException;
    }
  }

  Future<void> changePassword(String email, String oldPassword, String password,
      String rePassword) async {
    isRequesting = true;
    notifyListeners();

    try {
      await dumbledoreRepository.changePassword(
          email, oldPassword, password, rePassword);
      isRequesting = false;
      notifyListeners();
    } on ApiException catch (apiException) {
      isRequesting = false;
      notifyListeners();
      throw apiException;
    }
  }
}

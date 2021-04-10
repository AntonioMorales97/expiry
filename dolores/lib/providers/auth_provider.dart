import 'package:dolores/helpers/api_exception.dart';
import 'package:dolores/models/user.dart';
import 'package:dolores/models/validation_item.dart';
import 'package:dolores/repositories/filtch_repository.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  FiltchRepository filtchRepository = FiltchRepository();

  ValidationItem _errorMessage = ValidationItem(null, null);
  ValidationItem get errorMessage => _errorMessage;

  String _token;
  User _user;

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
    await filtchRepository.logout(_user.rememberMe ?? false);
    _token = null;
    notifyListeners();
  }

  Future<void> login(String email, String password, {bool rememberMe}) async {
    try {
      User user = await filtchRepository.authenticate(email, password,
          rememberMe: rememberMe);

      _user = user;
      _token = await filtchRepository.getToken();
      notifyListeners();
    } on ApiException catch (apiException) {
      _errorMessage = ValidationItem(null, apiException.detail);
      notifyListeners();
    } catch (error) {
      _errorMessage = ValidationItem(null, error.toString());
      notifyListeners();
    }
  }
}

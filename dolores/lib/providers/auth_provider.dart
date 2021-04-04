import 'package:dolores/helpers/api_exception.dart';
import 'package:dolores/models/validation_item.dart';
import 'package:dolores/repositories/filtch_repository.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  FiltchRepository filtchRepository = FiltchRepository();

  ValidationItem _errorMessage = ValidationItem(null, null);
  ValidationItem get errorMessage => _errorMessage;

  String _token;

  String get token => _token;

  bool get isAuth {
    return token != null;
  }

  Future<bool> tryAutoLogin() async {
    String token = await filtchRepository.getToken();
    if (token == null) {
      return false;
    }

    _token = token;
    notifyListeners();
    return true;
  }

  Future<String> getEmail() async {
    return await filtchRepository.getEmail();
  }

  Future<void> logout() async {
    await filtchRepository.logout();
    _token = null;
    notifyListeners();
  }

  Future<void> login(String email, String password, {bool rememberMe}) async {
    try {
      String token = await filtchRepository.authenticate(email, password,
          rememberMe: rememberMe);
      _token = token;
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

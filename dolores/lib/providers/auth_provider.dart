import 'package:dolores/helpers/api_exception.dart';
import 'package:dolores/models/validation_item.dart';
import 'package:dolores/repositories/filtch_repository.dart';
import 'package:flutter/material.dart';

enum Status {
  INVALID_CREDENTIALS,
  LOADING,
  LOGGED_IN,
  LOGGED_OUT,
  ERROR,
}

class AuthProvider with ChangeNotifier {
  FiltchRepository filtchRepository = FiltchRepository();
  String _token;

  Status _authStatus = Status.LOADING;

  Status get authStatus => _authStatus;

  ValidationItem _errorMessage = ValidationItem(null, null);

  ValidationItem get errorMessage => _errorMessage;

  bool get isAuth {
    return _token != null;
  }

  Future<bool> init() async {
    _token = await filtchRepository.getToken();
    if (_token == null) {
      return false;
    }
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
    notifyListeners();

    try {
      await filtchRepository.authenticate(email, password,
          rememberMe: rememberMe);
      _authStatus = Status.LOGGED_IN;
    } on ApiException catch (apiException) {
      if (apiException.status < 500) {
        _authStatus = Status.INVALID_CREDENTIALS;
      } else {
        _authStatus = Status.ERROR;
      }
      _errorMessage = ValidationItem(null, apiException.detail);
    } catch (error) {
      _authStatus = Status.ERROR;
      _errorMessage = ValidationItem(null, error.toString());
    }

    notifyListeners();
  }
}

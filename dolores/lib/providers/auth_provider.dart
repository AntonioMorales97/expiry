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

  Status _authStatus = Status.LOADING;

  Status get authStatus => _authStatus;

  ValidationItem _errorMessage = ValidationItem(null, null);

  ValidationItem get errorMessage => _errorMessage;

  Future<String> init() async {
    String token = await filtchRepository.getToken();
    if (token != null) {
      _authStatus = Status.LOGGED_IN;
    } else {
      _authStatus = Status.LOGGED_OUT;
    }
    return token;
  }

  Future<String> getEmail() async {
    return await filtchRepository.getEmail();
  }

  Future<void> logout() async {
    await filtchRepository.logout();
    _authStatus = Status.LOGGED_OUT;
    notifyListeners();
  }

  Future<void> login(String email, String password, {bool rememberMe}) async {
    _authStatus = Status.LOADING;
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

import 'package:dolores/helpers/dolores_error.dart';
import 'package:dolores/locator.dart';
import 'package:dolores/models/user.dart';
import 'package:dolores/services/auth_service.dart';
import 'package:dolores/ui/screens/base_model.dart';

class LoginModel extends BaseModel {
  AuthService _authService = locator<AuthService>();

  DoloresError _error;
  DoloresError get error => _error;

  Future<User> getStoredUser() async {
    return await _authService.user;
  }

  Future<bool> doLogin(String email, String password, bool rememberMe) async {
    setState(ViewState.Busy);

    var success;

    try {
      await _authService.login(email, password, rememberMe: rememberMe);
      success = true;
    } on DoloresError catch (error) {
      _handleDoloresError(error);
      success = false;
    } finally {
      setState(ViewState.Idle);
    }
    return success;
  }

  Future<bool> tryAutoLogin() async {
    return await _authService.tryAutoLogin();
  }

  _handleDoloresError(DoloresError error) async {
    _error = error;

    if (error.status == null || error.status != 403) {
      return;
    }
  }
}

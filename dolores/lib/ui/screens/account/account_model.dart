import 'package:dolores/locator.dart';
import 'package:dolores/models/user.dart';
import 'package:dolores/services/auth_service.dart';
import 'package:dolores/ui/screens/base_model.dart';

class AccountModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();

  User _user;
  User get user => _user;

  Future<bool> changePassword(
    String email,
    String oldPassword,
    String newPassword,
    String newRePassword,
  ) async {
    setState(ViewState.Busy);
    await _authService.changePassword(
        email, oldPassword, newPassword, newRePassword);
    setState(ViewState.Idle);
    return true;
  }

  Future getUser() async {
    setState(ViewState.Busy);
    _user = await _authService.user;
    setState(ViewState.Idle);
  }
}

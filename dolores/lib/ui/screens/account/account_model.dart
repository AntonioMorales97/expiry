import 'package:dolores/helpers/dolores_error.dart';
import 'package:dolores/locator.dart';
import 'package:dolores/models/user.dart';
import 'package:dolores/services/auth_service.dart';
import 'package:dolores/services/dialog_service.dart';
import 'package:dolores/services/product_service.dart';
import 'package:dolores/ui/screens/base_model.dart';

class AccountModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final ProductService _productService = locator<ProductService>();
  DialogService _dialogService = locator<DialogService>();

  User _user;
  User get user => _user;

  Future<bool> changePassword(
    String email,
    String oldPassword,
    String newPassword,
    String newRePassword,
  ) async {
    try {
      setState(ViewState.Busy);
      await _authService.changePassword(
          email, oldPassword, newPassword, newRePassword);

      setState(ViewState.Idle);
      return true;
    } on DoloresError catch (error) {
      _handleDoloresError(error);
      return false;
    }
  }

  Future getUser() async {
    setState(ViewState.Busy);
    _user = await _authService.user;
    setState(ViewState.Idle);
  }

  _handleDoloresError(DoloresError error) async {
    if (error.status == null || error.status != 403) {
      var res = await _dialogService.showDialog(
          title: "Felmedelande",
          description: error.detail,
          buttonTitle: "Tillbaka");

      if (res.confirmed) {
        setState(ViewState.Idle);
      }
      return;
    }
    if (error.status == 403) {
      await _productService.forceLogout();
    }
  }
}

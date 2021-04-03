import 'package:dolores/models/validation_item.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  ValidationItem _email = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);

  ValidationItem get email => _email;
  ValidationItem get password => _password;

  void submit() {
    _password = ValidationItem(null, 'Wrong');
    notifyListeners();
  }
}

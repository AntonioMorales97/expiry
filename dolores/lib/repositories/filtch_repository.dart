import 'dart:convert';

import 'package:dolores/models/user.dart';
import 'package:dolores/repositories/http_caller.dart';
import 'package:localstorage/localstorage.dart';

import 'http_caller.dart';

class FiltchRepository {
  static const String baseUrl = 'http://10.0.2.2:9092';

  final LocalStorage _storage = LocalStorage('filtch');

  final HttpCaller _httpCaller = HttpCaller();

  Future<String> authenticate(String email, String password,
      {bool rememberMe = false}) async {
    final Map<String, dynamic> resp =
        await _httpCaller.doPost(baseUrl + '/authenticate', body: {
      'email': email,
      'password': password,
    });
    User user = User.fromJson(resp);
    String token = resp['token'];

    await _saveToken(token);
    user.rememberMe = rememberMe;
    await _save("user", jsonEncode(user.toJSON()));
    return token;
  }

  Future<void> logout(remember) async {
    await _storage.ready;
    if (!remember) {
      await _storage.deleteItem('user');
    }
    //TODO: Save /remove token on login/logout in filtch.
    await _storage.deleteItem('token');
  }

  Future<void> _saveToken(String token) async {
    await _storage.ready;
    await _storage.setItem('token', token);
  }

  Future<void> _save(String key, String value) async {
    await _storage.ready;
    await _storage.setItem(key, value);
  }

  Future<String> getToken() async {
    await _storage.ready;

    return await _storage.getItem('token');
  }

  Future<User> getUser() async {
    await _storage.ready;
    String s = await _storage.getItem('user');
    if (s == null) {
      throw Exception('LOG THE FUCK OUT!');
    }
    User user = User.fromJson(jsonDecode(s));
    return user;
  }

  Future<void> _saveEmail(String email) async {
    await _storage.ready;
    await _storage.setItem('email', email);
  }
}

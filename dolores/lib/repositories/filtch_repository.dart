import 'package:dolores/repositories/http_caller.dart';
import 'package:localstorage/localstorage.dart';

class FiltchRepository {
  static const String baseUrl = 'http://10.0.2.2:9092';

  final LocalStorage _storage = LocalStorage('filtch');

  final HttpCaller _httpCaller = HttpCaller();

  Future<String> authenticate(String email, String password,
      {bool rememberMe = false}) async {
    final Map<String, dynamic> resp =
        await _httpCaller.doPost(baseUrl + '/validate-credentials', body: {
      'email': email,
      'password': password,
    });

    String token = resp['token'];

    await _saveToken(token);

    if (rememberMe) {
      await _saveEmail(email);
    } else {
      await _storage.ready;
      await _storage.deleteItem('email');
    }

    return token;
  }

  Future<void> logout() async {
    //TODO: Logout filtch
    await _storage.ready;
    await _storage.deleteItem('token');
  }

  Future<void> _saveToken(String token) async {
    await _storage.ready;
    await _storage.setItem('token', token);
  }

  Future<String> getToken() async {
    await _storage.ready;

    return await _storage.getItem('token');
  }

  Future<void> _saveEmail(String email) async {
    await _storage.ready;
    await _storage.setItem('email', email);
  }

  Future<String> getEmail() async {
    await _storage.ready;
    return await _storage.getItem('email');
  }
}

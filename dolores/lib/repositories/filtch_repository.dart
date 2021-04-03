import 'package:dolores/repositories/http_caller.dart';
import 'package:localstorage/localstorage.dart';

class FiltchRepository {
  static const String baseUrl = 'http://10.0.2.2:9092';

  final LocalStorage _storage = LocalStorage('filtch');

  final HttpCaller _httpCaller = HttpCaller();

  String _token;

  String get token => _token;

  Future<String> authenticate(String email, String password,
      {bool rememberMe = false}) async {
    final Map<String, dynamic> resp =
        await _httpCaller.doPost(baseUrl + '/validate-credentials', body: {
      'email': email,
      'password': password,
    });

    _token = resp['token'];

    await _saveToken(_token);

    if (rememberMe) {
      await _saveEmail(email);
    } else {
      await _saveEmail(null);
    }

    return _token;
  }

  Future<void> logout() async {
    //TODO: Logout filtch
    _token = null;
    await _saveToken(_token);
  }

  Future<void> _saveToken(String token) async {
    await _storage.setItem('filtch_token', token);
  }

  Future<String> getToken() async {
    if (_token != null) return _token;

    await _storage.ready;

    _token = await _storage.getItem('filtch_token');
    return _token;
  }

  Future<void> _saveEmail(String email) async {
    await _storage.setItem('filtch_email', email);
  }

  Future<String> getEmail() async {
    return await _storage.getItem('filtch_email');
  }
}

import 'dart:convert';

import 'package:dolores/models/preference.dart';
import 'package:localstorage/localstorage.dart';

import 'filtch_repository.dart';
import 'http_caller.dart';

class PreferenceRepository {
  static const String baseUrl = 'http://10.0.2.2:9091';
  static const String preferenceUrl = '/user/preference';

  final LocalStorage _storage = LocalStorage('preferences');
  final HttpCaller _httpCaller = HttpCaller();
  final FiltchRepository filtchRepository = FiltchRepository();

  String _token;
  //TODO save in dumbledore.
  Future<void> savePreference(Preference newPref) async {
    await _storage.ready;
    await _storage.setItem('preferences', jsonEncode(newPref.toJson()));
  }

  Future<Preference> getPreference() async {
    await _storage.ready;
    Preference preference;
    String serializedPreference = await _storage.getItem('preferences');

    if (serializedPreference != null) {
      return Preference.fromJson(jsonDecode(serializedPreference));
    } else {
      try {
        preference = await fetchPreferenceFromBackend();
        savePreference(preference);
      } catch (error) {
        //todo log?
        return null;
      }
      return preference;
    }
  }

  Future<void> savePreferenceToBackend() async {
    String s = await _storage.getItem('preferences');
    Preference preference = Preference.fromJson(jsonDecode(s));
    await _checkToken();
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.authorizationToken = _token;
    String sort = preference.sort.index.toString();
    String reverse = preference.reverse.toString();

    await _httpCaller
        .doPost(baseUrl + preferenceUrl, headers: httpHeaders, body: {
      'sort': sort,
      'reverse': reverse,
    });
  }

  Future<void> removePreferenceFromLocalStorage() async {
    await _storage.ready;
    await _storage.deleteItem('preferences');
    String s = await _storage.getItem('preferences');
  }

  Future<Preference> fetchPreferenceFromBackend() async {
    await _checkToken();
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.authorizationToken = _token;

    final dynamic resp =
        await _httpCaller.doGet(baseUrl + preferenceUrl, headers: httpHeaders);
    Preference preference = Preference.fromJson(resp);
    return preference;
  }

  Future _getToken() async {
    _token = await filtchRepository.getToken();
  }

  Future _checkToken() async {
    if (_token == null) {
      await _getToken();
    }
  }
}

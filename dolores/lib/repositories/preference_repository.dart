import 'dart:convert';

import 'package:dolores/models/preference.dart';
import 'package:localstorage/localstorage.dart';

class PreferenceRepository {
  final LocalStorage _storage = LocalStorage('preferences');
  //TODO save in dumbledore.
  Future<void> savePreference(Preference newPref) async {
    await _storage.ready;
    await _storage.setItem('preferences', jsonEncode(newPref.toJson()));
  }

  Future<Preference> getPreference() async {
    await _storage.ready;
    String serializedPreference = await _storage.getItem('preferences');
    return serializedPreference == null
        ? serializedPreference
        : Preference.fromJson(jsonDecode(serializedPreference));
  }
}

import 'package:dolores/models/preference.dart';
import 'package:dolores/repositories/preference_repository.dart';
import 'package:flutter/cupertino.dart';

class PreferenceProvider with ChangeNotifier {
  PreferenceRepository prefRepo = new PreferenceRepository();
  Preference _preference;

  Preference get preference => _preference;

  Future<Preference> getPreference() async {
    Preference preference = await prefRepo.getPreference();
    if (preference == null) {
      preference = Preference(sorting: 0);
      await prefRepo.savePreference(preference);
    }
    _preference = preference;
    return preference;
  }

  Future<void> updateSorting(sorting) async {
    Preference newPref = _preference.copyWith(sorting: sorting);
    _preference = newPref;
    await prefRepo.savePreference(newPref);
    notifyListeners();
  }
}

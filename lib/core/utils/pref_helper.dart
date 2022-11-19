import 'package:provider_arc/core/constants/app_contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  Future<SharedPreferences> _sharedPreference;
  static const String is_dark_mode = "is_dark_mode";
  static const String language_code = "language_code";

  SharedPreferenceHelper() {
    _sharedPreference = SharedPreferences.getInstance();
  }

  Future<String> get endpoint {
    return _sharedPreference.then((prefs) {
      return prefs.getString(KEYS.endpoint) ?? KEYS.endpoint;
    });
  }

  Future<void> setEndpoint(String value) {
    return _sharedPreference.then((prefs) {
      return prefs.setString(KEYS.endpoint, value);
    });
  }

  //Theme module
  Future<void> changeTheme(bool value) {
    return _sharedPreference.then((prefs) {
      return prefs.setBool(is_dark_mode, value);
    });
  }

  Future<bool> get isDarkMode {
    return _sharedPreference.then((prefs) {
      return prefs.getBool(is_dark_mode) ?? false;
    });
  }

  //Locale module
  Future<String> get appLocale {
    return _sharedPreference.then((prefs) {
      return prefs.getString(language_code) ?? null;
    });
  }

  Future<void> changeLanguage(String value) {
    return _sharedPreference.then((prefs) {
      return prefs.setString(language_code, value);
    });
  }

  Future<bool> get isLogin {
    return _sharedPreference.then((prefs) {
      return prefs.getBool(KEYS.LOGIN) ?? false;
    });
  }

  Future<bool> get isSignup {
    return _sharedPreference.then((prefs) {
      return prefs.getBool(KEYS.SIGNUP) ?? false;
    });
  }

  Future<int> get userId {
    return _sharedPreference.then((prefs) {
      return prefs.getInt(KEYS.iddriver) ?? 0;
    });
  }

  Future<int> get setting {
    return _sharedPreference.then((prefs) {
      return prefs.getInt(KEYS.SETTING) ?? 0;
    });
  }

  Future<int> get numAccess {
    return _sharedPreference.then((prefs) {
      return prefs.getInt(KEYS.NUMACCESS) ?? 0;
    });
  }

  Future<void> setLogin(bool value) {
    return _sharedPreference.then((prefs) {
      return prefs.setBool(KEYS.LOGIN, value);
    });
  }

  Future<void> setSignup(bool value) {
    return _sharedPreference.then((prefs) {
      return prefs.setBool(KEYS.SIGNUP, value);
    });
  }

  Future<void> setUserId(int value) {
    return _sharedPreference.then((prefs) {
      return prefs.setInt(KEYS.iddriver, value);
    });
  }

  Future<void> setSetting(int value) {
    return _sharedPreference.then((prefs) {
      return prefs.setInt(KEYS.SETTING, value);
    });
  }

  Future<void> setNumAccess(int value) {
    return _sharedPreference.then((prefs) {
      return prefs.setInt(KEYS.NUMACCESS, value);
    });
  }
}

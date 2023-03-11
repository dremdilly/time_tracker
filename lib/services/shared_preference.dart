import 'package:shared_preferences/shared_preferences.dart';

final sharedPreference = SharedPreferenceHelper();

class SharedPreferenceHelper {
  late SharedPreferences _sharedPreference;
  static const String DARK_MODE = "darkMode";

  init() async {
    _sharedPreference = await SharedPreferences.getInstance();
  }

  bool? get darkMode {
    return _sharedPreference.getBool(DARK_MODE);
  }

  void saveDarkMode(bool darkMode)  {
    _sharedPreference.setBool(DARK_MODE, darkMode);
  }

  Future<bool> get authenticationStatus async {
    return false; // Draft
  }

  String get getLocale {
    return _sharedPreference.getString('app_locale') ?? 'en';
  }
}
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreference = SharedPreferenceHelper();

class SharedPreferenceHelper {
  late SharedPreferences _sharedPreference;

  init() async {
    _sharedPreference = await SharedPreferences.getInstance();
  }

  Future<bool> get authenticationStatus async {
    return false; // Draft
  }

  String get getLocale {
    return _sharedPreference.getString('app_locale') ?? 'en';
  }
}
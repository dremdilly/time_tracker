import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl_standalone.dart'
if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker/localization/asset_loader.dart';
import 'package:time_tracker/localization/translations.dart';
import 'package:time_tracker/localization/utils.dart';


class AppLocalizationController extends ChangeNotifier {
  final List<Locale> supportedLocales;
  final bool saveLocale;
  final String path;
  final Function(FlutterError e) onLoadError;
  final Locale fallbackLocale;
  final AssetLoader assetLoader;
  final Locale? defaultLocale;

  static Locale? _savedLocale;
  static Locale? _deviceLocale;

  late Locale _locale;
  Locale get locale => _locale;

  static Logger logger = Logger();
  Translations? _translations;
  Translations? get translations => _translations;

  AppLocalizationController({
    required this.supportedLocales,
    required this.saveLocale,
    required this.path,
    required this.onLoadError,
    required this.fallbackLocale,
    required this.assetLoader,
    required this.defaultLocale,
  }) {
    if (_savedLocale != null) {
      _locale = _savedLocale!;
    } else if (defaultLocale != null) {
      _locale = defaultLocale!;
      _saveLocale(locale);
    } else {
      _locale = supportedLocales.firstWhere(
            (locale) => _checkInitLocale(locale, _deviceLocale),
        orElse: () => _getFallbackLocale(supportedLocales, fallbackLocale),
      );
      _saveLocale(_locale);
    }
    logger.d('init AppLocalizationController: $_locale');
  }

  static Future<void> initAppLocalization() async {
    final _preferences = await SharedPreferences.getInstance();
    final _strLocale = _preferences.getString('app_locale');
    _savedLocale = _strLocale?.toLocale();
    final _foundPlatformLocale = await findSystemLocale();
    _deviceLocale = _foundPlatformLocale.toLocale();
    logger.d('initAppLocalization\nSave Locale: $_savedLocale\nDevice Locale: $_deviceLocale');
  }

  Future<void> loadTranslations() async {
    Map<String, dynamic> data;
    try {
      data = await _loadTranslationData(_locale);
      _translations = Translations(data);
    } on FlutterError catch (e) {
      onLoadError(e);
    } catch (e) {
      onLoadError(FlutterError(e.toString()));
    }
  }

  Future<void> setLocale(Locale l) async {
    _locale = l;
    await loadTranslations();
    notifyListeners();
    logger.d('Locale $locale changed');
    await _saveLocale(_locale);
  }

  Future<void> _saveLocale(Locale? locale) async {
    if (!saveLocale) return;
    final _preferences = await SharedPreferences.getInstance();
    await _preferences.setString('app_locale', locale.toString());
    logger.d('Locale $locale saved');
  }

  Future _loadTranslationData(Locale locale) async {
    return assetLoader.load(path, Locale(locale.languageCode));
  }

  Locale _getFallbackLocale(List<Locale> supportedLocales, Locale? fallbackLocale) {
    if (fallbackLocale != null) return fallbackLocale;
    return supportedLocales.first;
  }

  bool _checkInitLocale(Locale locale, Locale? _deviceLocale) {
    if (locale.countryCode == null) {
      return (locale.languageCode == _deviceLocale!.languageCode);
    } else {
      return (locale == _deviceLocale);
    }
  }
}
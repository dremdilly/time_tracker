import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:time_tracker/localization/app_localization.dart';
import 'package:time_tracker/localization/app_localization_controller.dart';
import 'package:time_tracker/localization/app_localization_delegate.dart';

class AppLocalizationProvider extends InheritedWidget {
  final AppLocalization parent;
  final AppLocalizationController _localeState;
  final Locale? currentLocale;
  final AppLocalizationDelegate delegate;

  AppLocalizationProvider(
      this._localeState, {
        Key? key,
        required this.parent,
        required this.delegate,
      })  : currentLocale = _localeState.locale,
        super(key: key, child: parent.child);

  static AppLocalizationProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppLocalizationProvider>();
  }

  Locale get locale => _localeState.locale;

  List<Locale> get supportedLocales => parent.supportedLocales;

  List<LocalizationsDelegate> get delegates {
    return [
      delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
  }

  Future<void> setLocale(Locale _locale) async {
    if (_locale != _localeState.locale) {
      assert(parent.supportedLocales.contains(_locale));
      await _localeState.setLocale(_locale);
    }
  }

  @override
  bool updateShouldNotify(covariant AppLocalizationProvider oldWidget) {
    return oldWidget.currentLocale != locale;
  }
}

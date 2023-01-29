import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:time_tracker/localization/app_localization_controller.dart';
import 'package:time_tracker/localization/localization.dart';

class AppLocalizationDelegate extends LocalizationsDelegate<Localization> {
  final List<Locale>? supportedLocales;
  final AppLocalizationController controller;
  Logger logger = Logger();

  AppLocalizationDelegate({
    required this.supportedLocales,
    required this.controller,
  });

  @override
  bool isSupported(Locale locale) => supportedLocales!.contains(locale);

  @override
  Future<Localization> load(Locale locale) async {
    logger.d('Load Localization Delegate');
    if (controller.translations == null) await controller.loadTranslations();
    Localization.load(locale, translations: controller.translations);
    return Future.value(Localization.instance);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Localization> old) => false;
}

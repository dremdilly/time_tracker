import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:time_tracker/localization/plural_rules.dart';
import 'package:time_tracker/localization/translations.dart';

class Localization {
  Translations? _translations;
  late Locale _locale;

  Logger logger = Logger();
  final RegExp _replaceArgRegex = RegExp('{}');
  final RegExp _linkKeyMatcher = RegExp(r'(?:@(?:\.[a-z]+)?:(?:[\w\-_|.]+|\([\w\-_|.]+\)))');
  final RegExp _linkKeyPrefixMatcher = RegExp(r'^@(?:\.([a-z]+))?:');
  final RegExp _bracketsMatcher = RegExp('[()]');
  final _modifiers = <String, String Function(String?)>{
    'upper': (String? val) => val!.toUpperCase(),
    'lower': (String? val) => val!.toLowerCase(),
    'capitalize': (String? val) => '${val![0].toUpperCase()}${val.substring(1)}'
  };

  static Localization? _instance;
  static Localization get instance => _instance ?? (_instance = Localization());
  static Localization? of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  static bool load(
      Locale locale, {
        Translations? translations,
      }) {
    instance._locale = locale;
    instance._translations = translations;
    return translations == null ? false : true;
  }

  String translate({
    required String key,
    List<String>? args,
    Map<String, String>? namedArgs,
    String? gender,
  }) {
    late String data;
    if (gender != null) {
      data = (_resolve(key) as Map)[gender];
      if (_resolve(key) is Map) data = _resolve(key)[gender];
    } else {
      data = _resolve(key);
    }
    data = _replaceLinks(data);
    data = _replaceNamedArgs(data, namedArgs);
    data = _replaceArgs(data, args);
    return data;
  }

  String plural({
    required String key,
    required num value,
    List<String>? args,
    Map<String, String>? namedArgs,
    String? name,
    NumberFormat? format,
  }) {
    late String data;
    var pluralRule = _pluralRule(_locale.languageCode, value);
    late var pluralCase = pluralRule();
    switch (pluralCase) {
      case PluralCase.SUFFIX:
        data = _resolve(key, subKey: 'suffix');
        break;
      default:
        data = _resolve(key, subKey: 'other');
        break;
    }
    final formattedValue = format == null ? '$value' : format.format(value);
    if (name != null) {
      namedArgs = {...?namedArgs, name: formattedValue};
    }
    data = _replaceNamedArgs(data, namedArgs);
    return _replaceArgs(data, args ?? [formattedValue]);
  }

  PluralRule _pluralRule(String? locale, num howMany) {
    startRuleEvaluation(howMany);
    return pluralRules[locale]!;
  }

  dynamic _resolve(String key, {bool logging = true, String? subKey}) {
    var resource = _translations?.get(key);
    if (resource == null) {
      if (logging) {
        logger.w('Localization key [$key] not found');
      }
      return key;
    }
    if (subKey != null && resource is Map) {
      resource = resource[subKey];
      if (resource == null) {
        if (logging) {
          logger.w('Localization key [$key.$subKey] not found');
        }
        return '$key.$subKey';
      }
    }
    return resource;
  }

  String _replaceArgs(String res, List<String>? args) {
    if (args == null || args.isEmpty) return res;
    for (var str in args) {
      res = res.replaceFirst(_replaceArgRegex, str);
    }
    return res;
  }

  String _replaceNamedArgs(String res, Map<String, String>? args) {
    if (args == null || args.isEmpty) return res;
    args.forEach((String key, String value) {
      res = res.replaceAll(RegExp('{$key}'), value);
    });
    return res;
  }

  String _replaceLinks(String res, {bool logging = true}) {
    final matches = _linkKeyMatcher.allMatches(res);
    var result = res;

    for (final match in matches) {
      final link = match[0]!;
      final linkPrefixMatches = _linkKeyPrefixMatcher.allMatches(link);
      final linkPrefix = linkPrefixMatches.first[0]!;
      final formatterName = linkPrefixMatches.first[1];

      // Remove the leading @:, @.case: and the brackets
      final linkPlaceholder = link.replaceAll(linkPrefix, '').replaceAll(_bracketsMatcher, '');
      var translated = _resolve(linkPlaceholder);

      if (formatterName != null) {
        if (_modifiers.containsKey(formatterName)) {
          translated = _modifiers[formatterName]!(translated);
        } else {
          if (logging) {
            logger.w('Undefined modifier $formatterName, available modifiers: ${_modifiers.keys.toString()}');
          }
        }
      }
      result = translated.isEmpty ? result : result.replaceAll(link, translated);
    }
    return result;
  }
}

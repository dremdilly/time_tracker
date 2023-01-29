import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/localization/localization.dart';

/// Text widget extension method for access to [tr()] and [plural()]
/// Example :
/// ```
/// Text('title').tr()
/// Text('day').plural(21)
/// ```
extension TextTranslateExtension on Text {
  Text tr({
    List<String>? args,
    Map<String, String>? namedArgs,
    String? gender,
  }) {
    return Text(
      Localization.instance.translate(
        key: data ?? '',
        args: args,
        namedArgs: namedArgs,
        gender: gender,
      ),
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  Text plural(
      num value, {
        List<String>? args,
        Map<String, String>? namedArgs,
        String? name,
        NumberFormat? format,
      }) {
    return Text(
      Localization.instance.plural(
        key: data ?? '',
        value: value,
        args: args,
        namedArgs: namedArgs,
        name: name,
        format: format,
      ),
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}

/// Strings extension method for access to [tr()] and [plural()]
/// Example :
/// ```
/// 'title'.tr()
/// 'day'.plural(21)
/// ```
extension StringTranslateExtension on String {
  String tr({
    List<String>? args,
    Map<String, String>? namedArgs,
    String? gender,
  }) {
    return Localization.instance.translate(
      key: this,
      args: args,
      namedArgs: namedArgs,
      gender: gender,
    );
  }

  String plural(
      num value, {
        List<String>? args,
        Map<String, String>? namedArgs,
        String? name,
        NumberFormat? format,
      }) {
    return Localization.instance.plural(
      key: this,
      value: value,
      args: args,
      namedArgs: namedArgs,
      name: name,
      format: format,
    );
  }
}

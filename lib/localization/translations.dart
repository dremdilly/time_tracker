class Translations {
  final Map<String, dynamic>? _translations;

  Translations(this._translations);

  dynamic get(String key) {
    return _translations?[key];
  }
}
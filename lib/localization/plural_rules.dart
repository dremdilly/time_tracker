// ignore_for_file: constant_identifier_names, non_constant_identifier_names

typedef PluralRule = PluralCase Function();

enum PluralCase { SUFFIX, OTHER }

PluralCase get _SUFFIX => PluralCase.SUFFIX;
PluralCase get _OTHER => PluralCase.OTHER;

late num _num;

void startRuleEvaluation(num howMany) {
  _num = howMany;
}

PluralCase _default_rule() => _OTHER;

PluralCase _ru_rule() {
  num _n = _num % 100;
  if (_n % 10 >= 2 && _n % 10 <= 4 && (_n % 100 < 12 || _n % 100 > 14)) {
    return _SUFFIX;
  }
  return _OTHER;
}

PluralCase _en_rule() {
  if (_num != 1) return _SUFFIX;
  return _OTHER;
}

final Map<String, PluralCase Function()> pluralRules = {
  'en': _en_rule,
  'kz': _default_rule,
  'ru': _ru_rule,
  'default': _default_rule,
};
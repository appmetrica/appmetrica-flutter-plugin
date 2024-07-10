import '../appmetrica_api_pigeon.dart';

class AppMetricaBirthDateAttribute extends UserProfileAttribute {
  final int? _age;
  final int? _year;
  final int? _month;
  final int? _day;

  final bool _reset;

  AppMetricaBirthDateAttribute.withAge(int age)
      : _age = age,
        _year = null,
        _month = null,
        _day = null,
        _reset = false;

  AppMetricaBirthDateAttribute.withYear(int year)
      : _age = null,
        _year = year,
        _month = null,
        _day = null,
        _reset = false;

  AppMetricaBirthDateAttribute.withDateParts(int year, int month, {int? day})
      : _age = null,
        _year = year,
        _month = month,
        _day = day,
        _reset = false;

  AppMetricaBirthDateAttribute.withDate(DateTime date)
      : _age = null,
        _year = date.year,
        _month = date.month,
        _day = date.day,
        _reset = false;

  AppMetricaBirthDateAttribute.withValueReset()
      : _age = null,
        _year = null,
        _month = null,
        _day = null,
        _reset = true;

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.BIRTH_DATE;

  @override
  UserProfileAttributePigeon _toPigeon() => super._toPigeon()
    ..year = _year
    ..month = _month
    ..day = _day
    ..age = _age
    ..ifUndefined = false
    ..reset = _reset;
}

class AppMetricaBooleanAttribute extends _ValueAttribute<bool> {
  AppMetricaBooleanAttribute.withValue(key, value, {ifUndefined = false})
      : super(key, value, ifUndefined, false);

  AppMetricaBooleanAttribute.withValueReset(key) : super(key, null, false, true);

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.BOOLEAN;

  @override
  void _setPigeonValue(UserProfileAttributePigeon pigeon) {
    pigeon.boolValue = _value;
  }
}

class AppMetricaCounterAttribute extends UserProfileAttribute {
  final String key;
  final double _delta;

  AppMetricaCounterAttribute.withDelta(this.key, this._delta);

  @override
  UserProfileAttributePigeon _toPigeon() => super._toPigeon()
    ..key = key
    ..reset = false
    ..ifUndefined = false
    ..doubleValue = _delta;

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.COUNTER;
}

class AppMetricaGenderAttribute extends _ValueAttribute<AppMetricaGender> {
  AppMetricaGenderAttribute.withValue(value) : super("", value, false, false);

  AppMetricaGenderAttribute.withValueReset() : super("", null, false, true);

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.GENDER;

  @override
  void _setPigeonValue(UserProfileAttributePigeon pigeon) {
    pigeon.genderValue =
        _value == null ? GenderPigeon.UNDEFINED : genderToPigeon[_value];
  }
}

enum AppMetricaGender {
  male,
  female,
  other,
}

class AppMetricaNameAttribute extends AppMetricaStringAttribute {
  AppMetricaNameAttribute.withValue(value)
      : super.withValue("", value, ifUndefined: false);

  AppMetricaNameAttribute.withValueReset() : super.withValueReset("");

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.NAME;
}

class AppMetricaNotificationEnabledAttribute extends AppMetricaBooleanAttribute {
  AppMetricaNotificationEnabledAttribute.withValue(value)
      : super.withValue("", value, ifUndefined: false);

  AppMetricaNotificationEnabledAttribute.withValueReset() : super.withValueReset("");

  @override
  UserProfileAttributeType _type() =>
      UserProfileAttributeType.NOTIFICATION_ENABLED;
}

class AppMetricaNumberAttribute extends _ValueAttribute<double> {
  AppMetricaNumberAttribute.withValue(key, value, {ifUndefined = false})
      : super(key, value, ifUndefined, false);

  AppMetricaNumberAttribute.withValueReset(key) : super(key, null, false, true);

  @override
  void _setPigeonValue(UserProfileAttributePigeon pigeon) {
    pigeon.doubleValue = _value;
  }

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.NUMBER;
}

class AppMetricaStringAttribute extends _ValueAttribute<String> {
  AppMetricaStringAttribute.withValue(key, value, {ifUndefined = false})
      : super(key, value, ifUndefined, false);

  AppMetricaStringAttribute.withValueReset(key) : super(key, null, false, true);

  @override
  void _setPigeonValue(UserProfileAttributePigeon pigeon) {
    pigeon.stringValue = _value;
  }

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.STRING;
}

class AppMetricaUserProfile {
  final List<UserProfileAttribute> _attributes;

  AppMetricaUserProfile(this._attributes);
}

abstract class UserProfileAttribute {
  UserProfileAttributePigeon _toPigeon() => UserProfileAttributePigeon(key: "")
    ..genderValue = GenderPigeon.UNDEFINED
    ..type = _type();

  UserProfileAttributeType _type();
}

abstract class _ValueAttribute<T> extends UserProfileAttribute {
  final String _key;
  final T? _value;
  final bool _ifUndefined;
  final bool _reset;

  _ValueAttribute(this._key, this._value, this._ifUndefined, this._reset);

  @override
  UserProfileAttributePigeon _toPigeon() {
    final result = super._toPigeon()
      ..key = _key
      ..ifUndefined = _ifUndefined
      ..reset = _reset;
    _setPigeonValue(result);
    return result;
  }

  void _setPigeonValue(UserProfileAttributePigeon pigeon);
}

final genderToPigeon = {
  AppMetricaGender.male: GenderPigeon.MALE,
  AppMetricaGender.female: GenderPigeon.FEMALE,
  AppMetricaGender.other: GenderPigeon.OTHER,
};

extension UserProfileConverter on AppMetricaUserProfile {
  UserProfilePigeon toPigeon() {
    final result = UserProfilePigeon(
        attributes:
            _attributes.map((e) => e._toPigeon()).toList(growable: false));

    return result;
  }
}

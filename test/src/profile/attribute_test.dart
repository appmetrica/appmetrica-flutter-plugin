import 'package:appmetrica_plugin/src/appmetrica_api_pigeon.dart';
import 'package:appmetrica_plugin/src/profile/attribute.dart';
import 'package:flutter_test/flutter_test.dart';

class _UserProfileMatcher extends Matcher {
  final UserProfileAttributePigeon expected;

  _UserProfileMatcher(this.expected);

  @override
  Description describe(Description description) =>
      description.add("profile matcher");

  @override
  bool matches(covariant UserProfileAttributePigeon actual,
          Map<dynamic, dynamic> matchState) =>
      actual.day == expected.day &&
      actual.month == expected.month &&
      actual.year == expected.year &&
      actual.age == expected.age &&
      actual.ifUndefined == expected.ifUndefined &&
      actual.reset == expected.reset &&
      actual.genderValue == expected.genderValue &&
      actual.key == expected.key &&
      actual.doubleValue == expected.doubleValue &&
      actual.boolValue == expected.boolValue &&
      actual.stringValue == expected.stringValue;
}

UserProfileAttributePigeon? _convert(UserProfileAttribute attribute) =>
    AppMetricaUserProfile([attribute]).toPigeon().attributes.first;

UserProfileAttributePigeon _template(UserProfileAttributeType type,
        {bool reset = false, bool ifUndefined = false}) =>
    UserProfileAttributePigeon(
        key: "",
        genderValue: GenderPigeon.UNDEFINED,
        type: type,
        reset: reset,
        ifUndefined: ifUndefined);

void main() {
  group("BirthDateAttribute", () {
    test('birthDateWithAge', () async {
      expect(
          _convert(AppMetricaBirthDateAttribute.withAge(20)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BIRTH_DATE)
            ..type = UserProfileAttributeType.BIRTH_DATE
            ..age = 20));
    });
    test('birthDateWithAgeIfUndefinde', () async {
      expect(
          _convert(AppMetricaBirthDateAttribute.withAge(20)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.BIRTH_DATE, ifUndefined: false)
                ..type = UserProfileAttributeType.BIRTH_DATE
                ..age = 20));
    });
    test('birthDateWithDate', () async {
      final now = DateTime.now();
      expect(
          _convert(AppMetricaBirthDateAttribute.withDate(now)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BIRTH_DATE)
            ..type = UserProfileAttributeType.BIRTH_DATE
            ..year = now.year
            ..month = now.month
            ..day = now.day));
    });
    test('birthDateWithAgeIfUndefinde', () async {
      final now = DateTime.now();
      expect(
          _convert(AppMetricaBirthDateAttribute.withDate(now)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.BIRTH_DATE, ifUndefined: false)
                ..type = UserProfileAttributeType.BIRTH_DATE
                ..year = now.year
                ..month = now.month
                ..day = now.day));
    });
    test('birthDateWithYear', () async {
      expect(
          _convert(AppMetricaBirthDateAttribute.withYear(20)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BIRTH_DATE)
            ..type = UserProfileAttributeType.BIRTH_DATE
            ..year = 20));
    });
    test('birthDateWithYearIfUndefined', () async {
      expect(
          _convert(AppMetricaBirthDateAttribute.withYear(20)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.BIRTH_DATE, ifUndefined: false)
                ..type = UserProfileAttributeType.BIRTH_DATE
                ..year = 20));
    });
    test('birthDateWithDateParts', () async {
      expect(
          _convert(AppMetricaBirthDateAttribute.withDateParts(20, 21)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BIRTH_DATE)
            ..type = UserProfileAttributeType.BIRTH_DATE
            ..year = 20
            ..month = 21));
    });
    test('birthDateWithDatePartsIfUndefined', () async {
      expect(
          _convert(AppMetricaBirthDateAttribute.withDateParts(20, 21)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.BIRTH_DATE, ifUndefined: false)
                ..type = UserProfileAttributeType.BIRTH_DATE
                ..year = 20
                ..month = 21));
    });
    test('birthDateWithDatePartsAndDay', () async {
      expect(
          _convert(AppMetricaBirthDateAttribute.withDateParts(20, 21, day: 22)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BIRTH_DATE)
            ..type = UserProfileAttributeType.BIRTH_DATE
            ..year = 20
            ..month = 21
            ..day = 22));
    });
    test('birthDateWithDatePartsAndDayIfUndefined', () async {
      expect(
          _convert(AppMetricaBirthDateAttribute.withDateParts(20, 21, day: 22)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.BIRTH_DATE, ifUndefined: false)
                ..type = UserProfileAttributeType.BIRTH_DATE
                ..year = 20
                ..month = 21
                ..day = 22));
    });
  });

  group("BooleanAttribute", () {
    test("withValue", () {
      var itemKey = "key";
      var value = false;
      expect(
          _convert(AppMetricaBooleanAttribute.withValue(itemKey, value)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BOOLEAN)
            ..key = itemKey
            ..boolValue = value));
    });
    test("withValueIfUndefined", () {
      var itemKey = "key";
      var value = false;
      expect(
          _convert(
              AppMetricaBooleanAttribute.withValue(itemKey, value, ifUndefined: true)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BOOLEAN)
            ..key = itemKey
            ..boolValue = value
            ..ifUndefined = true));
    });
    test("withValueReset", () {
      var itemKey = "key";
      expect(
          _convert(AppMetricaBooleanAttribute.withValueReset(itemKey)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BOOLEAN)
            ..key = itemKey
            ..reset = true));
    });
  });

  group("CounterAttribute", () {
    test("withValue", () {
      var itemKey = "key";
      var value = 11.0;
      expect(
          _convert(AppMetricaCounterAttribute.withDelta(itemKey, value)),
          _UserProfileMatcher(_template(UserProfileAttributeType.COUNTER)
            ..key = itemKey
            ..doubleValue = value));
    });
  });

  group("GenderAttribute", () {
    test("withValue", () {
      expect(
          _convert(AppMetricaGenderAttribute.withValue(AppMetricaGender.male)),
          _UserProfileMatcher(_template(UserProfileAttributeType.GENDER)
            ..genderValue = GenderPigeon.MALE));
    });
    test("withValueIfUndefined", () {
      expect(
          _convert(AppMetricaGenderAttribute.withValue(AppMetricaGender.female)),
          _UserProfileMatcher(_template(UserProfileAttributeType.GENDER)
            ..genderValue = GenderPigeon.FEMALE
            ..ifUndefined = false));
    });
    test("withValueReset", () {
      expect(
          _convert(AppMetricaGenderAttribute.withValueReset()),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.GENDER)..reset = true));
    });
  });

  group("NameAttribute", () {
    test("withValue", () {
      const val = "Some name";
      expect(
          _convert(AppMetricaNameAttribute.withValue(val)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.NAME)..stringValue = val));
    });
    test("withValueIfUndefined", () {
      const val = "Some name";
      expect(
          _convert(AppMetricaNameAttribute.withValue(val)),
          _UserProfileMatcher(_template(UserProfileAttributeType.NAME)
            ..stringValue = val
            ..ifUndefined = false));
    });
    test("withValueReset", () {
      expect(
          _convert(AppMetricaNameAttribute.withValueReset()),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.NAME)..reset = true));
    });
  });

  group("NotificationEnabledAttribute", () {
    test("withValue", () {
      const val = true;
      expect(
          _convert(AppMetricaNotificationEnabledAttribute.withValue(val)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.NOTIFICATION_ENABLED)
                ..boolValue = val));
    });
    test("withValueIfUndefined", () {
      const val = true;
      expect(
          _convert(AppMetricaNotificationEnabledAttribute.withValue(val)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.NOTIFICATION_ENABLED)
                ..boolValue = val
                ..ifUndefined = false));
    });
    test("withValueReset", () {
      expect(
          _convert(AppMetricaNotificationEnabledAttribute.withValueReset()),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.NOTIFICATION_ENABLED)
                ..reset = true));
    });
  });

  group("NumberAttribute", () {
    test("withValue", () {
      const key = "someKey";
      const val = 100.0;
      expect(
          _convert(AppMetricaNumberAttribute.withValue(key, val)),
          _UserProfileMatcher(_template(UserProfileAttributeType.NUMBER)
            ..key = key
            ..doubleValue = val));
    });
    test("withValueIfUndefined", () {
      const key = "someKey";
      const val = 100.0;
      expect(
          _convert(AppMetricaNumberAttribute.withValue(key, val, ifUndefined: true)),
          _UserProfileMatcher(_template(UserProfileAttributeType.NUMBER)
            ..key = key
            ..doubleValue = val
            ..ifUndefined = true));
    });
    test("withValueReset", () {
      const key = "someKey";
      expect(
          _convert(AppMetricaNumberAttribute.withValueReset(key)),
          _UserProfileMatcher(_template(UserProfileAttributeType.NUMBER)
            ..key = key
            ..reset = true));
    });
  });

  group("StringAttribute", () {
    test("withValue", () {
      const key = "someKey";
      const val = "Some name";
      expect(
          _convert(AppMetricaStringAttribute.withValue(key, val)),
          _UserProfileMatcher(_template(UserProfileAttributeType.STRING)
            ..key = key
            ..stringValue = val));
    });
    test("withValueIfUndefined", () {
      const key = "someKey";
      const val = "Some name";
      expect(
          _convert(AppMetricaStringAttribute.withValue(key, val, ifUndefined: true)),
          _UserProfileMatcher(_template(UserProfileAttributeType.STRING)
            ..key = key
            ..stringValue = val
            ..ifUndefined = true));
    });
    test("withValueReset", () {
      const key = "someKey";
      expect(
          _convert(AppMetricaStringAttribute.withValueReset(key)),
          _UserProfileMatcher(_template(UserProfileAttributeType.STRING)
            ..key = key
            ..reset = true));
    });
  });
}

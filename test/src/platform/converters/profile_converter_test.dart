import 'package:appmetrica_plugin/src/models/profile.dart';
import 'package:appmetrica_plugin/src/platform/converters/profile_converter.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfileConverter', () {
    test('converts empty profile', () {
      final AppMetricaUserProfile profile = AppMetricaUserProfile(<UserProfileAttribute>[]);

      final UserProfilePigeon pigeon = profile.toPigeon();

      expect(pigeon.attributes, isEmpty);
    });

    test('converts profile with single attribute', () {
      final AppMetricaUserProfile profile = AppMetricaUserProfile(<UserProfileAttribute>[
        AppMetricaNameAttribute.withValue('John'),
      ]);

      final UserProfilePigeon pigeon = profile.toPigeon();

      expect(pigeon.attributes.length, 1);
      expect(pigeon.attributes[0]?.type, UserProfileAttributeType.NAME);
    });

    test('converts profile with multiple attributes', () {
      final AppMetricaUserProfile profile = AppMetricaUserProfile(<UserProfileAttribute>[
        AppMetricaNameAttribute.withValue('Alice'),
        AppMetricaGenderAttribute.withValue(AppMetricaGender.female),
        AppMetricaBirthDateAttribute.withAge(25),
        AppMetricaNotificationEnabledAttribute.withValue(true),
      ]);

      final UserProfilePigeon pigeon = profile.toPigeon();

      expect(pigeon.attributes.length, 4);
    });

    test('converts profile with custom attributes', () {
      final AppMetricaUserProfile profile = AppMetricaUserProfile(<UserProfileAttribute>[
        AppMetricaStringAttribute.withValue('level', 'gold'),
        AppMetricaNumberAttribute.withValue('score', 1500.5),
        AppMetricaBooleanAttribute.withValue('premium', true),
        AppMetricaCounterAttribute.withDelta('purchases', 1),
      ]);

      final UserProfilePigeon pigeon = profile.toPigeon();

      expect(pigeon.attributes.length, 4);
    });
  });

  group('BirthDateAttributeConverter', () {
    test('converts withAge', () {
      final AppMetricaBirthDateAttribute attr = AppMetricaBirthDateAttribute.withAge(30);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.BIRTH_DATE);
      expect(pigeon.age, 30);
      expect(pigeon.year, null);
      expect(pigeon.month, null);
      expect(pigeon.day, null);
      expect(pigeon.reset, false);
    });

    test('converts withYear', () {
      final AppMetricaBirthDateAttribute attr = AppMetricaBirthDateAttribute.withYear(1990);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.BIRTH_DATE);
      expect(pigeon.year, 1990);
      expect(pigeon.age, null);
      expect(pigeon.month, null);
      expect(pigeon.day, null);
    });

    test('converts withDateParts without day', () {
      final AppMetricaBirthDateAttribute attr = AppMetricaBirthDateAttribute.withDateParts(1985, 6);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.year, 1985);
      expect(pigeon.month, 6);
      expect(pigeon.day, null);
    });

    test('converts withDateParts with day', () {
      final AppMetricaBirthDateAttribute attr = AppMetricaBirthDateAttribute.withDateParts(1985, 6, day: 15);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.year, 1985);
      expect(pigeon.month, 6);
      expect(pigeon.day, 15);
    });

    test('converts withDate', () {
      final AppMetricaBirthDateAttribute attr = AppMetricaBirthDateAttribute.withDate(DateTime(1990, 12, 25));

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.year, 1990);
      expect(pigeon.month, 12);
      expect(pigeon.day, 25);
    });

    test('converts withValueReset', () {
      final AppMetricaBirthDateAttribute attr = AppMetricaBirthDateAttribute.withValueReset();

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.reset, true);
      expect(pigeon.age, null);
      expect(pigeon.year, null);
    });
  });

  group('GenderAttributeConverter', () {
    test('converts male', () {
      final AppMetricaGenderAttribute attr = AppMetricaGenderAttribute.withValue(AppMetricaGender.male);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.GENDER);
      expect(pigeon.genderValue, GenderPigeon.MALE);
    });

    test('converts female', () {
      final AppMetricaGenderAttribute attr = AppMetricaGenderAttribute.withValue(AppMetricaGender.female);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.genderValue, GenderPigeon.FEMALE);
    });

    test('converts other', () {
      final AppMetricaGenderAttribute attr = AppMetricaGenderAttribute.withValue(AppMetricaGender.other);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.genderValue, GenderPigeon.OTHER);
    });

    test('converts withValueReset', () {
      final AppMetricaGenderAttribute attr = AppMetricaGenderAttribute.withValueReset();

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.reset, true);
      expect(pigeon.genderValue, GenderPigeon.UNDEFINED);
    });
  });

  group('NameAttributeConverter', () {
    test('converts withValue', () {
      final AppMetricaNameAttribute attr = AppMetricaNameAttribute.withValue('John Doe');

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.NAME);
      expect(pigeon.stringValue, 'John Doe');
      expect(pigeon.ifUndefined, false);
      expect(pigeon.reset, false);
    });

    test('converts withValueReset', () {
      final AppMetricaNameAttribute attr = AppMetricaNameAttribute.withValueReset();

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.NAME);
      expect(pigeon.reset, true);
    });

    test('converts empty name', () {
      final AppMetricaNameAttribute attr = AppMetricaNameAttribute.withValue('');

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValue, '');
    });

    test('converts unicode name', () {
      final AppMetricaNameAttribute attr = AppMetricaNameAttribute.withValue('Иван Петров');

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValue, 'Иван Петров');
    });
  });

  group('NotificationEnabledAttributeConverter', () {
    test('converts true value', () {
      final AppMetricaNotificationEnabledAttribute attr = AppMetricaNotificationEnabledAttribute.withValue(true);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.NOTIFICATION_ENABLED);
      expect(pigeon.boolValue, true);
    });

    test('converts false value', () {
      final AppMetricaNotificationEnabledAttribute attr = AppMetricaNotificationEnabledAttribute.withValue(false);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.boolValue, false);
    });

    test('converts withValueReset', () {
      final AppMetricaNotificationEnabledAttribute attr = AppMetricaNotificationEnabledAttribute.withValueReset();

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.reset, true);
    });
  });

  group('BooleanAttributeConverter', () {
    test('converts withValue true', () {
      final AppMetricaBooleanAttribute attr = AppMetricaBooleanAttribute.withValue('is_premium', true);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.BOOLEAN);
      expect(pigeon.key, 'is_premium');
      expect(pigeon.boolValue, true);
      expect(pigeon.ifUndefined, false);
    });

    test('converts withValue false with ifUndefined', () {
      final AppMetricaBooleanAttribute attr = AppMetricaBooleanAttribute.withValue('is_new', false,
          ifUndefined: true);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.boolValue, false);
      expect(pigeon.ifUndefined, true);
    });

    test('converts withValueReset', () {
      final AppMetricaBooleanAttribute attr = AppMetricaBooleanAttribute.withValueReset('is_premium');

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.key, 'is_premium');
      expect(pigeon.reset, true);
    });
  });

  group('NumberAttributeConverter', () {
    test('converts value', () {
      final AppMetricaNumberAttribute attr = AppMetricaNumberAttribute.withValue('level', 10.0);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.NUMBER);
      expect(pigeon.key, 'level');
      expect(pigeon.doubleValue, 10);
    });

    test('converts zero value', () {
      final AppMetricaNumberAttribute attr = AppMetricaNumberAttribute.withValue('balance', 0.0);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.doubleValue, 0.0);
    });

    test('converts negative value', () {
      final AppMetricaNumberAttribute attr = AppMetricaNumberAttribute.withValue('debt', -500.0);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.doubleValue, -500.0);
    });

    test('converts with ifUndefined', () {
      final AppMetricaNumberAttribute attr =
          AppMetricaNumberAttribute.withValue('default_score', 100.0, ifUndefined: true);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.ifUndefined, true);
    });

    test('converts withValueReset', () {
      final AppMetricaNumberAttribute attr = AppMetricaNumberAttribute.withValueReset('score');

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.reset, true);
    });
  });

  group('StringAttributeConverter', () {
    test('converts withValue', () {
      final AppMetricaStringAttribute attr = AppMetricaStringAttribute.withValue('country', 'USA');

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.STRING);
      expect(pigeon.key, 'country');
      expect(pigeon.stringValue, 'USA');
    });

    test('converts empty string', () {
      final AppMetricaStringAttribute attr = AppMetricaStringAttribute.withValue('note', '');

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValue, '');
    });

    test('converts long string', () {
      final String longValue = 'a' * 1000;
      final AppMetricaStringAttribute attr = AppMetricaStringAttribute.withValue('description', longValue);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValue, longValue);
    });

    test('converts with ifUndefined', () {
      final AppMetricaStringAttribute attr = AppMetricaStringAttribute.withValue('status', 'active',
          ifUndefined: true);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.ifUndefined, true);
    });

    test('converts withValueReset', () {
      final AppMetricaStringAttribute attr = AppMetricaStringAttribute.withValueReset('country');

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.reset, true);
    });
  });

  group('CounterAttributeConverter', () {
    test('converts positive delta', () {
      final AppMetricaCounterAttribute attr = AppMetricaCounterAttribute.withDelta('purchases', 1);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.COUNTER);
      expect(pigeon.key, 'purchases');
      expect(pigeon.doubleValue, 1);
    });

    test('converts negative delta', () {
      final AppMetricaCounterAttribute attr = AppMetricaCounterAttribute.withDelta('lives', -1);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.doubleValue, -1);
    });

    test('converts zero delta', () {
      final AppMetricaCounterAttribute attr = AppMetricaCounterAttribute.withDelta('unchanged', 0);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.doubleValue, 0);
    });

    test('converts fractional delta', () {
      final AppMetricaCounterAttribute attr = AppMetricaCounterAttribute.withDelta('progress', 0.5);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.doubleValue, 0.5);
    });
  });

  group('PhoneHashAttributeConverter', () {
    test('converts phone values', () {
      final AppMetricaPhoneHashAttribute attr = AppMetricaPhoneHashAttribute.withPhoneValues(
          <String>['+1234567890', '+0987654321']);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.PHONE_HASH);
      expect(pigeon.stringValues, <String>['+1234567890', '+0987654321']);
    });

    test('converts single phone value', () {
      final AppMetricaPhoneHashAttribute attr = AppMetricaPhoneHashAttribute.withPhoneValues(<String>['+1111111111']);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValues?.length, 1);
    });

    test('converts empty phone values', () {
      final AppMetricaPhoneHashAttribute attr = AppMetricaPhoneHashAttribute.withPhoneValues(<String>[]);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValues, isEmpty);
    });

    test('converts null phone values', () {
      final AppMetricaPhoneHashAttribute attr = AppMetricaPhoneHashAttribute.withPhoneValues(null);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValues, null);
    });

    test('converts phone values with nulls', () {
      final AppMetricaPhoneHashAttribute attr =
          AppMetricaPhoneHashAttribute.withPhoneValues(<String?>['+1234567890', null]);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValues, <String?>['+1234567890', null]);
    });
  });

  group('EmailHashAttributeConverter', () {
    test('converts email values', () {
      final AppMetricaEmailHashAttribute attr = AppMetricaEmailHashAttribute.withEmailValues(
          <String>['user@example.com', 'test@test.com']);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.EMAIL_HASH);
      expect(pigeon.stringValues, <String>['user@example.com', 'test@test.com']);
    });

    test('converts single email', () {
      final AppMetricaEmailHashAttribute attr =
          AppMetricaEmailHashAttribute.withEmailValues(<String>['solo@email.com']);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValues?.length, 1);
    });

    test('converts empty email values', () {
      final AppMetricaEmailHashAttribute attr = AppMetricaEmailHashAttribute.withEmailValues(<String>[]);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValues, isEmpty);
    });

    test('converts null email values', () {
      final AppMetricaEmailHashAttribute attr = AppMetricaEmailHashAttribute.withEmailValues(null);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValues, null);
    });
  });

  group('TelegramLoginHashAttributeConverter', () {
    test('converts telegram login values', () {
      final AppMetricaTelegramLoginHashAttribute attr = AppMetricaTelegramLoginHashAttribute.withTelegramLoginValues(
          <String>['@user1', '@user2']);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.TELEGRAM_LOGIN_HASH);
      expect(pigeon.stringValues, <String>['@user1', '@user2']);
    });

    test('converts single telegram login', () {
      final AppMetricaTelegramLoginHashAttribute attr = AppMetricaTelegramLoginHashAttribute.withTelegramLoginValues(
          <String>['@single_user']);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValues?.length, 1);
    });

    test('converts empty telegram login values', () {
      final AppMetricaTelegramLoginHashAttribute attr =
          AppMetricaTelegramLoginHashAttribute.withTelegramLoginValues(<String>[]);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValues, isEmpty);
    });

    test('converts null telegram login values', () {
      final AppMetricaTelegramLoginHashAttribute attr =
          AppMetricaTelegramLoginHashAttribute.withTelegramLoginValues(null);

      final UserProfileAttributePigeon pigeon = attr.toPigeon();

      expect(pigeon.stringValues, null);
    });
  });
}

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/profile_converter.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfileConverter', () {
    test('converts empty profile', () {
      final profile = AppMetricaUserProfile([]);

      final pigeon = profile.toPigeon();

      expect(pigeon.attributes, isEmpty);
    });

    test('converts profile with single attribute', () {
      final profile = AppMetricaUserProfile([
        AppMetricaNameAttribute.withValue('John'),
      ]);

      final pigeon = profile.toPigeon();

      expect(pigeon.attributes.length, 1);
      expect(pigeon.attributes[0]?.type, UserProfileAttributeType.NAME);
    });

    test('converts profile with multiple attributes', () {
      final profile = AppMetricaUserProfile([
        AppMetricaNameAttribute.withValue('Alice'),
        AppMetricaGenderAttribute.withValue(AppMetricaGender.female),
        AppMetricaBirthDateAttribute.withAge(25),
        AppMetricaNotificationEnabledAttribute.withValue(true),
      ]);

      final pigeon = profile.toPigeon();

      expect(pigeon.attributes.length, 4);
    });

    test('converts profile with custom attributes', () {
      final profile = AppMetricaUserProfile([
        AppMetricaStringAttribute.withValue('level', 'gold'),
        AppMetricaNumberAttribute.withValue('score', 1500.5),
        AppMetricaBooleanAttribute.withValue('premium', true),
        AppMetricaCounterAttribute.withDelta('purchases', 1),
      ]);

      final pigeon = profile.toPigeon();

      expect(pigeon.attributes.length, 4);
    });
  });

  group('BirthDateAttributeConverter', () {
    test('converts withAge', () {
      final attr = AppMetricaBirthDateAttribute.withAge(30);

      final pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.BIRTH_DATE);
      expect(pigeon.age, 30);
      expect(pigeon.year, null);
      expect(pigeon.month, null);
      expect(pigeon.day, null);
      expect(pigeon.reset, false);
    });

    test('converts withYear', () {
      final attr = AppMetricaBirthDateAttribute.withYear(1990);

      final pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.BIRTH_DATE);
      expect(pigeon.year, 1990);
      expect(pigeon.age, null);
      expect(pigeon.month, null);
      expect(pigeon.day, null);
    });

    test('converts withDateParts without day', () {
      final attr = AppMetricaBirthDateAttribute.withDateParts(1985, 6);

      final pigeon = attr.toPigeon();

      expect(pigeon.year, 1985);
      expect(pigeon.month, 6);
      expect(pigeon.day, null);
    });

    test('converts withDateParts with day', () {
      final attr = AppMetricaBirthDateAttribute.withDateParts(1985, 6, day: 15);

      final pigeon = attr.toPigeon();

      expect(pigeon.year, 1985);
      expect(pigeon.month, 6);
      expect(pigeon.day, 15);
    });

    test('converts withDate', () {
      final attr = AppMetricaBirthDateAttribute.withDate(DateTime(1990, 12, 25));

      final pigeon = attr.toPigeon();

      expect(pigeon.year, 1990);
      expect(pigeon.month, 12);
      expect(pigeon.day, 25);
    });

    test('converts withValueReset', () {
      final attr = AppMetricaBirthDateAttribute.withValueReset();

      final pigeon = attr.toPigeon();

      expect(pigeon.reset, true);
      expect(pigeon.age, null);
      expect(pigeon.year, null);
    });
  });

  group('GenderAttributeConverter', () {
    test('converts male', () {
      final attr = AppMetricaGenderAttribute.withValue(AppMetricaGender.male);

      final pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.GENDER);
      expect(pigeon.genderValue, GenderPigeon.MALE);
    });

    test('converts female', () {
      final attr = AppMetricaGenderAttribute.withValue(AppMetricaGender.female);

      final pigeon = attr.toPigeon();

      expect(pigeon.genderValue, GenderPigeon.FEMALE);
    });

    test('converts other', () {
      final attr = AppMetricaGenderAttribute.withValue(AppMetricaGender.other);

      final pigeon = attr.toPigeon();

      expect(pigeon.genderValue, GenderPigeon.OTHER);
    });

    test('converts withValueReset', () {
      final attr = AppMetricaGenderAttribute.withValueReset();

      final pigeon = attr.toPigeon();

      expect(pigeon.reset, true);
      expect(pigeon.genderValue, GenderPigeon.UNDEFINED);
    });
  });

  group('NameAttributeConverter', () {
    test('converts withValue', () {
      final attr = AppMetricaNameAttribute.withValue('John Doe');

      final pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.NAME);
      expect(pigeon.stringValue, 'John Doe');
      expect(pigeon.ifUndefined, false);
      expect(pigeon.reset, false);
    });

    test('converts withValueReset', () {
      final attr = AppMetricaNameAttribute.withValueReset();

      final pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.NAME);
      expect(pigeon.reset, true);
    });

    test('converts empty name', () {
      final attr = AppMetricaNameAttribute.withValue('');

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValue, '');
    });

    test('converts unicode name', () {
      final attr = AppMetricaNameAttribute.withValue('Иван Петров');

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValue, 'Иван Петров');
    });
  });

  group('NotificationEnabledAttributeConverter', () {
    test('converts true value', () {
      final attr = AppMetricaNotificationEnabledAttribute.withValue(true);

      final pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.NOTIFICATION_ENABLED);
      expect(pigeon.boolValue, true);
    });

    test('converts false value', () {
      final attr = AppMetricaNotificationEnabledAttribute.withValue(false);

      final pigeon = attr.toPigeon();

      expect(pigeon.boolValue, false);
    });

    test('converts withValueReset', () {
      final attr = AppMetricaNotificationEnabledAttribute.withValueReset();

      final pigeon = attr.toPigeon();

      expect(pigeon.reset, true);
    });
  });

  group('BooleanAttributeConverter', () {
    test('converts withValue true', () {
      final attr = AppMetricaBooleanAttribute.withValue('is_premium', true);

      final pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.BOOLEAN);
      expect(pigeon.key, 'is_premium');
      expect(pigeon.boolValue, true);
      expect(pigeon.ifUndefined, false);
    });

    test('converts withValue false with ifUndefined', () {
      final attr = AppMetricaBooleanAttribute.withValue('is_new', false,
          ifUndefined: true);

      final pigeon = attr.toPigeon();

      expect(pigeon.boolValue, false);
      expect(pigeon.ifUndefined, true);
    });

    test('converts withValueReset', () {
      final attr = AppMetricaBooleanAttribute.withValueReset('is_premium');

      final pigeon = attr.toPigeon();

      expect(pigeon.key, 'is_premium');
      expect(pigeon.reset, true);
    });
  });

  group('NumberAttributeConverter', () {
    test('converts value', () {
      final attr = AppMetricaNumberAttribute.withValue('level', 10.0);

      final pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.NUMBER);
      expect(pigeon.key, 'level');
      expect(pigeon.doubleValue, 10);
    });

    test('converts zero value', () {
      final attr = AppMetricaNumberAttribute.withValue('balance', 0.0);

      final pigeon = attr.toPigeon();

      expect(pigeon.doubleValue, 0.0);
    });

    test('converts negative value', () {
      final attr = AppMetricaNumberAttribute.withValue('debt', -500.0);

      final pigeon = attr.toPigeon();

      expect(pigeon.doubleValue, -500.0);
    });

    test('converts with ifUndefined', () {
      final attr =
          AppMetricaNumberAttribute.withValue('default_score', 100.0, ifUndefined: true);

      final pigeon = attr.toPigeon();

      expect(pigeon.ifUndefined, true);
    });

    test('converts withValueReset', () {
      final attr = AppMetricaNumberAttribute.withValueReset('score');

      final pigeon = attr.toPigeon();

      expect(pigeon.reset, true);
    });
  });

  group('StringAttributeConverter', () {
    test('converts withValue', () {
      final attr = AppMetricaStringAttribute.withValue('country', 'USA');

      final pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.STRING);
      expect(pigeon.key, 'country');
      expect(pigeon.stringValue, 'USA');
    });

    test('converts empty string', () {
      final attr = AppMetricaStringAttribute.withValue('note', '');

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValue, '');
    });

    test('converts long string', () {
      final longValue = 'a' * 1000;
      final attr = AppMetricaStringAttribute.withValue('description', longValue);

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValue, longValue);
    });

    test('converts with ifUndefined', () {
      final attr = AppMetricaStringAttribute.withValue('status', 'active',
          ifUndefined: true);

      final pigeon = attr.toPigeon();

      expect(pigeon.ifUndefined, true);
    });

    test('converts withValueReset', () {
      final attr = AppMetricaStringAttribute.withValueReset('country');

      final pigeon = attr.toPigeon();

      expect(pigeon.reset, true);
    });
  });

  group('CounterAttributeConverter', () {
    test('converts positive delta', () {
      final attr = AppMetricaCounterAttribute.withDelta('purchases', 1);

      final pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.COUNTER);
      expect(pigeon.key, 'purchases');
      expect(pigeon.doubleValue, 1);
    });

    test('converts negative delta', () {
      final attr = AppMetricaCounterAttribute.withDelta('lives', -1);

      final pigeon = attr.toPigeon();

      expect(pigeon.doubleValue, -1);
    });

    test('converts zero delta', () {
      final attr = AppMetricaCounterAttribute.withDelta('unchanged', 0);

      final pigeon = attr.toPigeon();

      expect(pigeon.doubleValue, 0);
    });

    test('converts fractional delta', () {
      final attr = AppMetricaCounterAttribute.withDelta('progress', 0.5);

      final pigeon = attr.toPigeon();

      expect(pigeon.doubleValue, 0.5);
    });
  });

  group('PhoneHashAttributeConverter', () {
    test('converts phone values', () {
      final attr = AppMetricaPhoneHashAttribute.withPhoneValues(
          ['+1234567890', '+0987654321']);

      final pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.PHONE_HASH);
      expect(pigeon.stringValues, ['+1234567890', '+0987654321']);
    });

    test('converts single phone value', () {
      final attr = AppMetricaPhoneHashAttribute.withPhoneValues(['+1111111111']);

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValues?.length, 1);
    });

    test('converts empty phone values', () {
      final attr = AppMetricaPhoneHashAttribute.withPhoneValues([]);

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValues, isEmpty);
    });

    test('converts null phone values', () {
      final attr = AppMetricaPhoneHashAttribute.withPhoneValues(null);

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValues, null);
    });

    test('converts phone values with nulls', () {
      final attr =
          AppMetricaPhoneHashAttribute.withPhoneValues(['+1234567890', null]);

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValues, ['+1234567890', null]);
    });
  });

  group('EmailHashAttributeConverter', () {
    test('converts email values', () {
      final attr = AppMetricaEmailHashAttribute.withEmailValues(
          ['user@example.com', 'test@test.com']);

      final pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.EMAIL_HASH);
      expect(pigeon.stringValues, ['user@example.com', 'test@test.com']);
    });

    test('converts single email', () {
      final attr =
          AppMetricaEmailHashAttribute.withEmailValues(['solo@email.com']);

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValues?.length, 1);
    });

    test('converts empty email values', () {
      final attr = AppMetricaEmailHashAttribute.withEmailValues([]);

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValues, isEmpty);
    });

    test('converts null email values', () {
      final attr = AppMetricaEmailHashAttribute.withEmailValues(null);

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValues, null);
    });
  });

  group('TelegramLoginHashAttributeConverter', () {
    test('converts telegram login values', () {
      final attr = AppMetricaTelegramLoginHashAttribute.withTelegramLoginValues(
          ['@user1', '@user2']);

      final pigeon = attr.toPigeon();

      expect(pigeon.type, UserProfileAttributeType.TELEGRAM_LOGIN_HASH);
      expect(pigeon.stringValues, ['@user1', '@user2']);
    });

    test('converts single telegram login', () {
      final attr = AppMetricaTelegramLoginHashAttribute.withTelegramLoginValues(
          ['@single_user']);

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValues?.length, 1);
    });

    test('converts empty telegram login values', () {
      final attr =
          AppMetricaTelegramLoginHashAttribute.withTelegramLoginValues([]);

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValues, isEmpty);
    });

    test('converts null telegram login values', () {
      final attr =
          AppMetricaTelegramLoginHashAttribute.withTelegramLoginValues(null);

      final pigeon = attr.toPigeon();

      expect(pigeon.stringValues, null);
    });
  });
}

import '../../models/profile.dart';
import '../pigeon/appmetrica_api_pigeon.dart';

extension UserProfileConverter on AppMetricaUserProfile {
  UserProfilePigeon toPigeon() => UserProfilePigeon(
      attributes: attributes.map((e) => e.toPigeon()).toList(growable: false));
}

extension UserProfileAttributeConverter on UserProfileAttribute {
  UserProfileAttributePigeon toPigeon() {
    final attr = this;
    // Order matters: more specific types (subclasses) must come first
    if (attr is AppMetricaNameAttribute) return attr._toPigeon();
    if (attr is AppMetricaNotificationEnabledAttribute) return attr._toPigeon();
    if (attr is AppMetricaBirthDateAttribute) return attr._toPigeon();
    if (attr is AppMetricaCounterAttribute) return attr._toPigeon();
    if (attr is AppMetricaGenderAttribute) return attr._toPigeon();
    if (attr is AppMetricaBooleanAttribute) return attr._toPigeon();
    if (attr is AppMetricaNumberAttribute) return attr._toPigeon();
    if (attr is AppMetricaStringAttribute) return attr._toPigeon();
    if (attr is AppMetricaPhoneHashAttribute) return attr._toPigeon();
    if (attr is AppMetricaEmailHashAttribute) return attr._toPigeon();
    if (attr is AppMetricaTelegramLoginHashAttribute) return attr._toPigeon();
    throw UnimplementedError('Unknown attribute type: $runtimeType');
  }
}

extension on AppMetricaBirthDateAttribute {
  UserProfileAttributePigeon _toPigeon() => UserProfileAttributePigeon(key: "")
    ..type = UserProfileAttributeType.BIRTH_DATE
    ..genderValue = GenderPigeon.UNDEFINED
    ..year = year
    ..month = month
    ..day = day
    ..age = age
    ..ifUndefined = false
    ..reset = reset;
}

extension on AppMetricaCounterAttribute {
  UserProfileAttributePigeon _toPigeon() => UserProfileAttributePigeon(key: key)
    ..type = UserProfileAttributeType.COUNTER
    ..genderValue = GenderPigeon.UNDEFINED
    ..doubleValue = delta
    ..ifUndefined = false
    ..reset = false;
}

extension on AppMetricaNameAttribute {
  UserProfileAttributePigeon _toPigeon() => UserProfileAttributePigeon(key: key)
    ..type = UserProfileAttributeType.NAME
    ..genderValue = GenderPigeon.UNDEFINED
    ..stringValue = value
    ..ifUndefined = ifUndefined
    ..reset = reset;
}

extension on AppMetricaNotificationEnabledAttribute {
  UserProfileAttributePigeon _toPigeon() => UserProfileAttributePigeon(key: key)
    ..type = UserProfileAttributeType.NOTIFICATION_ENABLED
    ..genderValue = GenderPigeon.UNDEFINED
    ..boolValue = value
    ..ifUndefined = ifUndefined
    ..reset = reset;
}

extension on AppMetricaGenderAttribute {
  UserProfileAttributePigeon _toPigeon() => UserProfileAttributePigeon(key: key)
    ..type = UserProfileAttributeType.GENDER
    ..genderValue = value == null ? GenderPigeon.UNDEFINED : _genderToPigeon[value]!
    ..ifUndefined = ifUndefined
    ..reset = reset;
}

extension on AppMetricaBooleanAttribute {
  UserProfileAttributePigeon _toPigeon() => UserProfileAttributePigeon(key: key)
    ..type = UserProfileAttributeType.BOOLEAN
    ..genderValue = GenderPigeon.UNDEFINED
    ..boolValue = value
    ..ifUndefined = ifUndefined
    ..reset = reset;
}

extension on AppMetricaNumberAttribute {
  UserProfileAttributePigeon _toPigeon() => UserProfileAttributePigeon(key: key)
    ..type = UserProfileAttributeType.NUMBER
    ..genderValue = GenderPigeon.UNDEFINED
    ..doubleValue = value
    ..ifUndefined = ifUndefined
    ..reset = reset;
}

extension on AppMetricaStringAttribute {
  UserProfileAttributePigeon _toPigeon() => UserProfileAttributePigeon(key: key)
    ..type = UserProfileAttributeType.STRING
    ..genderValue = GenderPigeon.UNDEFINED
    ..stringValue = value
    ..ifUndefined = ifUndefined
    ..reset = reset;
}

extension on AppMetricaPhoneHashAttribute {
  UserProfileAttributePigeon _toPigeon() => UserProfileAttributePigeon(key: "")
    ..type = UserProfileAttributeType.PHONE_HASH
    ..stringValues = values;
}

extension on AppMetricaEmailHashAttribute {
  UserProfileAttributePigeon _toPigeon() => UserProfileAttributePigeon(key: "")
    ..type = UserProfileAttributeType.EMAIL_HASH
    ..stringValues = values;
}

extension on AppMetricaTelegramLoginHashAttribute {
  UserProfileAttributePigeon _toPigeon() => UserProfileAttributePigeon(key: "")
    ..type = UserProfileAttributeType.TELEGRAM_LOGIN_HASH
    ..stringValues = values;
}

const _genderToPigeon = {
  AppMetricaGender.male: GenderPigeon.MALE,
  AppMetricaGender.female: GenderPigeon.FEMALE,
  AppMetricaGender.other: GenderPigeon.OTHER,
};

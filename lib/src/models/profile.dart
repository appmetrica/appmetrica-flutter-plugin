class AppMetricaBirthDateAttribute extends UserProfileAttribute {
  final int? age;
  final int? year;
  final int? month;
  final int? day;
  final bool reset;

  AppMetricaBirthDateAttribute.withAge(int this.age)
      : year = null,
        month = null,
        day = null,
        reset = false;

  AppMetricaBirthDateAttribute.withYear(int this.year)
      : age = null,
        month = null,
        day = null,
        reset = false;

  AppMetricaBirthDateAttribute.withDateParts(int this.year, int this.month, {this.day})
      : age = null,
        reset = false;

  AppMetricaBirthDateAttribute.withDate(DateTime date)
      : age = null,
        year = date.year,
        month = date.month,
        day = date.day,
        reset = false;

  AppMetricaBirthDateAttribute.withValueReset()
      : age = null,
        year = null,
        month = null,
        day = null,
        reset = true;
}

class AppMetricaBooleanAttribute extends _ValueAttribute<bool> {
  AppMetricaBooleanAttribute.withValue(key, value, {ifUndefined = false})
      : super(key, value, ifUndefined, false);

  AppMetricaBooleanAttribute.withValueReset(key) : super(key, null, false, true);
}

class AppMetricaCounterAttribute extends UserProfileAttribute {
  final String key;
  final double delta;

  AppMetricaCounterAttribute.withDelta(this.key, this.delta);
}

class AppMetricaGenderAttribute extends _ValueAttribute<AppMetricaGender> {
  AppMetricaGenderAttribute.withValue(value) : super("", value, false, false);

  AppMetricaGenderAttribute.withValueReset() : super("", null, false, true);
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
}

class AppMetricaNotificationEnabledAttribute extends AppMetricaBooleanAttribute {
  AppMetricaNotificationEnabledAttribute.withValue(value)
      : super.withValue("", value, ifUndefined: false);

  AppMetricaNotificationEnabledAttribute.withValueReset() : super.withValueReset("");
}

class AppMetricaNumberAttribute extends _ValueAttribute<double> {
  AppMetricaNumberAttribute.withValue(key, value, {ifUndefined = false})
      : super(key, value, ifUndefined, false);

  AppMetricaNumberAttribute.withValueReset(key) : super(key, null, false, true);
}

class AppMetricaStringAttribute extends _ValueAttribute<String> {
  AppMetricaStringAttribute.withValue(key, value, {ifUndefined = false})
      : super(key, value, ifUndefined, false);

  AppMetricaStringAttribute.withValueReset(key) : super(key, null, false, true);
}

class AppMetricaUserProfile {
  final List<UserProfileAttribute> attributes;

  AppMetricaUserProfile(this.attributes);
}

abstract class UserProfileAttribute {}

abstract class _ValueAttribute<T> extends UserProfileAttribute {
  final String key;
  final T? value;
  final bool ifUndefined;
  final bool reset;

  _ValueAttribute(this.key, this.value, this.ifUndefined, this.reset);
}

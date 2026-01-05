import '../models/error_description.dart';

extension AppMetricaErrorDescriptionNullableSerializer on AppMetricaErrorDescription? {
  AppMetricaErrorDescription tryToAddCurrentTrace() =>
      this ?? AppMetricaErrorDescription.fromCurrentStackTrace();
}

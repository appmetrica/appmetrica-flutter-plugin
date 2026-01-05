import 'dart:convert';

import '../models/ad_revenue.dart';
import '../models/ecommerce.dart';
import '../models/error_description.dart';
import '../models/profile.dart';
import '../models/revenue.dart';
import '../platform/converters/ad_revenue_converter.dart';
import '../platform/converters/ecommerce_converter.dart';
import '../platform/converters/error_description_converter.dart';
import '../platform/converters/profile_converter.dart';
import '../platform/converters/revenue_converter.dart';
import '../platform/reporter_platform_bridge.dart';
import '../reporter.dart';
import 'service_locator.dart';
import 'utils.dart';

class ReporterImpl implements AppMetricaReporter {
  final String _apiKey;

  ReporterPlatformBridge get _platform => AppMetricaServiceLocator.reporterBridge;

  ReporterImpl(this._apiKey);

  @override
  Future<void> clearAppEnvironment() =>
      _platform.clearAppEnvironment(_apiKey);

  @override
  Future<void> pauseSession() =>
      _platform.pauseSession(_apiKey);

  @override
  Future<void> putAppEnvironmentValue(String key, String? value) =>
      _platform.putAppEnvironmentValue(_apiKey, key, value);

  @override
  Future<void> reportAdRevenue(AppMetricaAdRevenue adRevenue) =>
      _platform.reportAdRevenue(_apiKey, adRevenue.toPigeon());

  @override
  Future<void> reportECommerce(AppMetricaECommerceEvent event) =>
      _platform.reportECommerce(_apiKey, event.toPigeon());

  @override
  Future<void> reportError({
    String? message,
    AppMetricaErrorDescription? errorDescription
  }) =>
      _platform.reportError(_apiKey, errorDescription.tryToAddCurrentTrace().toPigeon(), message);

  @override
  Future<void> reportErrorWithGroup(
      String groupId, {
        AppMetricaErrorDescription? errorDescription,
        String? message
      }) =>
      _platform.reportErrorWithGroup(_apiKey, groupId, errorDescription?.toPigeon(), message);

  @override
  Future<void> reportEvent(String eventName) =>
      _platform.reportEvent(_apiKey, eventName);

  @override
  Future<void> reportEventWithJson(String eventName, String? attributesJson) =>
      _platform.reportEventWithJson(_apiKey, eventName, attributesJson);

  @override
  Future<void> reportEventWithMap(
      String eventName,
      Map<String, Object>? attributes
  ) =>
      _platform.reportEventWithJson(_apiKey, eventName, jsonEncode(attributes));

  @override
  Future<void> reportRevenue(AppMetricaRevenue revenue) =>
      _platform.reportRevenue(_apiKey, revenue.toPigeon());

  @override
  Future<void> reportUnhandledException(AppMetricaErrorDescription error) =>
      _platform.reportUnhandledException(_apiKey, error.toPigeon());

  @override
  Future<void> reportUserProfile(AppMetricaUserProfile userProfile) =>
      _platform.reportUserProfile(_apiKey, userProfile.toPigeon());

  @override
  Future<void> resumeSession() =>
      _platform.resumeSession(_apiKey);

  @override
  Future<void> sendEventsBuffer() =>
      _platform.sendEventsBuffer(_apiKey);

  @override
  Future<void> setDataSendingEnabled(bool enabled) =>
      _platform.setDataSendingEnabled(_apiKey, enabled);

  @override
  Future<void> setUserProfileID(String? userProfileID) =>
      _platform.setUserProfileID(_apiKey, userProfileID);
}

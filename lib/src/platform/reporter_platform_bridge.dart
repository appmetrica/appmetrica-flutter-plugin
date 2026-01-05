import 'pigeon/appmetrica_api_pigeon.dart';

/// Abstract interface for Reporter platform communication.
///
/// This abstraction allows mocking the Reporter platform layer in tests.
abstract class ReporterPlatformBridge {
  Future<void> clearAppEnvironment(String apiKey);
  Future<void> pauseSession(String apiKey);
  Future<void> putAppEnvironmentValue(String apiKey, String key, String? value);
  Future<void> reportAdRevenue(String apiKey, AdRevenuePigeon adRevenue);
  Future<void> reportECommerce(String apiKey, ECommerceEventPigeon event);
  Future<void> reportError(String apiKey, ErrorDetailsPigeon error, String? message);
  Future<void> reportErrorWithGroup(String apiKey, String groupId, ErrorDetailsPigeon? error, String? message);
  Future<void> reportEvent(String apiKey, String eventName);
  Future<void> reportEventWithJson(String apiKey, String eventName, String? attributesJson);
  Future<void> reportRevenue(String apiKey, RevenuePigeon revenue);
  Future<void> reportUnhandledException(String apiKey, ErrorDetailsPigeon error);
  Future<void> reportUserProfile(String apiKey, UserProfilePigeon userProfile);
  Future<void> resumeSession(String apiKey);
  Future<void> sendEventsBuffer(String apiKey);
  Future<void> setDataSendingEnabled(String apiKey, bool enabled);
  Future<void> setUserProfileID(String apiKey, String? userProfileID);
}

/// Implementation of [ReporterPlatformBridge] using Pigeon-generated code.
class PigeonReporterBridge implements ReporterPlatformBridge {
  final ReporterPigeon _pigeon;

  PigeonReporterBridge([ReporterPigeon? pigeon])
      : _pigeon = pigeon ?? ReporterPigeon();

  @override
  Future<void> clearAppEnvironment(String apiKey) =>
      _pigeon.clearAppEnvironment(apiKey);

  @override
  Future<void> pauseSession(String apiKey) =>
      _pigeon.pauseSession(apiKey);

  @override
  Future<void> putAppEnvironmentValue(String apiKey, String key, String? value) =>
      _pigeon.putAppEnvironmentValue(apiKey, key, value);

  @override
  Future<void> reportAdRevenue(String apiKey, AdRevenuePigeon adRevenue) =>
      _pigeon.reportAdRevenue(apiKey, adRevenue);

  @override
  Future<void> reportECommerce(String apiKey, ECommerceEventPigeon event) =>
      _pigeon.reportECommerce(apiKey, event);

  @override
  Future<void> reportError(String apiKey, ErrorDetailsPigeon error, String? message) =>
      _pigeon.reportError(apiKey, error, message);

  @override
  Future<void> reportErrorWithGroup(
      String apiKey, String groupId, ErrorDetailsPigeon? error, String? message) =>
      _pigeon.reportErrorWithGroup(apiKey, groupId, error, message);

  @override
  Future<void> reportEvent(String apiKey, String eventName) =>
      _pigeon.reportEvent(apiKey, eventName);

  @override
  Future<void> reportEventWithJson(String apiKey, String eventName, String? attributesJson) =>
      _pigeon.reportEventWithJson(apiKey, eventName, attributesJson);

  @override
  Future<void> reportRevenue(String apiKey, RevenuePigeon revenue) =>
      _pigeon.reportRevenue(apiKey, revenue);

  @override
  Future<void> reportUnhandledException(String apiKey, ErrorDetailsPigeon error) =>
      _pigeon.reportUnhandledException(apiKey, error);

  @override
  Future<void> reportUserProfile(String apiKey, UserProfilePigeon userProfile) =>
      _pigeon.reportUserProfile(apiKey, userProfile);

  @override
  Future<void> resumeSession(String apiKey) =>
      _pigeon.resumeSession(apiKey);

  @override
  Future<void> sendEventsBuffer(String apiKey) =>
      _pigeon.sendEventsBuffer(apiKey);

  @override
  Future<void> setDataSendingEnabled(String apiKey, bool enabled) =>
      _pigeon.setDataSendingEnabled(apiKey, enabled);

  @override
  Future<void> setUserProfileID(String apiKey, String? userProfileID) =>
      _pigeon.setUserProfileID(apiKey, userProfileID);
}

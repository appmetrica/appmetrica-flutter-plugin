import 'pigeon/appmetrica_api_pigeon.dart';

/// Abstract interface for platform communication.
///
/// This abstraction allows mocking the platform layer in tests.
/// In production, [PigeonPlatformBridge] is used.
abstract class PlatformBridge {
  // Lifecycle
  Future<void> activate(AppMetricaConfigPigeon config);
  Future<void> activateReporter(ReporterConfigPigeon config);
  Future<void> handlePluginInitFinished();

  // Device info
  Future<String?> getDeviceId();
  Future<String?> getUuid();
  Future<int> getLibraryApiLevel();
  Future<String> getLibraryVersion();

  // Events
  Future<void> reportEvent(String eventName);
  Future<void> reportEventWithJson(String eventName, String? attributesJson);
  Future<void> reportAppOpen(String deeplink);
  Future<void> reportReferralUrl(String referralUrl);

  // Errors
  Future<void> reportError(ErrorDetailsPigeon error, String? message);
  Future<void> reportErrorWithGroup(String groupId, ErrorDetailsPigeon? error, String? message);
  Future<void> reportUnhandledException(ErrorDetailsPigeon error);

  // Revenue
  Future<void> reportRevenue(RevenuePigeon revenue);
  Future<void> reportAdRevenue(AdRevenuePigeon adRevenue);

  // E-commerce
  Future<void> reportECommerce(ECommerceEventPigeon event);

  // Profile
  Future<void> reportUserProfile(UserProfilePigeon userProfile);
  Future<void> setUserProfileID(String? userProfileID);

  // Environment
  Future<void> putAppEnvironmentValue(String key, String? value);
  Future<void> clearAppEnvironment();
  Future<void> putErrorEnvironmentValue(String key, String? value);

  // Session
  Future<void> pauseSession();
  Future<void> resumeSession();

  // Settings
  Future<void> setDataSendingEnabled(bool enabled);
  Future<void> setLocation(LocationPigeon? location);
  Future<void> setLocationTracking(bool enabled);
  Future<void> setAdvIdentifiersTracking(bool enabled);
  Future<void> enableActivityAutoTracking();

  // Deeplinks
  Future<AppMetricaDeferredDeeplinkPigeon> requestDeferredDeeplink();
  Future<AppMetricaDeferredDeeplinkParametersPigeon> requestDeferredDeeplinkParameters();

  // Startup params
  Future<StartupParamsPigeon> requestStartupParams(List<String?> params);

  // Buffer
  Future<void> sendEventsBuffer();

  // Reporter
  Future<void> touchReporter(String apiKey);

  // Attribution
  Future<void> reportExternalAttribution(ExternalAttributionPigeon externalAttribution);
}

/// Implementation of [PlatformBridge] using Pigeon-generated code.
///
/// This is the default implementation used in production.
class PigeonPlatformBridge implements PlatformBridge {
  final AppMetricaPigeon _pigeon;

  PigeonPlatformBridge([AppMetricaPigeon? pigeon])
      : _pigeon = pigeon ?? AppMetricaPigeon();

  // Lifecycle

  @override
  Future<void> activate(AppMetricaConfigPigeon config) =>
      _pigeon.activate(config);

  @override
  Future<void> activateReporter(ReporterConfigPigeon config) =>
      _pigeon.activateReporter(config);

  @override
  Future<void> handlePluginInitFinished() =>
      _pigeon.handlePluginInitFinished();

  // Device info

  @override
  Future<String?> getDeviceId() => _pigeon.getDeviceId();

  @override
  Future<String?> getUuid() => _pigeon.getUuid();

  @override
  Future<int> getLibraryApiLevel() => _pigeon.getLibraryApiLevel();

  @override
  Future<String> getLibraryVersion() => _pigeon.getLibraryVersion();

  // Events

  @override
  Future<void> reportEvent(String eventName) =>
      _pigeon.reportEvent(eventName);

  @override
  Future<void> reportEventWithJson(String eventName, String? attributesJson) =>
      _pigeon.reportEventWithJson(eventName, attributesJson);

  @override
  Future<void> reportAppOpen(String deeplink) =>
      _pigeon.reportAppOpen(deeplink);

  @override
  Future<void> reportReferralUrl(String referralUrl) =>
      _pigeon.reportReferralUrl(referralUrl);

  // Errors

  @override
  Future<void> reportError(ErrorDetailsPigeon error, String? message) =>
      _pigeon.reportError(error, message);

  @override
  Future<void> reportErrorWithGroup(
      String groupId, ErrorDetailsPigeon? error, String? message) =>
      _pigeon.reportErrorWithGroup(groupId, error, message);

  @override
  Future<void> reportUnhandledException(ErrorDetailsPigeon error) =>
      _pigeon.reportUnhandledException(error);

  // Revenue

  @override
  Future<void> reportRevenue(RevenuePigeon revenue) =>
      _pigeon.reportRevenue(revenue);

  @override
  Future<void> reportAdRevenue(AdRevenuePigeon adRevenue) =>
      _pigeon.reportAdRevenue(adRevenue);

  // E-commerce

  @override
  Future<void> reportECommerce(ECommerceEventPigeon event) =>
      _pigeon.reportECommerce(event);

  // Profile

  @override
  Future<void> reportUserProfile(UserProfilePigeon userProfile) =>
      _pigeon.reportUserProfile(userProfile);

  @override
  Future<void> setUserProfileID(String? userProfileID) =>
      _pigeon.setUserProfileID(userProfileID);

  // Environment

  @override
  Future<void> putAppEnvironmentValue(String key, String? value) =>
      _pigeon.putAppEnvironmentValue(key, value);

  @override
  Future<void> clearAppEnvironment() => _pigeon.clearAppEnvironment();

  @override
  Future<void> putErrorEnvironmentValue(String key, String? value) =>
      _pigeon.putErrorEnvironmentValue(key, value);

  // Session

  @override
  Future<void> pauseSession() => _pigeon.pauseSession();

  @override
  Future<void> resumeSession() => _pigeon.resumeSession();

  // Settings

  @override
  Future<void> setDataSendingEnabled(bool enabled) =>
      _pigeon.setDataSendingEnabled(enabled);

  @override
  Future<void> setLocation(LocationPigeon? location) =>
      _pigeon.setLocation(location);

  @override
  Future<void> setLocationTracking(bool enabled) =>
      _pigeon.setLocationTracking(enabled);

  @override
  Future<void> setAdvIdentifiersTracking(bool enabled) =>
      _pigeon.setAdvIdentifiersTracking(enabled);

  @override
  Future<void> enableActivityAutoTracking() =>
      _pigeon.enableActivityAutoTracking();

  // Deeplinks

  @override
  Future<AppMetricaDeferredDeeplinkPigeon> requestDeferredDeeplink() =>
      _pigeon.requestDeferredDeeplink();

  @override
  Future<AppMetricaDeferredDeeplinkParametersPigeon>
  requestDeferredDeeplinkParameters() =>
      _pigeon.requestDeferredDeeplinkParameters();

  // Startup params

  @override
  Future<StartupParamsPigeon> requestStartupParams(List<String?> params) =>
      _pigeon.requestStartupParams(params);

  // Buffer

  @override
  Future<void> sendEventsBuffer() => _pigeon.sendEventsBuffer();

  // Reporter

  @override
  Future<void> touchReporter(String apiKey) => _pigeon.touchReporter(apiKey);

  // Attribution

  @override
  Future<void> reportExternalAttribution(
      ExternalAttributionPigeon externalAttribution) =>
      _pigeon.reportExternalAttribution(externalAttribution);
}

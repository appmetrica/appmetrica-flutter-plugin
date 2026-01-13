import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import 'internal/activation_config_holder.dart';
import 'internal/reporter_storage.dart';
import 'internal/service_locator.dart';
import 'internal/utils.dart';
import 'models/ad_revenue.dart';
import 'models/appmetrica_config.dart';
import 'models/deferred_deeplink_result.dart';
import 'models/ecommerce.dart';
import 'models/error_description.dart';
import 'models/external_attribution.dart';
import 'models/location.dart';
import 'models/profile.dart';
import 'models/reporter_config.dart';
import 'models/revenue.dart';
import 'models/startup_params.dart';
import 'platform/converters/ad_revenue_converter.dart';
import 'platform/converters/appmetrica_config_converter.dart';
import 'platform/converters/deferred_deeplink_result_converter.dart';
import 'platform/converters/ecommerce_converter.dart';
import 'platform/converters/error_description_converter.dart';
import 'platform/converters/external_attribution_converter.dart';
import 'platform/converters/location_converter.dart';
import 'platform/converters/profile_converter.dart';
import 'platform/converters/reporter_config_converter.dart';
import 'platform/converters/revenue_converter.dart';
import 'platform/converters/startup_params_converter.dart';
import 'platform/pigeon/appmetrica_api_pigeon.dart';
import 'platform/platform_bridge.dart';
import 'reporter.dart';

/// The class contains methods for working with the library.
class AppMetrica {
  AppMetrica._();

  static final _reporterStorage = ReporterStorage();

  static PlatformBridge get _platform => AppMetricaServiceLocator.platformBridge;

  static const _appMetricaRootLoggerName = "AppMetricaPlugin";

  static final _logger = Logger("$_appMetricaRootLoggerName.MainFacade");

  /// Initializes the library in the application with the initial configuration [config].
  static Future<void> activate(AppMetricaConfig config) async {
    if (config.logs == true) {
      setUpAppMetricaLogger(Logger(_appMetricaRootLoggerName));
    }
    setUpErrorHandlingWithAppMetrica(config);
    var activationCompleter = AppMetricaActivationCompleter(config);
    return _platform.activate(config.toPigeon()).then(
        activationCompleter.complete,
        onError: activationCompleter.onError
    );
  }

  /// Activates reporter with the [config] configuration.
  ///
  /// The reporter must be activated with a configuration that contains an API key different from the API key of the application.
  static Future<void> activateReporter(AppMetricaReporterConfig config) =>
      _platform.activateReporter(config.toPigeon());

  static Future<void> clearAppEnvironment() =>
      _platform.clearAppEnvironment();

  static Future<void> enableActivityAutoTracking() =>
      _platform.enableActivityAutoTracking();

  /// Returns deviceId
  static Future<String?> get deviceId => _platform.getDeviceId();

  /// Returns the API level of the library (Android).
  static Future<int> get libraryApiLevel => _platform.getLibraryApiLevel();

  /// Returns the current version of the AppMetrica library.
  static Future<String> get libraryVersion => _platform.getLibraryVersion();

  /// Returns an object that implements the Reporter interface for the specified [apiKey].
  ///
  /// Used to send statistics using an API key different from the app's API key.
  static AppMetricaReporter getReporter(String apiKey) {
    _platform.touchReporter(apiKey).ignore();
    return _reporterStorage.getReporter(apiKey);
  }

  static Future<String?> get uuid => _platform.getUuid();

  /// Suspends the current foreground session.
  ///
  /// Use the method only when session auto-tracking is disabled [AppMetricaConfig.sessionsAutoTracking].
  static Future<void> pauseSession() => _platform.pauseSession();

  static Future<void> putAppEnvironmentValue(String key, String? value) {
    return _platform.putAppEnvironmentValue(key, value);
  }

  /// Adds a [key]-[value] pair to or deletes it from the application error environment. The environment is shown in the crash and error report.
  ///
  /// * The maximum length of the [key] key is 50 characters. If the length is exceeded, the key is truncated to 50 characters.
  /// * The maximum length of the [value] value is 4000 characters. If the length is exceeded, the value is truncated to 4000 characters.
  /// * A maximum of 30 environment pairs of the form {key, value} are allowed. If you try to add the 31st pair, it will be ignored.
  /// * Total size (sum {len(key) + len(value)} for (key, value) in error_environment) - 4500 characters.
  /// * If a new pair exceeds the total size, it will be ignored.
  static Future<void> putErrorEnvironmentValue(String key, String? value) =>
      _platform.putErrorEnvironmentValue(key, value);

  /// Sends information about ad revenue.
  static Future<void> reportAdRevenue(AppMetricaAdRevenue adRevenue) =>
      _platform.reportAdRevenue(adRevenue.toPigeon());

  /// Sends a message about opening the application using [deeplink].
  static Future<void> reportAppOpen(String deeplink) =>
      _platform.reportAppOpen(deeplink);

  /// Sends a message about an e-commerce event.
  static Future<void> reportECommerce(AppMetricaECommerceEvent event) =>
      _platform.reportECommerce(event.toPigeon());

  /// Sends an error message [message] with the description [errorDescription].
  /// If there is no [errorDescription] description, the current stacktrace will be automatically added.
  static Future<void> reportError(
      {String? message, AppMetricaErrorDescription? errorDescription}) =>
      _platform.reportError(
          errorDescription.tryToAddCurrentTrace().toPigeon(), message);

  /// Sends an error message with its own identifier [groupId]. Errors in reports are grouped by it.
  static Future<void> reportErrorWithGroup(String groupId,
      {AppMetricaErrorDescription? errorDescription, String? message}) =>
      _platform.reportErrorWithGroup(
          groupId, errorDescription?.toPigeon(), message);

  /// Sends an event message with a short name or description of the event [eventName].
  static Future<void> reportEvent(String eventName) =>
      _platform.reportEvent(eventName);

  /// Sends an event message in JSON format [attributesJson] as a string and a short name or description of the event [eventName].
  static Future<void> reportEventWithJson(
      String eventName, String? attributesJson) =>
      _platform.reportEventWithJson(eventName, attributesJson);

  /// Sends an event message as a set of attributes [attributes] Map and a short name or description of the event [eventName].
  static Future<void> reportEventWithMap(
      String eventName, Map<String, Object>? attributes) =>
      _platform.reportEventWithJson(eventName, attributes != null ? jsonEncode(attributes) : null);

  /// Sets the [referralUrl] of the application installation.
  ///
  /// The method can be used to track some traffic sources.
  static Future<void> reportReferralUrl(String referralUrl) =>
      _platform.reportReferralUrl(referralUrl);

  /// Sends the purchase information to the AppMetrica server.
  static Future<void> reportRevenue(AppMetricaRevenue revenue) =>
      _platform.reportRevenue(revenue.toPigeon());

  /// Sends an event with an unhandled exception [errorDescription].
  static Future<void> reportUnhandledException(
      AppMetricaErrorDescription errorDescription) =>
      _platform.reportUnhandledException(errorDescription.toPigeon());

  /// Sends information about updating the user profile using the [userProfile] parameter.
  static Future<void> reportUserProfile(AppMetricaUserProfile userProfile) =>
      _platform.reportUserProfile(userProfile.toPigeon());

  /// Requests a deferred deeplink.
  ///
  /// Relevant only for Android. For iOS, it returns the unknown error.
  static Future<String> requestDeferredDeeplink() =>
      _platform.requestDeferredDeeplink().then((value) {
        final error = value.error;
        if (error != null &&
            error.reason != AppMetricaDeferredDeeplinkReasonPigeon.NO_ERROR) {
          throw AppMetricaDeferredDeeplinkRequestException(
              error.reason.toDart(),
              error.errorDescription,
              error.message);
        } else if (value.deeplink == null) {
          throw AppMetricaDeferredDeeplinkRequestException(
              AppMetricaDeferredDeeplinkErrorReason.unknown,
              "Unable to retrieve deeplink from native library",
              error?.message);
        } else {
          return value.deeplink!;
        }
      });

  /// Requests deferred deeplink parameters.
  ///
  /// Relevant only for Android. For iOS, it returns the unknown error.
  static Future<Map<String, String>> requestDeferredDeeplinkParameters() =>
      _platform.requestDeferredDeeplinkParameters().then((value) {
        final error = value.error;
        if (error != null &&
            error.reason != AppMetricaDeferredDeeplinkReasonPigeon.NO_ERROR) {
          throw AppMetricaDeferredDeeplinkRequestException(
              error.reason.toDart(),
              error.errorDescription,
              error.message);
        } else if (value.parameters == null) {
          throw AppMetricaDeferredDeeplinkRequestException(
              AppMetricaDeferredDeeplinkErrorReason.unknown,
              "Unable to retrieve deeplink from native library",
              error?.message);
        } else {
          return value.parameters!
              .map((key, value) => MapEntry(key as String, value as String));
        }
      });

  /// Requests startup params from AppMetrica.
  ///
  /// Possible values of params can be found in [AppMetricaStartupParams] class.
  static Future<AppMetricaStartupParams> requestStartupParams(List<String>? params)  =>
      _platform.requestStartupParams(params ?? [])
          .then((value) => value.toDart());

  /// Resumes the foreground session or creates a new one if the session timeout has expired.
  ///
  /// Use the method only when session auto-tracking is disabled [AppMetricaConfig.sessionsAutoTracking].
  static Future<void> resumeSession() => _platform.resumeSession();

  /// Sends saved events from the buffer.
  static Future<void> sendEventsBuffer() => _platform.sendEventsBuffer();

  /// Enables/disables including advertising identifiers like GAID, Huawei OAID within its reports.
  static Future<void> setAdvIdentifiersTracking(bool enabled) => _platform.setAdvIdentifiersTracking(enabled);

  /// Enables/disables sending statistics to the AppMetrica server.
  ///
  /// Disabling sending for the main API key also disables sending data from all reporters
  /// that were initialized with another API key.
  static Future<void> setDataSendingEnabled(bool enabled) =>
      _platform.setDataSendingEnabled(enabled);

  /// Sets its own device location information using the [location] parameter.
  static Future<void> setLocation(AppMetricaLocation? location) =>
      _platform.setLocation(location?.toPigeon());

  /// Enables/disables sending device location information using the [enabled].
  /// The default value for Android is false, for iOS is true.
  static Future<void> setLocationTracking(bool enabled) =>
      _platform.setLocationTracking(enabled);

  /// Sets the ID for the user profile using the [userProfileID] parameter.
  ///
  /// If Profile Id sending is not configured, predefined attributes are not displayed in the web interface.
  static Future<void> setUserProfileID(String? userProfileID) =>
      _platform.setUserProfileID(userProfileID);

  static Future<void> reportExternalAttribution(
      AppMetricaExternalAttribution externalAttribution) =>
      _platform.reportExternalAttribution(externalAttribution.toPigeon());

  // utilitary methods

  /// Runs [callback] in its own error zone created by [runZonedGuarded](https://api.flutter.dev/flutter/dart-async/runZonedGuarded.html),
  /// and reports all exceptions to AppMetrica.
  static void runZoneGuarded(VoidCallback callback) {
    runZonedGuarded(() {
      WidgetsFlutterBinding.ensureInitialized();
      callback();
    }, (Object err, StackTrace stack) {
      _logger.warning("error caught by Zone", err, stack);
      if (AppMetricaActivationConfigHolder.lastActivationConfig != null) {
        _platform.reportUnhandledException(convertErrorDetails(
            err.runtimeType.toString(),
            err.toString(),
            stack
        )).ignore();
      }
    });
  }
}

var _crashHandlingActivated = false;

void setUpErrorHandlingWithAppMetrica(AppMetricaConfig config) {
  if (config.flutterCrashReporting == false) {
    return;
  }
  if (_crashHandlingActivated) {
    return;
  }
  _crashHandlingActivated = true;
  final prev = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) async {
    AppMetrica._logger.warning("error caught by handler ${details.summary}", details.exception, details.stack);
    await AppMetrica._platform.reportUnhandledException(convertErrorDetails(
        details.exception.runtimeType.toString(),
        details.summary.toString(),
        details.stack));
    if (prev != null) {
      prev(details);
    }
  };
}

void setUpAppMetricaLogger(Logger logger) {
  hierarchicalLoggingEnabled = true;
  logger.level = Level.ALL;
  logger.onRecord.listen((event) {
    log(event.message,
        error: event.error,
        stackTrace: event.stackTrace,
        sequenceNumber: event.sequenceNumber,
        name: event.loggerName,
        time: event.time,
        zone: event.zone,
        level: event.level.value);
  });
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import 'activation_config_holder.dart';
import 'ad_revenue.dart';
import 'appmetrica_api_pigeon.dart';
import 'appmetrica_config.dart';
import 'deferred_deeplink_result.dart';
import 'ecommerce_event.dart';
import 'error_description.dart';
import 'external_attribution.dart';
import 'location.dart';
import 'logging.dart';
import 'pigeon_converter.dart';
import 'profile/attribute.dart';
import 'reporter/reporter.dart';
import 'reporter/reporter_config.dart';
import 'reporter/reporter_storage.dart';
import 'revenue.dart';
import 'startup_params.dart';
import 'to_dart_converter.dart';

/// The class contains methods for working with the library.
class AppMetrica {
  AppMetrica._();

  static final _reporterStorage = ReporterStorage();

  static final AppMetricaPigeon _appMetrica = AppMetricaPigeon();

  static final _logger = Logger("$appMetricaRootLoggerName.MainFacade");

  /// Initializes the library in the application with the initial configuration [config].
  static Future<void> activate(AppMetricaConfig config) async {
    if (config.logs == true) {
      setUpAppMetricaLogger(appMetricaRootLogger);
    }
    setUpErrorHandlingWithAppMetrica(config);
    var activationCompleter = AppMetricaActivationCompleter(config);
    return _appMetrica.activate(config.toPigeon()).then(
        activationCompleter.complete,
        onError: activationCompleter.onError
    );
  }

  /// Activates reporter with the [config] configuration.
  ///
  /// The reporter must be activated with a configuration that contains an API key different from the API key of the application.
  static Future<void> activateReporter(AppMetricaReporterConfig config) =>
      _appMetrica.activateReporter(config.toPigeon());

  static Future<void> clearAppEnvironment() =>
      _appMetrica.clearAppEnvironment();

  static Future<void> enableActivityAutoTracking() =>
      _appMetrica.enableActivityAutoTracking();

  /// Returns deviceId
  static Future<String?> get deviceId => _appMetrica.getDeviceId();

  /// Returns the API level of the library (Android).
  static Future<int> get libraryApiLevel => _appMetrica.getLibraryApiLevel();

  /// Returns the current version of the AppMetrica library.
  static Future<String> get libraryVersion => _appMetrica.getLibraryVersion();

  /// Returns an object that implements the Reporter interface for the specified [apiKey].
  ///
  /// Used to send statistics using an API key different from the app's API key.
  static AppMetricaReporter getReporter(String apiKey) {
    _appMetrica.touchReporter(apiKey).ignore();
    return _reporterStorage.getReporter(apiKey);
  }

  static Future<String?> get uuid => _appMetrica.getUuid();

  /// Suspends the current foreground session.
  ///
  /// Use the method only when session auto-tracking is disabled [AppMetricaConfig.sessionsAutoTracking].
  static Future<void> pauseSession() => _appMetrica.pauseSession();

  static Future<void> putAppEnvironmentValue(String key, String? value) {
    return _appMetrica.putAppEnvironmentValue(key, value);
  }

  /// Adds a [key]-[value] pair to or deletes it from the application error environment. The environment is shown in the crash and error report.
  ///
  /// * The maximum length of the [key] key is 50 characters. If the length is exceeded, the key is truncated to 50 characters.
  /// * The maximum length of the [value] value is 4000 characters. If the length is exceeded, the value is truncated to 4000 characters.
  /// * A maximum of 30 environment pairs of the form {key, value} are allowed. If you try to add the 31st pair, it will be ignored.
  /// * Total size (sum {len(key) + len(value)} for (key, value) in error_environment) - 4500 characters.
  /// * If a new pair exceeds the total size, it will be ignored.
  static Future<void> putErrorEnvironmentValue(String key, String? value) =>
      _appMetrica.putErrorEnvironmentValue(key, value);

  /// Sends information about ad revenue.
  static Future<void> reportAdRevenue(AppMetricaAdRevenue adRevenue) =>
      _appMetrica.reportAdRevenue(adRevenue.toPigeon());

  /// Sends a message about opening the application using [deeplink].
  static Future<void> reportAppOpen(String deeplink) =>
      _appMetrica.reportAppOpen(deeplink);

  /// Sends a message about an e-commerce event.
  static Future<void> reportECommerce(AppMetricaECommerceEvent event) =>
      _appMetrica.reportECommerce(event.toPigeon());

  /// Sends an error message [message] with the description [errorDescription].
  /// If there is no [errorDescription] description, the current stacktrace will be automatically added.
  static Future<void> reportError(
      {String? message, AppMetricaErrorDescription? errorDescription}) =>
      _appMetrica.reportError(
          errorDescription.tryToAddCurrentTrace().toPigeon(), message);

  /// Sends an error message with its own identifier [groupId]. Errors in reports are grouped by it.
  static Future<void> reportErrorWithGroup(String groupId,
      {AppMetricaErrorDescription? errorDescription, String? message}) =>
      _appMetrica.reportErrorWithGroup(
          groupId, errorDescription?.toPigeon(), message);

  /// Sends an event message with a short name or description of the event [eventName].
  static Future<void> reportEvent(String eventName) =>
      _appMetrica.reportEvent(eventName);

  /// Sends an event message in JSON format [attributesJson] as a string and a short name or description of the event [eventName].
  static Future<void> reportEventWithJson(
      String eventName, String? attributesJson) =>
      _appMetrica.reportEventWithJson(eventName, attributesJson);

  /// Sends an event message as a set of attributes [attributes] Map and a short name or description of the event [eventName].
  static Future<void> reportEventWithMap(
      String eventName, Map<String, Object>? attributes) =>
      _appMetrica.reportEventWithJson(eventName, attributes != null ? jsonEncode(attributes) : null);

  /// Sets the [referralUrl] of the application installation.
  ///
  /// The method can be used to track some traffic sources.
  static Future<void> reportReferralUrl(String referralUrl) =>
      _appMetrica.reportReferralUrl(referralUrl);

  /// Sends the purchase information to the AppMetrica server.
  static Future<void> reportRevenue(AppMetricaRevenue revenue) =>
      _appMetrica.reportRevenue(revenue.toPigeon());

  /// Sends an event with an unhandled exception [errorDescription].
  static Future<void> reportUnhandledException(
      AppMetricaErrorDescription errorDescription) =>
      _appMetrica.reportUnhandledException(errorDescription.toPigeon());

  /// Sends information about updating the user profile using the [userProfile] parameter.
  static Future<void> reportUserProfile(AppMetricaUserProfile userProfile) =>
      _appMetrica.reportUserProfile(userProfile.toPigeon());

  /// Requests a deferred deeplink.
  ///
  /// Relevant only for Android. For iOS, it returns the unknown error.
  static Future<String> requestDeferredDeeplink() =>
      _appMetrica.requestDeferredDeeplink().then((value) {
        final error = value.error;
        if (error != null &&
            error.reason != AppMetricaDeferredDeeplinkReasonPigeon.NO_ERROR) {
          throw AppMetricaDeferredDeeplinkRequestException(
              _deferredDeeplinkErrorToDart(error.reason),
              error.description,
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
      _appMetrica.requestDeferredDeeplinkParameters().then((value) {
        final error = value.error;
        if (error != null &&
            error.reason != AppMetricaDeferredDeeplinkReasonPigeon.NO_ERROR) {
          throw AppMetricaDeferredDeeplinkRequestException(
              _deferredDeeplinkErrorToDart(error.reason),
              error.description,
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
      _appMetrica.requestStartupParams(params ?? [])
          .then((value) => value.toDart());

  /// Resumes the foreground session or creates a new one if the session timeout has expired.
  ///
  /// Use the method only when session auto-tracking is disabled [AppMetricaConfig.sessionsAutoTracking].
  static Future<void> resumeSession() => _appMetrica.resumeSession();

  /// Sends saved events from the buffer.
  static Future<void> sendEventsBuffer() => _appMetrica.sendEventsBuffer();

  /// Enables/disables including advertising identifiers like GAID, Huawei OAID within its reports.
  static Future<void> setAdvIdentifiersTracking(bool enabled) => _appMetrica.setAdvIdentifiersTracking(enabled);

  /// Enables/disables sending statistics to the AppMetrica server.
  ///
  /// Disabling sending for the main API key also disables sending data from all reporters
  /// that were initialized with another API key.
  static Future<void> setDataSendingEnabled(bool enabled) =>
      _appMetrica.setDataSendingEnabled(enabled);

  /// Sets its own device location information using the [location] parameter.
  static Future<void> setLocation(AppMetricaLocation? location) =>
      _appMetrica.setLocation(location?.toPigeon());

  /// Enables/disables sending device location information using the [enabled].
  /// The default value for Android is false, for iOS is true.
  static Future<void> setLocationTracking(bool enabled) =>
      _appMetrica.setLocationTracking(enabled);

  /// Sets the ID for the user profile using the [userProfileID] parameter.
  ///
  /// If Profile Id sending is not configured, predefined attributes are not displayed in the web interface.
  static Future<void> setUserProfileID(String? userProfileID) =>
      _appMetrica.setUserProfileID(userProfileID);

  static Future<void> reportExternalAttribution(
      AppMetricaExternalAttribution externalAttribution) =>
      _appMetrica.reportExternalAttribution(externalAttribution.toPigeon());

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
        _appMetrica.reportUnhandledException(convertErrorDetails(
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
    await AppMetrica._appMetrica.reportUnhandledException(convertErrorDetails(
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

AppMetricaDeferredDeeplinkErrorReason _deferredDeeplinkErrorToDart(
    AppMetricaDeferredDeeplinkReasonPigeon error) {
  switch (error) {
    case AppMetricaDeferredDeeplinkReasonPigeon.NOT_A_FIRST_LAUNCH:
      return AppMetricaDeferredDeeplinkErrorReason.notAFirstLaunch;
    case AppMetricaDeferredDeeplinkReasonPigeon.PARSE_ERROR:
      return AppMetricaDeferredDeeplinkErrorReason.parseError;
    case AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN:
      return AppMetricaDeferredDeeplinkErrorReason.unknown;
    case AppMetricaDeferredDeeplinkReasonPigeon.NO_REFERRER:
      return AppMetricaDeferredDeeplinkErrorReason.noReferrer;
    default:
      return AppMetricaDeferredDeeplinkErrorReason.unknown;
  }
}

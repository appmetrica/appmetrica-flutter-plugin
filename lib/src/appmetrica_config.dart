import 'package:appmetrica_plugin/src/appmetrica_api_pigeon.dart';
import 'package:appmetrica_plugin/src/pigeon_converter.dart';

import 'location.dart';
import 'preload_info.dart';

/// The class contains the starting configuration of the library.
/// Configuration parameters are applied from the moment the library is initialized. You can set:
/// * [apiKey] — application API key;
/// * [anrMonitoring] - whether to capture and send reports about ANRs automatically. The default value is false.
/// * [anrMonitoringTimeout] - the timeout in seconds at which the fact of ANR is recorded.
/// * [appBuildNumber] - build number of application.
/// * [appEnvironment] - application environment to be set after initialization.
/// * [appOpenTrackingEnabled] — indicates automatic collection and sending of information about app open. The default value is true.
/// * [appVersion] — application version;
/// * [crashReporting] — flag for sending information about unhandled exceptions in the platform part of the application. The default value is true;
/// * [customHosts] - custom hosts for startup config.
/// * [dataSendingEnabled] — indicates whether sending statistics is enabled. The default value is true;
/// * [deviceType] - device type based on screen size: phone, tablet, TV.
/// * [dispatchPeriodSeconds] - timeout for sending reports.
/// * [errorEnvironment] — the environment of the application error in the form of a key-value pair. The environment is displayed in the crashes and errors report;
/// * [firstActivationAsUpdate] — flag that determines if the first launch of the application is an update. The default value is false;
///   If the first launch of the application is defined as an update, the installation will not be displayed in reports as a new installation and will not be attributed to partners;
/// * [flutterCrashReporting] — flag for sending information about unhandled exceptions in the flutter code of the application. The default value is true;
/// * [location] — device location information;
/// * [locationTracking] — indicates whether the device location information is being collected and sent.
///   The default value for Android is false, for iOS is true.
/// * [logs] — indicates that logging of the library is enabled. The default value is false;
/// * [maxReportsCount] - maximum buffer size for reports.
/// * [maxReportsInDatabaseCount] — is the maximum number of events that can be stored in the database on the device before being sent to AppMetrica. The default value is 1000.
///   Values in the range [100; 10000] are allowed. Values that do not fall within this interval will be automatically replaced with the value of the nearest interval boundary;
/// * [nativeCrashReporting] — flag for sending information about unhandled exceptions in the application. Exceptions are caused by C++ code in Android;
/// * [preloadInfo] — a [AppMetricaPreloadInfo] object for tracking preinstalled applications;
/// * [revenueAutoTrackingEnabled] — indicates automatic collection and sending of information about In-App purchases. The default value is true.
/// * [sessionTimeout] — session timeout in seconds. The default value is 10 (the minimum allowed value);
/// * [sessionsAutoTrackingEnabled] — indicates automatic collection and sending of information about the sessions of the application user. The default value is true;
/// * [userProfileID] — user profile ID;
class AppMetricaConfig {
  static final _converter = AppMetricaConfigConverterPigeon();

  final String apiKey;
  final bool? anrMonitoring;
  final int? anrMonitoringTimeout;
  final int? appBuildNumber;
  final Map<String?, String?>? appEnvironment;
  final bool? appOpenTrackingEnabled;
  final String? appVersion;
  final bool? crashReporting;
  final List<String?>? customHosts;
  final bool? dataSendingEnabled;
  final String? deviceType;
  final int? dispatchPeriodSeconds;
  final Map<String?, String?>? errorEnvironment;
  final bool? firstActivationAsUpdate;
  final bool? flutterCrashReporting; // flutter only
  final AppMetricaLocation? location;
  final bool? locationTracking;
  final bool? logs;
  final int? maxReportsCount;
  final int? maxReportsInDatabaseCount;
  final bool? nativeCrashReporting;
  final AppMetricaPreloadInfo? preloadInfo;
  final bool? revenueAutoTrackingEnabled;
  final int? sessionTimeout;
  final bool? sessionsAutoTrackingEnabled;
  final String? userProfileID;

  /// Creates an AppMetrica library configuration object. [apiKey] is a required parameter.
  const AppMetricaConfig(
    this.apiKey, {
        this.anrMonitoring,
        this.anrMonitoringTimeout,
        this.appBuildNumber,
        this.appEnvironment,
        this.appOpenTrackingEnabled,
        this.appVersion,
        this.crashReporting,
        this.customHosts,
        this.dataSendingEnabled,
        this.deviceType,
        this.dispatchPeriodSeconds,
        this.errorEnvironment,
        this.flutterCrashReporting,
        this.firstActivationAsUpdate,
        this.location,
        this.locationTracking,
        this.logs,
        this.maxReportsCount,
        this.maxReportsInDatabaseCount,
        this.nativeCrashReporting,
        this.preloadInfo,
        this.revenueAutoTrackingEnabled,
        this.sessionTimeout,
        this.sessionsAutoTrackingEnabled,
        this.userProfileID,
      });

  Future<String> toJson() => _converter.toJson(toPigeon());
}

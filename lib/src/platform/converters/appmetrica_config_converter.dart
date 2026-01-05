import '../../models/appmetrica_config.dart';
import '../pigeon/appmetrica_api_pigeon.dart';
import 'location_converter.dart';
import 'preload_info_converter.dart';

extension ConfigConverter on AppMetricaConfig {
  AppMetricaConfigPigeon toPigeon() => AppMetricaConfigPigeon(
    apiKey: apiKey,
    advIdentifiersTracking: advIdentifiersTracking,
    anrMonitoring: anrMonitoring,
    anrMonitoringTimeout: anrMonitoringTimeout,
    appBuildNumber: appBuildNumber,
    appEnvironment: appEnvironment,
    appOpenTrackingEnabled: appOpenTrackingEnabled,
    appVersion: appVersion,
    crashReporting: crashReporting,
    customHosts: customHosts,
    dataSendingEnabled: dataSendingEnabled,
    deviceType: deviceType,
    dispatchPeriodSeconds: dispatchPeriodSeconds,
    errorEnvironment: errorEnvironment,
    firstActivationAsUpdate: firstActivationAsUpdate,
    location: location?.toPigeon(),
    locationTracking: locationTracking,
    logs: logs,
    maxReportsCount: maxReportsCount,
    maxReportsInDatabaseCount: maxReportsInDatabaseCount,
    nativeCrashReporting: nativeCrashReporting,
    preloadInfo: preloadInfo?.toPigeon(),
    revenueAutoTrackingEnabled: revenueAutoTrackingEnabled,
    sessionTimeout: sessionTimeout,
    sessionsAutoTrackingEnabled: sessionsAutoTrackingEnabled,
    userProfileID: userProfileID,
  );
}

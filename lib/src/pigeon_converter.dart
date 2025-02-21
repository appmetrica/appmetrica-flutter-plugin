import 'dart:io';

import 'package:stack_trace/stack_trace.dart';

import 'ad_revenue.dart';
import 'appmetrica_api_pigeon.dart';
import 'appmetrica_config.dart';
import 'error_description.dart';
import 'location.dart';
import 'preload_info.dart';
import 'reporter/reporter_config.dart';
import 'revenue.dart';

extension ReceiptConverter on AppMetricaReceipt {
  ReceiptPigeon toPigeon() => ReceiptPigeon(data: data, signature: signature);
}

extension RevenueConverter on AppMetricaRevenue {
  RevenuePigeon toPigeon() => RevenuePigeon(
      price: price.toString(),
      currency: currency,
      productId: productId,
      quantity: quantity,
      payload: payload,
      transactionId: transactionId,
      receipt: receipt?.toPigeon());
}

List<StackTraceElementPigeon> convertErrorStackTrace(StackTrace stack) {
  final backtrace = Trace.from(stack).frames.map((element) {
    final firstDot = element.member?.indexOf(".") ?? -1;
    final className =
        firstDot >= 0 ? element.member?.substring(0, firstDot) : null;
    final methodName = element.member?.substring(firstDot + 1);
    return StackTraceElementPigeon(
        className: className ?? "",
        methodName: methodName ?? "",
        fileName: element.library,
        line: element.line ?? 0,
        column: element.column ?? 0);
  });
  return backtrace.toList(growable: false);
}

extension AppMetricaErrorDescriptionSubstitutor on AppMetricaErrorDescription? {
  AppMetricaErrorDescription tryToAddCurrentTrace() {
    if (this == null) {
      return AppMetricaErrorDescription.fromCurrentStackTrace();
    } else {
      return this!;
    }
  }
}

extension AppMetricaErrorDescriptionSerializer on AppMetricaErrorDescription {
  ErrorDetailsPigeon toPigeon() =>
      convertErrorDetails(type ?? "", message, stackTrace);
}

ErrorDetailsPigeon convertErrorDetails(
        String clazz, String? msg, StackTrace? stack) =>
    ErrorDetailsPigeon(
        exceptionClass: clazz,
        message: msg,
        dartVersion: Platform.version,
        backtrace: stack != null ? convertErrorStackTrace(stack) : []);

extension LocationConverter on AppMetricaLocation {
  LocationPigeon toPigeon() => LocationPigeon(
      latitude: latitude,
      longitude: longitude,
      provider: provider,
      altitude: altitude,
      accuracy: accuracy,
      course: course,
      speed: speed,
      timestamp: timestamp);
}

extension PreloadInfoConverter on AppMetricaPreloadInfo {
  PreloadInfoPigeon toPigeon() =>
      PreloadInfoPigeon(trackingId: trackingId, additionalInfo: additionalInfo);
}

extension ConfigConverter on AppMetricaConfig {
  AppMetricaConfigPigeon toPigeon() => AppMetricaConfigPigeon(
    apiKey: apiKey,
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

extension ReporterConfigConverter on AppMetricaReporterConfig {
  ReporterConfigPigeon toPigeon() => ReporterConfigPigeon(
    apiKey: apiKey,
    appEnvironment: appEnvironment,
    dataSendingEnabled: dataSendingEnabled,
    dispatchPeriodSeconds: dispatchPeriodSeconds,
    logs: logs,
    maxReportsCount: maxReportsCount,
    maxReportsInDatabaseCount: maxReportsInDatabaseCount,
    sessionTimeout: sessionTimeout,
    userProfileID: userProfileID,
  );
}

final adTypeToPigeon = {
  AppMetricaAdType.unknown: AdTypePigeon.UNKNOWN,
  AppMetricaAdType.native: AdTypePigeon.NATIVE,
  AppMetricaAdType.banner: AdTypePigeon.BANNER,
  AppMetricaAdType.rewarded: AdTypePigeon.REWARDED,
  AppMetricaAdType.interstitial: AdTypePigeon.INTERSTITIAL,
  AppMetricaAdType.mrec: AdTypePigeon.MREC,
  AppMetricaAdType.other: AdTypePigeon.OTHER,
};

extension AdRevenueConverter on AppMetricaAdRevenue {
  AdRevenuePigeon toPigeon() => AdRevenuePigeon(
        adRevenue: adRevenue.toString(),
        currency: currency,
        adType: adTypeToPigeon[adType],
        adNetwork: adNetwork,
        adUnitId: adUnitId,
        adUnitName: adUnitName,
        adPlacementId: adPlacementId,
        adPlacementName: adPlacementName,
        precision: precision,
        payload: payload,
      );
}

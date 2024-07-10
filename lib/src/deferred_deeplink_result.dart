/// Describes an error that occurs when requesting a deferred deeplink.
class AppMetricaDeferredDeeplinkRequestException implements Exception {
  final AppMetricaDeferredDeeplinkErrorReason reason;
  final String description;
  final String? message;
  AppMetricaDeferredDeeplinkRequestException(this.reason, this.description, this.message);
}

/// Contains possible error values when requesting a deferred deeplink:
/// * [notAFirstLaunch] - the deferred deeplink cannot be received, since the deferred deeplink request is possible only on the first launch.
/// * [parseError] - the deferred deeplink could not be found. This is possible if the referrer did not contain the appmetrica_deep_link parameter.
/// * [noReferrer] - the referrer could not be found, or the value is null/Play Services is missing/Huawei Media Services is missing.
/// * [unknown] - unknown error.
enum AppMetricaDeferredDeeplinkErrorReason {
  notAFirstLaunch,
  parseError,
  noReferrer,
  unknown,
}

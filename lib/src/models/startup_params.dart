enum AppMetricaStartupParamsItemStatus {
  featureDisabled,
  invalidValueFromProvider,
  networkError,
  ok,
  providerUnavailable,
  unknownError,
}

class AppMetricaStartupParamsItem {
  final String? id;
  final AppMetricaStartupParamsItemStatus status;
  final String? errorDetails;

  const AppMetricaStartupParamsItem({
    this.id,
      this.status = AppMetricaStartupParamsItemStatus.unknownError,
      this.errorDetails,
  });
}

class AppMetricaStartupParamsResult {
  final String? deviceId;
  final String? deviceIdHash;
  final Map<String?, AppMetricaStartupParamsItem?>? parameters;
  final String? uuid;

  const AppMetricaStartupParamsResult({
    this.deviceId,
    this.deviceIdHash,
    this.parameters,
    this.uuid,
  });
}

enum AppMetricaStartupParamsReason {
  invalidResponse,
  network,
  unknown,
}

class AppMetricaStartupParams {
  final AppMetricaStartupParamsResult? result;
  final AppMetricaStartupParamsReason? reason;

  const AppMetricaStartupParams({
    this.result,
    this.reason,
  });

  static const String uuidKey = "appmetrica_uuid";
  static const String deviceIdKey = "appmetrica_device_id";
  static const String deviceIdHashKey = "appmetrica_device_id_hash";
}

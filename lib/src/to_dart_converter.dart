import 'package:appmetrica_plugin/src/appmetrica_api_pigeon.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

extension StartupParamsItemStatusConverter on StartupParamsItemStatusPigeon {
  AppMetricaStartupParamsItemStatus toDart() {
    switch (this) {
      case StartupParamsItemStatusPigeon.FEATURE_DISABLED:
        return AppMetricaStartupParamsItemStatus.featureDisabled;
      case StartupParamsItemStatusPigeon.INVALID_VALUE_FROM_PROVIDER:
        return AppMetricaStartupParamsItemStatus.invalidValueFromProvider;
      case StartupParamsItemStatusPigeon.NETWORK_ERROR:
        return AppMetricaStartupParamsItemStatus.networkError;
      case StartupParamsItemStatusPigeon.OK:
        return AppMetricaStartupParamsItemStatus.ok;
      case StartupParamsItemStatusPigeon.PROVIDER_UNAVAILABLE:
        return AppMetricaStartupParamsItemStatus.providerUnavailable;
      case StartupParamsItemStatusPigeon.UNKNOWN_ERROR:
        return AppMetricaStartupParamsItemStatus.unknownError;
      default:
        return AppMetricaStartupParamsItemStatus.unknownError;
    }
  }
}

extension StartupParamsItemConverter on StartupParamsItemPigeon {
  AppMetricaStartupParamsItem toDart() {
    return AppMetricaStartupParamsItem(
      id: id,
      status: status.toDart(),
      errorDetails: errorDetails,
    );
  }
}

extension StartupParamsResultConverter on StartupParamsResultPigeon {
  AppMetricaStartupParamsResult toDart() {
    return AppMetricaStartupParamsResult(
      deviceId: deviceId,
      deviceIdHash: deviceIdHash,
      parameters: parameters?.map((key, value) => MapEntry(
          key,
          value?.toDart()
      )),
      uuid: uuid,
    );
  }
}

extension StartupParamsReasonConverter on StartupParamsReasonPigeon {
  AppMetricaStartupParamsReason  toDart() {
    switch (value) {
      case "INVALID_RESPONSE":
        return AppMetricaStartupParamsReason.invalidResponse;
    case "NETWORK":
    return AppMetricaStartupParamsReason.network;
    case "UNKNOWN":
    return AppMetricaStartupParamsReason.unknown;
      default:
        return AppMetricaStartupParamsReason.unknown;
    }
  }
}

extension StartupParamsConverter on StartupParamsPigeon {
  AppMetricaStartupParams toDart() {
    return AppMetricaStartupParams(
      result: result?.toDart(),
      reason: reason?.toDart(),
    );
  }
}

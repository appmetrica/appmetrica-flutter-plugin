import '../../models/deferred_deeplink_result.dart';
import '../pigeon/appmetrica_api_pigeon.dart';

extension AppMetricaDeferredDeeplinkReasonConverter on AppMetricaDeferredDeeplinkReasonPigeon {
  AppMetricaDeferredDeeplinkErrorReason toDart() {
    switch (this) {
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
}

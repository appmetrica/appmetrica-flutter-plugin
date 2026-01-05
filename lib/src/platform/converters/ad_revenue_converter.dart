import '../../models/ad_revenue.dart';
import '../pigeon/appmetrica_api_pigeon.dart';

final adTypeToPigeon = {
  AppMetricaAdType.unknown: AdTypePigeon.UNKNOWN,
  AppMetricaAdType.native: AdTypePigeon.NATIVE,
  AppMetricaAdType.banner: AdTypePigeon.BANNER,
  AppMetricaAdType.rewarded: AdTypePigeon.REWARDED,
  AppMetricaAdType.interstitial: AdTypePigeon.INTERSTITIAL,
  AppMetricaAdType.mrec: AdTypePigeon.MREC,
  AppMetricaAdType.appOpen: AdTypePigeon.APP_OPEN,
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

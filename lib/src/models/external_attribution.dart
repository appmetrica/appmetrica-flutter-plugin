/// The class to store external attribution data.
class AppMetricaExternalAttribution {
  final String source;
  final Map<String?, dynamic> data;

  /// Creates AppsFlyer implementation of AppMetricaExternalAttribution.
  AppMetricaExternalAttribution.appsflyer(Map<String, dynamic> attribution)
      : source = "appsflyer",
        data = attribution["payload"];

  /// Creates Adjust implementation of AppMetricaExternalAttribution.
  AppMetricaExternalAttribution.adjust({
    String? trackerToken,
    String? trackerName,
    String? network,
    String? campaign,
    String? adgroup,
    String? creative,
    String? clickLabel,
    String? adid,
    String? costType,
    num? costAmount,
    String? costCurrency,
    String? fbInstallReferrer
  })
      : source = "adjust",
        data = {
          "trackerToken": trackerToken,
          "trackerName": trackerName,
          "network": network,
          "campaign": campaign,
          "adgroup": adgroup,
          "creative": creative,
          "clickLabel": clickLabel,
          "adid": adid,
          "costType": costType,
          "costAmount": costAmount,
          "costCurrency": costCurrency,
          "fbInstallReferrer": fbInstallReferrer,
        };

  /// Creates Kochava implementation of AppMetricaExternalAttribution.
  AppMetricaExternalAttribution.kochava(Map<String, dynamic> attribution)
      : source = "kochava",
        data = Map.from(attribution);

  /// Creates Tenjin implementation of AppMetricaExternalAttribution.
  AppMetricaExternalAttribution.tenjin(Map<String, dynamic> attribution)
      : source = "tenjin",
        data = Map.from(attribution);

  /// Creates AirBridge implementation of AppMetricaExternalAttribution.
  AppMetricaExternalAttribution.airbridge(Map<dynamic, dynamic> attribution)
      : source = "airbridge",
        data = attribution.map((key, value) => MapEntry(key?.toString(), value));

  /// Creates Singular implementation of AppMetricaExternalAttribution.
  AppMetricaExternalAttribution.singular(Map<String, dynamic> attribution)
      : source = "singular",
        data = Map.from(attribution);
}

import 'package:appmetrica_plugin/src/appmetrica_api_pigeon.dart';

/// The class to store external attribution data.
class AppMetricaExternalAttribution {
  final String _source;
  final Map<String?, dynamic> _data;

  /// Creates AppsFlyer implementation of AppMetricaExternalAttribution.
  AppMetricaExternalAttribution.appsflyer(Map<String, dynamic> attribution)
      : _source = "appsflyer",
        _data = attribution["payload"];

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
      : _source = "adjust",
        _data = {
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
      : _source = "kochava",
        _data = Map.from(attribution);

  /// Creates Tenjin implementation of AppMetricaExternalAttribution.
  AppMetricaExternalAttribution.tenjin(Map<String, dynamic> attribution)
      : _source = "tenjin",
        _data = Map.from(attribution);

  /// Creates AirBridge implementation of AppMetricaExternalAttribution.
  AppMetricaExternalAttribution.airbridge(Map<dynamic, dynamic> attribution)
      : _source = "airbridge",
        _data = attribution.map((key, value) => MapEntry(key?.toString(), value));

  /// Creates Singular implementation of AppMetricaExternalAttribution.
  AppMetricaExternalAttribution.singular(Map<String, dynamic> attribution)
      : _source = "singular",
        _data = Map.from(attribution);

  /// Serializes data to pigeon. For internal use.
  ExternalAttributionPigeon toPigeon() => ExternalAttributionPigeon(
      source: _source,
      data: _data,
  );
}

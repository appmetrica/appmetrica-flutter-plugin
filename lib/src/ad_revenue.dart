import 'package:decimal/decimal.dart';

/// The class to store Ad Revenue data. You can set:
/// * [adRevenue] - amount of money received via ad revenue (it cannot be negative);
/// * [currency] - Currency in which money from [adRevenue] is represented;
/// * [adType] - ad type;
/// * [adNetwork] - ad network. Maximum length is 100 symbols;
/// * [adUnitId] - id of ad unit. Maximum length is 100 symbols;
/// * [adUnitName] - name of ad unit. Maximum length is 100 symbols;
/// * [adPlacementId] - id of ad placement. Maximum length is 100 symbols;
/// * [adPlacementName] - name of ad placement. Maximum length is 100 symbols;
/// * [precision] - precision. Example: "publisher_defined", "estimated". Maximum length is 100 symbols;
/// * [payload] - arbitrary payload: additional info represented as key-value pairs. Maximum size is 30 KB.
class AppMetricaAdRevenue {
  final Decimal adRevenue;
  final String currency;
  final AppMetricaAdType? adType;
  final String? adNetwork;
  final String? adUnitId;
  final String? adUnitName;
  final String? adPlacementId;
  final String? adPlacementName;
  final String? precision;
  final Map<String, String>? payload;

  /// Creates an object with information about income from in-app purchases. The parameters [adRevenue], [currency] are required.
  AppMetricaAdRevenue({
    required this.adRevenue,
    required this.currency,
    this.adType,
    this.adNetwork,
    this.adUnitId,
    this.adUnitName,
    this.adPlacementId,
    this.adPlacementName,
    this.precision,
    this.payload,
  });
}

/// Enum containing possible Ad Type values.
enum AppMetricaAdType {
  unknown,
  native,
  banner,
  rewarded,
  interstitial,
  mrec,
  other,
}

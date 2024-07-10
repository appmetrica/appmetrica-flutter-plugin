import 'package:decimal/decimal.dart';

/// The class contains information about income from in-app purchases. You can set:
/// * [price] - cost. It can be negative, for example, for a refund;
/// * [currency] - the currency code of the purchase according to the standard [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217);
/// * [quantity] — number of purchases (purchased goods).;
/// * [productID] - purchase ID. It can contain up to 200 characters;
/// * [payload] - additional information about the purchase. The string must contain valid JSON. The maximum size of the value is 30 KB;
/// * [receipt] — in-app purchase information from Google Play/App Store;
/// * [transactionID] - ID of the purchase transaction in the App Store. This parameter is relevant only for iOS.
class AppMetricaRevenue {
  final Decimal price;
  final String currency;
  final int? quantity;
  final String? productId;
  final String? payload;
  final AppMetricaReceipt? receipt;
  final String? transactionId;

  /// Creates an object with information about income from in-app purchases. The parameters [price], [currency] are required.
  AppMetricaRevenue(this.price, this.currency,
      {this.quantity,
      this.productId,
      this.payload,
      this.receipt,
      this.transactionId});
}

/// The class contains information about the purchase:
/// * [data] — information about the purchase from Google Play/App Store;
/// * [signature] - signature confirming the purchase in Google Play/App Store. Used for validating purchases in Google Play/App Store.
class AppMetricaReceipt {
  final String? data;
  final String? signature;

  /// Creates an object with information about the purchase.
  AppMetricaReceipt({this.data, this.signature});
}

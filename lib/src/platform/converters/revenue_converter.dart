import '../../models/revenue.dart';
import '../pigeon/appmetrica_api_pigeon.dart';

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

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/revenue_converter.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RevenueConverter', () {
    test('converts all fields correctly', () {
      final AppMetricaRevenue revenue = AppMetricaRevenue(
        Decimal.parse('9.99'),
        'USD',
        productId: 'product_123',
        quantity: 2,
        payload: '{"promotion": "summer_sale"}',
        transactionId: 'txn_456',
        receipt: AppMetricaReceipt(
          data: 'receipt_data_string',
          signature: 'receipt_signature',
        ),
      );

      final RevenuePigeon pigeon = revenue.toPigeon();

      expect(pigeon.price, '9.99');
      expect(pigeon.currency, 'USD');
      expect(pigeon.productId, 'product_123');
      expect(pigeon.quantity, 2);
      expect(pigeon.payload, '{"promotion": "summer_sale"}');
      expect(pigeon.transactionId, 'txn_456');
      expect(pigeon.receipt?.data, 'receipt_data_string');
      expect(pigeon.receipt?.signature, 'receipt_signature');
    });

    test('converts only required fields', () {
      final AppMetricaRevenue revenue = AppMetricaRevenue(
        Decimal.parse('4.99'),
        'EUR',
      );

      final RevenuePigeon pigeon = revenue.toPigeon();

      expect(pigeon.price, '4.99');
      expect(pigeon.currency, 'EUR');
      expect(pigeon.productId, null);
      expect(pigeon.quantity, null);
      expect(pigeon.payload, null);
      expect(pigeon.transactionId, null);
      expect(pigeon.receipt, null);
    });

    test('converts negative price (refund)', () {
      final AppMetricaRevenue revenue = AppMetricaRevenue(
        Decimal.parse('-19.99'),
        'USD',
        productId: 'refunded_product',
      );

      final RevenuePigeon pigeon = revenue.toPigeon();

      expect(pigeon.price, '-19.99');
    });

    test('converts zero price', () {
      final AppMetricaRevenue revenue = AppMetricaRevenue(
        Decimal.zero,
        'USD',
        productId: 'free_product',
      );

      final RevenuePigeon pigeon = revenue.toPigeon();

      expect(pigeon.price, '0');
    });

    test('converts price with many decimal places', () {
      final AppMetricaRevenue revenue = AppMetricaRevenue(
        Decimal.parse('0.00000001'),
        'BTC',
      );

      final RevenuePigeon pigeon = revenue.toPigeon();

      expect(pigeon.price, '0.00000001');
    });

    test('converts large price value', () {
      final AppMetricaRevenue revenue = AppMetricaRevenue(
        Decimal.parse('9999999.99'),
        'USD',
      );

      final RevenuePigeon pigeon = revenue.toPigeon();

      expect(pigeon.price, '9999999.99');
    });
  });

  group('ReceiptConverter', () {
    test('converts receipt with all fields', () {
      final AppMetricaReceipt receipt = AppMetricaReceipt(
        data: 'purchase_data',
        signature: 'purchase_signature',
      );

      final AppMetricaRevenue revenue = AppMetricaRevenue(
        Decimal.one,
        'USD',
        receipt: receipt,
      );

      final RevenuePigeon pigeon = revenue.toPigeon();

      expect(pigeon.receipt?.data, 'purchase_data');
      expect(pigeon.receipt?.signature, 'purchase_signature');
    });

    test('converts receipt with only data', () {
      final AppMetricaReceipt receipt = AppMetricaReceipt(
        data: 'purchase_data',
      );

      final AppMetricaRevenue revenue = AppMetricaRevenue(
        Decimal.one,
        'USD',
        receipt: receipt,
      );

      final RevenuePigeon pigeon = revenue.toPigeon();

      expect(pigeon.receipt?.data, 'purchase_data');
      expect(pigeon.receipt?.signature, null);
    });

    test('converts receipt with only signature', () {
      final AppMetricaReceipt receipt = AppMetricaReceipt(
        signature: 'purchase_signature',
      );

      final AppMetricaRevenue revenue = AppMetricaRevenue(
        Decimal.one,
        'USD',
        receipt: receipt,
      );

      final RevenuePigeon pigeon = revenue.toPigeon();

      expect(pigeon.receipt?.data, null);
      expect(pigeon.receipt?.signature, 'purchase_signature');
    });

    test('converts empty receipt', () {
      final AppMetricaReceipt receipt = AppMetricaReceipt();

      final AppMetricaRevenue revenue = AppMetricaRevenue(
        Decimal.one,
        'USD',
        receipt: receipt,
      );

      final RevenuePigeon pigeon = revenue.toPigeon();

      expect(pigeon.receipt?.data, null);
      expect(pigeon.receipt?.signature, null);
    });
  });
}

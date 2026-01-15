import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/ad_revenue_converter.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdRevenueConverter', () {
    test('converts all fields correctly', () {
      final adRevenue = AppMetricaAdRevenue(
        adRevenue: Decimal.parse('0.05'),
        currency: 'USD',
        adType: AppMetricaAdType.banner,
        adNetwork: 'AdMob',
        adUnitId: 'unit_123',
        adUnitName: 'Banner Unit',
        adPlacementId: 'placement_456',
        adPlacementName: 'Home Screen',
        precision: 'publisher_defined',
        payload: {'key1': 'value1', 'key2': 'value2'},
      );

      final pigeon = adRevenue.toPigeon();

      expect(pigeon.adRevenue, '0.05');
      expect(pigeon.currency, 'USD');
      expect(pigeon.adType, AdTypePigeon.BANNER);
      expect(pigeon.adNetwork, 'AdMob');
      expect(pigeon.adUnitId, 'unit_123');
      expect(pigeon.adUnitName, 'Banner Unit');
      expect(pigeon.adPlacementId, 'placement_456');
      expect(pigeon.adPlacementName, 'Home Screen');
      expect(pigeon.precision, 'publisher_defined');
      expect(pigeon.payload, {'key1': 'value1', 'key2': 'value2'});
    });

    test('converts only required fields', () {
      final adRevenue = AppMetricaAdRevenue(
        adRevenue: Decimal.parse('1.23'),
        currency: 'EUR',
      );

      final pigeon = adRevenue.toPigeon();

      expect(pigeon.adRevenue, '1.23');
      expect(pigeon.currency, 'EUR');
      expect(pigeon.adType, null);
      expect(pigeon.adNetwork, null);
      expect(pigeon.adUnitId, null);
      expect(pigeon.adUnitName, null);
      expect(pigeon.adPlacementId, null);
      expect(pigeon.adPlacementName, null);
      expect(pigeon.precision, null);
      expect(pigeon.payload, null);
    });

    test('converts Decimal with many decimal places', () {
      final adRevenue = AppMetricaAdRevenue(
        adRevenue: Decimal.parse('0.00123456789'),
        currency: 'USD',
      );

      final pigeon = adRevenue.toPigeon();

      expect(pigeon.adRevenue, '0.00123456789');
    });

    test('converts large Decimal values', () {
      final adRevenue = AppMetricaAdRevenue(
        adRevenue: Decimal.parse('999999999.99'),
        currency: 'USD',
      );

      final pigeon = adRevenue.toPigeon();

      expect(pigeon.adRevenue, '999999999.99');
    });

    group('adType conversion', () {
      test('converts unknown', () {
        final adRevenue = AppMetricaAdRevenue(
          adRevenue: Decimal.one,
          currency: 'USD',
          adType: AppMetricaAdType.unknown,
        );

        expect(adRevenue.toPigeon().adType, AdTypePigeon.UNKNOWN);
      });

      test('converts native', () {
        final adRevenue = AppMetricaAdRevenue(
          adRevenue: Decimal.one,
          currency: 'USD',
          adType: AppMetricaAdType.native,
        );

        expect(adRevenue.toPigeon().adType, AdTypePigeon.NATIVE);
      });

      test('converts banner', () {
        final adRevenue = AppMetricaAdRevenue(
          adRevenue: Decimal.one,
          currency: 'USD',
          adType: AppMetricaAdType.banner,
        );

        expect(adRevenue.toPigeon().adType, AdTypePigeon.BANNER);
      });

      test('converts rewarded', () {
        final adRevenue = AppMetricaAdRevenue(
          adRevenue: Decimal.one,
          currency: 'USD',
          adType: AppMetricaAdType.rewarded,
        );

        expect(adRevenue.toPigeon().adType, AdTypePigeon.REWARDED);
      });

      test('converts interstitial', () {
        final adRevenue = AppMetricaAdRevenue(
          adRevenue: Decimal.one,
          currency: 'USD',
          adType: AppMetricaAdType.interstitial,
        );

        expect(adRevenue.toPigeon().adType, AdTypePigeon.INTERSTITIAL);
      });

      test('converts mrec', () {
        final adRevenue = AppMetricaAdRevenue(
          adRevenue: Decimal.one,
          currency: 'USD',
          adType: AppMetricaAdType.mrec,
        );

        expect(adRevenue.toPigeon().adType, AdTypePigeon.MREC);
      });

      test('converts appOpen', () {
        final adRevenue = AppMetricaAdRevenue(
          adRevenue: Decimal.one,
          currency: 'USD',
          adType: AppMetricaAdType.appOpen,
        );

        expect(adRevenue.toPigeon().adType, AdTypePigeon.APP_OPEN);
      });

      test('converts other', () {
        final adRevenue = AppMetricaAdRevenue(
          adRevenue: Decimal.one,
          currency: 'USD',
          adType: AppMetricaAdType.other,
        );

        expect(adRevenue.toPigeon().adType, AdTypePigeon.OTHER);
      });
    });
  });
}

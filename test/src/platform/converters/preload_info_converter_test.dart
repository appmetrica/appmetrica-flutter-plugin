import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/preload_info_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PreloadInfoConverter', () {
    test('converts only tracking id', () {
      const preloadInfo = AppMetricaPreloadInfo('tracking_123');

      final pigeon = preloadInfo.toPigeon();

      expect(pigeon.trackingId, 'tracking_123');
      expect(pigeon.additionalInfo, null);
    });

    test('converts with additional info', () {
      const preloadInfo = AppMetricaPreloadInfo(
        'tracking_456',
        additionalInfo: {
          'source': 'partner_app',
          'campaign': 'preinstall_promo',
        },
      );

      final pigeon = preloadInfo.toPigeon();

      expect(pigeon.trackingId, 'tracking_456');
      expect(pigeon.additionalInfo, {
        'source': 'partner_app',
        'campaign': 'preinstall_promo',
      });
    });

    test('converts with empty additional info', () {
      const preloadInfo = AppMetricaPreloadInfo(
        'tracking_789',
        additionalInfo: {},
      );

      final pigeon = preloadInfo.toPigeon();

      expect(pigeon.trackingId, 'tracking_789');
      expect(pigeon.additionalInfo, {});
    });

    test('converts with single additional info entry', () {
      const preloadInfo = AppMetricaPreloadInfo(
        'tracking_single',
        additionalInfo: {'key': 'value'},
      );

      final pigeon = preloadInfo.toPigeon();

      expect(pigeon.additionalInfo, {'key': 'value'});
    });

    test('converts with many additional info entries', () {
      const preloadInfo = AppMetricaPreloadInfo(
        'tracking_many',
        additionalInfo: {
          'key1': 'value1',
          'key2': 'value2',
          'key3': 'value3',
          'key4': 'value4',
          'key5': 'value5',
        },
      );

      final pigeon = preloadInfo.toPigeon();

      expect(pigeon.additionalInfo?.length, 5);
      expect(pigeon.additionalInfo?['key1'], 'value1');
      expect(pigeon.additionalInfo?['key5'], 'value5');
    });

    test('converts tracking id with special characters', () {
      const preloadInfo = AppMetricaPreloadInfo('tracking-id_123.abc');

      final pigeon = preloadInfo.toPigeon();

      expect(pigeon.trackingId, 'tracking-id_123.abc');
    });

    test('converts empty tracking id', () {
      const preloadInfo = AppMetricaPreloadInfo('');

      final pigeon = preloadInfo.toPigeon();

      expect(pigeon.trackingId, '');
    });

    test('converts additional info with empty string values', () {
      const preloadInfo = AppMetricaPreloadInfo(
        'tracking',
        additionalInfo: {
          'empty': '',
          'non_empty': 'value',
        },
      );

      final pigeon = preloadInfo.toPigeon();

      expect(pigeon.additionalInfo?['empty'], '');
      expect(pigeon.additionalInfo?['non_empty'], 'value');
    });

    test('converts additional info with unicode values', () {
      const preloadInfo = AppMetricaPreloadInfo(
        'tracking_unicode',
        additionalInfo: {
          'cyrillic': 'Привет',
          'chinese': '你好',
          'emoji': '😀',
        },
      );

      final pigeon = preloadInfo.toPigeon();

      expect(pigeon.additionalInfo?['cyrillic'], 'Привет');
      expect(pigeon.additionalInfo?['chinese'], '你好');
      expect(pigeon.additionalInfo?['emoji'], '😀');
    });
  });
}

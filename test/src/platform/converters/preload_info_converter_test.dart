import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/preload_info_converter.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PreloadInfoConverter', () {
    test('converts only tracking id', () {
      const AppMetricaPreloadInfo preloadInfo = AppMetricaPreloadInfo('tracking_123');

      final PreloadInfoPigeon pigeon = preloadInfo.toPigeon();

      expect(pigeon.trackingId, 'tracking_123');
      expect(pigeon.additionalInfo, null);
    });

    test('converts with additional info', () {
      const AppMetricaPreloadInfo preloadInfo = AppMetricaPreloadInfo(
        'tracking_456',
        additionalInfo: <String, String>{
          'source': 'partner_app',
          'campaign': 'preinstall_promo',
        },
      );

      final PreloadInfoPigeon pigeon = preloadInfo.toPigeon();

      expect(pigeon.trackingId, 'tracking_456');
      expect(pigeon.additionalInfo, <String, String>{
        'source': 'partner_app',
        'campaign': 'preinstall_promo',
      });
    });

    test('converts with empty additional info', () {
      const AppMetricaPreloadInfo preloadInfo = AppMetricaPreloadInfo(
        'tracking_789',
        additionalInfo: <String, String>{},
      );

      final PreloadInfoPigeon pigeon = preloadInfo.toPigeon();

      expect(pigeon.trackingId, 'tracking_789');
      expect(pigeon.additionalInfo, <String, String>{});
    });

    test('converts with single additional info entry', () {
      const AppMetricaPreloadInfo preloadInfo = AppMetricaPreloadInfo(
        'tracking_single',
        additionalInfo: <String, String>{'key': 'value'},
      );

      final PreloadInfoPigeon pigeon = preloadInfo.toPigeon();

      expect(pigeon.additionalInfo, <String, String>{'key': 'value'});
    });

    test('converts with many additional info entries', () {
      const AppMetricaPreloadInfo preloadInfo = AppMetricaPreloadInfo(
        'tracking_many',
        additionalInfo: <String, String>{
          'key1': 'value1',
          'key2': 'value2',
          'key3': 'value3',
          'key4': 'value4',
          'key5': 'value5',
        },
      );

      final PreloadInfoPigeon pigeon = preloadInfo.toPigeon();

      expect(pigeon.additionalInfo?.length, 5);
      expect(pigeon.additionalInfo?['key1'], 'value1');
      expect(pigeon.additionalInfo?['key5'], 'value5');
    });

    test('converts tracking id with special characters', () {
      const AppMetricaPreloadInfo preloadInfo = AppMetricaPreloadInfo('tracking-id_123.abc');

      final PreloadInfoPigeon pigeon = preloadInfo.toPigeon();

      expect(pigeon.trackingId, 'tracking-id_123.abc');
    });

    test('converts empty tracking id', () {
      const AppMetricaPreloadInfo preloadInfo = AppMetricaPreloadInfo('');

      final PreloadInfoPigeon pigeon = preloadInfo.toPigeon();

      expect(pigeon.trackingId, '');
    });

    test('converts additional info with empty string values', () {
      const AppMetricaPreloadInfo preloadInfo = AppMetricaPreloadInfo(
        'tracking',
        additionalInfo: <String, String>{
          'empty': '',
          'non_empty': 'value',
        },
      );

      final PreloadInfoPigeon pigeon = preloadInfo.toPigeon();

      expect(pigeon.additionalInfo?['empty'], '');
      expect(pigeon.additionalInfo?['non_empty'], 'value');
    });

    test('converts additional info with unicode values', () {
      const AppMetricaPreloadInfo preloadInfo = AppMetricaPreloadInfo(
        'tracking_unicode',
        additionalInfo: <String, String>{
          'cyrillic': 'Привет',
          'chinese': '你好',
          'emoji': '😀',
        },
      );

      final PreloadInfoPigeon pigeon = preloadInfo.toPigeon();

      expect(pigeon.additionalInfo?['cyrillic'], 'Привет');
      expect(pigeon.additionalInfo?['chinese'], '你好');
      expect(pigeon.additionalInfo?['emoji'], '😀');
    });
  });
}

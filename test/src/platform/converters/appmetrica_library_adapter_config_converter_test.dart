import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/appmetrica_library_adapter_config_converter.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppMetricaLibraryAdapterConfig.toPigeon', () {
    test('maps null / true / false advIdentifiersTracking', () {
      expect(
        const AppMetricaLibraryAdapterConfig().toPigeon().advIdentifiersTracking,
        isNull,
      );
      expect(
        const AppMetricaLibraryAdapterConfig(advIdentifiersTracking: true)
            .toPigeon()
            .advIdentifiersTracking,
        isTrue,
      );
      expect(
        const AppMetricaLibraryAdapterConfig(advIdentifiersTracking: false)
            .toPigeon()
            .advIdentifiersTracking,
        isFalse,
      );
    });

    test('returns AppMetricaLibraryAdapterConfigPigeon instance', () {
      expect(
        const AppMetricaLibraryAdapterConfig(advIdentifiersTracking: true).toPigeon(),
        isA<AppMetricaLibraryAdapterConfigPigeon>(),
      );
    });
  });
}

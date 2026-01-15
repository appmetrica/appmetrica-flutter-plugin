import 'package:appmetrica_plugin/src/internal/service_locator.dart';
import 'package:appmetrica_plugin/src/platform/platform_bridge.dart';
import 'package:appmetrica_plugin/src/platform/reporter_platform_bridge.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.mocks.dart';

void main() {
  tearDown(() {
    AppMetricaServiceLocator.reset();
  });

  group('AppMetricaServiceLocator.platformBridge', () {
    test('returns PigeonPlatformBridge by default', () {
      final bridge = AppMetricaServiceLocator.platformBridge;

      expect(bridge, isA<PigeonPlatformBridge>());
    });

    test('returns same instance on multiple calls', () {
      final bridge1 = AppMetricaServiceLocator.platformBridge;
      final bridge2 = AppMetricaServiceLocator.platformBridge;

      expect(identical(bridge1, bridge2), true);
    });
  });

  group('AppMetricaServiceLocator.reporterBridge', () {
    test('returns PigeonReporterBridge by default', () {
      final bridge = AppMetricaServiceLocator.reporterBridge;

      expect(bridge, isA<PigeonReporterBridge>());
    });

    test('returns same instance on multiple calls', () {
      final bridge1 = AppMetricaServiceLocator.reporterBridge;
      final bridge2 = AppMetricaServiceLocator.reporterBridge;

      expect(identical(bridge1, bridge2), true);
    });
  });

  group('AppMetricaServiceLocator.overridePlatformBridge', () {
    test('overrides platform bridge', () {
      final mockBridge = MockPlatformBridge();

      AppMetricaServiceLocator.overridePlatformBridge(mockBridge);

      expect(
        identical(AppMetricaServiceLocator.platformBridge, mockBridge),
        true,
      );
    });

    test('can override multiple times', () {
      final mockBridge1 = MockPlatformBridge();
      final mockBridge2 = MockPlatformBridge();

      AppMetricaServiceLocator.overridePlatformBridge(mockBridge1);
      expect(
        identical(AppMetricaServiceLocator.platformBridge, mockBridge1),
        true,
      );

      AppMetricaServiceLocator.overridePlatformBridge(mockBridge2);
      expect(
        identical(AppMetricaServiceLocator.platformBridge, mockBridge2),
        true,
      );
    });
  });

  group('AppMetricaServiceLocator.overrideReporterBridge', () {
    test('overrides reporter bridge', () {
      final mockBridge = MockReporterPlatformBridge();

      AppMetricaServiceLocator.overrideReporterBridge(mockBridge);

      expect(
        identical(AppMetricaServiceLocator.reporterBridge, mockBridge),
        true,
      );
    });

    test('can override multiple times', () {
      final mockBridge1 = MockReporterPlatformBridge();
      final mockBridge2 = MockReporterPlatformBridge();

      AppMetricaServiceLocator.overrideReporterBridge(mockBridge1);
      expect(
        identical(AppMetricaServiceLocator.reporterBridge, mockBridge1),
        true,
      );

      AppMetricaServiceLocator.overrideReporterBridge(mockBridge2);
      expect(
        identical(AppMetricaServiceLocator.reporterBridge, mockBridge2),
        true,
      );
    });
  });

  group('AppMetricaServiceLocator.reset', () {
    test('resets platform bridge to default', () {
      final mockBridge = MockPlatformBridge();
      AppMetricaServiceLocator.overridePlatformBridge(mockBridge);

      AppMetricaServiceLocator.reset();

      expect(
        AppMetricaServiceLocator.platformBridge,
        isA<PigeonPlatformBridge>(),
      );
      expect(
        identical(AppMetricaServiceLocator.platformBridge, mockBridge),
        false,
      );
    });

    test('resets reporter bridge to default', () {
      final mockBridge = MockReporterPlatformBridge();
      AppMetricaServiceLocator.overrideReporterBridge(mockBridge);

      AppMetricaServiceLocator.reset();

      expect(
        AppMetricaServiceLocator.reporterBridge,
        isA<PigeonReporterBridge>(),
      );
      expect(
        identical(AppMetricaServiceLocator.reporterBridge, mockBridge),
        false,
      );
    });

    test('resets both bridges at once', () {
      final mockPlatformBridge = MockPlatformBridge();
      final mockReporterBridge = MockReporterPlatformBridge();

      AppMetricaServiceLocator.overridePlatformBridge(mockPlatformBridge);
      AppMetricaServiceLocator.overrideReporterBridge(mockReporterBridge);

      AppMetricaServiceLocator.reset();

      expect(
        AppMetricaServiceLocator.platformBridge,
        isA<PigeonPlatformBridge>(),
      );
      expect(
        AppMetricaServiceLocator.reporterBridge,
        isA<PigeonReporterBridge>(),
      );
    });

    test('can be called multiple times safely', () {
      AppMetricaServiceLocator.reset();
      AppMetricaServiceLocator.reset();
      AppMetricaServiceLocator.reset();

      expect(
        AppMetricaServiceLocator.platformBridge,
        isA<PigeonPlatformBridge>(),
      );
    });
  });

  group('Isolation between bridges', () {
    test('overriding platform bridge does not affect reporter bridge', () {
      // Get default reporter bridge first
      final defaultReporterBridge = AppMetricaServiceLocator.reporterBridge;

      // Override platform bridge
      final mockPlatformBridge = MockPlatformBridge();
      AppMetricaServiceLocator.overridePlatformBridge(mockPlatformBridge);

      // Reporter bridge should still be the same
      expect(
        identical(
          AppMetricaServiceLocator.reporterBridge,
          defaultReporterBridge,
        ),
        true,
      );
    });

    test('overriding reporter bridge does not affect platform bridge', () {
      // Get default platform bridge first
      final defaultPlatformBridge = AppMetricaServiceLocator.platformBridge;

      // Override reporter bridge
      final mockReporterBridge = MockReporterPlatformBridge();
      AppMetricaServiceLocator.overrideReporterBridge(mockReporterBridge);

      // Platform bridge should still be the same
      expect(
        identical(
          AppMetricaServiceLocator.platformBridge,
          defaultPlatformBridge,
        ),
        true,
      );
    });
  });
}

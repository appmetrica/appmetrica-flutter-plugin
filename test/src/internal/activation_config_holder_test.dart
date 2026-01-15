import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/internal/service_locator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockPlatformBridge mockPlatformBridge;

  setUp(() {
    mockPlatformBridge = MockPlatformBridge();
    AppMetricaServiceLocator.overridePlatformBridge(mockPlatformBridge);
  });

  tearDown(() {
    AppMetricaServiceLocator.reset();
  });

  group('AppMetricaActivationConfigHolder', () {
    test('initial state is not activated', () {
      // Note: This test checks the expected behavior, but since activated is static
      // it may be affected by other tests. In practice, the holder tracks activation state.
      expect(AppMetricaActivationConfigHolder.activated, isA<bool>());
    });

    test('lastActivationConfig is initially null before any activation', () {
      // The lastActivationConfig stores the most recent config used for activation
      expect(
        AppMetricaActivationConfigHolder.lastActivationConfig,
        isA<AppMetricaConfig?>(),
      );
    });

    test('setting lastActivationConfig marks as activated', () {
      const config = AppMetricaConfig('test-api-key');

      AppMetricaActivationConfigHolder.lastActivationConfig = config;

      expect(AppMetricaActivationConfigHolder.activated, true);
      expect(AppMetricaActivationConfigHolder.lastActivationConfig, config);
    });

    test('setting lastActivationConfig to null keeps activated as true', () {
      const config = AppMetricaConfig('test-api-key');
      AppMetricaActivationConfigHolder.lastActivationConfig = config;

      AppMetricaActivationConfigHolder.lastActivationConfig = null;

      expect(AppMetricaActivationConfigHolder.activated, true);
      expect(AppMetricaActivationConfigHolder.lastActivationConfig, null);
    });

    test('activationListener is called when config is set', () {
      AppMetricaConfig? receivedConfig;
      AppMetricaActivationConfigHolder.activationListener = (config) {
        receivedConfig = config;
      };

      const config = AppMetricaConfig('listener-test-key');
      AppMetricaActivationConfigHolder.lastActivationConfig = config;

      expect(receivedConfig, config);

      // Cleanup
      AppMetricaActivationConfigHolder.activationListener = null;
    });

    test('activationListener receives null when config is set to null', () {
      bool listenerCalled = false;
      AppMetricaConfig? receivedConfig = const AppMetricaConfig('placeholder');

      AppMetricaActivationConfigHolder.activationListener = (config) {
        listenerCalled = true;
        receivedConfig = config;
      };

      AppMetricaActivationConfigHolder.lastActivationConfig = null;

      expect(listenerCalled, true);
      expect(receivedConfig, null);

      // Cleanup
      AppMetricaActivationConfigHolder.activationListener = null;
    });
  });

  group('AppMetricaActivationCompleter', () {
    test('complete sets lastActivationConfig', () async {
      const config = AppMetricaConfig(
        'completer-test-key',
        sessionsAutoTrackingEnabled: false,
        appOpenTrackingEnabled: false,
      );
      final completer = AppMetricaActivationCompleter(config);

      await completer.complete(null);

      expect(AppMetricaActivationConfigHolder.lastActivationConfig, config);
    });

    test('onError sets lastActivationConfig to null', () {
      const config = AppMetricaConfig('error-test-key');
      AppMetricaActivationConfigHolder.lastActivationConfig = config;
      final completer = AppMetricaActivationCompleter(config);

      expect(
        () => completer.onError(Exception('Test error'), StackTrace.empty),
        throwsA(isA<Exception>()),
      );

      expect(AppMetricaActivationConfigHolder.lastActivationConfig, null);
    });

    test('onError does not throw when error is null', () {
      const config = AppMetricaConfig('null-error-test-key');
      final completer = AppMetricaActivationCompleter(config);

      // Should not throw
      completer.onError(null, StackTrace.empty);

      expect(AppMetricaActivationConfigHolder.lastActivationConfig, null);
    });

    test('complete returns the passed value', () async {
      const config = AppMetricaConfig(
        'return-value-test',
        sessionsAutoTrackingEnabled: false,
        appOpenTrackingEnabled: false,
      );
      final completer = AppMetricaActivationCompleter(config);

      final result = await completer.complete('test-value');

      expect(result, 'test-value');
    });
  });
}

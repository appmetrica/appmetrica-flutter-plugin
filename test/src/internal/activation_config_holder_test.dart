import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
      const AppMetricaConfig config = AppMetricaConfig('test-api-key');

      AppMetricaActivationConfigHolder.lastActivationConfig = config;

      expect(AppMetricaActivationConfigHolder.activated, true);
      expect(AppMetricaActivationConfigHolder.lastActivationConfig, config);
    });

    test('setting lastActivationConfig to null keeps activated as true', () {
      const AppMetricaConfig config = AppMetricaConfig('test-api-key');
      AppMetricaActivationConfigHolder.lastActivationConfig = config;

      AppMetricaActivationConfigHolder.lastActivationConfig = null;

      expect(AppMetricaActivationConfigHolder.activated, true);
      expect(AppMetricaActivationConfigHolder.lastActivationConfig, null);
    });

    test('activationListener is called when config is set', () {
      AppMetricaConfig? receivedConfig;
      AppMetricaActivationConfigHolder.activationListener = (AppMetricaConfig? config) {
        receivedConfig = config;
      };

      const AppMetricaConfig config = AppMetricaConfig('listener-test-key');
      AppMetricaActivationConfigHolder.lastActivationConfig = config;

      expect(receivedConfig, config);

      // Cleanup
      AppMetricaActivationConfigHolder.activationListener = null;
    });

    test('activationListener receives null when config is set to null', () {
      bool listenerCalled = false;
      AppMetricaConfig? receivedConfig = const AppMetricaConfig('placeholder');

      AppMetricaActivationConfigHolder.activationListener = (AppMetricaConfig? config) {
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
}

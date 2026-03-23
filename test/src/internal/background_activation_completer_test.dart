import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/internal/background_activation_completer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppMetricaBackgroundActivationCompleter', () {
    test('complete sets lastActivationConfig', () async {
      const AppMetricaConfig config = AppMetricaConfig(
        'bg-completer-test-key',
        appOpenTrackingEnabled: false,
      );
      final AppMetricaBackgroundActivationCompleter completer =
          AppMetricaBackgroundActivationCompleter(config);

      await completer.complete(null);

      expect(AppMetricaActivationConfigHolder.lastActivationConfig, config);
    });

    test('complete returns the passed value', () async {
      const AppMetricaConfig config = AppMetricaConfig(
        'bg-return-value-test',
        appOpenTrackingEnabled: false,
      );
      final AppMetricaBackgroundActivationCompleter completer =
          AppMetricaBackgroundActivationCompleter(config);

      final String result = await completer.complete('bg-test-value');

      expect(result, 'bg-test-value');
    });

    test('onError sets lastActivationConfig to null and rethrows', () {
      const AppMetricaConfig config = AppMetricaConfig('bg-error-test-key');
      AppMetricaActivationConfigHolder.lastActivationConfig = config;
      final AppMetricaBackgroundActivationCompleter completer =
          AppMetricaBackgroundActivationCompleter(config);

      expect(
        () => completer.onError(Exception('Test error'), StackTrace.empty),
        throwsA(isA<Exception>()),
      );

      expect(AppMetricaActivationConfigHolder.lastActivationConfig, null);
    });

    test('onError does not throw when error is null', () {
      const AppMetricaConfig config = AppMetricaConfig('bg-null-error-test-key');
      final AppMetricaBackgroundActivationCompleter completer =
          AppMetricaBackgroundActivationCompleter(config);

      completer.onError(null, StackTrace.empty);

      expect(AppMetricaActivationConfigHolder.lastActivationConfig, null);
    });
  });
}

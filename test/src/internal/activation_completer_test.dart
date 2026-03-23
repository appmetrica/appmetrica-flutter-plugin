import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/internal/activation_completer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppMetricaActivationCompleter', () {
    test('complete sets lastActivationConfig', () async {
      const AppMetricaConfig config = AppMetricaConfig(
        'completer-test-key',
        sessionsAutoTrackingEnabled: false,
        appOpenTrackingEnabled: false,
      );
      final AppMetricaActivationCompleter completer = AppMetricaActivationCompleter(config);

      await completer.complete(null);

      expect(AppMetricaActivationConfigHolder.lastActivationConfig, config);
    });

    test('complete returns the passed value', () async {
      const AppMetricaConfig config = AppMetricaConfig(
        'return-value-test',
        sessionsAutoTrackingEnabled: false,
        appOpenTrackingEnabled: false,
      );
      final AppMetricaActivationCompleter completer = AppMetricaActivationCompleter(config);

      final String result = await completer.complete('test-value');

      expect(result, 'test-value');
    });

    test('onError sets lastActivationConfig to null and rethrows', () {
      const AppMetricaConfig config = AppMetricaConfig('error-test-key');
      AppMetricaActivationConfigHolder.lastActivationConfig = config;
      final AppMetricaActivationCompleter completer = AppMetricaActivationCompleter(config);

      expect(
        () => completer.onError(Exception('Test error'), StackTrace.empty),
        throwsA(isA<Exception>()),
      );

      expect(AppMetricaActivationConfigHolder.lastActivationConfig, null);
    });

    test('onError does not throw when error is null', () {
      const AppMetricaConfig config = AppMetricaConfig('null-error-test-key');
      final AppMetricaActivationCompleter completer = AppMetricaActivationCompleter(config);

      completer.onError(null, StackTrace.empty);

      expect(AppMetricaActivationConfigHolder.lastActivationConfig, null);
    });
  });
}

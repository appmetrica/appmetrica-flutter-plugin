import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/internal/activation_completer.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const String deeplinkChannel =
      'dev.flutter.pigeon.appmetrica_plugin.InitialDeepLinkHolderPigeon.getInitialDeeplink';
  const String reportAppOpenChannel =
      'dev.flutter.pigeon.appmetrica_plugin.AppMetricaPigeon.reportAppOpen';
  const MessageCodec<Object?> deeplinkCodec = InitialDeepLinkHolderPigeon.codec;
  const MessageCodec<Object?> appMetricaCodec = AppMetricaPigeon.codec;

  setUp(() {
    AppMetricaActivationConfigHolder.resetForTest();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(deeplinkChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(reportAppOpenChannel, null);
    AppMetricaActivationConfigHolder.resetForTest();
  });

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

    test('auto app-open reports non-null initial deeplink', () async {
      final Completer<Object?> reportedArgs = Completer<Object?>();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(deeplinkChannel, (ByteData? message) async {
        return deeplinkCodec.encodeMessage(<Object?>['app://open']);
      });
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(reportAppOpenChannel, (ByteData? message) async {
        if (!reportedArgs.isCompleted) {
          reportedArgs.complete(appMetricaCodec.decodeMessage(message));
        }
        return appMetricaCodec.encodeMessage(<Object?>[]);
      });

      const AppMetricaConfig config = AppMetricaConfig(
        'auto-open-key',
        sessionsAutoTrackingEnabled: false,
        appOpenTrackingEnabled: true,
        flutterCrashReporting: false,
      );
      await AppMetricaActivationCompleter(config).complete(null);

      final Object? args = await reportedArgs.future.timeout(const Duration(seconds: 2));
      expect(args, <Object?>['app://open']);
      expect(AppMetricaActivationConfigHolder.lastActivationConfig, config);
    });

    test('auto app-open is no-op when initial deeplink is null', () async {
      bool reportCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(deeplinkChannel, (ByteData? message) async {
        return deeplinkCodec.encodeMessage(<Object?>[null]);
      });
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(reportAppOpenChannel, (ByteData? message) async {
        reportCalled = true;
        return appMetricaCodec.encodeMessage(<Object?>[]);
      });

      const AppMetricaConfig config = AppMetricaConfig(
        'null-deeplink-key',
        sessionsAutoTrackingEnabled: false,
        appOpenTrackingEnabled: true,
        flutterCrashReporting: false,
      );
      await AppMetricaActivationCompleter(config).complete(null);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(reportCalled, isFalse);
    });

    test('auto app-open early-returns when tracking disabled or already activated', () async {
      bool deeplinkCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(deeplinkChannel, (ByteData? message) async {
        deeplinkCalled = true;
        return deeplinkCodec.encodeMessage(<Object?>['app://should-not']);
      });

      await AppMetricaActivationCompleter(
        const AppMetricaConfig(
          'disabled-open-key',
          sessionsAutoTrackingEnabled: false,
          appOpenTrackingEnabled: false,
          flutterCrashReporting: false,
        ),
      ).complete(null);
      await Future<void>.delayed(Duration.zero);
      expect(deeplinkCalled, isFalse);

      AppMetricaActivationConfigHolder.resetForTest();
      AppMetricaActivationConfigHolder.lastActivationConfig =
          const AppMetricaConfig('seed', flutterCrashReporting: false);
      expect(AppMetricaActivationConfigHolder.activated, isTrue);

      await AppMetricaActivationCompleter(
        const AppMetricaConfig(
          'already-activated-key',
          sessionsAutoTrackingEnabled: false,
          appOpenTrackingEnabled: true,
          flutterCrashReporting: false,
        ),
      ).complete(null);
      await Future<void>.delayed(Duration.zero);
      expect(deeplinkCalled, isFalse);
    });
  });
}

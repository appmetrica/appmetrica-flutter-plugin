import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/internal/reporter_impl.dart';
import 'package:appmetrica_plugin/src/internal/service_locator.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockReporterPlatformBridge mockReporterBridge;
  late ReporterImpl reporter;
  const apiKey = 'test-reporter-api-key';

  setUp(() {
    mockReporterBridge = MockReporterPlatformBridge();
    AppMetricaServiceLocator.overrideReporterBridge(mockReporterBridge);
    reporter = ReporterImpl(apiKey);
  });

  tearDown(() {
    AppMetricaServiceLocator.reset();
  });

  group('ReporterImpl.reportEvent', () {
    test('calls platform bridge with api key and event name', () async {
      when(mockReporterBridge.reportEvent(any, any))
          .thenAnswer((_) => Future.value());

      await reporter.reportEvent('test_event');

      verify(mockReporterBridge.reportEvent(apiKey, 'test_event')).called(1);
    });
  });

  group('ReporterImpl.reportEventWithJson', () {
    test('calls platform bridge with api key, event name and json', () async {
      when(mockReporterBridge.reportEventWithJson(any, any, any))
          .thenAnswer((_) => Future.value());

      await reporter.reportEventWithJson('test_event', '{"key": "value"}');

      verify(mockReporterBridge.reportEventWithJson(
              apiKey, 'test_event', '{"key": "value"}'))
          .called(1);
    });

    test('handles null json', () async {
      when(mockReporterBridge.reportEventWithJson(any, any, any))
          .thenAnswer((_) => Future.value());

      await reporter.reportEventWithJson('test_event', null);

      verify(mockReporterBridge.reportEventWithJson(apiKey, 'test_event', null))
          .called(1);
    });
  });

  group('ReporterImpl.reportEventWithMap', () {
    test('converts map to json and calls platform bridge', () async {
      when(mockReporterBridge.reportEventWithJson(any, any, any))
          .thenAnswer((_) => Future.value());

      await reporter.reportEventWithMap('test_event', {'key': 'value'});

      verify(mockReporterBridge.reportEventWithJson(
              apiKey, 'test_event', '{"key":"value"}'))
          .called(1);
    });

    test('handles null attributes', () async {
      when(mockReporterBridge.reportEventWithJson(any, any, any))
          .thenAnswer((_) => Future.value());

      await reporter.reportEventWithMap('test_event', null);

      verify(mockReporterBridge.reportEventWithJson(
              apiKey, 'test_event', 'null'))
          .called(1);
    });
  });

  group('ReporterImpl.reportError', () {
    test('calls platform bridge with error description', () async {
      when(mockReporterBridge.reportError(any, any, any))
          .thenAnswer((_) => Future.value());

      final error = AppMetricaErrorDescription(
        StackTrace.current,
        message: 'Test error',
        type: 'TestException',
      );

      await reporter.reportError(
          message: 'Error occurred', errorDescription: error);

      final captured =
          verify(mockReporterBridge.reportError(apiKey, captureAny, captureAny))
              .captured;
      expect(captured[0], isA<ErrorDetailsPigeon>());
      expect(captured[1], 'Error occurred');
    });

    test('adds current stack trace when error description is null', () async {
      when(mockReporterBridge.reportError(any, any, any))
          .thenAnswer((_) => Future.value());

      await reporter.reportError(message: 'Error occurred');

      final captured =
          verify(mockReporterBridge.reportError(apiKey, captureAny, captureAny))
              .captured;
      final errorDetails = captured[0] as ErrorDetailsPigeon;
      expect(errorDetails.backtrace, isNotEmpty);
    });
  });

  group('ReporterImpl.reportErrorWithGroup', () {
    test('calls platform bridge with group id', () async {
      when(mockReporterBridge.reportErrorWithGroup(any, any, any, any))
          .thenAnswer((_) => Future.value());

      await reporter.reportErrorWithGroup('error_group',
          message: 'Grouped error');

      verify(mockReporterBridge.reportErrorWithGroup(
              apiKey, 'error_group', any, 'Grouped error'))
          .called(1);
    });

    test('handles null error description', () async {
      when(mockReporterBridge.reportErrorWithGroup(any, any, any, any))
          .thenAnswer((_) => Future.value());

      await reporter.reportErrorWithGroup('error_group');

      verify(mockReporterBridge.reportErrorWithGroup(
              apiKey, 'error_group', null, null))
          .called(1);
    });
  });

  group('ReporterImpl.reportRevenue', () {
    test('calls platform bridge with converted revenue', () async {
      when(mockReporterBridge.reportRevenue(any, any))
          .thenAnswer((_) => Future.value());

      final revenue = AppMetricaRevenue(
        Decimal.parse('9.99'),
        'USD',
        productId: 'product_123',
        quantity: 1,
      );

      await reporter.reportRevenue(revenue);

      final captured =
          verify(mockReporterBridge.reportRevenue(apiKey, captureAny))
              .captured
              .single as RevenuePigeon;
      expect(captured.price, '9.99');
      expect(captured.currency, 'USD');
      expect(captured.productId, 'product_123');
      expect(captured.quantity, 1);
    });

    test('handles revenue with receipt', () async {
      when(mockReporterBridge.reportRevenue(any, any))
          .thenAnswer((_) => Future.value());

      final revenue = AppMetricaRevenue(
        Decimal.parse('4.99'),
        'EUR',
        receipt: AppMetricaReceipt(
          data: 'receipt_data',
          signature: 'signature',
        ),
      );

      await reporter.reportRevenue(revenue);

      final captured =
          verify(mockReporterBridge.reportRevenue(apiKey, captureAny))
              .captured
              .single as RevenuePigeon;
      expect(captured.receipt?.data, 'receipt_data');
      expect(captured.receipt?.signature, 'signature');
    });
  });

  group('ReporterImpl.reportAdRevenue', () {
    test('calls platform bridge with converted ad revenue', () async {
      when(mockReporterBridge.reportAdRevenue(any, any))
          .thenAnswer((_) => Future.value());

      final adRevenue = AppMetricaAdRevenue(
        adRevenue: Decimal.parse('0.05'),
        currency: 'USD',
        adType: AppMetricaAdType.interstitial,
        adNetwork: 'Unity',
        adUnitId: 'unit123',
      );

      await reporter.reportAdRevenue(adRevenue);

      final captured =
          verify(mockReporterBridge.reportAdRevenue(apiKey, captureAny))
              .captured
              .single as AdRevenuePigeon;
      expect(captured.adRevenue, '0.05');
      expect(captured.currency, 'USD');
      expect(captured.adType, AdTypePigeon.INTERSTITIAL);
      expect(captured.adNetwork, 'Unity');
      expect(captured.adUnitId, 'unit123');
    });
  });

  group('ReporterImpl.reportECommerce', () {
    test('calls platform bridge with ecommerce event', () async {
      when(mockReporterBridge.reportECommerce(any, any))
          .thenAnswer((_) => Future.value());

      const screen = AppMetricaECommerceScreen(name: 'TestScreen');
      final event = AppMetricaECommerce.showScreenEvent(screen);

      await reporter.reportECommerce(event);

      final captured =
          verify(mockReporterBridge.reportECommerce(apiKey, captureAny))
              .captured
              .single as ECommerceEventPigeon;
      expect(captured.eventType, 'show_screen_event');
    });
  });

  group('ReporterImpl.reportUserProfile', () {
    test('calls platform bridge with user profile', () async {
      when(mockReporterBridge.reportUserProfile(any, any))
          .thenAnswer((_) => Future.value());

      final profile = AppMetricaUserProfile([
        AppMetricaNameAttribute.withValue('Jane Doe'),
        AppMetricaBirthDateAttribute.withAge(25),
      ]);

      await reporter.reportUserProfile(profile);

      final captured =
          verify(mockReporterBridge.reportUserProfile(apiKey, captureAny))
              .captured
              .single as UserProfilePigeon;
      expect(captured.attributes.length, 2);
    });
  });

  group('ReporterImpl.reportUnhandledException', () {
    test('calls platform bridge with error details', () async {
      when(mockReporterBridge.reportUnhandledException(any, any))
          .thenAnswer((_) => Future.value());

      final error = AppMetricaErrorDescription(
        StackTrace.current,
        message: 'Fatal error',
        type: 'FatalException',
      );

      await reporter.reportUnhandledException(error);

      final captured = verify(
              mockReporterBridge.reportUnhandledException(apiKey, captureAny))
          .captured
          .single as ErrorDetailsPigeon;
      expect(captured.exceptionClass, 'FatalException');
      expect(captured.message, 'Fatal error');
    });
  });

  group('ReporterImpl.pauseSession', () {
    test('calls platform bridge with api key', () async {
      when(mockReporterBridge.pauseSession(any))
          .thenAnswer((_) => Future.value());

      await reporter.pauseSession();

      verify(mockReporterBridge.pauseSession(apiKey)).called(1);
    });
  });

  group('ReporterImpl.resumeSession', () {
    test('calls platform bridge with api key', () async {
      when(mockReporterBridge.resumeSession(any))
          .thenAnswer((_) => Future.value());

      await reporter.resumeSession();

      verify(mockReporterBridge.resumeSession(apiKey)).called(1);
    });
  });

  group('ReporterImpl.sendEventsBuffer', () {
    test('calls platform bridge with api key', () async {
      when(mockReporterBridge.sendEventsBuffer(any))
          .thenAnswer((_) => Future.value());

      await reporter.sendEventsBuffer();

      verify(mockReporterBridge.sendEventsBuffer(apiKey)).called(1);
    });
  });

  group('ReporterImpl.setDataSendingEnabled', () {
    test('calls platform bridge with api key and true', () async {
      when(mockReporterBridge.setDataSendingEnabled(any, any))
          .thenAnswer((_) => Future.value());

      await reporter.setDataSendingEnabled(true);

      verify(mockReporterBridge.setDataSendingEnabled(apiKey, true)).called(1);
    });

    test('calls platform bridge with api key and false', () async {
      when(mockReporterBridge.setDataSendingEnabled(any, any))
          .thenAnswer((_) => Future.value());

      await reporter.setDataSendingEnabled(false);

      verify(mockReporterBridge.setDataSendingEnabled(apiKey, false)).called(1);
    });
  });

  group('ReporterImpl.setUserProfileID', () {
    test('calls platform bridge with api key and profile id', () async {
      when(mockReporterBridge.setUserProfileID(any, any))
          .thenAnswer((_) => Future.value());

      await reporter.setUserProfileID('user456');

      verify(mockReporterBridge.setUserProfileID(apiKey, 'user456')).called(1);
    });

    test('calls platform bridge with api key and null', () async {
      when(mockReporterBridge.setUserProfileID(any, any))
          .thenAnswer((_) => Future.value());

      await reporter.setUserProfileID(null);

      verify(mockReporterBridge.setUserProfileID(apiKey, null)).called(1);
    });
  });

  group('ReporterImpl.clearAppEnvironment', () {
    test('calls platform bridge with api key', () async {
      when(mockReporterBridge.clearAppEnvironment(any))
          .thenAnswer((_) => Future.value());

      await reporter.clearAppEnvironment();

      verify(mockReporterBridge.clearAppEnvironment(apiKey)).called(1);
    });
  });

  group('ReporterImpl.putAppEnvironmentValue', () {
    test('calls platform bridge with api key, key and value', () async {
      when(mockReporterBridge.putAppEnvironmentValue(any, any, any))
          .thenAnswer((_) => Future.value());

      await reporter.putAppEnvironmentValue('env_key', 'env_value');

      verify(mockReporterBridge.putAppEnvironmentValue(
              apiKey, 'env_key', 'env_value'))
          .called(1);
    });

    test('calls platform bridge with null value', () async {
      when(mockReporterBridge.putAppEnvironmentValue(any, any, any))
          .thenAnswer((_) => Future.value());

      await reporter.putAppEnvironmentValue('env_key', null);

      verify(mockReporterBridge.putAppEnvironmentValue(apiKey, 'env_key', null))
          .called(1);
    });
  });
}

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/internal/service_locator.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockPlatformBridge mockPlatformBridge;

  setUp(() {
    mockPlatformBridge = MockPlatformBridge();
    AppMetricaServiceLocator.overridePlatformBridge(mockPlatformBridge);

    // Default stubs for common methods
    when(mockPlatformBridge.activate(any)).thenAnswer((_) => Future.value());
    when(mockPlatformBridge.handlePluginInitFinished())
        .thenAnswer((_) => Future.value());
  });

  tearDown(() {
    AppMetricaServiceLocator.reset();
  });

  group('AppMetrica.activate', () {
    test('calls platform bridge with converted config', () async {
      // Disable auto-tracking to avoid calling real Pigeon methods
      const config = AppMetricaConfig(
        'test-api-key',
        sessionsAutoTrackingEnabled: false,
        appOpenTrackingEnabled: false,
        flutterCrashReporting: false,
      );

      await AppMetrica.activate(config);

      final captured =
          verify(mockPlatformBridge.activate(captureAny)).captured.single
              as AppMetricaConfigPigeon;
      expect(captured.apiKey, 'test-api-key');
    });

    test('passes all config parameters to platform bridge', () async {
      const config = AppMetricaConfig(
        'test-api-key',
        appVersion: '1.0.0',
        crashReporting: true,
        dataSendingEnabled: true,
        locationTracking: false,
        logs: false,
        sessionTimeout: 30,
        userProfileID: 'user123',
        firstActivationAsUpdate: true,
        maxReportsInDatabaseCount: 500,
        sessionsAutoTrackingEnabled: false,
        appOpenTrackingEnabled: false,
        flutterCrashReporting: false,
      );

      await AppMetrica.activate(config);

      final captured =
          verify(mockPlatformBridge.activate(captureAny)).captured.single
              as AppMetricaConfigPigeon;
      expect(captured.apiKey, 'test-api-key');
      expect(captured.appVersion, '1.0.0');
      expect(captured.crashReporting, true);
      expect(captured.dataSendingEnabled, true);
      expect(captured.locationTracking, false);
      expect(captured.logs, false);
      expect(captured.sessionTimeout, 30);
      expect(captured.userProfileID, 'user123');
      expect(captured.firstActivationAsUpdate, true);
      expect(captured.maxReportsInDatabaseCount, 500);
    });
  });

  group('AppMetrica.activateReporter', () {
    test('calls platform bridge with converted reporter config', () async {
      when(mockPlatformBridge.activateReporter(any))
          .thenAnswer((_) => Future.value());

      const config = AppMetricaReporterConfig(
        'reporter-api-key',
        dataSendingEnabled: true,
        sessionTimeout: 20,
      );

      await AppMetrica.activateReporter(config);

      final captured =
          verify(mockPlatformBridge.activateReporter(captureAny)).captured.single
              as ReporterConfigPigeon;
      expect(captured.apiKey, 'reporter-api-key');
      expect(captured.dataSendingEnabled, true);
      expect(captured.sessionTimeout, 20);
    });
  });

  group('AppMetrica.reportEvent', () {
    test('calls platform bridge with event name', () async {
      when(mockPlatformBridge.reportEvent(any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.reportEvent('test_event');

      verify(mockPlatformBridge.reportEvent('test_event')).called(1);
    });
  });

  group('AppMetrica.reportEventWithJson', () {
    test('calls platform bridge with event name and json', () async {
      when(mockPlatformBridge.reportEventWithJson(any, any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.reportEventWithJson(
          'test_event', '{"key": "value"}');

      verify(mockPlatformBridge.reportEventWithJson(
              'test_event', '{"key": "value"}'))
          .called(1);
    });

    test('handles null json', () async {
      when(mockPlatformBridge.reportEventWithJson(any, any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.reportEventWithJson('test_event', null);

      verify(mockPlatformBridge.reportEventWithJson('test_event', null))
          .called(1);
    });
  });

  group('AppMetrica.reportEventWithMap', () {
    test('converts map to json and calls platform bridge', () async {
      when(mockPlatformBridge.reportEventWithJson(any, any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.reportEventWithMap(
          'test_event', {'key': 'value', 'number': 42});

      verify(mockPlatformBridge.reportEventWithJson(
              'test_event', '{"key":"value","number":42}'))
          .called(1);
    });

    test('handles null attributes', () async {
      when(mockPlatformBridge.reportEventWithJson(any, any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.reportEventWithMap('test_event', null);

      verify(mockPlatformBridge.reportEventWithJson('test_event', null))
          .called(1);
    });
  });

  group('AppMetrica.reportError', () {
    test('calls platform bridge with error description', () async {
      when(mockPlatformBridge.reportError(any, any))
          .thenAnswer((_) => Future.value());

      final error = AppMetricaErrorDescription(
        StackTrace.current,
        message: 'Test error',
        type: 'TestException',
      );

      await AppMetrica.reportError(
          message: 'Error occurred', errorDescription: error);

      final captured =
          verify(mockPlatformBridge.reportError(captureAny, captureAny))
              .captured;
      expect(captured[0], isA<ErrorDetailsPigeon>());
      expect(captured[1], 'Error occurred');
    });

    test('adds current stack trace when error description is null', () async {
      when(mockPlatformBridge.reportError(any, any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.reportError(message: 'Error occurred');

      final captured =
          verify(mockPlatformBridge.reportError(captureAny, captureAny))
              .captured;
      final errorDetails = captured[0] as ErrorDetailsPigeon;
      expect(errorDetails.backtrace, isNotEmpty);
    });
  });

  group('AppMetrica.reportErrorWithGroup', () {
    test('calls platform bridge with group id', () async {
      when(mockPlatformBridge.reportErrorWithGroup(any, any, any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.reportErrorWithGroup('error_group',
          message: 'Grouped error');

      verify(mockPlatformBridge.reportErrorWithGroup(
              'error_group', any, 'Grouped error'))
          .called(1);
    });
  });

  group('AppMetrica.reportRevenue', () {
    test('calls platform bridge with converted revenue', () async {
      when(mockPlatformBridge.reportRevenue(any))
          .thenAnswer((_) => Future.value());

      final revenue = AppMetricaRevenue(
        Decimal.parse('9.99'),
        'USD',
        productId: 'product_123',
        quantity: 1,
      );

      await AppMetrica.reportRevenue(revenue);

      final captured =
          verify(mockPlatformBridge.reportRevenue(captureAny)).captured.single
              as RevenuePigeon;
      expect(captured.price, '9.99');
      expect(captured.currency, 'USD');
      expect(captured.productId, 'product_123');
      expect(captured.quantity, 1);
    });
  });

  group('AppMetrica.reportAdRevenue', () {
    test('calls platform bridge with converted ad revenue', () async {
      when(mockPlatformBridge.reportAdRevenue(any))
          .thenAnswer((_) => Future.value());

      final adRevenue = AppMetricaAdRevenue(
        adRevenue: Decimal.parse('0.05'),
        currency: 'USD',
        adType: AppMetricaAdType.banner,
        adNetwork: 'AdMob',
      );

      await AppMetrica.reportAdRevenue(adRevenue);

      final captured =
          verify(mockPlatformBridge.reportAdRevenue(captureAny)).captured.single
              as AdRevenuePigeon;
      expect(captured.adRevenue, '0.05');
      expect(captured.currency, 'USD');
      expect(captured.adType, AdTypePigeon.BANNER);
      expect(captured.adNetwork, 'AdMob');
    });
  });

  group('AppMetrica.reportECommerce', () {
    test('calls platform bridge with ecommerce event', () async {
      when(mockPlatformBridge.reportECommerce(any))
          .thenAnswer((_) => Future.value());

      const screen = AppMetricaECommerceScreen(
        name: 'ProductScreen',
        searchQuery: 'shoes',
      );
      final event = AppMetricaECommerce.showScreenEvent(screen);

      await AppMetrica.reportECommerce(event);

      final captured =
          verify(mockPlatformBridge.reportECommerce(captureAny)).captured.single
              as ECommerceEventPigeon;
      expect(captured.eventType, 'show_screen_event');
    });
  });

  group('AppMetrica.reportUserProfile', () {
    test('calls platform bridge with user profile', () async {
      when(mockPlatformBridge.reportUserProfile(any))
          .thenAnswer((_) => Future.value());

      final profile = AppMetricaUserProfile([
        AppMetricaNameAttribute.withValue('John Doe'),
        AppMetricaGenderAttribute.withValue(AppMetricaGender.male),
      ]);

      await AppMetrica.reportUserProfile(profile);

      final captured =
          verify(mockPlatformBridge.reportUserProfile(captureAny))
              .captured
              .single as UserProfilePigeon;
      expect(captured.attributes.length, 2);
    });
  });

  group('AppMetrica.reportUnhandledException', () {
    test('calls platform bridge with error details', () async {
      when(mockPlatformBridge.reportUnhandledException(any))
          .thenAnswer((_) => Future.value());

      final error = AppMetricaErrorDescription(
        StackTrace.current,
        message: 'Unhandled exception',
        type: 'Exception',
      );

      await AppMetrica.reportUnhandledException(error);

      verify(mockPlatformBridge.reportUnhandledException(any)).called(1);
    });
  });

  group('AppMetrica.reportAppOpen', () {
    test('calls platform bridge with deeplink', () async {
      when(mockPlatformBridge.reportAppOpen(any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.reportAppOpen('myapp://path/to/content');

      verify(mockPlatformBridge.reportAppOpen('myapp://path/to/content'))
          .called(1);
    });
  });

  group('AppMetrica.reportReferralUrl', () {
    test('calls platform bridge with referral url', () async {
      when(mockPlatformBridge.reportReferralUrl(any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.reportReferralUrl('https://example.com/referral');

      verify(mockPlatformBridge.reportReferralUrl('https://example.com/referral'))
          .called(1);
    });
  });

  group('AppMetrica.requestDeferredDeeplink', () {
    test('returns deeplink on success', () async {
      when(mockPlatformBridge.requestDeferredDeeplink()).thenAnswer(
        (_) => Future.value(AppMetricaDeferredDeeplinkPigeon(
          deeplink: 'myapp://deeplink',
        )),
      );

      final result = await AppMetrica.requestDeferredDeeplink();

      expect(result, 'myapp://deeplink');
    });

    test('throws exception on error', () async {
      when(mockPlatformBridge.requestDeferredDeeplink()).thenAnswer(
        (_) => Future.value(AppMetricaDeferredDeeplinkPigeon(
          error: AppMetricaDeferredDeeplinkErrorPigeon(
            reason: AppMetricaDeferredDeeplinkReasonPigeon.NOT_A_FIRST_LAUNCH,
            description: 'Not first launch',
            message: 'Error message',
          ),
        )),
      );

      expect(
        () => AppMetrica.requestDeferredDeeplink(),
        throwsA(isA<AppMetricaDeferredDeeplinkRequestException>()),
      );
    });

    test('throws exception when deeplink is null', () async {
      when(mockPlatformBridge.requestDeferredDeeplink()).thenAnswer(
        (_) => Future.value(AppMetricaDeferredDeeplinkPigeon()),
      );

      expect(
        () => AppMetrica.requestDeferredDeeplink(),
        throwsA(isA<AppMetricaDeferredDeeplinkRequestException>()),
      );
    });
  });

  group('AppMetrica.requestDeferredDeeplinkParameters', () {
    test('returns parameters on success', () async {
      when(mockPlatformBridge.requestDeferredDeeplinkParameters()).thenAnswer(
        (_) => Future.value(AppMetricaDeferredDeeplinkParametersPigeon(
          parameters: {'key': 'value', 'foo': 'bar'},
        )),
      );

      final result = await AppMetrica.requestDeferredDeeplinkParameters();

      expect(result, {'key': 'value', 'foo': 'bar'});
    });

    test('throws exception on error', () async {
      when(mockPlatformBridge.requestDeferredDeeplinkParameters()).thenAnswer(
        (_) => Future.value(AppMetricaDeferredDeeplinkParametersPigeon(
          error: AppMetricaDeferredDeeplinkErrorPigeon(
            reason: AppMetricaDeferredDeeplinkReasonPigeon.NO_REFERRER,
            description: 'No referrer',
            message: 'Error',
          ),
        )),
      );

      expect(
        () => AppMetrica.requestDeferredDeeplinkParameters(),
        throwsA(isA<AppMetricaDeferredDeeplinkRequestException>()),
      );
    });
  });

  group('AppMetrica.requestStartupParams', () {
    test('returns converted startup params', () async {
      when(mockPlatformBridge.requestStartupParams(any)).thenAnswer(
        (_) => Future.value(StartupParamsPigeon(
          result: StartupParamsResultPigeon(
            deviceId: 'device123',
            uuid: 'uuid456',
          ),
        )),
      );

      final result = await AppMetrica.requestStartupParams(null);

      expect(result.result?.deviceId, 'device123');
      expect(result.result?.uuid, 'uuid456');
    });
  });

  group('AppMetrica.setLocation', () {
    test('calls platform bridge with location', () async {
      when(mockPlatformBridge.setLocation(any))
          .thenAnswer((_) => Future.value());

      const location = AppMetricaLocation(55.751244, 37.618423);

      await AppMetrica.setLocation(location);

      final captured =
          verify(mockPlatformBridge.setLocation(captureAny)).captured.single
              as LocationPigeon;
      expect(captured.latitude, 55.751244);
      expect(captured.longitude, 37.618423);
    });

    test('calls platform bridge with null location', () async {
      when(mockPlatformBridge.setLocation(any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.setLocation(null);

      verify(mockPlatformBridge.setLocation(null)).called(1);
    });
  });

  group('AppMetrica.setLocationTracking', () {
    test('calls platform bridge with true', () async {
      when(mockPlatformBridge.setLocationTracking(any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.setLocationTracking(true);

      verify(mockPlatformBridge.setLocationTracking(true)).called(1);
    });

    test('calls platform bridge with false', () async {
      when(mockPlatformBridge.setLocationTracking(any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.setLocationTracking(false);

      verify(mockPlatformBridge.setLocationTracking(false)).called(1);
    });
  });

  group('AppMetrica.setDataSendingEnabled', () {
    test('calls platform bridge with true', () async {
      when(mockPlatformBridge.setDataSendingEnabled(any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.setDataSendingEnabled(true);

      verify(mockPlatformBridge.setDataSendingEnabled(true)).called(1);
    });

    test('calls platform bridge with false', () async {
      when(mockPlatformBridge.setDataSendingEnabled(any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.setDataSendingEnabled(false);

      verify(mockPlatformBridge.setDataSendingEnabled(false)).called(1);
    });
  });

  group('AppMetrica.setUserProfileID', () {
    test('calls platform bridge with profile id', () async {
      when(mockPlatformBridge.setUserProfileID(any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.setUserProfileID('user123');

      verify(mockPlatformBridge.setUserProfileID('user123')).called(1);
    });

    test('calls platform bridge with null', () async {
      when(mockPlatformBridge.setUserProfileID(any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.setUserProfileID(null);

      verify(mockPlatformBridge.setUserProfileID(null)).called(1);
    });
  });

  group('AppMetrica.setAdvIdentifiersTracking', () {
    test('calls platform bridge', () async {
      when(mockPlatformBridge.setAdvIdentifiersTracking(any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.setAdvIdentifiersTracking(true);

      verify(mockPlatformBridge.setAdvIdentifiersTracking(true)).called(1);
    });
  });

  group('AppMetrica.pauseSession', () {
    test('calls platform bridge', () async {
      when(mockPlatformBridge.pauseSession())
          .thenAnswer((_) => Future.value());

      await AppMetrica.pauseSession();

      verify(mockPlatformBridge.pauseSession()).called(1);
    });
  });

  group('AppMetrica.resumeSession', () {
    test('calls platform bridge', () async {
      when(mockPlatformBridge.resumeSession())
          .thenAnswer((_) => Future.value());

      await AppMetrica.resumeSession();

      verify(mockPlatformBridge.resumeSession()).called(1);
    });
  });

  group('AppMetrica.sendEventsBuffer', () {
    test('calls platform bridge', () async {
      when(mockPlatformBridge.sendEventsBuffer())
          .thenAnswer((_) => Future.value());

      await AppMetrica.sendEventsBuffer();

      verify(mockPlatformBridge.sendEventsBuffer()).called(1);
    });
  });

  group('AppMetrica.clearAppEnvironment', () {
    test('calls platform bridge', () async {
      when(mockPlatformBridge.clearAppEnvironment())
          .thenAnswer((_) => Future.value());

      await AppMetrica.clearAppEnvironment();

      verify(mockPlatformBridge.clearAppEnvironment()).called(1);
    });
  });

  group('AppMetrica.putAppEnvironmentValue', () {
    test('calls platform bridge with key and value', () async {
      when(mockPlatformBridge.putAppEnvironmentValue(any, any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.putAppEnvironmentValue('env_key', 'env_value');

      verify(mockPlatformBridge.putAppEnvironmentValue('env_key', 'env_value'))
          .called(1);
    });

    test('calls platform bridge with null value', () async {
      when(mockPlatformBridge.putAppEnvironmentValue(any, any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.putAppEnvironmentValue('env_key', null);

      verify(mockPlatformBridge.putAppEnvironmentValue('env_key', null))
          .called(1);
    });
  });

  group('AppMetrica.putErrorEnvironmentValue', () {
    test('calls platform bridge with key and value', () async {
      when(mockPlatformBridge.putErrorEnvironmentValue(any, any))
          .thenAnswer((_) => Future.value());

      await AppMetrica.putErrorEnvironmentValue('error_key', 'error_value');

      verify(mockPlatformBridge.putErrorEnvironmentValue(
              'error_key', 'error_value'))
          .called(1);
    });
  });

  group('AppMetrica.reportExternalAttribution', () {
    test('calls platform bridge with adjust attribution', () async {
      when(mockPlatformBridge.reportExternalAttribution(any))
          .thenAnswer((_) => Future.value());

      final attribution = AppMetricaExternalAttribution.adjust(
        trackerToken: 'token123',
        network: 'facebook',
      );

      await AppMetrica.reportExternalAttribution(attribution);

      final captured = verify(
              mockPlatformBridge.reportExternalAttribution(captureAny))
          .captured
          .single as ExternalAttributionPigeon;
      expect(captured.source, 'adjust');
    });
  });

  group('AppMetrica.deviceId', () {
    test('returns device id from platform bridge', () async {
      when(mockPlatformBridge.getDeviceId())
          .thenAnswer((_) => Future.value('device123'));

      final result = await AppMetrica.deviceId;

      expect(result, 'device123');
    });

    test('returns null when device id is not available', () async {
      when(mockPlatformBridge.getDeviceId())
          .thenAnswer((_) => Future.value(null));

      final result = await AppMetrica.deviceId;

      expect(result, null);
    });
  });

  group('AppMetrica.uuid', () {
    test('returns uuid from platform bridge', () async {
      when(mockPlatformBridge.getUuid())
          .thenAnswer((_) => Future.value('uuid123'));

      final result = await AppMetrica.uuid;

      expect(result, 'uuid123');
    });
  });

  group('AppMetrica.libraryVersion', () {
    test('returns library version from platform bridge', () async {
      when(mockPlatformBridge.getLibraryVersion())
          .thenAnswer((_) => Future.value('5.0.0'));

      final result = await AppMetrica.libraryVersion;

      expect(result, '5.0.0');
    });
  });

  group('AppMetrica.libraryApiLevel', () {
    test('returns api level from platform bridge', () async {
      when(mockPlatformBridge.getLibraryApiLevel())
          .thenAnswer((_) => Future.value(100));

      final result = await AppMetrica.libraryApiLevel;

      expect(result, 100);
    });
  });

  group('AppMetrica.enableActivityAutoTracking', () {
    test('calls platform bridge', () async {
      when(mockPlatformBridge.enableActivityAutoTracking())
          .thenAnswer((_) => Future.value());

      await AppMetrica.enableActivityAutoTracking();

      verify(mockPlatformBridge.enableActivityAutoTracking()).called(1);
    });
  });

  group('AppMetrica.getReporter', () {
    test('returns reporter and touches it on platform bridge', () async {
      when(mockPlatformBridge.touchReporter(any))
          .thenAnswer((_) => Future.value());

      final reporter = AppMetrica.getReporter('reporter-key');

      expect(reporter, isNotNull);
      verify(mockPlatformBridge.touchReporter('reporter-key')).called(1);
    });

    test('returns same reporter for same api key', () async {
      when(mockPlatformBridge.touchReporter(any))
          .thenAnswer((_) => Future.value());

      final reporter1 = AppMetrica.getReporter('reporter-key');
      final reporter2 = AppMetrica.getReporter('reporter-key');

      expect(identical(reporter1, reporter2), true);
    });

    test('returns different reporters for different api keys', () async {
      when(mockPlatformBridge.touchReporter(any))
          .thenAnswer((_) => Future.value());

      final reporter1 = AppMetrica.getReporter('reporter-key-1');
      final reporter2 = AppMetrica.getReporter('reporter-key-2');

      expect(identical(reporter1, reporter2), false);
    });
  });
}

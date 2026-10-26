import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:appmetrica_plugin/src/platform/platform_bridge.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAppMetricaPigeon mockPigeon;
  late PigeonPlatformBridge bridge;

  setUp(() {
    mockPigeon = MockAppMetricaPigeon();
    bridge = PigeonPlatformBridge(mockPigeon);
  });

  test('PigeonPlatformBridge delegates every method to AppMetricaPigeon', () async {
    final AppMetricaConfigPigeon config = AppMetricaConfigPigeon(apiKey: 'api-key');
    final ReporterConfigPigeon reporterConfig = ReporterConfigPigeon(apiKey: 'reporter-key');
    final ErrorDetailsPigeon error = ErrorDetailsPigeon(
      exceptionClass: 'Exception',
      dartVersion: '3.0.0',
      message: 'boom',
    );
    final RevenuePigeon revenue = RevenuePigeon(price: '1.0', currency: 'USD');
    final AdRevenuePigeon adRevenue =
        AdRevenuePigeon(adRevenue: '0.5', currency: 'USD');
    final ECommerceEventPigeon ecommerce =
        ECommerceEventPigeon(eventType: 'show_screen_event');
    final UserProfilePigeon profile =
        UserProfilePigeon(attributes: <UserProfileAttributePigeon?>[]);
    final LocationPigeon location =
        LocationPigeon(latitude: 1.0, longitude: 2.0);
    final ExternalAttributionPigeon attribution =
        ExternalAttributionPigeon(source: 'appsflyer', data: <String?, Object?>{});
    final AppMetricaDeferredDeeplinkPigeon deeplink =
        AppMetricaDeferredDeeplinkPigeon(deeplink: 'app://open');
    final AppMetricaDeferredDeeplinkParametersPigeon deeplinkParams =
        AppMetricaDeferredDeeplinkParametersPigeon(
            parameters: <String?, String?>{'a': 'b'});
    final StartupParamsPigeon startup =
        StartupParamsPigeon(result: StartupParamsResultPigeon());
    const List<String?> startupKeys = <String?>['uuid', 'device_id'];

    when(mockPigeon.activate(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.activateReporter(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.handlePluginInitFinished()).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.getDeviceId()).thenAnswer((_) => Future<String?>.value('device'));
    when(mockPigeon.getUuid()).thenAnswer((_) => Future<String?>.value('uuid'));
    when(mockPigeon.getLibraryApiLevel()).thenAnswer((_) => Future<int>.value(42));
    when(mockPigeon.getLibraryVersion()).thenAnswer((_) => Future<String>.value('1.0.0'));
    when(mockPigeon.reportEvent(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportEventWithJson(any, any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportAppOpen(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportError(any, any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportErrorWithGroup(any, any, any))
        .thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportUnhandledException(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportRevenue(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportAdRevenue(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportECommerce(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportUserProfile(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.setUserProfileID(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.putAppEnvironmentValue(any, any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.clearAppEnvironment()).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.putErrorEnvironmentValue(any, any))
        .thenAnswer((_) => Future<void>.value());
    when(mockPigeon.pauseSession()).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.resumeSession()).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.setDataSendingEnabled(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.setLocation(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.setLocationTracking(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.setAdvIdentifiersTracking(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.enableActivityAutoTracking()).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.requestDeferredDeeplink())
        .thenAnswer((_) => Future<AppMetricaDeferredDeeplinkPigeon>.value(deeplink));
    when(mockPigeon.requestDeferredDeeplinkParameters()).thenAnswer(
        (_) => Future<AppMetricaDeferredDeeplinkParametersPigeon>.value(deeplinkParams));
    when(mockPigeon.requestStartupParams(any))
        .thenAnswer((_) => Future<StartupParamsPigeon>.value(startup));
    when(mockPigeon.sendEventsBuffer()).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.touchReporter(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportExternalAttribution(any)).thenAnswer((_) => Future<void>.value());

    await bridge.activate(config);
    await bridge.activateReporter(reporterConfig);
    await bridge.handlePluginInitFinished();
    expect(await bridge.getDeviceId(), 'device');
    expect(await bridge.getUuid(), 'uuid');
    expect(await bridge.getLibraryApiLevel(), 42);
    expect(await bridge.getLibraryVersion(), '1.0.0');
    await bridge.reportEvent('event');
    await bridge.reportEventWithJson('event', '{"a":1}');
    await bridge.reportAppOpen('deeplink');
    await bridge.reportError(error, 'msg');
    await bridge.reportErrorWithGroup('group', error, 'msg');
    await bridge.reportUnhandledException(error);
    await bridge.reportRevenue(revenue);
    await bridge.reportAdRevenue(adRevenue);
    await bridge.reportECommerce(ecommerce);
    await bridge.reportUserProfile(profile);
    await bridge.setUserProfileID('profile');
    await bridge.putAppEnvironmentValue('k', 'v');
    await bridge.clearAppEnvironment();
    await bridge.putErrorEnvironmentValue('ek', 'ev');
    await bridge.pauseSession();
    await bridge.resumeSession();
    await bridge.setDataSendingEnabled(true);
    await bridge.setLocation(location);
    await bridge.setLocationTracking(false);
    await bridge.setAdvIdentifiersTracking(true);
    await bridge.enableActivityAutoTracking();
    expect(await bridge.requestDeferredDeeplink(), same(deeplink));
    expect(await bridge.requestDeferredDeeplinkParameters(), same(deeplinkParams));
    expect(await bridge.requestStartupParams(startupKeys), same(startup));
    await bridge.sendEventsBuffer();
    await bridge.touchReporter('api-key');
    await bridge.reportExternalAttribution(attribution);

    verify(mockPigeon.activate(config)).called(1);
    verify(mockPigeon.activateReporter(reporterConfig)).called(1);
    verify(mockPigeon.handlePluginInitFinished()).called(1);
    verify(mockPigeon.getDeviceId()).called(1);
    verify(mockPigeon.getUuid()).called(1);
    verify(mockPigeon.getLibraryApiLevel()).called(1);
    verify(mockPigeon.getLibraryVersion()).called(1);
    verify(mockPigeon.reportEvent('event')).called(1);
    verify(mockPigeon.reportEventWithJson('event', '{"a":1}')).called(1);
    verify(mockPigeon.reportAppOpen('deeplink')).called(1);
    verify(mockPigeon.reportError(error, 'msg')).called(1);
    verify(mockPigeon.reportErrorWithGroup('group', error, 'msg')).called(1);
    verify(mockPigeon.reportUnhandledException(error)).called(1);
    verify(mockPigeon.reportRevenue(revenue)).called(1);
    verify(mockPigeon.reportAdRevenue(adRevenue)).called(1);
    verify(mockPigeon.reportECommerce(ecommerce)).called(1);
    verify(mockPigeon.reportUserProfile(profile)).called(1);
    verify(mockPigeon.setUserProfileID('profile')).called(1);
    verify(mockPigeon.putAppEnvironmentValue('k', 'v')).called(1);
    verify(mockPigeon.clearAppEnvironment()).called(1);
    verify(mockPigeon.putErrorEnvironmentValue('ek', 'ev')).called(1);
    verify(mockPigeon.pauseSession()).called(1);
    verify(mockPigeon.resumeSession()).called(1);
    verify(mockPigeon.setDataSendingEnabled(true)).called(1);
    verify(mockPigeon.setLocation(location)).called(1);
    verify(mockPigeon.setLocationTracking(false)).called(1);
    verify(mockPigeon.setAdvIdentifiersTracking(true)).called(1);
    verify(mockPigeon.enableActivityAutoTracking()).called(1);
    verify(mockPigeon.requestDeferredDeeplink()).called(1);
    verify(mockPigeon.requestDeferredDeeplinkParameters()).called(1);
    verify(mockPigeon.requestStartupParams(startupKeys)).called(1);
    verify(mockPigeon.sendEventsBuffer()).called(1);
    verify(mockPigeon.touchReporter('api-key')).called(1);
    verify(mockPigeon.reportExternalAttribution(attribution)).called(1);
    verifyNoMoreInteractions(mockPigeon);
  });
}

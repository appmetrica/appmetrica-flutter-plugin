import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:appmetrica_plugin/src/platform/reporter_platform_bridge.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockReporterPigeon mockPigeon;
  late PigeonReporterBridge bridge;

  setUp(() {
    mockPigeon = MockReporterPigeon();
    bridge = PigeonReporterBridge(mockPigeon);
  });

  test('PigeonReporterBridge delegates every method to ReporterPigeon', () async {
    const String apiKey = 'reporter-api-key';
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

    when(mockPigeon.clearAppEnvironment(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.pauseSession(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.putAppEnvironmentValue(any, any, any))
        .thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportAdRevenue(any, any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportECommerce(any, any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportError(any, any, any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportErrorWithGroup(any, any, any, any))
        .thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportEvent(any, any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportEventWithJson(any, any, any))
        .thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportRevenue(any, any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportUnhandledException(any, any))
        .thenAnswer((_) => Future<void>.value());
    when(mockPigeon.reportUserProfile(any, any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.resumeSession(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.sendEventsBuffer(any)).thenAnswer((_) => Future<void>.value());
    when(mockPigeon.setDataSendingEnabled(any, any))
        .thenAnswer((_) => Future<void>.value());
    when(mockPigeon.setUserProfileID(any, any)).thenAnswer((_) => Future<void>.value());

    await bridge.clearAppEnvironment(apiKey);
    await bridge.pauseSession(apiKey);
    await bridge.putAppEnvironmentValue(apiKey, 'k', 'v');
    await bridge.reportAdRevenue(apiKey, adRevenue);
    await bridge.reportECommerce(apiKey, ecommerce);
    await bridge.reportError(apiKey, error, 'msg');
    await bridge.reportErrorWithGroup(apiKey, 'group', error, 'msg');
    await bridge.reportEvent(apiKey, 'event');
    await bridge.reportEventWithJson(apiKey, 'event', '{"a":1}');
    await bridge.reportRevenue(apiKey, revenue);
    await bridge.reportUnhandledException(apiKey, error);
    await bridge.reportUserProfile(apiKey, profile);
    await bridge.resumeSession(apiKey);
    await bridge.sendEventsBuffer(apiKey);
    await bridge.setDataSendingEnabled(apiKey, true);
    await bridge.setUserProfileID(apiKey, 'profile');

    verify(mockPigeon.clearAppEnvironment(apiKey)).called(1);
    verify(mockPigeon.pauseSession(apiKey)).called(1);
    verify(mockPigeon.putAppEnvironmentValue(apiKey, 'k', 'v')).called(1);
    verify(mockPigeon.reportAdRevenue(apiKey, adRevenue)).called(1);
    verify(mockPigeon.reportECommerce(apiKey, ecommerce)).called(1);
    verify(mockPigeon.reportError(apiKey, error, 'msg')).called(1);
    verify(mockPigeon.reportErrorWithGroup(apiKey, 'group', error, 'msg')).called(1);
    verify(mockPigeon.reportEvent(apiKey, 'event')).called(1);
    verify(mockPigeon.reportEventWithJson(apiKey, 'event', '{"a":1}')).called(1);
    verify(mockPigeon.reportRevenue(apiKey, revenue)).called(1);
    verify(mockPigeon.reportUnhandledException(apiKey, error)).called(1);
    verify(mockPigeon.reportUserProfile(apiKey, profile)).called(1);
    verify(mockPigeon.resumeSession(apiKey)).called(1);
    verify(mockPigeon.sendEventsBuffer(apiKey)).called(1);
    verify(mockPigeon.setDataSendingEnabled(apiKey, true)).called(1);
    verify(mockPigeon.setUserProfileID(apiKey, 'profile')).called(1);
    verifyNoMoreInteractions(mockPigeon);
  });
}

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/appmetrica_config_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppMetricaConfigConverter', () {
    test('converts only api key', () {
      const config = AppMetricaConfig('test-api-key');

      final pigeon = config.toPigeon();

      expect(pigeon.apiKey, 'test-api-key');
      expect(pigeon.advIdentifiersTracking, null);
      expect(pigeon.anrMonitoring, null);
      expect(pigeon.appVersion, null);
      expect(pigeon.crashReporting, null);
      expect(pigeon.dataSendingEnabled, null);
      expect(pigeon.location, null);
      expect(pigeon.locationTracking, null);
      expect(pigeon.logs, null);
      expect(pigeon.preloadInfo, null);
      expect(pigeon.sessionTimeout, null);
      expect(pigeon.userProfileID, null);
    });

    test('converts all fields', () {
      const config = AppMetricaConfig(
        'full-api-key',
        advIdentifiersTracking: true,
        anrMonitoring: true,
        anrMonitoringTimeout: 5,
        appBuildNumber: 123,
        appEnvironment: {'env_key': 'env_value'},
        appOpenTrackingEnabled: true,
        appVersion: '2.0.0',
        crashReporting: true,
        customHosts: ['host1.example.com', 'host2.example.com'],
        dataSendingEnabled: true,
        deviceType: 'phone',
        dispatchPeriodSeconds: 60,
        errorEnvironment: {'error_key': 'error_value'},
        firstActivationAsUpdate: true,
        location: AppMetricaLocation(55.751244, 37.618423),
        locationTracking: true,
        logs: true,
        maxReportsCount: 100,
        maxReportsInDatabaseCount: 5000,
        nativeCrashReporting: true,
        preloadInfo: AppMetricaPreloadInfo('tracking_id_123'),
        revenueAutoTrackingEnabled: true,
        sessionTimeout: 30,
        sessionsAutoTrackingEnabled: true,
        userProfileID: 'user_123',
      );

      final pigeon = config.toPigeon();

      expect(pigeon.apiKey, 'full-api-key');
      expect(pigeon.advIdentifiersTracking, true);
      expect(pigeon.anrMonitoring, true);
      expect(pigeon.anrMonitoringTimeout, 5);
      expect(pigeon.appBuildNumber, 123);
      expect(pigeon.appEnvironment, {'env_key': 'env_value'});
      expect(pigeon.appOpenTrackingEnabled, true);
      expect(pigeon.appVersion, '2.0.0');
      expect(pigeon.crashReporting, true);
      expect(pigeon.customHosts, ['host1.example.com', 'host2.example.com']);
      expect(pigeon.dataSendingEnabled, true);
      expect(pigeon.deviceType, 'phone');
      expect(pigeon.dispatchPeriodSeconds, 60);
      expect(pigeon.errorEnvironment, {'error_key': 'error_value'});
      expect(pigeon.firstActivationAsUpdate, true);
      expect(pigeon.location?.latitude, 55.751244);
      expect(pigeon.location?.longitude, 37.618423);
      expect(pigeon.locationTracking, true);
      expect(pigeon.logs, true);
      expect(pigeon.maxReportsCount, 100);
      expect(pigeon.maxReportsInDatabaseCount, 5000);
      expect(pigeon.nativeCrashReporting, true);
      expect(pigeon.preloadInfo?.trackingId, 'tracking_id_123');
      expect(pigeon.revenueAutoTrackingEnabled, true);
      expect(pigeon.sessionTimeout, 30);
      expect(pigeon.sessionsAutoTrackingEnabled, true);
      expect(pigeon.userProfileID, 'user_123');
    });

    test('converts false boolean values', () {
      const config = AppMetricaConfig(
        'test-api-key',
        advIdentifiersTracking: false,
        anrMonitoring: false,
        appOpenTrackingEnabled: false,
        crashReporting: false,
        dataSendingEnabled: false,
        firstActivationAsUpdate: false,
        locationTracking: false,
        logs: false,
        nativeCrashReporting: false,
        revenueAutoTrackingEnabled: false,
        sessionsAutoTrackingEnabled: false,
      );

      final pigeon = config.toPigeon();

      expect(pigeon.advIdentifiersTracking, false);
      expect(pigeon.anrMonitoring, false);
      expect(pigeon.appOpenTrackingEnabled, false);
      expect(pigeon.crashReporting, false);
      expect(pigeon.dataSendingEnabled, false);
      expect(pigeon.firstActivationAsUpdate, false);
      expect(pigeon.locationTracking, false);
      expect(pigeon.logs, false);
      expect(pigeon.nativeCrashReporting, false);
      expect(pigeon.revenueAutoTrackingEnabled, false);
      expect(pigeon.sessionsAutoTrackingEnabled, false);
    });

    test('converts location with all fields', () {
      const config = AppMetricaConfig(
        'test-api-key',
        location: AppMetricaLocation(
          55.751244,
          37.618423,
          provider: 'gps',
          altitude: 150.5,
          accuracy: 10.0,
          course: 45.0,
          speed: 5.0,
          timestamp: 1234567890,
        ),
      );

      final pigeon = config.toPigeon();

      expect(pigeon.location?.latitude, 55.751244);
      expect(pigeon.location?.longitude, 37.618423);
      expect(pigeon.location?.provider, 'gps');
      expect(pigeon.location?.altitude, 150.5);
      expect(pigeon.location?.accuracy, 10.0);
      expect(pigeon.location?.course, 45.0);
      expect(pigeon.location?.speed, 5.0);
      expect(pigeon.location?.timestamp, 1234567890);
    });

    test('converts preload info with additional info', () {
      const config = AppMetricaConfig(
        'test-api-key',
        preloadInfo: AppMetricaPreloadInfo(
          'tracking_id',
          additionalInfo: {'source': 'partner', 'campaign': 'promo'},
        ),
      );

      final pigeon = config.toPigeon();

      expect(pigeon.preloadInfo?.trackingId, 'tracking_id');
      expect(pigeon.preloadInfo?.additionalInfo, {
        'source': 'partner',
        'campaign': 'promo',
      });
    });

    test('converts empty environments', () {
      const config = AppMetricaConfig(
        'test-api-key',
        appEnvironment: {},
        errorEnvironment: {},
      );

      final pigeon = config.toPigeon();

      expect(pigeon.appEnvironment, {});
      expect(pigeon.errorEnvironment, {});
    });

    test('converts empty custom hosts', () {
      const config = AppMetricaConfig(
        'test-api-key',
        customHosts: [],
      );

      final pigeon = config.toPigeon();

      expect(pigeon.customHosts, []);
    });

    test('converts minimum session timeout', () {
      const config = AppMetricaConfig(
        'test-api-key',
        sessionTimeout: 10,
      );

      final pigeon = config.toPigeon();

      expect(pigeon.sessionTimeout, 10);
    });

    test('converts zero values', () {
      const config = AppMetricaConfig(
        'test-api-key',
        anrMonitoringTimeout: 0,
        appBuildNumber: 0,
        dispatchPeriodSeconds: 0,
        maxReportsCount: 0,
        maxReportsInDatabaseCount: 0,
        sessionTimeout: 0,
      );

      final pigeon = config.toPigeon();

      expect(pigeon.anrMonitoringTimeout, 0);
      expect(pigeon.appBuildNumber, 0);
      expect(pigeon.dispatchPeriodSeconds, 0);
      expect(pigeon.maxReportsCount, 0);
      expect(pigeon.maxReportsInDatabaseCount, 0);
      expect(pigeon.sessionTimeout, 0);
    });
  });
}

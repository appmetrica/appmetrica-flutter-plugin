import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/reporter_config_converter.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReporterConfigConverter', () {
    test('converts only api key', () {
      const AppMetricaReporterConfig config = AppMetricaReporterConfig('reporter-api-key');

      final ReporterConfigPigeon pigeon = config.toPigeon();

      expect(pigeon.apiKey, 'reporter-api-key');
      expect(pigeon.appEnvironment, null);
      expect(pigeon.dataSendingEnabled, null);
      expect(pigeon.dispatchPeriodSeconds, null);
      expect(pigeon.logs, null);
      expect(pigeon.maxReportsCount, null);
      expect(pigeon.maxReportsInDatabaseCount, null);
      expect(pigeon.sessionTimeout, null);
      expect(pigeon.userProfileID, null);
    });

    test('converts all fields', () {
      const AppMetricaReporterConfig config = AppMetricaReporterConfig(
        'full-reporter-key',
        appEnvironment: <String, String?>{'env_key': 'env_value', 'key2': 'value2'},
        dataSendingEnabled: true,
        dispatchPeriodSeconds: 120,
        logs: true,
        maxReportsCount: 50,
        maxReportsInDatabaseCount: 2000,
        sessionTimeout: 60,
        userProfileID: 'reporter_user_123',
      );

      final ReporterConfigPigeon pigeon = config.toPigeon();

      expect(pigeon.apiKey, 'full-reporter-key');
      expect(pigeon.appEnvironment, <String, String?>{'env_key': 'env_value', 'key2': 'value2'});
      expect(pigeon.dataSendingEnabled, true);
      expect(pigeon.dispatchPeriodSeconds, 120);
      expect(pigeon.logs, true);
      expect(pigeon.maxReportsCount, 50);
      expect(pigeon.maxReportsInDatabaseCount, 2000);
      expect(pigeon.sessionTimeout, 60);
      expect(pigeon.userProfileID, 'reporter_user_123');
    });

    test('converts false values', () {
      const AppMetricaReporterConfig config = AppMetricaReporterConfig(
        'reporter-key',
        dataSendingEnabled: false,
        logs: false,
      );

      final ReporterConfigPigeon pigeon = config.toPigeon();

      expect(pigeon.dataSendingEnabled, false);
      expect(pigeon.logs, false);
    });

    test('converts zero values', () {
      const AppMetricaReporterConfig config = AppMetricaReporterConfig(
        'reporter-key',
        dispatchPeriodSeconds: 0,
        maxReportsCount: 0,
        maxReportsInDatabaseCount: 0,
        sessionTimeout: 0,
      );

      final ReporterConfigPigeon pigeon = config.toPigeon();

      expect(pigeon.dispatchPeriodSeconds, 0);
      expect(pigeon.maxReportsCount, 0);
      expect(pigeon.maxReportsInDatabaseCount, 0);
      expect(pigeon.sessionTimeout, 0);
    });

    test('converts empty environment', () {
      const AppMetricaReporterConfig config = AppMetricaReporterConfig(
        'reporter-key',
        appEnvironment: <String, String?>{},
      );

      final ReporterConfigPigeon pigeon = config.toPigeon();

      expect(pigeon.appEnvironment, <String, String?>{});
    });

    test('converts environment with null values', () {
      const AppMetricaReporterConfig config = AppMetricaReporterConfig(
        'reporter-key',
        appEnvironment: <String, String?>{'key1': 'value1', 'key2': null},
      );

      final ReporterConfigPigeon pigeon = config.toPigeon();

      expect(pigeon.appEnvironment, <String, String?>{'key1': 'value1', 'key2': null});
    });

    test('converts large dispatch period', () {
      const AppMetricaReporterConfig config = AppMetricaReporterConfig(
        'reporter-key',
        dispatchPeriodSeconds: 3600, // 1 hour
      );

      final ReporterConfigPigeon pigeon = config.toPigeon();

      expect(pigeon.dispatchPeriodSeconds, 3600);
    });

    test('converts boundary maxReportsInDatabaseCount values', () {
      const AppMetricaReporterConfig configMin = AppMetricaReporterConfig(
        'reporter-key',
        maxReportsInDatabaseCount: 100, // minimum
      );

      const AppMetricaReporterConfig configMax = AppMetricaReporterConfig(
        'reporter-key',
        maxReportsInDatabaseCount: 10000, // maximum
      );

      expect(configMin.toPigeon().maxReportsInDatabaseCount, 100);
      expect(configMax.toPigeon().maxReportsInDatabaseCount, 10000);
    });

    test('converts minimum session timeout', () {
      const AppMetricaReporterConfig config = AppMetricaReporterConfig(
        'reporter-key',
        sessionTimeout: 10, // minimum
      );

      final ReporterConfigPigeon pigeon = config.toPigeon();

      expect(pigeon.sessionTimeout, 10);
    });
  });
}

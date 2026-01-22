import 'package:appmetrica_plugin/src/internal/reporter_impl.dart';
import 'package:appmetrica_plugin/src/internal/reporter_storage.dart';
import 'package:appmetrica_plugin/src/reporter.dart';
import 'package:appmetrica_plugin/src/internal/service_locator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.mocks.dart';

void main() {
  late ReporterStorage storage;

  setUp(() {
    storage = ReporterStorage();
    // Override reporter bridge to avoid platform channel issues
    AppMetricaServiceLocator.overrideReporterBridge(MockReporterPlatformBridge());
  });

  tearDown(() {
    AppMetricaServiceLocator.reset();
  });

  group('ReporterStorage.getReporter', () {
    test('returns ReporterImpl for api key', () {
      final AppMetricaReporter reporter = storage.getReporter('test-api-key');

      expect(reporter, isA<ReporterImpl>());
    });

    test('returns same reporter for same api key', () {
      final AppMetricaReporter reporter1 = storage.getReporter('api-key-1');
      final AppMetricaReporter reporter2 = storage.getReporter('api-key-1');

      expect(identical(reporter1, reporter2), true);
    });

    test('returns different reporters for different api keys', () {
      final AppMetricaReporter reporter1 = storage.getReporter('api-key-1');
      final AppMetricaReporter reporter2 = storage.getReporter('api-key-2');

      expect(identical(reporter1, reporter2), false);
    });

    test('stores multiple reporters', () {
      final AppMetricaReporter reporter1 = storage.getReporter('key-1');
      final AppMetricaReporter reporter2 = storage.getReporter('key-2');
      final AppMetricaReporter reporter3 = storage.getReporter('key-3');

      expect(identical(storage.getReporter('key-1'), reporter1), true);
      expect(identical(storage.getReporter('key-2'), reporter2), true);
      expect(identical(storage.getReporter('key-3'), reporter3), true);
    });

    test('handles empty api key', () {
      final AppMetricaReporter reporter = storage.getReporter('');

      expect(reporter, isA<ReporterImpl>());
    });

    test('handles api key with special characters', () {
      final AppMetricaReporter reporter = storage.getReporter('api-key_123.test@example');

      expect(reporter, isA<ReporterImpl>());
    });

    test('handles very long api key', () {
      final String longKey = 'a' * 1000;
      final AppMetricaReporter reporter = storage.getReporter(longKey);

      expect(reporter, isA<ReporterImpl>());
      expect(identical(storage.getReporter(longKey), reporter), true);
    });

    test('different storage instances are independent', () {
      final ReporterStorage storage1 = ReporterStorage();
      final ReporterStorage storage2 = ReporterStorage();

      final AppMetricaReporter reporter1 = storage1.getReporter('shared-key');
      final AppMetricaReporter reporter2 = storage2.getReporter('shared-key');

      expect(identical(reporter1, reporter2), false);
    });

    test('keys are case-sensitive', () {
      final AppMetricaReporter reporterLower = storage.getReporter('api-key');
      final AppMetricaReporter reporterUpper = storage.getReporter('API-KEY');
      final AppMetricaReporter reporterMixed = storage.getReporter('Api-Key');

      expect(identical(reporterLower, reporterUpper), false);
      expect(identical(reporterLower, reporterMixed), false);
      expect(identical(reporterUpper, reporterMixed), false);
    });
  });
}

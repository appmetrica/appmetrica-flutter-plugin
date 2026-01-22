import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/deferred_deeplink_result_converter.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppMetricaDeferredDeeplinkReasonConverter', () {
    test('converts NOT_A_FIRST_LAUNCH', () {
      const AppMetricaDeferredDeeplinkReasonPigeon reason = AppMetricaDeferredDeeplinkReasonPigeon.NOT_A_FIRST_LAUNCH;

      expect(
        reason.toDart(),
        AppMetricaDeferredDeeplinkErrorReason.notAFirstLaunch,
      );
    });

    test('converts PARSE_ERROR', () {
      const AppMetricaDeferredDeeplinkReasonPigeon reason = AppMetricaDeferredDeeplinkReasonPigeon.PARSE_ERROR;

      expect(
        reason.toDart(),
        AppMetricaDeferredDeeplinkErrorReason.parseError,
      );
    });

    test('converts UNKNOWN', () {
      const AppMetricaDeferredDeeplinkReasonPigeon reason = AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN;

      expect(
        reason.toDart(),
        AppMetricaDeferredDeeplinkErrorReason.unknown,
      );
    });

    test('converts NO_REFERRER', () {
      const AppMetricaDeferredDeeplinkReasonPigeon reason = AppMetricaDeferredDeeplinkReasonPigeon.NO_REFERRER;

      expect(
        reason.toDart(),
        AppMetricaDeferredDeeplinkErrorReason.noReferrer,
      );
    });

    test('converts NO_ERROR to unknown (fallback)', () {
      const AppMetricaDeferredDeeplinkReasonPigeon reason = AppMetricaDeferredDeeplinkReasonPigeon.NO_ERROR;

      expect(
        reason.toDart(),
        AppMetricaDeferredDeeplinkErrorReason.unknown,
      );
    });
  });

  group('AppMetricaDeferredDeeplinkRequestException', () {
    test('creates exception with all fields', () {
      final AppMetricaDeferredDeeplinkRequestException exception = AppMetricaDeferredDeeplinkRequestException(
        AppMetricaDeferredDeeplinkErrorReason.notAFirstLaunch,
        'Not the first app launch',
        'Deferred deeplink is only available on first launch',
      );

      expect(exception.reason,
          AppMetricaDeferredDeeplinkErrorReason.notAFirstLaunch);
      expect(exception.description, 'Not the first app launch');
      expect(exception.message,
          'Deferred deeplink is only available on first launch');
    });

    test('creates exception with null message', () {
      final AppMetricaDeferredDeeplinkRequestException exception = AppMetricaDeferredDeeplinkRequestException(
        AppMetricaDeferredDeeplinkErrorReason.noReferrer,
        'No referrer found',
        null,
      );

      expect(exception.reason, AppMetricaDeferredDeeplinkErrorReason.noReferrer);
      expect(exception.description, 'No referrer found');
      expect(exception.message, null);
    });

    test('is an Exception', () {
      final AppMetricaDeferredDeeplinkRequestException exception = AppMetricaDeferredDeeplinkRequestException(
        AppMetricaDeferredDeeplinkErrorReason.parseError,
        'Parse error',
        null,
      );

      expect(exception, isA<Exception>());
    });
  });
}

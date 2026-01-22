import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/startup_params_converter.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StartupParamsItemStatusConverter', () {
    test('converts FEATURE_DISABLED', () {
      const StartupParamsItemStatusPigeon status = StartupParamsItemStatusPigeon.FEATURE_DISABLED;

      expect(
        status.toDart(),
        AppMetricaStartupParamsItemStatus.featureDisabled,
      );
    });

    test('converts INVALID_VALUE_FROM_PROVIDER', () {
      const StartupParamsItemStatusPigeon status = StartupParamsItemStatusPigeon.INVALID_VALUE_FROM_PROVIDER;

      expect(
        status.toDart(),
        AppMetricaStartupParamsItemStatus.invalidValueFromProvider,
      );
    });

    test('converts NETWORK_ERROR', () {
      const StartupParamsItemStatusPigeon status = StartupParamsItemStatusPigeon.NETWORK_ERROR;

      expect(
        status.toDart(),
        AppMetricaStartupParamsItemStatus.networkError,
      );
    });

    test('converts OK', () {
      const StartupParamsItemStatusPigeon status = StartupParamsItemStatusPigeon.OK;

      expect(
        status.toDart(),
        AppMetricaStartupParamsItemStatus.ok,
      );
    });

    test('converts PROVIDER_UNAVAILABLE', () {
      const StartupParamsItemStatusPigeon status = StartupParamsItemStatusPigeon.PROVIDER_UNAVAILABLE;

      expect(
        status.toDart(),
        AppMetricaStartupParamsItemStatus.providerUnavailable,
      );
    });

    test('converts UNKNOWN_ERROR', () {
      const StartupParamsItemStatusPigeon status = StartupParamsItemStatusPigeon.UNKNOWN_ERROR;

      expect(
        status.toDart(),
        AppMetricaStartupParamsItemStatus.unknownError,
      );
    });
  });

  group('StartupParamsItemConverter', () {
    test('converts all fields', () {
      final StartupParamsItemPigeon item = StartupParamsItemPigeon(
        id: 'item_123',
        status: StartupParamsItemStatusPigeon.OK,
        errorDetails: 'No errors',
      );

      final AppMetricaStartupParamsItem dart = item.toDart();

      expect(dart.id, 'item_123');
      expect(dart.status, AppMetricaStartupParamsItemStatus.ok);
      expect(dart.errorDetails, 'No errors');
    });

    test('converts with error status', () {
      final StartupParamsItemPigeon item = StartupParamsItemPigeon(
        id: 'item_456',
        status: StartupParamsItemStatusPigeon.NETWORK_ERROR,
        errorDetails: 'Connection timeout',
      );

      final AppMetricaStartupParamsItem dart = item.toDart();

      expect(dart.id, 'item_456');
      expect(dart.status, AppMetricaStartupParamsItemStatus.networkError);
      expect(dart.errorDetails, 'Connection timeout');
    });

    test('converts with null fields', () {
      final StartupParamsItemPigeon item = StartupParamsItemPigeon(
        status: StartupParamsItemStatusPigeon.UNKNOWN_ERROR,
      );

      final AppMetricaStartupParamsItem dart = item.toDart();

      expect(dart.id, null);
      expect(dart.status, AppMetricaStartupParamsItemStatus.unknownError);
      expect(dart.errorDetails, null);
    });
  });

  group('StartupParamsResultConverter', () {
    test('converts all fields', () {
      final StartupParamsResultPigeon result = StartupParamsResultPigeon(
        deviceId: 'device_123',
        deviceIdHash: 'hash_456',
        uuid: 'uuid_789',
        parameters: <String, StartupParamsItemPigeon?>{
          'param1': StartupParamsItemPigeon(
            id: 'id1',
            status: StartupParamsItemStatusPigeon.OK,
          ),
        },
      );

      final AppMetricaStartupParamsResult dart = result.toDart();

      expect(dart.deviceId, 'device_123');
      expect(dart.deviceIdHash, 'hash_456');
      expect(dart.uuid, 'uuid_789');
      expect(dart.parameters, isNotNull);
      expect(dart.parameters!['param1']?.id, 'id1');
      expect(dart.parameters!['param1']?.status,
          AppMetricaStartupParamsItemStatus.ok);
    });

    test('converts with null fields', () {
      final StartupParamsResultPigeon result = StartupParamsResultPigeon();

      final AppMetricaStartupParamsResult dart = result.toDart();

      expect(dart.deviceId, null);
      expect(dart.deviceIdHash, null);
      expect(dart.uuid, null);
      expect(dart.parameters, null);
    });

    test('converts with empty parameters', () {
      final StartupParamsResultPigeon result = StartupParamsResultPigeon(
        deviceId: 'device_id',
        parameters: <String, StartupParamsItemPigeon?>{},
      );

      final AppMetricaStartupParamsResult dart = result.toDart();

      expect(dart.deviceId, 'device_id');
      expect(dart.parameters, isNotNull);
      expect(dart.parameters, isEmpty);
    });

    test('converts with multiple parameters', () {
      final StartupParamsResultPigeon result = StartupParamsResultPigeon(
        parameters: <String, StartupParamsItemPigeon?>{
          'uuid': StartupParamsItemPigeon(
            id: 'uuid_value',
            status: StartupParamsItemStatusPigeon.OK,
          ),
          'device_id': StartupParamsItemPigeon(
            id: 'device_value',
            status: StartupParamsItemStatusPigeon.FEATURE_DISABLED,
          ),
        },
      );

      final AppMetricaStartupParamsResult dart = result.toDart();

      expect(dart.parameters!.length, 2);
      expect(dart.parameters!['uuid']?.status,
          AppMetricaStartupParamsItemStatus.ok);
      expect(dart.parameters!['device_id']?.status,
          AppMetricaStartupParamsItemStatus.featureDisabled);
    });
  });

  group('StartupParamsReasonConverter', () {
    test('converts INVALID_RESPONSE', () {
      final StartupParamsReasonPigeon reason = StartupParamsReasonPigeon(value: 'INVALID_RESPONSE');

      expect(reason.toDart(), AppMetricaStartupParamsReason.invalidResponse);
    });

    test('converts NETWORK', () {
      final StartupParamsReasonPigeon reason = StartupParamsReasonPigeon(value: 'NETWORK');

      expect(reason.toDart(), AppMetricaStartupParamsReason.network);
    });

    test('converts UNKNOWN', () {
      final StartupParamsReasonPigeon reason = StartupParamsReasonPigeon(value: 'UNKNOWN');

      expect(reason.toDart(), AppMetricaStartupParamsReason.unknown);
    });

    test('converts unknown value to unknown', () {
      final StartupParamsReasonPigeon reason = StartupParamsReasonPigeon(value: 'SOME_NEW_REASON');

      expect(reason.toDart(), AppMetricaStartupParamsReason.unknown);
    });

    test('converts empty value to unknown', () {
      final StartupParamsReasonPigeon reason = StartupParamsReasonPigeon(value: '');

      expect(reason.toDart(), AppMetricaStartupParamsReason.unknown);
    });
  });

  group('StartupParamsConverter', () {
    test('converts with result', () {
      final StartupParamsPigeon params = StartupParamsPigeon(
        result: StartupParamsResultPigeon(
          deviceId: 'device_123',
          uuid: 'uuid_456',
        ),
      );

      final AppMetricaStartupParams dart = params.toDart();

      expect(dart.result, isNotNull);
      expect(dart.result!.deviceId, 'device_123');
      expect(dart.result!.uuid, 'uuid_456');
      expect(dart.reason, null);
    });

    test('converts with reason', () {
      final StartupParamsPigeon params = StartupParamsPigeon(
        reason: StartupParamsReasonPigeon(value: 'NETWORK'),
      );

      final AppMetricaStartupParams dart = params.toDart();

      expect(dart.result, null);
      expect(dart.reason, AppMetricaStartupParamsReason.network);
    });

    test('converts with both result and reason', () {
      final StartupParamsPigeon params = StartupParamsPigeon(
        result: StartupParamsResultPigeon(
          deviceId: 'device_id',
        ),
        reason: StartupParamsReasonPigeon(value: 'INVALID_RESPONSE'),
      );

      final AppMetricaStartupParams dart = params.toDart();

      expect(dart.result?.deviceId, 'device_id');
      expect(dart.reason, AppMetricaStartupParamsReason.invalidResponse);
    });

    test('converts empty params', () {
      final StartupParamsPigeon params = StartupParamsPigeon();

      final AppMetricaStartupParams dart = params.toDart();

      expect(dart.result, null);
      expect(dart.reason, null);
    });
  });
}

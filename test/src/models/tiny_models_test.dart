import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tiny model constructors smoke', () {
    final AppMetricaDeviceIdRequestException deviceIdError =
        AppMetricaDeviceIdRequestException(AppMetricaDeviceIdErrorReason.network);
    expect(deviceIdError.reason, AppMetricaDeviceIdErrorReason.network);

    const AppMetricaLocation location = AppMetricaLocation(
      10.0,
      20.0,
      provider: 'gps',
      altitude: 1,
      accuracy: 2,
      course: 3,
      speed: 4,
      timestamp: 5,
    );
    expect(location.latitude, 10.0);
    expect(location.longitude, 20.0);
    expect(location.provider, 'gps');

    const AppMetricaPreloadInfo preload = AppMetricaPreloadInfo(
      'tracking',
      additionalInfo: <String, String>{'a': 'b'},
    );
    expect(preload.trackingId, 'tracking');
    expect(preload.additionalInfo, <String, String>{'a': 'b'});

    const AppMetricaReporterConfig reporter = AppMetricaReporterConfig(
      'reporter-key',
      logs: true,
      sessionTimeout: 15,
    );
    expect(reporter.apiKey, 'reporter-key');
    expect(reporter.logs, isTrue);
    expect(reporter.sessionTimeout, 15);
  });
}

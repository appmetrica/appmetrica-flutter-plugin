import '../platform/pigeon/appmetrica_api_pigeon.dart';
import 'activation_config_holder.dart';
import 'base_activation_completer.dart';

class AppMetricaActivationCompleter extends BaseActivationCompleter {
  AppMetricaActivationCompleter(super.config);

  @override
  Future<dynamic> complete(dynamic value) {
    _startFirstAutoTrackedSession(config.sessionsAutoTrackingEnabled);
    return super.complete(value);
  }

  Future<void> _startFirstAutoTrackedSession(bool? sessionsAutoTracking) {
    if (AppMetricaActivationConfigHolder.activated || false == sessionsAutoTracking) {
      return Future<void>.value();
    } else {
      return AppMetricaPigeon().handlePluginInitFinished();
    }
  }
}

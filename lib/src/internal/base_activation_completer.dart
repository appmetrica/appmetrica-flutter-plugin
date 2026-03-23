import '../models/appmetrica_config.dart';
import '../platform/pigeon/appmetrica_api_pigeon.dart';
import 'activation_config_holder.dart';

abstract class BaseActivationCompleter {
  final AppMetricaConfig config;

  BaseActivationCompleter(this.config);

  Future<dynamic> complete(dynamic value) {
    _reportAutoTrackedAppOpen(config.appOpenTrackingEnabled);
    AppMetricaActivationConfigHolder.lastActivationConfig = config;
    return Future<dynamic>.value(value);
  }

  void onError(Object? error, StackTrace stackTrace) {
    AppMetricaActivationConfigHolder.lastActivationConfig = null;
    if (error != null) {
      throw error;
    }
  }

  Future<void> _reportAutoTrackedAppOpen(bool? appOpenTrackingEnabled) {
    if (AppMetricaActivationConfigHolder.activated || false == appOpenTrackingEnabled) {
      return Future<void>.value();
    } else {
      return InitialDeepLinkHolderPigeon()
          .getInitialDeeplink()
          .then((String? value) { if (value != null) { AppMetricaPigeon().reportAppOpen(value); } });
    }
  }
}

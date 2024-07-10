import 'package:appmetrica_plugin/src/appmetrica_api_pigeon.dart';
import '../appmetrica_plugin.dart';

class AppMetricaActivationConfigHolder {
  AppMetricaActivationConfigHolder._();

  static bool _isActivated = false;
  static bool get activated => _isActivated;

  static AppMetricaConfig? _lastActivationConfig;
  static AppMetricaConfig? get lastActivationConfig => _lastActivationConfig;
  static set lastActivationConfig(AppMetricaConfig? value) {
    if (!_isActivated) {
      _isActivated = true;
    }
    activationListener?.call(value);
    _lastActivationConfig = value;
  }

  static Function(AppMetricaConfig?)? activationListener;
}

class AppMetricaActivationCompleter {
  final AppMetricaConfig config;

  AppMetricaActivationCompleter(this.config);

  Future<dynamic> complete(dynamic value) {
    _startFirstAutoTrackedSession(config.sessionsAutoTrackingEnabled);
    _reportAutoTrackedAppOpen(config.appOpenTrackingEnabled);
    AppMetricaActivationConfigHolder.lastActivationConfig = config;
    return Future.value(value);
  }

  void onError(Object? error, StackTrace stackTrace) {
    AppMetricaActivationConfigHolder.lastActivationConfig = null;
    if (error != null) {
      throw error;
    }
  }

  Future<void> _startFirstAutoTrackedSession(bool? sessionsAutoTracking) {
    if (AppMetricaActivationConfigHolder.activated || false == sessionsAutoTracking) {
      return Future.value();
    } else {
      return AppMetricaPigeon().handlePluginInitFinished();
    }
  }

  Future<void> _reportAutoTrackedAppOpen(bool? appOpenTrackingEnabled) {
    if (AppMetricaActivationConfigHolder.activated || false == appOpenTrackingEnabled) {
      return Future.value();
    } else {
      return InitialDeepLinkHolderPigeon()
          .getInitialDeeplink()
          .then((value) => {
                if (value != null) {AppMetricaPigeon().reportAppOpen(value)}
              });
    }
  }
}

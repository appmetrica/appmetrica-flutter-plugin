import '../models/appmetrica_config.dart';

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

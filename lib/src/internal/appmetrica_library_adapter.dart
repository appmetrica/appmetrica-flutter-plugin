import '../models/appmetrica_library_adapter_config.dart';
import '../platform/converters/appmetrica_library_adapter_config_converter.dart';
import '../platform/pigeon/appmetrica_api_pigeon.dart';

class AppMetricaLibraryAdapter {
  AppMetricaLibraryAdapter._();

  static final AppMetricaLibraryAdapterPigeon _appMetricaLibraryAdapter = AppMetricaLibraryAdapterPigeon();

  /// Initializes the library in the application with the initial configuration [config].
  static Future<void> activate(AppMetricaLibraryAdapterConfig config) {
    return _appMetricaLibraryAdapter.activate(config.toPigeon());
  }

  /// Enables or disables advertising identifiers tracking.
  static Future<void> setAdvIdentifiersTracking(bool enabled) {
    return _appMetricaLibraryAdapter.setAdvIdentifiersTracking(enabled);
  }

  /// Subscribes for auto-collected data flow with [apiKey].
  static Future<void> subscribeForAutoCollectedData(String apiKey) {
    return _appMetricaLibraryAdapter.subscribeForAutoCollectedData(apiKey);
  }
}

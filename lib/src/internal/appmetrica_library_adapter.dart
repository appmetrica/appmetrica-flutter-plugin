import '../platform/pigeon/appmetrica_api_pigeon.dart';

class AppMetricaLibraryAdapter {
  AppMetricaLibraryAdapter._();

  static final AppMetricaLibraryAdapterPigeon _appMetricaLibraryAdapter = AppMetricaLibraryAdapterPigeon();

  /// Subscribes for auto-collected data flow with [apiKey].
  static Future<void> subscribeForAutoCollectedData(String apiKey) {
    return _appMetricaLibraryAdapter.subscribeForAutoCollectedData(apiKey);
  }
}

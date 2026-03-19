import '../../models/appmetrica_library_adapter_config.dart';
import '../pigeon/appmetrica_api_pigeon.dart';

extension ConfigConverter on AppMetricaLibraryAdapterConfig {
  AppMetricaLibraryAdapterConfigPigeon toPigeon() => AppMetricaLibraryAdapterConfigPigeon(
    advIdentifiersTracking: advIdentifiersTracking,
  );
}

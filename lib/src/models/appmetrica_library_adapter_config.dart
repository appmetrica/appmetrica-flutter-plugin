/// Contains configuration for AppMetricaLibraryAdapter. You can set:
/// * [advIdentifiersTracking] - indicates whether AppMetrica should include advertising identifiers withing its reports.
class AppMetricaLibraryAdapterConfig {
  final bool? advIdentifiersTracking;

  /// Creates a configuration object.
  const AppMetricaLibraryAdapterConfig({
    this.advIdentifiersTracking,
  });
}

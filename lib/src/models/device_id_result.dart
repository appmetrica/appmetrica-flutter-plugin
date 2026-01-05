/// Exception when requesting a unique AppMetrica ID.
class AppMetricaDeviceIdRequestException implements Exception {
  final AppMetricaDeviceIdErrorReason reason;
  AppMetricaDeviceIdRequestException(this.reason);
}

/// Contains possible error values when requesting a unique AppMetrica identifier:
/// * [unknown] - unknown error.
/// * [network] - internet connection problem.
/// * [invalidResponse] - server response parsing error.
enum AppMetricaDeviceIdErrorReason {
  unknown,
  network,
  invalidResponse,
}

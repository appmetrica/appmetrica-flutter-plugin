/// The class contains information for tracking pre-installed applications.
class AppMetricaPreloadInfo {
  final String trackingId;
  final Map<String, String>? additionalInfo;

  /// Creates a [AppMetricaPreloadInfo] object with [trackingId] and a list of additional parameters [additionalInfo].
  /// [trackingId] is a required parameter.
  const AppMetricaPreloadInfo(this.trackingId, {this.additionalInfo});
}

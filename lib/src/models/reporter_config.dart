/// Class contains the configuration of the reporter. You can set:
/// * [apiKey] - API key other than the API key of the application;
/// * [appEnvironment] - application environment to be set after initialization.
/// * [dataSendingEnabled] - indicates whether sending statistics is enabled. The default value is true;
/// * [dispatchPeriodSeconds] - timeout for sending reports.
/// * [logs] - a sign that determines whether logging of the reporter's work is enabled. The default value is false.
/// * [maxReportsCount] - maximum buffer size for reports.
/// * [maxReportsInDatabaseCount] — the maximum number of events that can be stored in the database on the device before being sent to AppMetrica. The default value is 1000.
/// Values in the range [100; 10000] are allowed. Values that do not fall within this interval will be automatically replaced with the value of the nearest interval boundary;
/// * [sessionTimeout] — session timeout in seconds. The default value is 10 (the minimum allowed value);
/// * [userProfileID] - user profile identifier (profileId) upon activation;
class AppMetricaReporterConfig {
  final String apiKey;

  final Map<String?, String?>? appEnvironment;
  final bool? dataSendingEnabled;
  final int? dispatchPeriodSeconds;
  final bool? logs;
  final int? maxReportsCount;
  final int? maxReportsInDatabaseCount;
  final int? sessionTimeout;
  final String? userProfileID;

  /// Creates an object of the [AppMetricaReporterConfig] class - the reporter configuration constructor. [apiKey] is a required parameter.
  const AppMetricaReporterConfig(
      this.apiKey, {
        this.appEnvironment,
      this.dataSendingEnabled,
      this.dispatchPeriodSeconds,
      this.logs,
      this.maxReportsCount,
      this.maxReportsInDatabaseCount,
      this.sessionTimeout,
      this.userProfileID
});
}

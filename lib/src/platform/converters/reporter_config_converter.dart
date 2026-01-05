import '../../models/reporter_config.dart';
import '../pigeon/appmetrica_api_pigeon.dart';

extension ReporterConfigConverter on AppMetricaReporterConfig {
  ReporterConfigPigeon toPigeon() => ReporterConfigPigeon(
    apiKey: apiKey,
    appEnvironment: appEnvironment,
    dataSendingEnabled: dataSendingEnabled,
    dispatchPeriodSeconds: dispatchPeriodSeconds,
    logs: logs,
    maxReportsCount: maxReportsCount,
    maxReportsInDatabaseCount: maxReportsInDatabaseCount,
    sessionTimeout: sessionTimeout,
    userProfileID: userProfileID,
  );
}

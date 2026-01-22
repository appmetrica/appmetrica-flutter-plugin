import '../reporter.dart';
import 'reporter_impl.dart';

class ReporterStorage {
  final Map<String, AppMetricaReporter> _map = <String, AppMetricaReporter>{};

  AppMetricaReporter getReporter(String apiKey) =>
      _map.putIfAbsent(apiKey, () => ReporterImpl(apiKey));
}

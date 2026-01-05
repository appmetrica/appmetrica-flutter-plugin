import '../../models/external_attribution.dart';
import '../pigeon/appmetrica_api_pigeon.dart';

extension ExternalAttributionConverter on AppMetricaExternalAttribution {
  ExternalAttributionPigeon toPigeon() => ExternalAttributionPigeon(
      source: source,
      data: data,
  );
}

import '../../models/preload_info.dart';
import '../pigeon/appmetrica_api_pigeon.dart';

extension PreloadInfoConverter on AppMetricaPreloadInfo {
  PreloadInfoPigeon toPigeon() =>
      PreloadInfoPigeon(trackingId: trackingId, additionalInfo: additionalInfo);
}

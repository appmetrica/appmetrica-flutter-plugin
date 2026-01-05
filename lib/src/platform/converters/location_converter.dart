import '../../models/location.dart';
import '../pigeon/appmetrica_api_pigeon.dart';

extension LocationConverter on AppMetricaLocation {
  LocationPigeon toPigeon() => LocationPigeon(
      latitude: latitude,
      longitude: longitude,
      provider: provider,
      altitude: altitude,
      accuracy: accuracy,
      course: course,
      speed: speed,
      timestamp: timestamp);
}

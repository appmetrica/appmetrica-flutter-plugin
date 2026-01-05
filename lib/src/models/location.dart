/// The class contains settings about the device location.
class AppMetricaLocation {
  final double latitude;
  final double longitude;
  final String? provider;
  final double? altitude;
  final double? accuracy;
  final double? course;
  final double? speed;
  final int? timestamp;

  /// Creates an object of the [AppMetricaLocation] class with the specified parameters. The parameters [latitude], [longitude] are required.
  const AppMetricaLocation(this.latitude, this.longitude,
      {this.provider,
      this.altitude,
      this.accuracy,
      this.course,
      this.speed,
      this.timestamp});
}

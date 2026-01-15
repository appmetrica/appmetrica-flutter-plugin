import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/location_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocationConverter', () {
    test('converts only required fields', () {
      const location = AppMetricaLocation(55.751244, 37.618423);

      final pigeon = location.toPigeon();

      expect(pigeon.latitude, 55.751244);
      expect(pigeon.longitude, 37.618423);
      expect(pigeon.provider, null);
      expect(pigeon.altitude, null);
      expect(pigeon.accuracy, null);
      expect(pigeon.course, null);
      expect(pigeon.speed, null);
      expect(pigeon.timestamp, null);
    });

    test('converts all fields', () {
      const location = AppMetricaLocation(
        55.751244,
        37.618423,
        provider: 'gps',
        altitude: 150.5,
        accuracy: 10.0,
        course: 45.0,
        speed: 5.0,
        timestamp: 1234567890,
      );

      final pigeon = location.toPigeon();

      expect(pigeon.latitude, 55.751244);
      expect(pigeon.longitude, 37.618423);
      expect(pigeon.provider, 'gps');
      expect(pigeon.altitude, 150.5);
      expect(pigeon.accuracy, 10.0);
      expect(pigeon.course, 45.0);
      expect(pigeon.speed, 5.0);
      expect(pigeon.timestamp, 1234567890);
    });

    test('converts negative coordinates', () {
      const location = AppMetricaLocation(-33.8688, -151.2093);

      final pigeon = location.toPigeon();

      expect(pigeon.latitude, -33.8688);
      expect(pigeon.longitude, -151.2093);
    });

    test('converts zero coordinates', () {
      const location = AppMetricaLocation(0.0, 0.0);

      final pigeon = location.toPigeon();

      expect(pigeon.latitude, 0.0);
      expect(pigeon.longitude, 0.0);
    });

    test('converts extreme latitude values', () {
      const locationNorth = AppMetricaLocation(90.0, 0.0);
      const locationSouth = AppMetricaLocation(-90.0, 0.0);

      expect(locationNorth.toPigeon().latitude, 90.0);
      expect(locationSouth.toPigeon().latitude, -90.0);
    });

    test('converts extreme longitude values', () {
      const locationEast = AppMetricaLocation(0.0, 180.0);
      const locationWest = AppMetricaLocation(0.0, -180.0);

      expect(locationEast.toPigeon().longitude, 180.0);
      expect(locationWest.toPigeon().longitude, -180.0);
    });

    test('converts with network provider', () {
      const location = AppMetricaLocation(
        55.751244,
        37.618423,
        provider: 'network',
      );

      final pigeon = location.toPigeon();

      expect(pigeon.provider, 'network');
    });

    test('converts zero altitude', () {
      const location = AppMetricaLocation(
        55.751244,
        37.618423,
        altitude: 0.0,
      );

      final pigeon = location.toPigeon();

      expect(pigeon.altitude, 0.0);
    });

    test('converts negative altitude (below sea level)', () {
      const location = AppMetricaLocation(
        31.5, // Dead Sea area
        35.5,
        altitude: -430.5, // Below sea level
      );

      final pigeon = location.toPigeon();

      expect(pigeon.altitude, -430.5);
    });

    test('converts high accuracy value', () {
      const location = AppMetricaLocation(
        55.751244,
        37.618423,
        accuracy: 0.5,
      );

      final pigeon = location.toPigeon();

      expect(pigeon.accuracy, 0.5);
    });

    test('converts full course range', () {
      const location0 = AppMetricaLocation(0.0, 0.0, course: 0.0);
      const location180 = AppMetricaLocation(0.0, 0.0, course: 180.0);
      const location359 = AppMetricaLocation(0.0, 0.0, course: 359.9);

      expect(location0.toPigeon().course, 0.0);
      expect(location180.toPigeon().course, 180.0);
      expect(location359.toPigeon().course, 359.9);
    });

    test('converts zero speed', () {
      const location = AppMetricaLocation(
        55.751244,
        37.618423,
        speed: 0.0,
      );

      final pigeon = location.toPigeon();

      expect(pigeon.speed, 0.0);
    });

    test('converts high speed value', () {
      const location = AppMetricaLocation(
        55.751244,
        37.618423,
        speed: 300.0, // m/s
      );

      final pigeon = location.toPigeon();

      expect(pigeon.speed, 300.0);
    });
  });
}

import 'package:flutter/foundation.dart';

import '../platform/platform_bridge.dart';
import '../platform/reporter_platform_bridge.dart';

/// Service Locator for dependency injection.
///
/// In production uses [PigeonPlatformBridge] and [PigeonReporterBridge].
/// For tests, you can override via [overridePlatformBridge] and [overrideReporterBridge].
///
/// Example usage in tests:
/// ```dart
/// setUp(() {
///   final mockBridge = MockPlatformBridge();
///   final mockReporterBridge = MockReporterPlatformBridge();
///   AppMetricaServiceLocator.overridePlatformBridge(mockBridge);
///   AppMetricaServiceLocator.overrideReporterBridge(mockReporterBridge);
/// });
///
/// tearDown(() {
///   AppMetricaServiceLocator.reset();
/// });
/// ```
class AppMetricaServiceLocator {
  AppMetricaServiceLocator._();

  static PlatformBridge? _platformBridge;
  static ReporterPlatformBridge? _reporterBridge;

  /// Returns the current [PlatformBridge] instance.
  ///
  /// Creates [PigeonPlatformBridge] on first access if not overridden.
  static PlatformBridge get platformBridge =>
      _platformBridge ??= PigeonPlatformBridge();

  /// Returns the current [ReporterPlatformBridge] instance.
  ///
  /// Creates [PigeonReporterBridge] on first access if not overridden.
  static ReporterPlatformBridge get reporterBridge =>
      _reporterBridge ??= PigeonReporterBridge();

  /// Overrides the [PlatformBridge] for testing.
  ///
  /// Call [reset] in tearDown to restore default behavior.
  @visibleForTesting
  static void overridePlatformBridge(PlatformBridge bridge) {
    _platformBridge = bridge;
  }

  /// Overrides the [ReporterPlatformBridge] for testing.
  ///
  /// Call [reset] in tearDown to restore default behavior.
  @visibleForTesting
  static void overrideReporterBridge(ReporterPlatformBridge bridge) {
    _reporterBridge = bridge;
  }

  /// Resets all overrides to default state.
  ///
  /// Should be called in test tearDown.
  @visibleForTesting
  static void reset() {
    _platformBridge = null;
    _reporterBridge = null;
  }
}

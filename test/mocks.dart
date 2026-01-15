import 'package:appmetrica_plugin/src/platform/platform_bridge.dart';
import 'package:appmetrica_plugin/src/platform/reporter_platform_bridge.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  PlatformBridge,
  ReporterPlatformBridge,
  AppMetricaPigeon,
  ReporterPigeon,
  InitialDeepLinkHolderPigeon,
  AppMetricaConfigConverterPigeon,
])
void main() {}

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/pigeon/appmetrica_api_pigeon.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MessageCodec<Object?> codec = AppMetricaLibraryAdapterPigeon.codec;
  const String activateChannel =
      'dev.flutter.pigeon.appmetrica_plugin.AppMetricaLibraryAdapterPigeon.activate';
  const String setAdvChannel =
      'dev.flutter.pigeon.appmetrica_plugin.AppMetricaLibraryAdapterPigeon.setAdvIdentifiersTracking';
  const String subscribeChannel =
      'dev.flutter.pigeon.appmetrica_plugin.AppMetricaLibraryAdapterPigeon.subscribeForAutoCollectedData';

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(activateChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(setAdvChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(subscribeChannel, null);
  });

  test('activate / setAdvIdentifiersTracking / subscribeForAutoCollectedData reach pigeon channels',
      () async {
    Object? activateArgs;
    Object? setAdvArgs;
    Object? subscribeArgs;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(activateChannel, (ByteData? message) async {
      activateArgs = codec.decodeMessage(message);
      return codec.encodeMessage(<Object?>[]);
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(setAdvChannel, (ByteData? message) async {
      setAdvArgs = codec.decodeMessage(message);
      return codec.encodeMessage(<Object?>[]);
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(subscribeChannel, (ByteData? message) async {
      subscribeArgs = codec.decodeMessage(message);
      return codec.encodeMessage(<Object?>[]);
    });

    await AppMetricaLibraryAdapter.activate(
      const AppMetricaLibraryAdapterConfig(advIdentifiersTracking: true),
    );
    await AppMetricaLibraryAdapter.setAdvIdentifiersTracking(false);
    await AppMetricaLibraryAdapter.subscribeForAutoCollectedData('api-key');

    final List<Object?> activateList = activateArgs! as List<Object?>;
    expect(activateList, hasLength(1));
    expect(
      activateList.single,
      isA<AppMetricaLibraryAdapterConfigPigeon>()
          .having(
            (AppMetricaLibraryAdapterConfigPigeon c) => c.advIdentifiersTracking,
            'advIdentifiersTracking',
            isTrue,
          ),
    );
    expect(setAdvArgs, <Object?>[false]);
    expect(subscribeArgs, <Object?>['api-key']);
  });
}

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppMetricaErrorDescription factories', () {
    test('fromFlutterErrorDetails / fromObjectAndStackTrace / fromCurrentStackTrace', () {
      final StackTrace stack = StackTrace.current;
      final StateError withStackError = StateError('with stack');
      final FlutterErrorDetails withStack = FlutterErrorDetails(
        exception: withStackError,
        stack: stack,
      );
      final AppMetricaErrorDescription fromDetails =
          AppMetricaErrorDescription.fromFlutterErrorDetails(withStack);
      expect(fromDetails.type, 'StateError');
      expect(fromDetails.message, contains('with stack'));
      expect(fromDetails.stackTrace, same(stack));

      final AppMetricaErrorDescription fromEmptyStack =
          AppMetricaErrorDescription.fromFlutterErrorDetails(
        FlutterErrorDetails(exception: StateError('empty'), stack: StackTrace.empty),
      );
      expect(fromEmptyStack.stackTrace.toString(), isNotEmpty);

      final AppMetricaErrorDescription fromNullStack =
          AppMetricaErrorDescription.fromFlutterErrorDetails(
        FlutterErrorDetails(exception: StateError('null stack')),
      );
      expect(fromNullStack.stackTrace.toString(), isNotEmpty);

      final StateError error = StateError('object');
      final AppMetricaErrorDescription fromObject =
          AppMetricaErrorDescription.fromObjectAndStackTrace(error, stack);
      expect(fromObject.message, error.toString());
      expect(fromObject.type, 'StateError');
      expect(fromObject.stackTrace, same(stack));

      final AppMetricaErrorDescription fromCurrent =
          AppMetricaErrorDescription.fromCurrentStackTrace(
        message: 'current',
        type: 'Custom',
      );
      expect(fromCurrent.message, 'current');
      expect(fromCurrent.type, 'Custom');
      expect(fromCurrent.stackTrace.toString(), isNotEmpty);
    });
  });
}

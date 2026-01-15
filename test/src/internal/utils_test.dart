import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/internal/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppMetricaErrorDescriptionNullableSerializer', () {
    group('tryToAddCurrentTrace', () {
      test('returns error description with current trace when null', () {
        const AppMetricaErrorDescription? nullError = null;

        final result = nullError.tryToAddCurrentTrace();

        expect(result, isA<AppMetricaErrorDescription>());
        expect(result.stackTrace, isNotNull);
        expect(result.stackTrace.toString(), isNotEmpty);
      });

      test('returns same error description when not null', () {
        final existingStackTrace = StackTrace.current;
        final error = AppMetricaErrorDescription(
          existingStackTrace,
          message: 'Existing error',
          type: 'ExistingType',
        );

        final result = error.tryToAddCurrentTrace();

        expect(identical(result, error), true);
        expect(result.message, 'Existing error');
        expect(result.type, 'ExistingType');
        expect(identical(result.stackTrace, existingStackTrace), true);
      });

      test('preserves all fields when error is not null', () {
        final error = AppMetricaErrorDescription(
          StackTrace.current,
          message: 'Test message',
          type: 'TestType',
        );

        final result = error.tryToAddCurrentTrace();

        expect(result.message, 'Test message');
        expect(result.type, 'TestType');
      });

      test('creates new error description from current trace when null', () {
        const AppMetricaErrorDescription? nullError = null;

        final result1 = nullError.tryToAddCurrentTrace();
        final result2 = nullError.tryToAddCurrentTrace();

        // Each call creates a new instance with different stack traces
        expect(identical(result1, result2), false);
      });

      test('returns error with null message and type when input is null', () {
        const AppMetricaErrorDescription? nullError = null;

        final result = nullError.tryToAddCurrentTrace();

        // fromCurrentStackTrace creates error with null message and type by default
        expect(result.message, null);
        expect(result.type, null);
      });

      test('handles error with null message', () {
        final error = AppMetricaErrorDescription(
          StackTrace.current,
          type: 'TypeOnly',
        );

        final result = error.tryToAddCurrentTrace();

        expect(result.message, null);
        expect(result.type, 'TypeOnly');
      });

      test('handles error with null type', () {
        final error = AppMetricaErrorDescription(
          StackTrace.current,
          message: 'MessageOnly',
        );

        final result = error.tryToAddCurrentTrace();

        expect(result.message, 'MessageOnly');
        expect(result.type, null);
      });

      test('handles error with empty message', () {
        final error = AppMetricaErrorDescription(
          StackTrace.current,
          message: '',
          type: 'EmptyMessageType',
        );

        final result = error.tryToAddCurrentTrace();

        expect(result.message, '');
        expect(result.type, 'EmptyMessageType');
      });

      test('handles error with empty type', () {
        final error = AppMetricaErrorDescription(
          StackTrace.current,
          message: 'Message',
          type: '',
        );

        final result = error.tryToAddCurrentTrace();

        expect(result.message, 'Message');
        expect(result.type, '');
      });
    });
  });
}

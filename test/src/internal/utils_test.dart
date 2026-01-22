import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/internal/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppMetricaErrorDescriptionNullableSerializer', () {
    group('tryToAddCurrentTrace', () {
      test('returns error description with current trace when null', () {
        const AppMetricaErrorDescription? nullError = null;

        final AppMetricaErrorDescription result = nullError.tryToAddCurrentTrace();

        expect(result, isA<AppMetricaErrorDescription>());
        expect(result.stackTrace, isNotNull);
        expect(result.stackTrace.toString(), isNotEmpty);
      });

      test('returns same error description when not null', () {
        final StackTrace existingStackTrace = StackTrace.current;
        final AppMetricaErrorDescription error = AppMetricaErrorDescription(
          existingStackTrace,
          message: 'Existing error',
          type: 'ExistingType',
        );

        final AppMetricaErrorDescription result = error.tryToAddCurrentTrace();

        expect(identical(result, error), true);
        expect(result.message, 'Existing error');
        expect(result.type, 'ExistingType');
        expect(identical(result.stackTrace, existingStackTrace), true);
      });

      test('preserves all fields when error is not null', () {
        final AppMetricaErrorDescription error = AppMetricaErrorDescription(
          StackTrace.current,
          message: 'Test message',
          type: 'TestType',
        );

        final AppMetricaErrorDescription result = error.tryToAddCurrentTrace();

        expect(result.message, 'Test message');
        expect(result.type, 'TestType');
      });

      test('creates new error description from current trace when null', () {
        const AppMetricaErrorDescription? nullError = null;

        final AppMetricaErrorDescription result1 = nullError.tryToAddCurrentTrace();
        final AppMetricaErrorDescription result2 = nullError.tryToAddCurrentTrace();

        // Each call creates a new instance with different stack traces
        expect(identical(result1, result2), false);
      });

      test('returns error with null message and type when input is null', () {
        const AppMetricaErrorDescription? nullError = null;

        final AppMetricaErrorDescription result = nullError.tryToAddCurrentTrace();

        // fromCurrentStackTrace creates error with null message and type by default
        expect(result.message, null);
        expect(result.type, null);
      });

      test('handles error with null message', () {
        final AppMetricaErrorDescription error = AppMetricaErrorDescription(
          StackTrace.current,
          type: 'TypeOnly',
        );

        final AppMetricaErrorDescription result = error.tryToAddCurrentTrace();

        expect(result.message, null);
        expect(result.type, 'TypeOnly');
      });

      test('handles error with null type', () {
        final AppMetricaErrorDescription error = AppMetricaErrorDescription(
          StackTrace.current,
          message: 'MessageOnly',
        );

        final AppMetricaErrorDescription result = error.tryToAddCurrentTrace();

        expect(result.message, 'MessageOnly');
        expect(result.type, null);
      });

      test('handles error with empty message', () {
        final AppMetricaErrorDescription error = AppMetricaErrorDescription(
          StackTrace.current,
          message: '',
          type: 'EmptyMessageType',
        );

        final AppMetricaErrorDescription result = error.tryToAddCurrentTrace();

        expect(result.message, '');
        expect(result.type, 'EmptyMessageType');
      });

      test('handles error with empty type', () {
        final AppMetricaErrorDescription error = AppMetricaErrorDescription(
          StackTrace.current,
          message: 'Message',
          type: '',
        );

        final AppMetricaErrorDescription result = error.tryToAddCurrentTrace();

        expect(result.message, 'Message');
        expect(result.type, '');
      });
    });
  });
}

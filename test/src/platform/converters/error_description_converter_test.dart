import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_plugin/src/platform/converters/error_description_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorDescriptionConverter', () {
    test('converts all fields', () {
      final stackTrace = StackTrace.current;
      final error = AppMetricaErrorDescription(
        stackTrace,
        message: 'Test error message',
        type: 'TestException',
      );

      final pigeon = error.toPigeon();

      expect(pigeon.exceptionClass, 'TestException');
      expect(pigeon.message, 'Test error message');
      expect(pigeon.backtrace, isNotEmpty);
      expect(pigeon.dartVersion, isNotEmpty);
    });

    test('converts with only stack trace', () {
      final stackTrace = StackTrace.current;
      final error = AppMetricaErrorDescription(stackTrace);

      final pigeon = error.toPigeon();

      expect(pigeon.exceptionClass, '');
      expect(pigeon.message, null);
      expect(pigeon.backtrace, isNotEmpty);
    });

    test('converts with null type to empty string', () {
      final stackTrace = StackTrace.current;
      final error = AppMetricaErrorDescription(
        stackTrace,
        message: 'Error message',
      );

      final pigeon = error.toPigeon();

      expect(pigeon.exceptionClass, '');
    });

    test('converts stack trace elements correctly', () {
      final stackTrace = StackTrace.current;
      final error = AppMetricaErrorDescription(stackTrace);

      final pigeon = error.toPigeon();

      expect(pigeon.backtrace, isNotEmpty);
      for (final element in pigeon.backtrace!) {
        expect(element?.fileName, isNotNull);
        expect(element?.line, isA<int>());
        expect(element?.column, isA<int>());
      }
    });
  });

  group('convertErrorDetails', () {
    test('creates ErrorDetailsPigeon with all fields', () {
      final stackTrace = StackTrace.current;

      final pigeon = convertErrorDetails(
        'CustomException',
        'Something went wrong',
        stackTrace,
      );

      expect(pigeon.exceptionClass, 'CustomException');
      expect(pigeon.message, 'Something went wrong');
      expect(pigeon.backtrace, isNotEmpty);
      expect(pigeon.dartVersion, isNotEmpty);
    });

    test('creates ErrorDetailsPigeon with null message', () {
      final stackTrace = StackTrace.current;

      final pigeon = convertErrorDetails('Exception', null, stackTrace);

      expect(pigeon.exceptionClass, 'Exception');
      expect(pigeon.message, null);
    });

    test('creates ErrorDetailsPigeon with null stack trace', () {
      final pigeon = convertErrorDetails('Exception', 'Error', null);

      expect(pigeon.exceptionClass, 'Exception');
      expect(pigeon.message, 'Error');
      expect(pigeon.backtrace, isEmpty);
    });

    test('creates ErrorDetailsPigeon with empty class name', () {
      final stackTrace = StackTrace.current;

      final pigeon = convertErrorDetails('', 'Error', stackTrace);

      expect(pigeon.exceptionClass, '');
    });
  });

  group('convertErrorStackTrace', () {
    test('converts stack trace to list of elements', () {
      final stackTrace = StackTrace.current;

      final elements = convertErrorStackTrace(stackTrace);

      expect(elements, isNotEmpty);
      expect(elements.first.fileName, isNotEmpty);
    });

    test('parses method names from stack trace', () {
      final stackTrace = StackTrace.current;

      final elements = convertErrorStackTrace(stackTrace);

      // At least one element should have a method name
      expect(elements.any((e) => e.methodName.isNotEmpty), isTrue);
    });

    test('includes line and column numbers', () {
      final stackTrace = StackTrace.current;

      final elements = convertErrorStackTrace(stackTrace);

      for (final element in elements) {
        expect(element.line, isA<int>());
        expect(element.column, isA<int>());
      }
    });
  });

  group('AppMetricaErrorDescription factory constructors', () {
    test('fromCurrentStackTrace creates with current stack', () {
      final error = AppMetricaErrorDescription.fromCurrentStackTrace(
        message: 'Current stack error',
        type: 'CurrentStackException',
      );

      final pigeon = error.toPigeon();

      expect(pigeon.message, 'Current stack error');
      expect(pigeon.exceptionClass, 'CurrentStackException');
      expect(pigeon.backtrace, isNotEmpty);
    });

    test('fromObjectAndStackTrace creates from error object', () {
      try {
        throw Exception('Test exception');
      } catch (e, stackTrace) {
        final error = AppMetricaErrorDescription.fromObjectAndStackTrace(
          e,
          stackTrace,
        );

        final pigeon = error.toPigeon();

        expect(pigeon.message, contains('Test exception'));
        expect(pigeon.exceptionClass, '_Exception');
        expect(pigeon.backtrace, isNotEmpty);
      }
    });

    test('fromObjectAndStackTrace with custom error type', () {
      try {
        throw ArgumentError('Invalid argument');
      } catch (e, stackTrace) {
        final error = AppMetricaErrorDescription.fromObjectAndStackTrace(
          e,
          stackTrace,
        );

        final pigeon = error.toPigeon();

        expect(pigeon.exceptionClass, 'ArgumentError');
        expect(pigeon.message, contains('Invalid argument'));
      }
    });
  });
}

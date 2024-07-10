import 'package:flutter/widgets.dart';

/// A class for transmitting to AppMetrica those errors that occur when the application is running.
class AppMetricaErrorDescription {
  final String? message;
  final String? type;
  final StackTrace stackTrace;

  /// Creates [AppMetricaErrorDescription]. [stackTrace] is a required parameter.
  AppMetricaErrorDescription(this.stackTrace, {this.message, this.type});

  /// Creates [AppMetricaErrorDescription] from [FlutterErrorDetails].
  AppMetricaErrorDescription.fromFlutterErrorDetails(
      FlutterErrorDetails details)
      : message = details.summary.toString(),
        type = details.exception.runtimeType.toString(),
        stackTrace = _wrapStackTrace(details.stack);

  /// Creates [AppMetricaErrorDescription] from the description of the error [error] and the stacktrace where the error [trace] occurred.
  AppMetricaErrorDescription.fromObjectAndStackTrace(
      Object error, StackTrace trace)
      : message = error.toString(),
        type = error.runtimeType.toString(),
        stackTrace = trace;

  /// Creates [AppMetricaErrorDescription] from the error message [message] and its type [type] with the current stacktrace.
  AppMetricaErrorDescription.fromCurrentStackTrace({this.message, this.type})
      : stackTrace = StackTrace.current;

  static StackTrace _wrapStackTrace(StackTrace? trace) {
    if (trace != null && trace.toString().isNotEmpty) {
      return trace;
    }
    return StackTrace.current;
  }
}

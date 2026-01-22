import 'dart:io';
import 'package:stack_trace/stack_trace.dart';

import '../../models/error_description.dart';
import '../pigeon/appmetrica_api_pigeon.dart';

extension AppMetricaErrorDescriptionSerializer on AppMetricaErrorDescription {
  ErrorDetailsPigeon toPigeon() =>
      convertErrorDetails(type ?? "", message, stackTrace);
}

ErrorDetailsPigeon convertErrorDetails(
        String clazz, String? msg, StackTrace? stack) =>
    ErrorDetailsPigeon(
        exceptionClass: clazz,
        message: msg,
        dartVersion: Platform.version,
        backtrace: stack != null ? convertErrorStackTrace(stack) : <StackTraceElementPigeon>[]);

List<StackTraceElementPigeon> convertErrorStackTrace(StackTrace stack) {
  final Iterable<StackTraceElementPigeon> backtrace = Trace.from(stack).frames.map((Frame element) {
    final int firstDot = element.member?.indexOf(".") ?? -1;
    final String? className =
    firstDot >= 0 ? element.member?.substring(0, firstDot) : null;
    final String? methodName = element.member?.substring(firstDot + 1);
    return StackTraceElementPigeon(
        className: className ?? "",
        methodName: methodName ?? "",
        fileName: element.library,
        line: element.line ?? 0,
        column: element.column ?? 0);
  });
  return backtrace.toList(growable: false);
}

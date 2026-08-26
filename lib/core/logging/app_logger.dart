import 'package:flutter/foundation.dart';
import 'package:smerp_go/core/logging/app_error_reporter.dart';
import 'package:smerp_go/core/logging/sensitive_log_sanitizer.dart';

enum AppLogLevel {
  debug,
  info,
  warning,
  error,
}

/// Environment-aware structured logging for the app.
///
/// Debug/info logs are suppressed in release builds.
/// Errors are forwarded to Crashlytics in release via [AppErrorReporter].
class AppLogger {
  AppLogger._();

  static void debug(String message, {String? tag}) {
    _log(AppLogLevel.debug, message, tag: tag);
  }

  static void info(String message, {String? tag}) {
    _log(AppLogLevel.info, message, tag: tag);
  }

  static void warning(String message, {String? tag}) {
    _log(AppLogLevel.warning, message, tag: tag);
  }

  static void error(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    String? tag,
  }) {
    final message = reason ?? error.toString();
    _log(AppLogLevel.error, message, tag: tag);
    AppErrorReporter.recordNonFatal(
      error,
      stackTrace,
      reason: reason ?? tag,
    );
  }

  static void logApi({
    required String method,
    required Uri url,
    Map<String, String>? headers,
    String? body,
  }) {
    if (!kDebugMode) {
      return;
    }

    final sanitizedHeaders = headers == null
        ? null
        : SensitiveLogSanitizer.redactHeaders(headers);

    debug(
      '[$method] $url'
      '${sanitizedHeaders == null ? '' : ' headers=$sanitizedHeaders'}'
      '${body == null ? '' : ' body=${SensitiveLogSanitizer.redactBody(body)}'}',
      tag: 'API',
    );
  }

  static void _log(AppLogLevel level, String message, {String? tag}) {
    if (level == AppLogLevel.debug || level == AppLogLevel.info) {
      if (!kDebugMode) {
        return;
      }
    }

    final prefix = switch (level) {
      AppLogLevel.debug => 'DEBUG',
      AppLogLevel.info => 'INFO',
      AppLogLevel.warning => 'WARN',
      AppLogLevel.error => 'ERROR',
    };

    final label = tag == null ? prefix : '$prefix/$tag';
    debugPrint('[$label] $message');
  }
}

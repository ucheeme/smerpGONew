import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:smerp_go/utils/AppUtils.dart';

/// Centralized error reporting for production observability.
///
/// Does not log tokens, PINs, or other sensitive fields.
class AppErrorReporter {
  AppErrorReporter._();

  static Future<void> initialize() async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      !kDebugMode,
    );

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  static void recordNonFatal(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  }) {
    AppUtils.debug(reason ?? error.toString());
    if (kDebugMode) {
      return;
    }

    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: false,
    );
  }
}

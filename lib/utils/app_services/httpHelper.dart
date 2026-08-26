import 'dart:io';

import 'package:flutter/foundation.dart';

/// Optional HTTP overrides for local development only.
///
/// Disabled in release builds. In debug, enable only when explicitly passed:
/// `--dart-define=ALLOW_BAD_CERT=true`
class MyHttpOverrides extends HttpOverrides {
  static bool get isEnabled {
    return kDebugMode &&
        const bool.fromEnvironment('ALLOW_BAD_CERT', defaultValue: false);
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => isEnabled;
  }
}

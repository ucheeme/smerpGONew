import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smerp_go/core/logging/sensitive_log_sanitizer.dart';
import 'package:smerp_go/core/network/api_constants.dart';
import 'package:smerp_go/core/network/connectivity_status.dart';
import 'package:smerp_go/utils/app_services/httpHelper.dart';

void main() {
  group('Android Play target API', () {
    test('app build.gradle targets API 36 for Google Play compliance', () {
      final buildGradle = File('android/app/build.gradle');
      expect(buildGradle.existsSync(), isTrue);

      final contents = buildGradle.readAsStringSync();
      expect(contents, contains('compileSdkVersion 36'));
      expect(contents, contains('targetSdkVersion 36'));
      expect(contents, isNot(contains('compileSdkVersion 35')));
      expect(contents, isNot(contains('targetSdkVersion 35')));
    });
  });

  group('SensitiveLogSanitizer', () {
    test('redacts authorization header', () {
      final redacted = SensitiveLogSanitizer.redactHeaders({
        'Authorization': 'Bearer secret-token',
        'Content-Type': 'application/json',
      });

      expect(redacted['Authorization'], 'Bearer [REDACTED]');
      expect(redacted['Content-Type'], 'application/json');
    });

    test('redacts sensitive json body fields', () {
      final redacted = SensitiveLogSanitizer.redactBody(
        '{"username":"merchant","pin":"1234","token":"abc"}',
      );

      expect(redacted, contains('"pin":"[REDACTED]"'));
      expect(redacted, contains('"token":"[REDACTED]"'));
      expect(redacted, contains('"username":"merchant"'));
    });
  });

  group('ConnectivityStatus', () {
    test('returns true when wifi is available', () {
      expect(
        ConnectivityStatus.hasActiveConnection(
          [ConnectivityResult.wifi],
        ),
        isTrue,
      );
    });

    test('returns false when no active connection exists', () {
      expect(
        ConnectivityStatus.hasActiveConnection(
          [ConnectivityResult.none],
        ),
        isFalse,
      );
    });
  });

  group('ApiConstants', () {
    test('uses a 30 second request timeout', () {
      expect(ApiConstants.requestTimeout, const Duration(seconds: 30));
    });
  });

  group('MyHttpOverrides', () {
    test('is disabled by default in tests', () {
      expect(MyHttpOverrides.isEnabled, isFalse);
    });
  });

  group('print migration', () {
    test('hot-path util and auth screens have no active print() calls', () {
      const paths = [
        'lib/utils/appDesignUtil.dart',
        'lib/utils/fileStorage.dart',
        'lib/utils/collectionUiKits.dart',
        'lib/screens/bottomsheets/newUpdate.dart',
        'lib/screens/bottomsheets/dateRangeFilter.dart',
        'lib/screens/bottomsheets/productCategory.dart',
        'lib/screens/bottomsheets/unitofmeasurement.dart',
        'lib/screens/bottomNav/screens/inventory/addNewProduct.dart',
        'lib/screens/authentication_signup/signInFlow/forgotPin.dart',
        'lib/screens/authentication_signup/signInFlow/forgotOTP.dart',
        'lib/screens/authentication_signup/signUpFlow/signUpOTP.dart',
      ];

      final activePrint = RegExp(r'^\s*print\s*\(');
      for (final path in paths) {
        final file = File(path);
        expect(file.existsSync(), isTrue, reason: path);
        final lines = file.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          if (line.trimLeft().startsWith('//')) continue;
          expect(
            activePrint.hasMatch(line),
            isFalse,
            reason: 'active print() in $path:${i + 1}: $line',
          );
        }
      }
    });
  });
}

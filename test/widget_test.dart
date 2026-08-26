import 'package:flutter_test/flutter_test.dart';
import 'package:smerp_go/core/logging/sensitive_log_sanitizer.dart';

void main() {
  test('legacy widget test placeholder replaced by modernization suite', () {
    expect(
      SensitiveLogSanitizer.redactBody('{"pin":"9999"}'),
      '{"pin":"[REDACTED]"}',
    );
  });
}

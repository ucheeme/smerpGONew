import 'package:flutter_test/flutter_test.dart';
import 'package:smerp_go/core/logging/app_error_reporter.dart';

void main() {
  test('recordNonFatal is safe to call in debug tests', () {
    expect(
      () => AppErrorReporter.recordNonFatal(
        Exception('test'),
        StackTrace.current,
        reason: 'unit_test',
      ),
      returnsNormally,
    );
  });
}

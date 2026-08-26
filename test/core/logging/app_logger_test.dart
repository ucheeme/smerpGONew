import 'package:flutter_test/flutter_test.dart';
import 'package:smerp_go/core/logging/app_logger.dart';

void main() {
  test('error logging delegates to AppErrorReporter without throwing', () {
    expect(
      () => AppLogger.error(
        Exception('test'),
        StackTrace.current,
        reason: 'unit_test',
        tag: 'Test',
      ),
      returnsNormally,
    );
  });

  test('logApi is safe to call in tests', () {
    expect(
      () => AppLogger.logApi(
        method: 'GET',
        url: Uri.parse('https://example.com/api'),
        headers: const {'Authorization': 'Bearer secret-token'},
        body: '{"pin":"1234"}',
      ),
      returnsNormally,
    );
  });

  test('debug and info are safe to call in tests', () {
    expect(() => AppLogger.debug('debug message', tag: 'Test'), returnsNormally);
    expect(() => AppLogger.info('info message', tag: 'Test'), returnsNormally);
    expect(() => AppLogger.warning('warn message', tag: 'Test'), returnsNormally);
  });
}

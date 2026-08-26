import 'package:flutter_test/flutter_test.dart';
import 'package:smerp_go/core/session/session_restore.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/UserUtils.dart';

void main() {
  const sampleLoginJson = '''
{
  "userId": "user-1",
  "firstName": "Ada",
  "lastName": "Lovelace",
  "storeName": "Ada Store",
  "merchantCode": "MC001",
  "storeLink": "https://example.com",
  "avatar": "https://example.com/avatar.png",
  "token": "stored-token",
  "storeEmailAddress": "ada@example.com"
}
''';

  group('SessionRestore', () {
    test('parseStoredLoginData decodes persisted login payload', () {
      final loginData = SessionRestore.parseStoredLoginData(sampleLoginJson);

      expect(loginData, isNotNull);
      expect(loginData!.userId, 'user-1');
      expect(loginData.token, 'stored-token');
    });

    test('parseStoredLoginData returns null for invalid payload', () {
      expect(SessionRestore.parseStoredLoginData(''), isNull);
      expect(SessionRestore.parseStoredLoginData('not-json'), isNull);
    });

    test('resolveAccessToken prefers secure storage token', () {
      expect(
        SessionRestore.resolveAccessToken(
          secureToken: 'secure-token',
          fallbackToken: 'legacy-token',
        ),
        'secure-token',
      );
    });

    test('resolveAccessToken falls back to persisted login token', () {
      expect(
        SessionRestore.resolveAccessToken(
          secureToken: null,
          fallbackToken: 'legacy-token',
        ),
        'legacy-token',
      );
    });

    test('applyLoginData hydrates in-memory auth globals', () {
      final loginData = SessionRestore.parseStoredLoginData(sampleLoginJson)!;

      SessionRestore.applyLoginData(loginData);

      expect(userAccessToken, isEmpty);
      expect(actionBy, isNotEmpty);
      expect(userMerchantCode, 'MC001');
      expect(userFirstName, 'Ada');
      expect(userBusinessName.value, 'Ada Store');
      expect(loginData?.userId, 'user-1');
    });
  });
}

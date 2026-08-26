import 'package:flutter_test/flutter_test.dart';
import 'package:smerp_go/core/session/credential_storage.dart';
import 'package:smerp_go/core/session/credential_storage_keys.dart';
import 'package:smerp_go/model/response/LoginResponse.dart';

void main() {
  group('CredentialStorage', () {
    test('defaults secure storage to enabled', () {
      expect(CredentialStorage.defaultSecureStorageEnabled, isTrue);
      expect(CredentialStorageKeys.remoteConfigFlag, 'useSecureAuthStorage');
    });

    test('sanitizeLoginJson redacts token when requested', () {
      final sanitized = CredentialStorage.sanitizeLoginJson(
        {
          'userId': 'user-1',
          'token': 'super-secret-token',
          'firstName': 'Ada',
        },
        redactToken: true,
      );

      expect(sanitized['token'], isEmpty);
      expect(sanitized['userId'], 'user-1');
      expect(sanitized['firstName'], 'Ada');
    });

    test('sanitizeLoginJson keeps token when redaction disabled', () {
      final sanitized = CredentialStorage.sanitizeLoginJson(
        {
          'userId': 'user-1',
          'token': 'super-secret-token',
        },
        redactToken: false,
      );

      expect(sanitized['token'], 'super-secret-token');
    });

    test('sanitizeLoginJson does not mutate the original map', () {
      final original = {
        'userId': 'user-1',
        'token': 'super-secret-token',
      };

      CredentialStorage.sanitizeLoginJson(original, redactToken: true);

      expect(original['token'], 'super-secret-token');
    });
  });

  group('LoginData persistence compatibility', () {
    test('fromJson tolerates missing token after secure redaction', () {
      final data = LoginData.fromJson({
        'userId': 'user-1',
        'firstName': 'Ada',
        'lastName': 'Lovelace',
        'storeName': 'Ada Store',
        'merchantCode': 'MC001',
        'storeLink': 'https://example.com',
        'avatar': '',
        'storeEmailAddress': 'ada@example.com',
      });

      expect(data.token, isEmpty);
      expect(data.userId, 'user-1');
    });
  });
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smerp_go/core/logging/app_logger.dart';
import 'package:smerp_go/core/session/shared_pref_string_codec.dart';
import 'package:smerp_go/core/session/credential_storage_keys.dart';
import 'package:smerp_go/main.dart';
import 'package:smerp_go/utils/UserUtils.dart';

/// Stores sensitive credentials in secure storage by default.
///
/// Remote Config flag [CredentialStorageKeys.remoteConfigFlag] can disable
/// secure storage as an emergency kill-switch (falls back to SharedPreferences
/// for PIN only). Access tokens are never written to SharedPreferences when
/// secure storage is enabled.
class CredentialStorage {
  CredentialStorage._();

  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// In-app default when Remote Config is unavailable or unset.
  static const bool defaultSecureStorageEnabled = true;

  static Future<bool> isSecureStorageEnabled() async {
    try {
      return remoteConfig.getBool(CredentialStorageKeys.remoteConfigFlag);
    } catch (_) {
      return defaultSecureStorageEnabled;
    }
  }

  static Future<void> savePin(String pin) async {
    if (await isSecureStorageEnabled()) {
      await _secureStorage.write(
        key: CredentialStorageKeys.userPin,
        value: pin,
      );
      await SharedPref.remove(CredentialStorageKeys.userPin);
      return;
    }

    await SharedPref.save(CredentialStorageKeys.userPin, pin);
  }

  static Future<String?> readPin() async {
    if (await isSecureStorageEnabled()) {
      final securePin = await _secureStorage.read(
        key: CredentialStorageKeys.userPin,
      );
      if (securePin != null && securePin.isNotEmpty) {
        return securePin;
      }

      final legacyPin = await _readLegacySharedPrefString(
        CredentialStorageKeys.userPin,
      );
      if (legacyPin != null && legacyPin.isNotEmpty) {
        await savePin(legacyPin);
        AppLogger.debug('Migrated legacy PIN into secure storage', tag: 'Session');
      }
      return legacyPin;
    }

    return _readLegacySharedPrefString(CredentialStorageKeys.userPin);
  }

  static Future<void> saveAccessToken(String token) async {
    if (token.isEmpty) {
      return;
    }

    if (await isSecureStorageEnabled()) {
      await _secureStorage.write(
        key: CredentialStorageKeys.accessToken,
        value: token,
      );
      return;
    }

    AppLogger.warning(
      'Secure storage disabled; access token not persisted to disk',
      tag: 'Session',
    );
  }

  static Future<String?> readAccessToken() async {
    if (!await isSecureStorageEnabled()) {
      return null;
    }

    return _secureStorage.read(key: CredentialStorageKeys.accessToken);
  }

  /// Returns a copy of [loginJson] safe for SharedPreferences.
  ///
  /// When secure storage is enabled, the access token is redacted so it is
  /// not duplicated in plaintext prefs.
  static Future<Map<String, dynamic>> sanitizeLoginJsonForPersistence(
    Map<String, dynamic> loginJson,
  ) async {
    return sanitizeLoginJson(
      loginJson,
      redactToken: await isSecureStorageEnabled(),
    );
  }

  /// Pure helper for unit tests and callers that already know the flag.
  static Map<String, dynamic> sanitizeLoginJson(
    Map<String, dynamic> loginJson, {
    required bool redactToken,
  }) {
    final copy = Map<String, dynamic>.from(loginJson);
    if (redactToken) {
      copy['token'] = '';
    }
    return copy;
  }

  static Future<void> clearAll() async {
    await _secureStorage.delete(key: CredentialStorageKeys.userPin);
    await _secureStorage.delete(key: CredentialStorageKeys.accessToken);
  }

  static Future<String?> _readLegacySharedPrefString(String key) async {
    final raw = await SharedPref.read(key);
    return SharedPrefStringCodec.decode(raw);
  }
}

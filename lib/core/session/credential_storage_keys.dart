/// Remote Config flag and storage keys for credential handling.
class CredentialStorageKeys {
  CredentialStorageKeys._();

  /// When `true` (app default), PIN and access token use secure storage.
  /// Set to `false` in Remote Config only as an emergency kill-switch.
  static const remoteConfigFlag = 'useSecureAuthStorage';

  static const userPin = 'userPin';
  static const accessToken = 'userAccessToken';
}

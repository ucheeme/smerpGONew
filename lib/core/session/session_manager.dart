import 'package:get/get.dart';
import 'package:smerp_go/core/cache/app_list_cache.dart';
import 'package:smerp_go/core/logging/app_logger.dart';
import 'package:smerp_go/core/session/auth_session.dart';
import 'package:smerp_go/core/session/credential_storage.dart';
import 'package:smerp_go/core/session/session_restore.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/UserUtils.dart';
import 'package:smerp_go/utils/mockdata/tempData.dart';

/// Centralized session lifecycle for logout and auth expiry flows.
class SessionManager {
  SessionManager._();

  static const _sharedPreferenceKeys = <String>[
    'userPin',
    'userInfo',
    'userId',
    'userIdentityValue',
    'userFirstName',
    'userImage',
    'userBusinessName',
  ];

  static Future<void> clearSession() async {
    clearInMemoryState();
    await clearPersistedCredentials();
  }

  /// Rehydrates auth globals after a cold start when [keepUserInfo] is enabled.
  ///
  /// PIN entry is still required before navigation; this only restores the
  /// persisted access token and profile snapshot needed by API headers.
  static Future<bool> restoreSessionFromStorage() async {
    if (!await SharedPref.getBool('keepUserInfo')) {
      return false;
    }

    await SessionRestore.restoreProfileFieldsFromPrefs();

    final storedLogin = SessionRestore.parseStoredLoginData(
      await SharedPref.read('userInfo'),
    );
    if (storedLogin != null) {
      SessionRestore.applyLoginData(storedLogin);
    }

    final secureToken = await CredentialStorage.readAccessToken();
    final resolvedToken = SessionRestore.resolveAccessToken(
      secureToken: secureToken,
      fallbackToken: storedLogin?.token,
    );

    if (resolvedToken == null) {
      AppLogger.debug('No persisted access token to restore', tag: 'Session');
      return false;
    }

    userAccessToken = resolvedToken;

    if (await CredentialStorage.isSecureStorageEnabled()) {
      if (secureToken == null || secureToken.isEmpty) {
        await CredentialStorage.saveAccessToken(resolvedToken);
        AppLogger.debug('Migrated legacy access token into secure storage',
            tag: 'Session');
      }

      // Remove plaintext token from SharedPreferences after migration.
      if (storedLogin != null &&
          storedLogin.token.isNotEmpty &&
          storedLogin.token == resolvedToken) {
        final redacted = CredentialStorage.sanitizeLoginJson(
          storedLogin.toJson(),
          redactToken: true,
        );
        await SharedPref.save('userInfo', redacted);
      }
    }

    AppLogger.debug('Session token restored from storage', tag: 'Session');
    return true;
  }

  static void clearInMemoryState() {
    AppListCache.invalidateAll();
    AuthSession.instance.clear();

    productCategoryList = [];
    productUnitCategoryList = [];
    inventoryListTemp = [];
    catalogListTemp = [];
    catalogsFTemp = [];
    saleListTemp = [];
    collectionInventoryListTemp = [];
    collectionListTemp = [];
    notificationListTemp = [];
    orderListTemp = [];

    isLoading.value = false;
    isSignUpViaPhone.value = true;

    isProductCategoryHasRun = Rx(false);
    isProductUnitCategoryHasRun = Rx(false);
    isInventoryListHasRun = false;
    isSalesListHasRun = false;
    isOrderListHasRun = false;
    isCatalogListHasRun = Rx(false);
    saleIsEmpty = RxBool(false);
    productIsEmpty = RxBool(false);
    orderListIsEmpty = RxBool(false);
    isCreatedSale.value = false;
    isCreatedProduct.value = false;
    isFirstTimeReport.value = true;
  }

  static Future<void> clearPersistedCredentials() async {
    await CredentialStorage.clearAll();

    for (final key in _sharedPreferenceKeys) {
      await SharedPref.remove(key);
    }

    await SharedPref.saveBool('keepUserInfo', false);
  }
}

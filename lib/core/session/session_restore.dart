import 'dart:convert';

import 'package:smerp_go/core/logging/app_logger.dart';
import 'package:smerp_go/core/session/shared_pref_string_codec.dart';
import 'package:smerp_go/model/response/LoginResponse.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/UserUtils.dart';
import 'package:smerp_go/utils/appUrl.dart';

/// Helpers for rebuilding in-memory auth state after a cold start.
class SessionRestore {
  SessionRestore._();

  static LoginData? parseStoredLoginData(String raw) {
    if (raw.isEmpty) {
      return null;
    }

    try {
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) {
        return LoginData.fromJson(decoded);
      }
    } catch (e, trace) {
      AppLogger.error(e, trace, reason: 'parseStoredLoginData', tag: 'Session');
    }

    return null;
  }

  static void applyLoginData(LoginData data) {
    loginData = data;
    actionBy = AppUrls().getActionBy(data.userId);
    userMerchantCode = data.merchantCode;
    userName = '${data.firstName} ${data.lastName}';
    userEmail = data.storeEmail;
    userFirstName = data.firstName;
    userFirstNameS.value = data.firstName;
    userBusinessName.value = data.storeName;
    if (data.avatar.isNotEmpty) {
      userImage.value = data.avatar;
    }
  }

  static String? resolveAccessToken({
    required String? secureToken,
    required String? fallbackToken,
  }) {
    if (secureToken != null && secureToken.isNotEmpty) {
      return secureToken;
    }
    if (fallbackToken != null && fallbackToken.isNotEmpty) {
      return fallbackToken;
    }
    return null;
  }

  static Future<void> restoreProfileFieldsFromPrefs() async {
    final identity = SharedPrefStringCodec.decode(
      await SharedPref.read('userIdentityValue'),
    );
    if (identity != null && identity.isNotEmpty) {
      userIdentityValue = identity;
    }

    final firstName = SharedPrefStringCodec.decode(
      await SharedPref.read('userFirstName'),
    );
    if (firstName != null && firstName.isNotEmpty) {
      userFirstName = firstName;
      userFirstNameS.value = firstName;
    }

    final image = SharedPrefStringCodec.decode(
      await SharedPref.read('userImage'),
    );
    if (image != null && image.isNotEmpty) {
      userImage.value = image;
    }
  }
}

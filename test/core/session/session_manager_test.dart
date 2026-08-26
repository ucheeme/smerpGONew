import 'package:flutter_test/flutter_test.dart';
import 'package:smerp_go/core/cache/app_list_cache.dart';
import 'package:smerp_go/core/cache/app_list_cache_keys.dart';
import 'package:smerp_go/core/session/session_manager.dart';
import 'package:smerp_go/core/session/shared_pref_string_codec.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/UserUtils.dart';

void main() {
  group('SharedPrefStringCodec', () {
    test('decodes json-encoded string values', () {
      expect(SharedPrefStringCodec.decode('"1234"'), '1234');
    });

    test('returns null for empty values', () {
      expect(SharedPrefStringCodec.decode(''), isNull);
    });
  });

  group('SessionManager', () {
    test('clearInMemoryState resets auth and cache globals', () {
      userAccessToken = 'token';
      loginData = null;
      userIdentityValue = 'merchant-1';
      userBusinessName.value = 'Store';
      isSalesListHasRun = true;
      isOrderListHasRun = true;
      AppListCache.markFresh(AppListCacheKeys.sales);
      AppListCache.markFresh(AppListCacheKeys.orders);

      SessionManager.clearInMemoryState();

      expect(userAccessToken, '');
      expect(userIdentityValue, isNull);
      expect(userBusinessName.value, '');
      expect(isSalesListHasRun, isFalse);
      expect(isOrderListHasRun, isFalse);
      expect(AppListCache.isFresh(AppListCacheKeys.sales), isFalse);
      expect(AppListCache.hasLoaded(AppListCacheKeys.sales), isFalse);
      expect(AppListCache.hasLoaded(AppListCacheKeys.orders), isFalse);
    });
  });
}

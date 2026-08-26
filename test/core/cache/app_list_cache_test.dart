import 'package:flutter_test/flutter_test.dart';
import 'package:smerp_go/core/cache/app_list_cache.dart';
import 'package:smerp_go/core/cache/app_list_cache_keys.dart';

void main() {
  setUp(() {
    AppListCache.debugReset(
      clockOverride: () => DateTime(2026, 1, 1, 12, 0, 0),
    );
  });

  tearDown(() {
    AppListCache.debugReset();
  });

  group('AppListCache', () {
    test('isFresh is false before markFresh', () {
      expect(AppListCache.isFresh(AppListCacheKeys.inventory), isFalse);
    });

    test('markFresh makes entry fresh within TTL', () {
      AppListCache.markFresh(AppListCacheKeys.sales);
      expect(AppListCache.isFresh(AppListCacheKeys.sales), isTrue);
      expect(AppListCache.hasLoaded(AppListCacheKeys.sales), isTrue);
      expect(
        AppListCache.shouldServe(AppListCacheKeys.sales, true),
        isTrue,
      );
      expect(AppListCache.shouldServeKey(AppListCacheKeys.sales), isTrue);
    });

    test('shouldServe is false when hasRunFlag is false even if marked', () {
      AppListCache.markFresh(AppListCacheKeys.orders);
      expect(
        AppListCache.shouldServe(AppListCacheKeys.orders, false),
        isFalse,
      );
    });

    test('setHasLoaded alone does not make shouldServeKey true without TTL', () {
      AppListCache.setHasLoaded(AppListCacheKeys.inventory, true);
      expect(AppListCache.hasLoaded(AppListCacheKeys.inventory), isTrue);
      expect(AppListCache.shouldServeKey(AppListCacheKeys.inventory), isFalse);
    });

    test('invalidate clears hasLoaded and freshness', () {
      AppListCache.markFresh(AppListCacheKeys.inventory);
      AppListCache.invalidate(AppListCacheKeys.inventory);
      expect(AppListCache.hasLoaded(AppListCacheKeys.inventory), isFalse);
      expect(AppListCache.isFresh(AppListCacheKeys.inventory), isFalse);
    });

    test('entry expires after TTL elapses', () {
      final start = DateTime(2026, 1, 1, 12, 0, 0);
      AppListCache.debugReset(clockOverride: () => start);
      AppListCache.markFresh(AppListCacheKeys.orders);

      // Orders TTL is 2 minutes.
      AppListCache.clock = () => start.add(const Duration(minutes: 2, seconds: 1));

      expect(AppListCache.isFresh(AppListCacheKeys.orders), isFalse);
      expect(
        AppListCache.shouldServe(AppListCacheKeys.orders, true),
        isFalse,
      );
      expect(AppListCache.fetchedAt(AppListCacheKeys.orders), isNull);
      expect(AppListCache.hasLoaded(AppListCacheKeys.orders), isFalse);
    });

    test('invalidateAll clears every key', () {
      AppListCache.markFresh(AppListCacheKeys.inventory);
      AppListCache.markFresh(AppListCacheKeys.catalog);
      AppListCache.invalidateAll();

      expect(AppListCache.isFresh(AppListCacheKeys.inventory), isFalse);
      expect(AppListCache.isFresh(AppListCacheKeys.catalog), isFalse);
    });

    test('sales shouldServeKey follows markFresh and TTL', () {
      final start = DateTime(2026, 1, 1, 12, 0, 0);
      AppListCache.debugReset(clockOverride: () => start);
      AppListCache.markFresh(AppListCacheKeys.sales);

      expect(AppListCache.shouldServeKey(AppListCacheKeys.sales), isTrue);

      // Sales TTL is 3 minutes.
      AppListCache.clock =
          () => start.add(const Duration(minutes: 3, seconds: 1));
      expect(AppListCache.shouldServeKey(AppListCacheKeys.sales), isFalse);
      expect(AppListCache.hasLoaded(AppListCacheKeys.sales), isFalse);
    });

    test('orders shouldServeKey follows markFresh and 2-minute TTL', () {
      final start = DateTime(2026, 1, 1, 12, 0, 0);
      AppListCache.debugReset(clockOverride: () => start);
      AppListCache.markFresh(AppListCacheKeys.orders);

      expect(AppListCache.shouldServeKey(AppListCacheKeys.orders), isTrue);

      AppListCache.clock =
          () => start.add(const Duration(minutes: 2, seconds: 1));
      expect(AppListCache.shouldServeKey(AppListCacheKeys.orders), isFalse);
      expect(AppListCache.hasLoaded(AppListCacheKeys.orders), isFalse);
    });

    test('custom ttl override is respected', () {
      final start = DateTime(2026, 1, 1, 12, 0, 0);
      AppListCache.debugReset(clockOverride: () => start);
      AppListCache.markFresh(AppListCacheKeys.inventory);

      AppListCache.clock = () => start.add(const Duration(seconds: 30));
      expect(
        AppListCache.isFresh(
          AppListCacheKeys.inventory,
          ttl: const Duration(seconds: 10),
        ),
        isFalse,
      );
    });
  });
}

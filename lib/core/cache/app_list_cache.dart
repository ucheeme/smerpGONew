import 'package:smerp_go/core/cache/app_list_cache_keys.dart';

/// Owns TTL metadata and has-run state for in-memory list caches (`tempData` globals).
///
/// The list payloads remain in existing globals for backward compatibility.
/// This layer tracks freshness so screens can skip stale data and refetch.
class AppListCache {
  AppListCache._();

  /// Default TTL for list caches when a key-specific override is absent.
  static const Duration defaultTtl = Duration(minutes: 5);

  /// Per-key TTLs for caches that should refresh more or less often.
  static const Map<String, Duration> ttlByKey = {
    AppListCacheKeys.inventory: Duration(minutes: 5),
    AppListCacheKeys.sales: Duration(minutes: 3),
    AppListCacheKeys.orders: Duration(minutes: 2),
    AppListCacheKeys.catalog: Duration(minutes: 5),
    AppListCacheKeys.collections: Duration(minutes: 5),
    AppListCacheKeys.notifications: Duration(minutes: 2),
    AppListCacheKeys.productCategories: Duration(minutes: 30),
    AppListCacheKeys.productUnitCategories: Duration(minutes: 30),
  };

  static final Map<String, DateTime> _fetchedAt = {};
  static final Map<String, bool> _hasLoaded = {};

  /// Injectable clock for deterministic unit tests.
  static DateTime Function() clock = DateTime.now;

  static Duration ttlFor(String key) => ttlByKey[key] ?? defaultTtl;

  /// Whether this key has completed at least one load this session.
  static bool hasLoaded(String key) => _hasLoaded[key] == true;

  /// Sets session has-run state without changing the TTL timestamp.
  ///
  /// Prefer [markFresh] after a successful fetch; use this to mirror legacy
  /// flags (including marking loaded after a failed call that still exits the
  /// loading path).
  static void setHasLoaded(String key, bool value) {
    if (value) {
      _hasLoaded[key] = true;
    } else {
      _hasLoaded.remove(key);
    }
  }

  /// Marks [key] as freshly fetched at [at] (defaults to now).
  ///
  /// Also sets has-run so [shouldServeKey] can work without a separate flag.
  static void markFresh(String key, {DateTime? at}) {
    _fetchedAt[key] = at ?? clock();
    _hasLoaded[key] = true;
  }

  static DateTime? fetchedAt(String key) => _fetchedAt[key];

  static bool isFresh(String key, {Duration? ttl}) {
    final timestamp = _fetchedAt[key];
    if (timestamp == null) {
      return false;
    }
    return clock().difference(timestamp) < (ttl ?? ttlFor(key));
  }

  /// Returns true when the legacy [hasRunFlag] is set and the TTL is still valid.
  ///
  /// When expired, invalidates the key so the next write can mark it fresh again.
  static bool shouldServe(String key, bool hasRunFlag, {Duration? ttl}) {
    if (!hasRunFlag) {
      return false;
    }
    if (isFresh(key, ttl: ttl)) {
      return true;
    }
    invalidate(key);
    return false;
  }

  /// Same as [shouldServe] using cache-owned has-run state for [key].
  static bool shouldServeKey(String key, {Duration? ttl}) {
    return shouldServe(key, hasLoaded(key), ttl: ttl);
  }

  static void invalidate(String key) {
    _fetchedAt.remove(key);
    _hasLoaded.remove(key);
  }

  static void invalidateAll() {
    _fetchedAt.clear();
    _hasLoaded.clear();
  }

  /// Test-only reset of clock + timestamps + has-run flags.
  static void debugReset({DateTime Function()? clockOverride}) {
    _fetchedAt.clear();
    _hasLoaded.clear();
    clock = clockOverride ?? DateTime.now;
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Shared network-image caching helpers.
///
/// All remote product/avatar URLs should resolve through this layer so disk
/// and memory caches stay consistent across screens.
class AppNetworkImage {
  AppNetworkImage._();

  static const String placeholderAsset = 'assets/pCircle.png';

  static CacheManager? _cacheManager;

  /// Cache manager used for URL → file lookups (including base64 conversion).
  ///
  /// Lazily created so unit tests that only validate URL helpers do not touch
  /// platform plugins (path_provider / sqflite).
  static CacheManager get cacheManager =>
      _cacheManager ??= DefaultCacheManager();

  /// Test seam for injecting a fake cache manager.
  @visibleForTesting
  static set cacheManagerOverride(CacheManager? manager) {
    _cacheManager = manager;
  }

  /// Returns true when [url] is a non-empty http(s) URL.
  static bool isRemoteUrl(String? url) {
    if (url == null) {
      return false;
    }
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      return false;
    }
    final uri = Uri.tryParse(trimmed);
    if (uri == null) {
      return false;
    }
    return uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  /// ImageProvider with disk/memory cache for remote URLs.
  ///
  /// Falls back to [placeholderAsset] when [url] is empty or invalid.
  static ImageProvider provider(String url) {
    if (!isRemoteUrl(url)) {
      return const AssetImage(placeholderAsset);
    }
    return CachedNetworkImageProvider(url.trim());
  }

  /// Convenience [Image] widget matching the app's historical fit/error UX.
  static Image image(
    String url, {
    BoxFit fit = BoxFit.fill,
    ImageErrorWidgetBuilder? errorBuilder,
  }) {
    return Image(
      image: provider(url),
      fit: fit,
      errorBuilder: errorBuilder ??
          (context, error, stackTrace) {
            return const Image(
              image: AssetImage(placeholderAsset),
              fit: BoxFit.fill,
            );
          },
    );
  }

  /// Loads bytes for [url], preferring the on-disk image cache when present.
  static Future<List<int>> loadBytes(String url) async {
    if (!isRemoteUrl(url)) {
      throw ArgumentError.value(url, 'url', 'Expected a remote http(s) URL');
    }
    final trimmed = url.trim();
    final cached = await cacheManager.getFileFromCache(trimmed);
    if (cached != null) {
      return cached.file.readAsBytes();
    }
    final file = await cacheManager.getSingleFile(trimmed);
    return file.readAsBytes();
  }
}

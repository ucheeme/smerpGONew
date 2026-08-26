import 'package:smerp_go/model/response/catalogListResponse.dart';

/// Catalog mutation / visibility data access for Cubits.
abstract class ICatalogRepository {
  /// Updates visibility for all catalog products in [category], then refreshes
  /// the in-memory catalog list so UI sees the change immediately.
  Future<bool> updateCatalogAllProductCata(bool isVisible, int category);

  /// Updates visibility for every catalog product, then refreshes caches.
  Future<bool> updateCatalogAllProduct(bool isVisible);

  /// Reloads catalog-as-shown list into shared in-memory caches.
  Future<List<CatalogData>> refreshCatalogListAsShownToUsers();
}

import 'package:smerp_go/Reposistory/apiRepo.dart';
import 'package:smerp_go/apiServiceLayer/apiService.dart';
import 'package:smerp_go/apiServiceLayer/api_status.dart';
import 'package:smerp_go/core/cache/app_list_cache.dart';
import 'package:smerp_go/core/cache/app_list_cache_keys.dart';
import 'package:smerp_go/core/repositories/i_catalog_repository.dart';
import 'package:smerp_go/model/response/catalogListResponse.dart';
import 'package:smerp_go/model/response/defaultApiResponse.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/app_services/helperClass.dart';
import 'package:smerp_go/utils/appUrl.dart';
import 'package:smerp_go/utils/mockdata/tempData.dart';

/// Catalog write operations previously invoked via [CatalogueController].
class CatalogRepo extends ApiRepository implements ICatalogRepository {
  @override
  Future<bool> updateCatalogAllProductCata(bool isVisible, int category) async {
    return _updateVisibility(
      url: AppUrls().updateCatalogProductAtCategoryRecord(category, isVisible),
      operation: 'updateCatalogAllProductCata',
    );
  }

  @override
  Future<bool> updateCatalogAllProduct(bool isVisible) async {
    return _updateVisibility(
      url: AppUrls().updateAllProductCatalogView(isVisible),
      operation: 'updateCatalogAllProduct',
    );
  }

  Future<bool> _updateVisibility({
    required String url,
    required String operation,
  }) async {
    final response = await ApiService.makeApiCall(
      null,
      url,
      method: HTTP_METHODS.put,
    );

    if (response is Success) {
      try {
        final data =
            defaultApiResponseFromJson(await response.response as String);
        if (data.isSuccess) {
          await refreshCatalogListAsShownToUsers();
          logRepoSuccess(operation);
          return true;
        }
        logRepoFailure(operation, data);
        return false;
      } catch (e, trace) {
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        return false;
      }
    }

    logRepoFailure(operation, response);
    handleErrorResponse(response);
    return false;
  }

  @override
  Future<List<CatalogData>> refreshCatalogListAsShownToUsers() async {
    final response = await ApiService.makeApiCall(
      null,
      AppUrls().getCatalogListAsShownToUsers,
      method: HTTP_METHODS.get,
    );

    if (response is! Success) {
      handleErrorResponse(response);
      return const [];
    }

    try {
      final parsed =
          catalogListResponseFromJson(await response.response as String);
      if (!parsed.isSuccess || parsed.data == null) {
        return const [];
      }

      catalogListTemp = parsed.data!;
      rebuildCatalogsFTemp(catalogListTemp);
      AppListCache.markFresh(AppListCacheKeys.catalog);
      isCatalogListHasRun.value = true;
      logRepoSuccess(
        'refreshCatalogListAsShownToUsers',
        count: catalogListTemp.length,
      );
      return catalogListTemp;
    } catch (e, trace) {
      AppUtils.debug(e.toString());
      AppUtils.debug(trace.toString());
      return const [];
    }
  }

  /// Rebuilds [catalogsFTemp] from inventory + visible catalog IDs.
  static List<CatalogFull> rebuildCatalogsFTemp(List<CatalogData> data) {
    catalogsFTemp.clear();
    if (data.isEmpty) {
      for (final element in inventoryListTemp) {
        catalogsFTemp.add(CatalogFull(element, false));
      }
      return catalogsFTemp;
    }

    for (final element in inventoryListTemp) {
      var found = false;
      for (final catalog in data) {
        if (catalog.id == element.id) {
          found = true;
          break;
        }
      }
      catalogsFTemp.add(CatalogFull(element, found));
    }
    return catalogsFTemp;
  }
}

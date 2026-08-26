import 'package:flutter_test/flutter_test.dart';
import 'package:smerp_go/Reposistory/catalogMutationRepo.dart';
import 'package:smerp_go/Reposistory/productListRepo.dart';
import 'package:smerp_go/core/repositories/app_repositories.dart';
import 'package:smerp_go/core/repositories/i_catalog_repository.dart';
import 'package:smerp_go/core/repositories/i_collection_repository.dart';
import 'package:smerp_go/core/repositories/i_order_history_repository.dart';

void main() {
  tearDown(() {
    AppRepositories.debugReset();
  });

  test('AppRepositories collection default is CollectionRepo', () {
    expect(AppRepositories.collection, isA<CollectionRepo>());
    expect(AppRepositories.collection, isA<ICollectionRepository>());
  });

  test('AppRepositories catalog default is CatalogRepo', () {
    expect(AppRepositories.catalog, isA<CatalogRepo>());
    expect(AppRepositories.catalog, isA<ICatalogRepository>());
  });

  test('AppRepositories.debugOverride replaces order history repo', () {
    final fake = _FakeOrderHistoryRepo();
    AppRepositories.debugOverride(orderHistoryRepo: fake);
    expect(AppRepositories.orderHistory, same(fake));
  });
}

class _FakeOrderHistoryRepo implements IOrderHistoryRepository {
  @override
  Future<Object> getOrderHistory() async => <Object>[];
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smerp_go/Reposistory/catalogMutationRepo.dart';
import 'package:smerp_go/model/response/catalogListResponse.dart';
import 'package:smerp_go/model/response/inventoryList.dart';
import 'package:smerp_go/utils/mockdata/tempData.dart';

InventoryInfo _item(int id, String name) {
  return InventoryInfo(
    id: id,
    productName: name,
    productCategory: 'Fashion',
    purchasePrice: 1,
    quantity: 1,
    sellingPrice: 1,
    unitCategory: 'pcs',
    createdBy: 'test',
    createdOn: DateTime(2026, 1, 1),
    updatedBy: 'test',
    timeStamp: DateTime(2026, 1, 1),
  );
}

void main() {
  tearDown(() {
    inventoryListTemp = [];
    catalogsFTemp = [];
    catalogListTemp = [];
  });

  test('rebuildCatalogsFTemp marks inventory items visible when in catalog', () {
    inventoryListTemp = [_item(1, 'A'), _item(2, 'B')];

    final rebuilt = CatalogRepo.rebuildCatalogsFTemp([
      CatalogData(
        id: 2,
        productName: 'B',
        productCategory: 'Fashion',
        productUnitCategory: 'pcs',
        sellingPrice: 1,
      ),
    ]);

    expect(rebuilt.length, 2);
    expect(rebuilt[0].isVisible, isFalse);
    expect(rebuilt[1].isVisible, isTrue);
  });

  test('rebuildCatalogsFTemp marks all invisible when catalog empty', () {
    inventoryListTemp = [_item(9, 'Only')];

    final rebuilt = CatalogRepo.rebuildCatalogsFTemp(const []);
    expect(rebuilt.single.isVisible, isFalse);
  });
}

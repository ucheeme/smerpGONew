/// Collection / product-list data access for Cubits.
abstract class ICollectionRepository {
  Future<Object> getProductList();

  Future<Object> getCollectionDetail(String collectionId);

  Future<Object> getCollectionList(String merchantCode);

  Future<Object?> createCollection(
    String collectionName,
    List<int> collectionProducts,
    String merchantCode, {
    String collectionImage = '',
    String collectionDescription = '',
  });

  Future<Object> updateCollection(
    List<int> collectionProducts,
    String collectionId, {
    String collectionName = '',
    String merchantCode = '',
    String collectionImage = '',
    String collectionDescription = '',
  });

  Future<Object> deleteCollection(String collectionId);
}

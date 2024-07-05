class MockProduct{

  MockProduct({
    required this.productAmount,
    required this.productCategory,
    required this.productImage,
    required this.productName,
    required this.productQty,
    required this.productUnit
});
  String productName;
  String productAmount;
  String productCategory;
  String productQty;
  String productUnit;
  String productImage;
}

List<MockProduct> mockProductData =[
  MockProduct(
      productAmount: "200000",
      productCategory: "jfkdjfkd", productImage: "", productName:"Play Station" ,
      productQty: "2", productUnit: "Cartpom"),
  MockProduct(
      productAmount: "210000",
      productCategory: "jfkdjfkd2", productImage: "", productName:"Play Station2" ,
      productQty: "2", productUnit: "Cartpom2"),
  MockProduct(
      productAmount: "220000",
      productCategory: "jfkdjfkd3", productImage: "", productName:"Play Station3" ,
      productQty: "2", productUnit: "Cartpom3"),
  MockProduct(
      productAmount: "230000",
      productCategory: "jfkdjfkd4", productImage: "", productName:"Play Station4" ,
      productQty: "2", productUnit: "Cartpom4"),
];
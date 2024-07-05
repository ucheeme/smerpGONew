import 'package:smerp_go/model/response/inventoryList.dart';

import '../model/request/createSale.dart';

class AddNewSale{
  String name;
  InventoryInfo? data;
  AddNewSale({required this.name,required this.data});
  List<SaleMoreInfo> sales = [];

 List<SaleMoreInfo> multipleProduct(){
    sales.add(  SaleMoreInfo(
        actionBy: name,
        actionOn: DateTime.now(),
        productId: data!.id,
        quantity: 1,
        paymentStatus: 0,
        timeStamp: DateTime.now()
    ));
    return sales;
  }
}
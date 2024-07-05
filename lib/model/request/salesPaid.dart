import 'dart:convert';

import 'package:smerp_go/model/request/updateAllSaleItemAsPaid.dart';


String createSaleToJson(UpdateAllSale data) => json.encode(data.toJson());

class UpdateAllSale {

  List<UpdateAllSaleItemAsPaid> sales;

  UpdateAllSale({
    required this.sales,
  });

  get list => sales;

 toJson(){
   List<dynamic> jsonList = list.map((item) => item.toJson()).toList();
   return jsonList;
 }

}
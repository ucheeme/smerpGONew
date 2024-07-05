import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smerp_go/Reposistory/apiRepo.dart';
import 'package:smerp_go/model/request/createProduct.dart';
import 'package:smerp_go/utils/app_services/helperClass.dart';
import 'package:smerp_go/utils/mockdata/tempData.dart';

import '../apiServiceLayer/apiService.dart';
import '../apiServiceLayer/api_status.dart';
import '../model/response/defaultApiResponse.dart';
import '../model/response/productCategory.dart';
import '../screens/bottomsheets/productCategory.dart';
import '../utils/AppUtils.dart';
import '../utils/UserUtils.dart';
import '../utils/appUrl.dart';

class ProductController extends GetxController{
  var productName =TextEditingController();
  var productCostPrice =TextEditingController();
  var productSellingPrice =TextEditingController();
  var productQuantity =TextEditingController();
  var productImage = RxString("inkk s");
  var productUnit = RxString("Select Unit");
  var productCategory = RxString("");
  var productCategoryId = 0;
  var productUnitCategoryId=0;
  var inventoryIsEmpty= RxBool(false);
  File? productImageFile;

  String removeCurrencyFormatting(String formattedText) {
    // Remove the currency symbol "₦"
    formattedText = formattedText.replaceAll('₦', '');

    // Remove the commas from the number
    formattedText = formattedText.replaceAll(',', '');

    return formattedText;
  }

  double convertFormattedTextToNumber(String formattedText) {
    String cleanedText = removeCurrencyFormatting(formattedText);
    return double.tryParse(cleanedText) ?? 0.0;
  }

  double getAmountAsNumber(TextEditingController controller) {
    String formattedText = controller.text;
    return convertFormattedTextToNumber(formattedText);
  }

  String removeDecimalInString(String value){
   if(value.contains(".")) {
     return value.split(".")[0];
   }else{
     return value;
   }
  }

  int getUnitCategoryID(String value){
  for(var element in productUnitCategoryList){
    if(element.name.toLowerCase() == value.toLowerCase()){
      return element.id;
    }
  }
    return 0;
  }
}
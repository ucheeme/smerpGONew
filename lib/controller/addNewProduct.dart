import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Reposistory/apiRepo.dart';
import '../apiServiceLayer/apiService.dart';
import '../apiServiceLayer/api_status.dart';
import '../model/request/createProduct.dart';
import '../model/request/createProductCategory.dart';
import '../model/response/defaultApiResponse.dart';
import '../model/response/inventoryList.dart';
import '../model/response/productCategory.dart';
import '../utils/AppUtils.dart';
import '../utils/UserUtils.dart';
import '../utils/appUrl.dart';
import '../utils/app_services/helperClass.dart';
import '../utils/mockdata/tempData.dart';
import 'inventoryController.dart'as inven ;
import 'inventoryController.dart';

class AddNewProductController extends  GetxController{
  var productName =TextEditingController();
  TextEditingController categoryName = TextEditingController();
  TextEditingController unitName = TextEditingController();
  TextEditingController categoryDescription = TextEditingController();
  TextEditingController unitDescription = TextEditingController();
  var productCostPrice =TextEditingController();
  var productSellingPrice =TextEditingController();
  var productQuantity =TextEditingController();
  var productImage = RxString("assets/waaz.png");
  File productImageFile =File("");
  var productUnit = RxString("");
  var productCategory = RxString("");
  var productCategoryId = 0;
  var productUnitCategoryId=0;
  var inventoryIsEmpty= RxBool(false);
RxBool  isLoading = false.obs;

  Future<List<DefaultProductCategory>> allProductUnitCategoryList({isRefresh=
  false,
    RefreshController? refreshController})async{
    isLoading.value = true;
    var response = await ApiService.makeApiCall(null,
        AppUrls().productUnitCategory(loginData!.merchantCode),
        method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = productUnitCategoryFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value = false;
          productUnitCategoryList= data.data;
          (isRefresh)?refreshController?.refreshCompleted():null;
          return data.data;
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController?.refreshFailed():null;
      }
    }else{
      (isRefresh)?refreshController?.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return [];
  }

  Future<List<DefaultProductCategory>> allProductCategoryList({isRefresh=
  false,
    RefreshController? refreshController})async{
    isLoading.value = true;
    var response = await ApiService.makeApiCall(null,
        AppUrls().productCategory(loginData!.merchantCode),
        method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = productUnitCategoryFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value = false;
          productCategoryList= data.data;
          (isRefresh)?refreshController?.refreshCompleted():null;
          return data.data;
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController?.refreshFailed():null;
      }
    }else{
      (isRefresh)?refreshController?.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return [];
  }

  Future<bool> productCreate(int quantity, int productCate, int unitCate,
      String prodName, String prodImage, double prodCostP, double prodSellingP)
  async {
    isLoading.value = true;


    CreateProduct? createProduct;

    createProduct = CreateProduct(
        actionBy: actionBy,
        actionOn: DateTime.now(),
        quantity: quantity,
        sellingPrice: prodSellingP,
        timeStamp: DateTime.now(),
        unitCategoryId: unitCate,
       //units: unitCate,
        productName: prodName,
        productImage: prodImage,
        productCategoryId: productCate,
        purchasePrice: prodCostP);
    var response = await ApiService.makeApiCall(createProduct, AppUrls.productInventory,
      isAdmin: false, );

    if (response is Success) {
      try {
        var data = defaultApiResponseFromJson(await response.response as String);
        if (data.isSuccess) {
          isLoading.value = false;
          Get.snackbar("New Product Added ",
            data.message,
            backgroundColor: Colors.green,
            colorText: Colors.white,);
          productSellingPrice.clear();
          productCostPrice.clear();
          productQuantity.clear();
          productImage.value="";
          productUnit.value ="";
          productCategory.value="";
          productName.clear();
          return true;
        }
      } catch (e, trace) {
        isLoading.value = false;
        Get.snackbar("An Error Occourred ",
          "${e.toString()}, please contact developer",
          backgroundColor: Colors.red,
          colorText: Colors.white,);
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
      }
    }else{
      isLoading.value= false;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
      return false;
    }
    return false;
  }



  Future<bool> createProductCategory() async {
    if(categoryName.text.isEmpty){
      Get.snackbar("Incomplete Information",
        "Enter Category Name",
        backgroundColor: Colors.red,
        colorText: Colors.white,);
    }else{
     // isLoading.value = true;


      CreateProductCategory? createProductCategory;

     createProductCategory = CreateProductCategory(actionBy: actionBy,
         actionOn: DateTime.now(), name: categoryName.text, description: categoryDescription.text);
      var response = await ApiService.makeApiCall(createProductCategory,
        AppUrls.createProductCategory,
        isAdmin: false,);

      if (response is Success) {
        try {
          var data = defaultApiResponseFromJson(await response.response as String);
          if (data.isSuccess) {
            isLoading.value = false;

            await allProductCategoryList();
            Get.snackbar("New Product Category Successfully Created",
              data.message,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            return true;
          }
        } catch (e, trace) {
          isLoading.value = false;
          AppUtils.debug(e.toString());
          AppUtils.debug(trace.toString());
        }
      }else{
        isLoading.value= false;
        var repo = ApiRepository();
        repo.handleErrorResponse(response);
        return false;
      }
    }
    //isLoading.value=false;
    return false;
  }


  Future<bool> createProductUnitCategory() async {
    if(unitName.text.isEmpty){
      Get.snackbar("Incomplete Information",
        "Enter Unit Name",
        backgroundColor: Colors.red,
        colorText: Colors.white,);
    }else{
      // isLoading.value = true;


      CreateProductCategory? createProductCategory;

      createProductCategory = CreateProductCategory(actionBy: actionBy,
          actionOn: DateTime.now(), name: unitName.text,
          description: unitDescription.text);
      var response = await ApiService.makeApiCall(createProductCategory,
        AppUrls.createProductUnitCategory,
        isAdmin: false,);

      if (response is Success) {
        try {
          var data = defaultApiResponseFromJson(await response.response as String);
          if (data.isSuccess) {
            isLoading.value = false;

            await allProductUnitCategoryList();
            Get.snackbar("New Unit Category Successfully Created",
              data.message,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            return true;
          }
        } catch (e, trace) {
          isLoading.value = false;
          AppUtils.debug(e.toString());
          AppUtils.debug(trace.toString());
        }
      }else{
        isLoading.value= false;
        var repo = ApiRepository();
        repo.handleErrorResponse(response);
        return false;
      }
    }
    //isLoading.value=false;
    return false;
  }



  Future<bool> productUpdate(int quantity, int productCate, int unitCate,
      String prodName, String prodImage, double prodCostP, double prodSellingP,
  int id)
  async {
    isLoading.value = true;
    inventoryId = id.toString();

    CreateProduct? createProduct;

    createProduct = CreateProduct(
        actionBy: actionBy,
        actionOn: DateTime.now(),
        quantity: quantity,
        sellingPrice: prodSellingP,
        timeStamp: DateTime.now(),
        unitCategoryId: unitCate,
      //  units: unitCate,
        productName: prodName,
        productImage: prodImage,
        productCategoryId: productCate,
        purchasePrice: prodCostP);
    var response = await ApiService.makeApiCall(createProduct,
      AppUrls.updateProductInventoryDetail(inventoryId),
      isAdmin: false, method: HTTP_METHODS.put);

    if (response is Success) {
      try {
        var data = defaultApiResponseFromJson(await response.response as String);
        if (data.isSuccess) {
          isLoading.value = false;
        await inven.InventoryController().allInventorylist();
          Get.snackbar("Product updated ",
            data.message,
            backgroundColor: Colors.green,
            colorText: Colors.white,);
          productSellingPrice.clear();
          productCostPrice.clear();
          productQuantity.clear();
          productImage.value="";
          productUnit.value ="";
          productCategory.value="";
          productName.clear();
          return true;
        }
      } catch (e, trace) {
        isLoading.value = false;
        Get.snackbar("An Error Occourred ",
          "${e.toString()}, please contact developer",
          backgroundColor: Colors.red,
          colorText: Colors.white,);
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
      }
    }else{
      isLoading.value= false;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
      return false;
    }
    return false;
  }

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

  var quantityController = TextEditingController();
  var unit =RxString("");
  List<String> units = ["Box","Pack", "Pair","Bag","Pieces","CM(Centimeter",
    "Dz(Doppelzentner","ft","Gram","Kg","Yard"];
}
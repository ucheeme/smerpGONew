import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/model/request/salesPaid.dart';

import '../Reposistory/apiRepo.dart';
import '../apiServiceLayer/apiService.dart';
import '../apiServiceLayer/api_status.dart';
import '../model/request/createProduct.dart';
import '../model/request/createSale.dart';
import '../model/request/editSale.dart';
import '../model/request/updateAllSaleItemAsPaid.dart';
import '../model/response/defaultApiResponse.dart';
import '../model/response/inventoryDetail.dart';
import '../model/response/inventoryList.dart';
import '../model/response/productCategory.dart';
import '../model/response/sales/saleList.dart';
import '../model/response/sales/saleListInfo.dart';
import '../model/response/salesList.dart';
import '../utils/AppUtils.dart';
import '../utils/UserUtils.dart';
import '../utils/appUrl.dart';
import '../utils/app_services/helperClass.dart';
import '../utils/mockdata/tempData.dart';

class AddNewSaleController extends GetxController{

  var productName =TextEditingController();
  var productCostPrice =TextEditingController();
  var customerName =TextEditingController();
  var productSellingPrice =TextEditingController();
  var productQuantity =TextEditingController();
  RxBool isLoading = false.obs;
  List<int>  salePaymentStatus =[];
  var productImage = RxString("inkk s");
  var productUnit = RxString("");
  var productCategory = RxString("");
  var productCategoryId = 0;
  var productUnitCategoryId=0;
  var qty=0;
  var tempQty=0;
  List<int> qtyList = [];
  var inventoryIsEmpty= RxBool(false);
  var prodName = "Select Product";
  var prodUnitName = "Select Unit";
  InventoryInformation? productSelectedValue;
  InventoryInfo? product;
  List<InventoryInfo> productAddList = [];
  List<SaleCreateItem> prAddList = [];
  double totalSaleCost = 0;
  double editTotalSaleCost = 0;
  RxInt paymentStatus = 0.obs;
  List<SaleMoreInfo> createSalesItem =[];
  var isDone = RxBool(false);
  double totalAmount=0.0;


  int paymentStatusid(String status){
    print(status);
    switch (status){
      case 'Paid':
        return 1;
      case 'NotPaid':
        return 0;
      case 'Unpaid':
        return 0;
      case 'Pending':
        return 0;
      case 'Processing':
        return 0;
      default:
        return 0;
    }

  }


  Future<List<DefaultProductCategory>> allProductUnitCategoryList(
      {isRefresh=false})async{
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
          (isRefresh)?refreshController.refreshCompleted():null;
          return data.data;
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController.refreshFailed():null;
      }
    }else{
      isLoading.value=false;
      (isRefresh)?refreshController.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return [];
  }

  Future<List<DefaultProductCategory>> allProductCategoryList(
      {isRefresh=false,
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
      isLoading.value= false;
      (isRefresh)?refreshController?.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return [];
  }

  Future<bool> createSale() async {
    if(customerName.text.isEmpty){
      Get.snackbar("Incomplete Information",
        "Enter Customer Name",
        backgroundColor: Colors.red,
        colorText: Colors.white,);
    }else{
      isLoading.value = true;


      CreateSale? createSale;

     createSale = CreateSale(sales: createSalesItem, actionBy: actionBy,
       actionOn: DateTime.now(), customerName: customerName.text,
     );
      var response = await ApiService.makeApiCall(createSale,
        AppUrls.saleItem,
        isAdmin: false,);

      if (response is Success) {
        try {
          var data = defaultApiResponseFromJson(await response.response as String);
          if (data.isSuccess) {
            isLoading.value = false;
            createSalesItem.clear();
            qtyList.clear();
            qty=0;
           await allSaleList();
            Get.snackbar("Sale Successful ",
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



  Future<List<SalesDatum>> allSaleList({isRefresh=
  false,
    RefreshController? refreshController})async{
    (isRefresh) ?isLoading.value=false:
    isLoading.value = true;
    var response = await ApiService.makeApiCall(null,
        AppUrls().getSaleItem,
       method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = saleListFromJson(await response.response as String);
        if(data.isSuccess && data.data != null){
          isLoading.value = false;
         saleListTemp= data.data!;
          if(data.data!.isEmpty){
            saleIsEmpty.value= true;
          }else{
           saleIsEmpty.value=false;
          }
          (isRefresh)?refreshController?.refreshCompleted():null;
         return data.data!;
        }else{
          isLoading.value = false;
          saleIsEmpty.value= true;
          return [];
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController?.refreshFailed():null;
      }
    }else{
      isLoading.value= false;
      (isRefresh)?refreshController?.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return [];
  }

  Future<bool> deleteSaleRecord(int salesId, int prodId,
      ) async {

      isLoading.value = true;

      var response = await ApiService.makeApiCall(null,
        AppUrls.deleteSaleRecord(salesId.toString(),),
        isAdmin: false,
      method: HTTP_METHODS.delete);

      if (response is Success) {
        try {
          var data = defaultApiResponseFromJson(await response.response as String);
          if (data.isSuccess) {
            isLoading.value = false;
            //allSaleList();
            Get.snackbar("Sale Deleted ",
              data.message,
              backgroundColor: Colors.green,
              colorText: Colors.white,);
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
    return false;
  }

  Future<bool> updateSaleRecord(int quantity, int paymentStatus,
      int saleId,
      int productId) async {
    if(quantity==0){
      Get.snackbar("Incomplete Information",
        "No field should be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,);
    }
    else{
      isLoading.value = true;
      EditSaleBody? editSaleBody;

      editSaleBody = EditSaleBody(actionBy: actionBy,actionOn: DateTime.now(),
        productId: productId, quantity:quantity, paymentStatus:paymentStatus,
        timeStamp: DateTime.now(),);
      var response = await ApiService.makeApiCall(editSaleBody,
       AppUrls.updateSaleRecord(saleId.toString()),
        isAdmin: false,
      method: HTTP_METHODS.put);

      if (response is Success) {
        try {
          var data = defaultApiResponseFromJson(
              await response.response as String);
          if (data.isSuccess) {
            isLoading.value = false;
            await allSaleList();
            Get.snackbar("Sale Updated ",
              data.message,
              backgroundColor: Colors.green,
              colorText: Colors.white,);
            return true;
          }else{
            isLoading.value = false;
            Get.snackbar("Sale Updated ",
              data.message,
              backgroundColor: Colors.red,
              colorText: Colors.white,);
            return false;
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
    return false;
  }

  Future<bool> updateAllItemsAsPaid(List<SalesItemInfo> sales,int saleId) async {
      isLoading.value = true;
      List<UpdateAllSaleItemAsPaid> editSaleBody=[];
      for(var element in sales){
        editSaleBody.add(
          UpdateAllSaleItemAsPaid(actionBy: actionBy,
          actionOn: DateTime.now(),
          itemId:element.salesItemId ,
          productId:element.productId, quantity:element.quantity,
          paymentStatus:1,
          timeStamp: DateTime.now(),)
        );
      }
      UpdateAllSale? request = UpdateAllSale(sales: editSaleBody);


      var response = await ApiService.makeApiCall(request,
          AppUrls.updateAllSaleItemToPaid(saleId.toString()),
          isAdmin: false,
          method: HTTP_METHODS.put);

      if (response is Success) {
        try {
          var data = defaultApiResponseFromJson(
              await response.response as String);
          if (data.isSuccess) {
            isLoading.value = false;
            await allSaleList();
            Get.snackbar("Sale Updated ",
              data.message,
              backgroundColor: Colors.green,
              colorText: Colors.white,);
            return true;
          }else{
            isLoading.value = false;
            Get.snackbar("Sale Updated ",
              data.message,
              backgroundColor: Colors.red,
              colorText: Colors.white,);
            return false;
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

    return false;
  }

  Future<bool> deleteItemRecord(int saleId, int saleItem,) async {

      isLoading.value = true;


      var response = await ApiService.makeApiCall(null,
          AppUrls.deleteItemOnSale(saleId,saleItem),
          requireAccess: true,
          method: HTTP_METHODS.delete);

      if (response is Success) {
        try {
          var data = defaultApiResponseFromJson(await response.response as String);
          if (data.isSuccess) {
            isLoading.value = false;
            await allSaleList();
            Get.snackbar("Sale Deleted ",
              data.message,
              backgroundColor: Colors.green,
              colorText: Colors.white,);
            return true;
          }else{
            isLoading.value = false;
            Get.snackbar("Sale status ",
              data.message,
              backgroundColor: Colors.red,
              colorText: Colors.white,);
            return false;
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

    return false;
  }

  Future<void>  productDetail(int id)async{
   // isLoading.value = true;
    inventoryId = id.toString();
    var response = await ApiService.makeApiCall(null,
        AppUrls().getProductInventoryDetail(inventoryId),requireAccess: true,
        method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = inventoryDetailFromJson(await response.response as String);
        if(data.isSuccess){
          productSelectedValue = data.data;

          isLoading.value = false;
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
       // (isRefresh)?refreshController.refreshFailed():null;
      }
    }else{
      // isLoading.value = false;
      // (isRefresh)?refreshController.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
  }

  Future< List<SaleListDataInfo>> saleListData(int saleId,
      RxBool isLoading,{isRefresh= false,
    RefreshController? refreshController})async{
    (isRefresh) ?isLoading.value=false:
    isLoading.value = true;
    var response = await ApiService.makeApiCall(null,
        AppUrls().getSaleDetails(saleId),
        method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = saleListInfoFromJson(await response.response as String);
        if(data.isSuccess && data.data != null){
          isLoading.value = false;
          return data.data!;
        }else{
          isLoading.value = false;
          return [];
        }
      }catch(e,trace){
      isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
      }
    }else{
      isLoading.value= false;
      (isRefresh)?refreshController?.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return [];
  }


  var quantityController = TextEditingController();
  var unit =RxString("");
  List<String> units = ["Box","Pack", "Pair","Bag","Pieces","CM(Centimeter",
  "Dz(Doppelzentner","ft","Gram","Kg","Yard"];
}

class SaleCreateItem {
  InventoryInfo data;
  bool hasQty;
  SaleCreateItem(this.data, this.hasQty);
}
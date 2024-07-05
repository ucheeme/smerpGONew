
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/model/request/updateStock.dart';
import 'package:smerp_go/model/response/defaultApiResponse.dart';
import 'package:smerp_go/model/response/inventoryCount.dart';
import 'package:smerp_go/model/response/inventoryDashboard.dart';
import 'package:smerp_go/model/response/inventoryDetail.dart';
import 'package:smerp_go/model/response/inventoryList.dart';
import 'package:smerp_go/utils/UserUtils.dart';

import '../Reposistory/apiRepo.dart';
import '../apiServiceLayer/apiService.dart';
import '../apiServiceLayer/api_status.dart';
import '../screens/bottomNav/screens/inventory/viewProduct.dart';
import '../utils/AppUtils.dart';
import '../utils/appUrl.dart';
import '../utils/app_services/helperClass.dart';
import '../utils/mockdata/tempData.dart';

class InventoryController extends GetxController{
  var inventoryIsEmpty = RxBool(false);
  InventoryInformation? information;
  var inventoryCount = RxString("0");
  RxBool isLoading = false.obs;
  String astericValue = '***';
  // var thisMonthSalesCount = RxString("0");
 // var thisMonthSalesAmount = RxString("00000");
  var inventoryAmount = RxString("00000");
  var isInventoryCountLoading = RxBool(false);
  List<InventoryInfo> inventoryList = [];

  Future<void>  inventoryDashboard({isRefresh=
  false})async{
    var response = await ApiService.makeApiCall(null,
        AppUrls().getInventorysummary,requireAccess: true,
        method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = inventoryDashboardFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value = false;
          inventoryCount.value = data.data.productCount.toString();
          inventoryAmount.value = data.data.salesValue.toString();

        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController.refreshFailed():null;
      }
    }else{
      isLoading.value = false;
      (isRefresh)?refreshController.refreshFailed():null;
    //  var repo = ApiRepository();
     //repo.handleErrorResponse(response);
    }
  }


  Future<List<InventoryInfo>> allInventorylist({isRefresh=
  false,
    RefreshController? refreshController
  })async{
    (isRefresh) ?isLoading.value=false:
    isLoading.value = true;
    var response = await ApiService.makeApiCall(null,
        AppUrls().getProductInventory,requireAccess: true,
        method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = inventoryListFromJson(await response.response as String);
        if(data.isSuccess && data.data != null){
          isLoading.value = false;
          inventoryList= data.data!;
          inventoryListTemp= data.data!;
          inventoryDashboard();
          if(data.data!.isEmpty){
            inventoryIsEmpty.value= true;
            productIsEmpty.value=true;
          }else{
            inventoryIsEmpty.value=false;
            productIsEmpty.value=false;
          }
          (isRefresh)?
          refreshController?.refreshCompleted():
          null;
         return data.data!;
        }
        else if(data.isSuccess==false){
          (isRefresh)?
          refreshController?.refreshCompleted():
          null;
          inventoryList =[];
         inventoryListTemp= inventoryList;
          inventoryIsEmpty.value=false;
        //  productIsEmpty.value=false;
          return [];
        }
        else{
          isLoading.value = false;
          inventoryIsEmpty.value= true;
         // productIsEmpty.value=true;
          return [];
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        inventoryIsEmpty.value=false;
       // productIsEmpty.value=true;
       (isRefresh)?refreshController?.refreshFailed():null;
      }
    }else{
       isLoading.value= false;
     //  productIsEmpty.value=true;
     (isRefresh)?refreshController?.refreshFailed():null;
       inventoryIsEmpty.value=false;
      // var repo = ApiRepository();
      // repo.handleErrorResponse(response);
    }
    return [];
  }

  void filterByName(String enteredValue){
    inventoryList = inventoryListTemp.where((element) =>
        element.productName.toLowerCase().
        contains(enteredValue.toLowerCase())).toList();
  }

  Future<void>  inventoryDetail(int id,{isRefresh=
  false})async{
    isLoading.value = true;
    inventoryId = id.toString();
    var response = await ApiService.makeApiCall(null,
        AppUrls().getProductInventoryDetail(inventoryId),requireAccess: true,
        method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = inventoryDetailFromJson(await response.response as String);
        if(data.isSuccess){
          information= data.data;
          Get.to(
              ViewProduct(information: information),
              duration: Duration(seconds: 1),
              curve: Curves.easeIn
          );
          isLoading.value = false;
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController.refreshFailed():null;
      }
    }else{
       isLoading.value = false;
      (isRefresh)?refreshController.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
  }

  Future<void>  deleteInventory(int id,String productName)async{
    isLoading.value = true;
    inventoryId = id.toString();
    var response = await ApiService.makeApiCall(null,
        AppUrls.deleteProductInventoryDetail(inventoryId,productName),requireAccess: true,
        method: HTTP_METHODS.delete );
    if(response is Success){
      try{
        var data = defaultApiResponseFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value = false;
          allInventorylist();
          Get.snackbar("Inventory Deleted",
            data.message,
            backgroundColor: Colors.green.withOpacity(0.5),
            colorText: Colors.white,);
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
       // (isRefresh)?refreshController.refreshFailed():null;
      }
    }else{
      isLoading.value = false;
      // (isRefresh)?refreshController.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
  }

  Future<bool>  updateInventoryStock(int quantity,int productId,
      RxBool isLoading)async{
    isLoading.value = true;
    UpdateStockRequestBody? updateStockRequestBody;
    updateStockRequestBody = UpdateStockRequestBody(actionBy: actionBy,
        actionOn: DateTime.now(), productId: productId, quantity: quantity);
    var response = await ApiService.makeApiCall(updateStockRequestBody,
        AppUrls.updateInventoryStock,requireAccess: true,
        method: HTTP_METHODS.post );
    if(response is Success){
      try{
        var data = defaultApiResponseFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value = false;
         await allInventorylist();
          Get.snackbar("Inventory status",
            data.message,
            backgroundColor: Colors.green.withOpacity(0.5),
            colorText: Colors.white,);
          return true;
        }else{
          isLoading.value = false;
          return false;
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        return false;
        // (isRefresh)?refreshController.refreshFailed():null;
      }
    }else{
      isLoading.value = false;
      // (isRefresh)?refreshController.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
      return false;
    }
    return false;
  }


  Future<void>  inventoryCountCall({isRefresh=
  false})async{
   //isLoading.value = true;
    isInventoryCountLoading.value = true;

    var response = await ApiService.makeApiCall(null,
        AppUrls().getInventoryCount,requireAccess: true,
        method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = inventoryCountFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value = false;
          inventoryCount.value = data.data.productCount.toString();
          // thisMonthSalesCount.value = data.data.salasCountCurrentMonth.toString();
          // // thisMonthSalesAmount.value = data.data.salasAmountCurrentMonth.toString();
          inventoryAmount.value = data.data.salesValue.toString();
          isInventoryCountLoading.value = false;
        }
      }catch(e,trace){
        isLoading.value = false;
        isInventoryCountLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController.refreshFailed():null;
      }
    }else{
      isLoading.value = false;
      isInventoryCountLoading.value = false;
      (isRefresh)?refreshController.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
  }
}
import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/cubit/bankDetail/bank_details_cubit.dart';
import 'package:smerp_go/model/response/defaultApiResponse.dart';
import 'package:smerp_go/model/response/salesDashboard.dart';
import 'package:smerp_go/model/response/salesList.dart';

import '../Reposistory/apiRepo.dart';
import '../apiServiceLayer/apiService.dart';
import '../apiServiceLayer/api_status.dart';
import '../model/response/bankDetail.dart';
import '../model/response/order/allOrders.dart';
import '../model/response/sales/saleList.dart';
import '../utils/AppUtils.dart';
import '../utils/appUrl.dart';
import '../utils/app_services/helperClass.dart';
import '../utils/mockdata/tempData.dart';

class DashboardController extends GetxController{
  RxString storeName = "".obs;
  RxString fullName ="".obs;
  RxString storeEmail ="".obs;
  RxString selectedPaymentChoice="".obs;

  RxList<DateTime?> selectedDateRange = RxList();
  RxInt selectedFilterChoice=0.obs;
  RxInt orderCount = 0.obs;
  var salesCount = RxString("0");
  var thisMonthSalesCount = RxString("0");
  var thisMonthSalesAmount = RxString("000000");
  var salesAmount = RxString("00000");
  String astericValue = '***';
  var isSaleDashboardLoading = RxBool(false);
  RxBool  isLoading=false.obs;
  RxBool  isTodayFilter=false.obs;


 double getEditHeight(int num){
   switch(num){
     case 2: return 600.h;
     case 3: return 680.h;
     case 4: return 820.h;
     case 4: return 820.h;
     case 5: return 835.h;
     default: return 950.h;
   }
 }

  double getReceiptHeight(int num){
    switch(num){
      case 2: return 600.h;
      case 3: return 780.h;
      case 4: return 820.h;
      case 4: return 820.h;
      case 5: return 850.h;
      default: return 950.h;
    }
  }

  Future<void>  salesDashboard({isRefresh=
  false})async{
  // isLoading.value = true;
    isSaleDashboardLoading.value = true;

    var response = await ApiService.makeApiCall(null,
        AppUrls().getSalesDashboard,requireAccess: true,
        method: HTTP_METHODS.post );
    if(response is Success){
      try{
        var data = salesDashboardFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value = false;
          salesCount.value = data.data.salasCount.toString();
          thisMonthSalesCount.value = data.data.salasCountCurrentMonth.toString();
          thisMonthSalesAmount.value = data.data.salasAmountCurrentMonth.toString();
          salesAmount.value = data.data.salasAmount.toString();
          isSaleDashboardLoading.value = false;
        }
      }catch(e,trace){
        isLoading.value = false;
        isSaleDashboardLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController.refreshFailed():null;
      }
    }else{
      isLoading.value = false;
      isSaleDashboardLoading.value = false;
     (isRefresh)?refreshController.refreshFailed():null;
      // var repo = ApiRepository();
      // repo.handleErrorResponse(response);
    }
  }
  Future<BankDetailReponse>  bankDetailDashboard({isRefresh= false})async{
    // isLoading.value = true;
    isSaleDashboardLoading.value = true;

    var response = await ApiService.makeApiCall(null,
        AppUrls().getBankDetails,
        method: HTTP_METHODS.get );
    var r =  ApiRepository().handleSuccessResponse(response);
    if(response is Success){
      if(r is DefaultApiResponse){
        try{
          BankDetailReponse data = bankDetailReponseFromJson(json.encode(r.data));
          isLoading.value = false;
          print("this is my value $data");
          storeBankDetail=data;
          isSaleDashboardLoading.value = false;
          return data;
        }catch(e,trace){
          isLoading.value = false;
          isSaleDashboardLoading.value = false;
          AppUtils.debug(e.toString());
          AppUtils.debug(trace.toString());
          (isRefresh)?refreshController.refreshFailed():null;
          return BankDetailReponse(bankName: "bankName", accountName: "accountName", accountNumber: "");
        }
      }else{
        isLoading.value = false;
        isSaleDashboardLoading.value = false;
        (isRefresh)?refreshController.refreshFailed():null;
        // var repo = ApiRepository();
        // repo.handleErrorResponse(response);
        return BankDetailReponse(bankName: "", accountName: "accountName", accountNumber: "");
      }
      }
    return BankDetailReponse(bankName: "", accountName: "accountName", accountNumber: "");
  }
  Future<List<Orders>> userOrders(
      {isRefresh = false, RefreshController? refreshController}) async {
    //(isRefresh) ? isLoading.value = false : isLoading.value = true;
    var response = await ApiService.makeApiCall(null, AppUrls().getAllOrders,
        method: HTTP_METHODS.get);
    if (response is Success) {
      try {
        var data = allOrderListFromJson(await response.response as String);
        if (data.isSuccess && data.data != null) {
          isLoading.value = false;
          if (data.data!.isEmpty) {
            (isRefresh) ? refreshController?.refreshCompleted() : null;
            isOrderListHasRun.value = false;
            orderListTemp = data.data!;
            orderCount.value =orderListTemp.where((element) =>
            element.isAccepted=="Pending" ||element.isAccepted =="Accepted")
                .length;
            return [];
          } else {
            (isRefresh) ? refreshController?.refreshCompleted() : null;
            orderListTemp = data.data!;
            orderCount.value =orderListTemp.where((element) =>
            element.isAccepted=="Pending" ||element.isAccepted =="Accepted")
                .length;
            return data.data!;
          }
        } else {
          (isRefresh) ? refreshController?.refreshFailed() : null;
          isLoading.value = false;
          return [];
        }
      } catch (e, trace) {
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh) ? refreshController?.refreshFailed() : null;
      }
    } else {
      isLoading.value = false;
      (isRefresh) ? refreshController?.refreshFailed() : null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return [];
  }

  List<SalesDatum> saleList = [];


  void filterByName(String enteredValue){
    print("Hey broo");
    saleList = saleListTemp.where((element) =>
       element.customerName.toLowerCase().
       contains(enteredValue.toLowerCase())).toList();
  }

  void filterByPaymentStatus(String paymentStatus){
    print(paymentStatus);
    if(paymentStatus=="Unpaid"){
      paymentStatus = "NotPaid";
    }
    saleList = saleListTemp.where((element) =>
        element.paymentStatus.toLowerCase()==(paymentStatus.toLowerCase())).toList();
    selectedFilterChoice.value =0;
  }

  void filterByDate(RxList<DateTime?> dateRange){
    print(dateRange[0]);
    print(dateRange[1]);
    if(dateRange.value.isEmpty||dateRange.value==null){
      saleList=saleListTemp;
    }else if(isTodayFilter.isTrue){
      DateFormat format = DateFormat('yyyy-MM-dd');
      saleList =saleListTemp.where((date) =>date.createdOn.month==dateRange[0]!.month
          && date.createdOn.year== dateRange[0]!.year && date.createdOn.day ==dateRange[0]!.day
      ).toList();
      isTodayFilter.value=false;
      print(saleList);
    }else{
      DateFormat format = DateFormat('yyyy-MM-dd');
      DateTime startDateObj = format.parse(dateRange[0]!.toIso8601String());
      DateTime endDateObj = format.parse(dateRange[1]!.toIso8601String());
    saleList= saleListTemp.where((date)=>startDateObj.isBefore(date.createdOn) ||
        startDateObj.isAtSameMomentAs(date.createdOn))
        .where((date) => endDateObj.isAfter(date.createdOn) ||
        endDateObj.isAtSameMomentAs(date.createdOn))
        .toList();
   }




    selectedFilterChoice.value =0;
   // print(saleList);
  }

  void dashboardFilter(int option){
    if(option ==1){
    filterByDate(selectedDateRange);
    }else if(option == 2){
      filterByPaymentStatus(selectedPaymentChoice.value);
    }else{

      saleList = saleListTemp;
    }
  }


  Future<List<SalesDatum>> allSaleList({isRefresh=
  false,
    RefreshController? refreshController})async{
    isSaleDashboardLoading.value= true;
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
          isSaleDashboardLoading.value= false;
          saleList= data.data!;
          salesDashboard();
          userOrders();
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
          isSaleDashboardLoading.value= false;
          return [];
        }
      }catch(e,trace){
        isLoading.value = false;
        isSaleDashboardLoading.value= false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController?.refreshFailed():null;
      }
    }else{
      isLoading.value = false;
      (isRefresh)?refreshController?.refreshFailed():null;
      isSaleDashboardLoading.value= false;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return [];
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/model/response/defaultApiResponse.dart';
import 'package:smerp_go/model/response/order/orderDetails.dart';
import 'package:smerp_go/utils/mockdata/tempData.dart';

import '../Reposistory/apiRepo.dart';
import '../apiServiceLayer/apiService.dart';
import '../apiServiceLayer/api_status.dart';
import '../model/response/order/allOrders.dart';
import '../model/response/order/deliveryConfirmation.dart';
import '../model/response/order/orderConfirmation.dart';
import '../utils/AppUtils.dart';
import '../utils/appUrl.dart';

class OrderController extends GetxController {
  var isLoading = false.obs;
  var updatePaymentStatusLoading = false.obs;
  List<Orders> orderList = [];
  RxString selectedPaymentChoice = "".obs;
  RxList<DateTime?> selectedDateRange = RxList();
  RxInt selectedFilterChoice = 0.obs;
  RxString selectedOrderStatusFilterChoice="".obs;
  var paymentStatus = RxInt(-1);
var orderAcceptance= RxBool(false);
  TextEditingController customerNameController = TextEditingController();
  double getBottomSheetHeights(int length){
    switch (length){
      case 0: return 400.h;
      case 1: return 200.h;
      case 2: return 400.h;
      case 3: return 420.h;
      case 4: return 550.h;
      case 5: return 600.h;
      default: return 800.h;
    }
  }
  void filterByPaymentStatus(String paymentStatus) {
    print(paymentStatus);
    if (paymentStatus == "Unpaid") {
      paymentStatus = "NotPaid";
    }
    orderList = orderListTemp
        .where((element) =>
            element.paymentStatus.toLowerCase() ==
            (paymentStatus.toLowerCase()))
        .toList();
    selectedFilterChoice.value = 0;
  }

  void filterByDate(RxList<DateTime?> dateRange) {
    print(dateRange[0]);
    print(dateRange[1]);
    if (dateRange.value.isEmpty || dateRange.value == null) {
      orderList = orderListTemp;
    } else {
      DateFormat format = DateFormat('yyyy-MM-dd');
      DateTime startDateObj = format.parse(dateRange[0]!.toIso8601String());
      DateTime endDateObj = format.parse(dateRange[1]!.toIso8601String());
      orderList = orderListTemp
          .where((date) =>
              startDateObj.isBefore(date.orderDate) ||
              startDateObj.isAtSameMomentAs(date.orderDate))
          .where((date) =>
              endDateObj.isAfter(date.orderDate) ||
              endDateObj.isAtSameMomentAs(date.orderDate))
          .toList();
    }

    selectedFilterChoice.value = 0;
    // print(saleList);
  }

  void orderFilter(int option) {
    if (option == 1) {
      filterByDate(selectedDateRange);
    } else if (option == 2) {
      filterByPaymentStatus(selectedPaymentChoice.value);
    } else {
      orderList = orderListTemp;
    }
  }

  double getVeiwOrderHeight(int num) {
    switch (num) {
      case 1:
        return 500.h;
      case 2:
        return 650.h;
      case 3:
        return 700.h;
      case 4:
        return 750.h;
      case 4:
        return 800.h;
      case 5:
        return 850.h;
      default:
        return 900.h;
    }
  }

  double getReceiptHeight(int num) {
    switch (num) {
      case 1:
        return 500.h;
      case 2:
        return 550.h;
      case 3:
        return 580.h;
      case 4:
        return 720.h;
      case 4:
        return 720.h;
      case 5:
        return 735.h;
      default:
        return 850.h;
    }
  }

  Future<bool> orderConfirmation(String orderId, bool isAccept) async {
    isLoading.value = true;
    OrderConfirmation orderConfirmation = OrderConfirmation(
        orderId: orderId,
        merchantCode: loginData!.merchantCode,
        isAccept: isAccept);
    var response = await ApiService.makeApiCall(
        orderConfirmation, AppUrls().orderConfirmation,
        method: HTTP_METHODS.put);
    if (response is Success) {
      try {
        var data =
            defaultApiResponseFromJson(await response.response as String);
        if (data.isSuccess) {
        //  userOrders();
          isLoading.value = false;
          if (isAccept) {
            Get.snackbar(
              "Order Accepted",
              data.message,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              "Order Rejected",
              data.message,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          }
          return true;
        } else {
          isLoading.value = false;
          return false;
        }
      } catch (e, trace) {
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
      }
    } else {
      isLoading.value = false;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return false;
  }

  Future<bool> orderCancel(String orderId, bool isAccept) async {
    isLoading.value = true;

    var response = await ApiService.makeApiCall(
        null, AppUrls.orderCancel(orderId),
        method: HTTP_METHODS.put);
    if (response is Success) {
      try {
        var data =
        defaultApiResponseFromJson(await response.response as String);
        if (data.isSuccess) {
          //  userOrders();
          isLoading.value = false;
          if (isAccept) {
            Get.snackbar(
              "Order Cancel",
              data.message,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              "Order Cancel",
              data.message,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          }
          return true;
        } else {
          isLoading.value = false;
          return false;
        }
      } catch (e, trace) {
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
      }
    } else {
      isLoading.value = false;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return false;
  }

  Future<bool> orderPayment(String orderId, String customerCode) async {
    isLoading.value = true;
    DeliveryConfirmation deliveryConfirmation = DeliveryConfirmation(
        orderId: orderId,
        merchantCode: loginData!.merchantCode,
        code: customerCode);
    var response = await ApiService.makeApiCall(
        deliveryConfirmation, AppUrls().orderDeliveryConfirmation,
        method: HTTP_METHODS.put);
    if (response is Success) {
      try {
        var data =
            defaultApiResponseFromJson(await response.response as String);
        if (data.isSuccess) {
          userOrders();
          isLoading.value = false;
          Get.snackbar(
            "Order Payment",
            data.message,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          return true;
        } else {
          isLoading.value = false;
          return false;
        }
      } catch (e, trace) {
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        return false;
      }
    } else {
      isLoading.value = false;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return false;
  }

  void filterByName(String enteredValue) {
    orderList = orderListTemp
        .where((element) => element.custormerName
            .toLowerCase()
            .contains(enteredValue.toLowerCase()))
        .toList();
  }

  Future<OrderInformation?> getOrderDetails(String orderId, RxBool isLoading,
      {isRefresh = false, RefreshController? refreshController}) async {
    (isRefresh) ? isLoading.value = false : isLoading.value = true;
    var response = await ApiService.makeApiCall(
        null, AppUrls().getOrderDetails(orderId),
        method: HTTP_METHODS.get);
    if (response is Success) {
      try {
        var data = orderDetailsFromJson(await response.response as String);
        if (data.isSuccess && data.data != null) {
          isLoading.value = false;
          (isRefresh) ? refreshController?.refreshCompleted() : null;
          return data.data;
        } else {
          (isRefresh) ? refreshController?.refreshFailed() : null;
          isLoading.value = false;
          return null;
        }
      } catch (e, trace) {
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
      }
    } else {
      isLoading.value = false;
      (isRefresh) ? refreshController?.refreshFailed() : null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
    return null;
  }

  Future<List<Orders>> userOrders(
      {isRefresh = false, RefreshController? refreshController}) async {
    (isRefresh) ? isLoading.value = false : isLoading.value = true;
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
            return [];
          } else {
            (isRefresh) ? refreshController?.refreshCompleted() : null;
            orderListTemp = data.data!;
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
}

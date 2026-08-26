import 'dart:convert';

import 'package:smerp_go/apiServiceLayer/apiService.dart';
import 'package:smerp_go/apiServiceLayer/api_status.dart';
import 'package:smerp_go/model/response/defaultApiResponse.dart';

import '../../model/response/order/orderHistory.dart';
import '../../utils/appUrl.dart';
import '../apiRepo.dart';
import 'package:smerp_go/core/repositories/i_order_history_repository.dart';

class OrderHistoryRepo extends ApiRepository implements IOrderHistoryRepository{

  Future<Object> getOrderHistory()async{
    var response = await ApiService.makeApiCall(null,AppUrls.orderHistory(),
        method: HTTP_METHODS.get);
    var r =  handleSuccessResponse(response);
    if(r is DefaultApiResponse){
      if(r.isSuccess){
        List<HistoryOrder> res = orderHistoryFromJson(json.encode(r.data));
        logRepoSuccess('getOrderHistory', count: res.length);
        return res;
      }else{
        logRepoFailure('getOrderHistory', r);
        return r;
      }
    }
    else{
      logRepoFailure('getOrderHistory', r);
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
}

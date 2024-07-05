import 'dart:convert';

import 'package:smerp_go/apiServiceLayer/apiService.dart';
import 'package:smerp_go/apiServiceLayer/api_status.dart';
import 'package:smerp_go/model/response/defaultApiResponse.dart';

import '../../model/response/order/orderHistory.dart';
import '../../utils/appUrl.dart';
import '../apiRepo.dart';

class OrderHistoryRepo extends ApiRepository{

  Future<Object> getOrderHistory()async{
    var response = await ApiService.makeApiCall(null,AppUrls.orderHistory(),
        method: HTTP_METHODS.get);
    var r =  handleSuccessResponse(response);
    if(r is DefaultApiResponse){
      if(r.isSuccess){
        List<HistoryOrder> res = orderHistoryFromJson(json.encode(r.data));
        print("response here:${res.length}");
        return res;
      }else{
        print("failed response here:${r}");
        return r;
      }
    }
    else{
      print("failed2 response here:${r}");
      handleErrorResponse(response);
      return errorResponse!;
    }
    // if(response is Success){
    //   try{
    //     OrderHistory data = orderHistoryFromJson(await response.response as String);
    //     if(data.isSuccess){
    //       return data.data;
    //     }
    //   }catch(e, trace){
    //     return [];
    //   }
    // }else if(response is Failure){
    //   var repo = ApiRepository();
    //   repo.handleErrorResponse(response);
    // }
    // return [];
  }
}
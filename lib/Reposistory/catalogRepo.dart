import 'dart:convert';

import 'package:smerp_go/Reposistory/apiRepo.dart';

import '../apiServiceLayer/apiService.dart';
import '../model/request/bankDetails.dart';
import '../model/response/bankDetail.dart';
import '../model/response/createBankDetailResponse.dart';
import '../model/response/defaultApiResponse.dart';
import '../model/response/notificationList.dart';
import '../utils/appUrl.dart';

class CataloRepo extends ApiRepository{
  Future<Object> getCatologList()async{
    var response = await ApiService.makeApiCall(null,AppUrls().getNotificationList,
        method: HTTP_METHODS.get);
    var r =  handleSuccessResponse(response);
    if(r is DefaultApiResponse){
      if(r.isSuccess){
        List<NotificationList> res = notificationListFromJson(json.encode(r.data));
        print("response here:${res.length}");
        print("response here:${res.runtimeType}");
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
  }

  Future<Object> getBankDetails()async{
    var response = await ApiService.makeApiCall(null,AppUrls().getBankDetails,
        method: HTTP_METHODS.get);
    var r =  handleSuccessResponse(response);
    if(r is DefaultApiResponse){
      if(r.isSuccess){
        BankDetailReponse res = bankDetailReponseFromJson(json.encode(r.data));
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
  }

  Future<Object> createBankDetails(StoreBankDetail request)async{
    var response = await ApiService.makeApiCall(request,AppUrls().createBankDetail,
        method: HTTP_METHODS.post);
    var r =  handleSuccessResponse(response);
    if(r is DefaultApiResponse){
       return r;
    }
    else{
      print("failed2 response here:${r}");
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
}
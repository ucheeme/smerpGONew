import 'dart:convert';

import 'package:smerp_go/Reposistory/apiRepo.dart';

import '../apiServiceLayer/apiService.dart';
import '../model/request/bankDetails.dart';
import '../model/response/bankDetail.dart';
import '../model/response/createBankDetailResponse.dart';
import '../model/response/defaultApiResponse.dart';
import '../model/response/notificationList.dart';
import '../utils/appUrl.dart';
import 'package:smerp_go/core/repositories/i_bank_details_repository.dart';

class CataloRepo extends ApiRepository implements IBankDetailsRepository{
  Future<Object> getCatologList()async{
    var response = await ApiService.makeApiCall(null,AppUrls().getNotificationList,
        method: HTTP_METHODS.get);
    var r =  handleSuccessResponse(response);
    if(r is DefaultApiResponse){
      if(r.isSuccess){
        List<NotificationList> res = notificationListFromJson(json.encode(r.data));
        logRepoSuccess('getCatologList', count: res.length);
        return res;
      }else{
        logRepoFailure('getCatologList', r);
        return r;
      }
    }
    else{
      logRepoFailure('getCatologList', r);
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
        logRepoSuccess('getBankDetails');
        return res;
      }else{
        logRepoFailure('getBankDetails', r);
        return r;
      }
    }
    else{
      logRepoFailure('getBankDetails', r);
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> createBankDetails(StoreBankDetail request)async{
    var response = await ApiService.makeApiCall(request,AppUrls().createBankDetail,
        method: HTTP_METHODS.post);
    var r =  handleSuccessResponse(response);
    if(r is DefaultApiResponse){
       logRepoSuccess('createBankDetails');
       return r;
    }
    else{
      logRepoFailure('createBankDetails', r);
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
}

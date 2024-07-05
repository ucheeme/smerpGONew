import 'dart:convert';

import 'package:smerp_go/Reposistory/apiRepo.dart';
import 'package:smerp_go/model/response/notificationList.dart';

import '../apiServiceLayer/apiService.dart';
import '../model/response/defaultApiResponse.dart';
import '../utils/appUrl.dart';

class NotificationRepo extends ApiRepository {
  Future<Object> getNotificationList()async{
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

}
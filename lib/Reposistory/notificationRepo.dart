import 'dart:convert';

import 'package:smerp_go/Reposistory/apiRepo.dart';
import 'package:smerp_go/model/response/notificationList.dart';

import '../apiServiceLayer/apiService.dart';
import '../model/response/defaultApiResponse.dart';
import '../utils/appUrl.dart';
import 'package:smerp_go/core/repositories/i_notification_repository.dart';

class NotificationRepo extends ApiRepository implements INotificationRepository {
  Future<Object> getNotificationList()async{
    var response = await ApiService.makeApiCall(null,AppUrls().getNotificationList,
        method: HTTP_METHODS.get);
    var r =  handleSuccessResponse(response);
    if(r is DefaultApiResponse){
      if(r.isSuccess){
        List<NotificationList> res = notificationListFromJson(json.encode(r.data));
        logRepoSuccess('getNotificationList', count: res.length);
        return res;
      }else{
        logRepoFailure('getNotificationList', r);
        return r;
      }
    }
    else{
      logRepoFailure('getNotificationList', r);
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

}

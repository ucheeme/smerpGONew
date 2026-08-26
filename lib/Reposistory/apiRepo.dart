import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/core/logging/app_logger.dart';
import 'package:smerp_go/core/session/session_manager.dart';
import 'package:smerp_go/screens/authentication_signup/signInFlow/signin.dart';
import 'package:smerp_go/screens/authentication_signup/signInFlow/signinViaPhoneEmail.dart';

import '../apiServiceLayer/api_status.dart';
import '../model/response/defaultApiResponse.dart';
import '../utils/AppUtils.dart';
import '../utils/UserUtils.dart';
import '../utils/mockdata/tempData.dart';

class ApiRepository{
  DefaultApiResponse? _errorResponse;
  DefaultApiResponse? get errorResponse => _errorResponse;
  setErrorResponse(DefaultApiResponse? value) {
    _errorResponse = value;
  }

  void logRepoSuccess(String operation, {int? count}) {
    AppLogger.debug(
      count != null ? '$operation count=$count' : operation,
      tag: 'Repo',
    );
  }

  void logRepoFailure(String operation, Object response) {
    final detail = response is DefaultApiResponse
        ? response.message
        : response.runtimeType.toString();
    AppLogger.warning('$operation failed: $detail', tag: 'Repo');
  }

  Object handleSuccessResponse(dynamic response){
    // if (response is DefaultApiResponse) {
    //   var r = response;//defaultApiResponseFromJson(response.response as String);
    //   return r;
    // }else{
    //   AppUtils.debug("here1 ");
    //   handleErrorResponse(response);
    //   return errorResponse!;
    // }
    if(response is Success) {
      var r = defaultApiResponseFromJson(response.response as String);
      return r;
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  handleErrorResponse(Object response,) async {
    isLoading.value= false;
    if (response is Failure) {
      try {
        var data = defaultApiResponseFromJson(response.errorResponse as String);
       if(data.isSuccess==false){
          if(data.data==null||data.data.runtimeType == bool){
            AppLogger.debug('Error data type: ${data.data.runtimeType}', tag: 'API');
            Get.snackbar( data.message,
              "",
              backgroundColor: Colors.red.withOpacity(0.4),
              colorText: Colors.white,
              duration: Duration(seconds: 3),
              isDismissible: true,

            );
          }else{
            AppLogger.debug('Error data type: ${data.data.runtimeType}', tag: 'API');
            Get.snackbar( data.message,
              "",
              backgroundColor: Colors.red.withOpacity(0.4),
              colorText: Colors.white,
              duration: Duration(seconds: 3),
              isDismissible: true,

            );
          }

        }else{
          Get.snackbar( data.message,
            (data.data!=null&&
                data.data[0].runtimeType==String)?data.data[0]:"",
            backgroundColor: Colors.red.withOpacity(0.4),
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            isDismissible: true,

          );
        }

      }
      catch (e,trace) {
        isLoading.value= false;
        AppLogger.error(e, trace, reason: 'handleErrorResponse', tag: 'API');
       setErrorResponse(AppUtils.defaultErrorResponse());

      }

    }
    else if(response is UnExpectedError){
      Get.snackbar("UnExpectedError",
        UnExpectedError().message,
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,);
      setErrorResponse(AppUtils.defaultErrorResponse(msg:UnExpectedError().message));

    }
    else if(response is NetWorkFailure){

      Get.snackbar("NetWork Failure",
        NetWorkFailure().message,
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,);
     setErrorResponse(AppUtils.defaultErrorResponse(msg: NetWorkFailure().message));
    }
    else if(response is TokenExpired){

      await SessionManager.clearSession();
      Get.offAll(SignIn(),
      transition: Transition.cupertino,
      duration: Duration(seconds: 1)
      );
      setErrorResponse(AppUtils.defaultErrorResponse(msg:
      TokenExpired(401, "Token Expired, please sign in").message));
    }
    else if(response is ForbiddenAccess){
      await SessionManager.clearSession();
      Get.off(SignIn(),
          transition: Transition.cupertino,
          duration: Duration(seconds: 1)
      );
      setErrorResponse(AppUtils.defaultErrorResponse(
        msg: 'Access forbidden. Please sign in again.',
      ));
    }
  }
}
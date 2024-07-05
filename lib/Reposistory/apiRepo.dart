import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
            print(data.data.runtimeType);
            Get.snackbar( data.message,
              "",
              backgroundColor: Colors.red.withOpacity(0.4),
              colorText: Colors.white,
              duration: Duration(seconds: 3),
              isDismissible: true,

            );
          }else{
            print(data.data.runtimeType);
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
        print("error");
        print(e);
        print(trace);
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

      // Get.snackbar("Authentication Expired",
      //   TokenExpired(401, "Token Expired").message,
      //   backgroundColor: Colors.red.withOpacity(0.5),
      //   colorText: Colors.white,);
      productCategoryList =[];
      productUnitCategoryList =[];
      inventoryListTemp =[];
      catalogListTemp =[];
      catalogsFTemp = [];
      saleListTemp=[];
      actionBy = "";
      inventoryId="";
      isLoading.value=false;
      isSignUpViaPhone.value =true;
      userIdentityValue=null;
      identitySource = null;
      otpCreateAccout= "";
      loginData=null;
      isProductCategoryHasRun = Rx(false);
      isProductUnitCategoryHasRun = Rx(false);
      isInventoryListHasRun =false;
      isSalesListHasRun = Rx(false);
      isCatalogListHasRun = Rx(false);
      saleIsEmpty= RxBool(false);
      productIsEmpty= RxBool(false);
      Get.offAll(SignIn(),
      transition: Transition.cupertino,
      duration: Duration(seconds: 1)
      );
      setErrorResponse(AppUtils.defaultErrorResponse(msg:
      TokenExpired(401, "Token Expired, please sign in").message));
    }
    else if(response is ForbiddenAccess){
      try {
        var data = defaultApiResponseFromJson(
            await  response.response.toString() );
        Get.off(SignIn(),
            transition: Transition.cupertino,
            duration: Duration(seconds: 1)
        );
      }
      catch (e,trace) {
        isLoading.value= false;
        print("error");
        print(e);
        print(trace);
        setErrorResponse(AppUtils.defaultErrorResponse());
      }

    }
  }
}
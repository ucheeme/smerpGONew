import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smerp_go/model/request/signUpTokenValidation.dart';

import '../Reposistory/apiRepo.dart';
import '../apiServiceLayer/apiService.dart';
import '../apiServiceLayer/api_status.dart';
import '../model/request/signupToken.dart';
import '../model/response/defaultApiResponse.dart';
import '../screens/authentication_signup/signUpFlow/setUpPin.dart';
import '../utils/AppUtils.dart';
import '../utils/appUrl.dart';
import '../utils/app_services/helperClass.dart';

class AccountVerificationController extends GetxController{
  StreamController<ErrorAnimationType> errorController =
  StreamController<ErrorAnimationType>();
 final TextEditingController pinValueController = TextEditingController();
  RxString otpValue="".obs;
  RxInt otplength = 0.obs;
  RxBool isEmpty=true.obs;
  RxBool isReSendOTP= false.obs;


  Future<void> tokenValidation()async{
    isLoading.value = true;
    SignUpTokenValidation? signUpTokenValidation;
    if (isSignUpViaPhone.value){
      signUpTokenValidation = SignUpTokenValidation(otpSource: identitySourceByPhone,
         source: userIdentityValue!,otp:otpValue.value );
    }else{
      signUpTokenValidation = SignUpTokenValidation(otpSource: identitySourceByMail,
          source: userIdentityValue!, otp: otpValue.value);
    }
    var service = ApiService();
    var response = await ApiService.makeApiCall(signUpTokenValidation, AppUrls.signUpTokenValidation,
        requireAccess: false);
    if(response is Success){
      try{
        var data = defaultApiResponseFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value=false;
          otpCreateAccout=otpValue.value;
          Get.snackbar("OTP VALIDATION",
            data.message,
            backgroundColor: Colors.green,
            colorText: Colors.white,);
          Get.off(SignUpPin(),
              duration: Duration(seconds: 1),
              curve: Curves.easeIn
          );
        }else{
          isLoading.value=false;

          Get.snackbar("OTP VALIDATION",
            data.message,
            backgroundColor: Colors.red,
            colorText: Colors.white,);
        }
      }catch(e, trace){
        print(e);
        print(trace);
        isLoading.value = false;
      }
    } else{
      isLoading.value= false;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
  }
  Future<void> signUpToken() async{
    isLoading.value = true;
    SignUpToken? signUptoken;
    if (isSignUpViaPhone.value){
      signUptoken = SignUpToken(identitySource: identitySourceByPhone,
          identity: userIdentityValue!);
    }else{
      signUptoken = SignUpToken(identitySource: identitySourceByMail,
          identity: userIdentityValue!);
    }


    var service = ApiService();
    var response = await ApiService.makeApiCall(signUptoken, AppUrls.signUpToken,
        requireAccess: false);

    if(response is Success){
      try{
        var data = defaultApiResponseFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value=false;
          Get.snackbar("OTP STATUS",
            data.message,
            backgroundColor: Colors.green,
            colorText: Colors.white,);
        }else{
          isLoading.value=false;
          Get.snackbar("OTP STATUS",
            data.message,
            backgroundColor: Colors.red,
            colorText: Colors.white,);
        }
      }catch(e, trace){
        print(e);
        print(trace);
        isLoading.value = false;
      }
    }else{
      isLoading.value= false;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }

  }

}
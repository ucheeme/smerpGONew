import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smerp_go/apiServiceLayer/api_status.dart';
import 'package:smerp_go/main.dart';
import 'package:smerp_go/model/request/signupPin.dart';
import 'package:smerp_go/model/request/signupToken.dart';
import 'package:smerp_go/utils/UserUtils.dart';
import 'package:smerp_go/utils/appUrl.dart';
import 'package:smerp_go/utils/app_services/helperClass.dart';

import '../Reposistory/apiRepo.dart';
import '../apiServiceLayer/apiService.dart';
import '../model/request/createAccount.dart';
import '../model/response/defaultApiResponse.dart';
import '../screens/authentication_signup/signUpFlow/signUpConfirmPinSetup.dart';
import '../screens/authentication_signup/signUpFlow/signUpOTP.dart';
import '../screens/bottomsheets/accountCreatedSuccessful.dart';
import '../utils/AppUtils.dart';
const List<String>trackedPagesAndActions=["SignUpPage","AccountCreatedPage","CreateSalePage","SaleCompletedPage",
"DownloadReport","DownloadReceipt","ShareReceipt"];
class SignUpController extends GetxController{
  TextEditingController signUpPhoneNumber = TextEditingController();
  TextEditingController signUpEmailAddress = TextEditingController();
  TextEditingController signUpPinSetUp = TextEditingController();
  TextEditingController signUpConfirmPinSetUp = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
  StreamController<ErrorAnimationType>();

  StreamController<ErrorAnimationType> errorControllerConfirmPin =
  StreamController<ErrorAnimationType>();


  var isSignUpSetPin =RxBool(false);
  var isSignUpSetPinEmpty =RxBool(false);
  var isSignUpConfirmSetPinEmpty =RxBool(false);

  RxString otpValue="".obs;
  RxInt otplength = 0.obs;
  RxString enteredValue=''.obs;

  Future<void> signUpToken(String value) async{
    if(value.isEmpty){
      Get.snackbar("Invalid ",
        "No field should be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,);

    }else{
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
            Get.to(SignUpOTP(),
                duration: Duration(seconds: 1),
               // curve: Curves.easeIn,
              transition: Transition
                  .cupertino,);
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


  Future<void> createAccount(String value) async{
    if(value.isEmpty){
      Get.snackbar("Invalid ",
        "No field should be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,);
    }else{

      isLoading.value = true;
      CreateAccount? createAccount;
      if (isSignUpViaPhone.value){
        identitySource =1;
        createAccount = CreateAccount(identitySource: identitySourceByPhone,
            identity: value, systemIp: deviceToken);

      }else{
        identitySource =2;
        createAccount = CreateAccount(identitySource: identitySourceByMail,
            identity: value, systemIp: deviceToken);

      }
      var response = await ApiService.makeApiCall(createAccount, AppUrls.createAccount,
          requireAccess: false);

      if(response is Success){
        try{
          var data = defaultApiResponseFromJson(await response.response as String);
          if(data.isSuccess){
            isLoading.value=false;
            Get.snackbar("OTP SENT",
              data.message,
              backgroundColor: Colors.green,
              colorText: Colors.white,);
            Get.to(SignUpOTP(),
                duration: Duration(seconds: 1),
                curve: Curves.easeIn,
              transition: Transition
                  .cupertino,);
          }else{
            isLoading.value=false;
            Get.snackbar("OTP FAILED",
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

  setPinStepOne(){
    print("today");
    if(signUpPinSetUp.text.isEmpty){
      Get.snackbar("Invalid ",
        "No field should be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,);
    }else if(signUpPinSetUp.text.length == 4){
      Get.to(SignUpConfirmPin(pin:int.parse(signUpPinSetUp.text)),
         duration: Duration(seconds: 1),
        // curve: Curves.easeIn,
        transition: Transition
            .cupertino,);
    }else{
      print(signUpPinSetUp.text.length);
      print(signUpPinSetUp.text);
    }
  }

  Future<void> setPinStepTwo()async{
    print(signUpPinSetUp.text);
    print(signUpConfirmPinSetUp.text);
    if(signUpConfirmPinSetUp.text.isEmpty){
      Get.snackbar("Invalid ",
        "No field should be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,);
    }else if(signUpPinSetUp.text == signUpConfirmPinSetUp.text){
      isLoading.value = true;
    // createAccount(userIdentityValue!);
      SignUpPin? signUpPin;

        signUpPin = SignUpPin(otpSource: identitySource!,
            source: userIdentityValue!,
            otp: otpCreateAccout,newPin: signUpConfirmPinSetUp.text);
        //var service = ApiService();
        var response = await ApiService.makeApiCall(signUpPin,
            AppUrls.signUpPin,requireAccess: false);
        print(response);

      if(response is Success){
        try{
          var data = defaultApiResponseFromJson(await response.response as String);

          if(data.isSuccess){
            isLoading.value=false;
            SharedPref.save("userPin", signUpConfirmPinSetUp.text);
            FirebaseAnalytics.instance.logEvent(
              name: trackedPagesAndActions[1],
              parameters: <String, Object>{
                'string_parameter': 'Successfully Create Account',
                'int_parameter': 1,
              },
            );
            Get.bottomSheet(Container(
                height: 445.h,
                child: AccountCreationSuccessful()),
            );
          }else{
            isLoading.value=false;
            Get.snackbar("OTP FAILED",
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
}
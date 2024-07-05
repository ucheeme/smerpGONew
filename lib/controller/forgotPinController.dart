import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smerp_go/model/response/defaultApiResponse.dart';

import '../Reposistory/apiRepo.dart';
import '../apiServiceLayer/apiService.dart';
import '../apiServiceLayer/api_status.dart';
import '../model/request/signupPin.dart';
import '../model/request/signupToken.dart';
import '../screens/authentication_signup/signInFlow/forgotOTP.dart';
import '../screens/bottomsheets/accountCreatedSuccessful.dart';
import '../screens/bottomsheets/pinCreatedSuccessful.dart';
import '../utils/AppUtils.dart';
import '../utils/UserUtils.dart';
import '../utils/appUrl.dart';
import '../utils/app_services/helperClass.dart';

class ForgotPinController extends GetxController{
  var pinValueController= TextEditingController();
  var setForgotPinPhoneNumber= TextEditingController();
  var setForgotPinEmailAddress= TextEditingController();
  TextEditingController forgotPinSetUp = TextEditingController();
  TextEditingController forgotConfirmPinSetUp = TextEditingController();
  var isSetForgotPinViaPhone= RxBool(true);
  StreamController<ErrorAnimationType> errorController =
  StreamController<ErrorAnimationType>();

  StreamController<ErrorAnimationType> errorControllerMail =
  StreamController<ErrorAnimationType>();
  TextEditingController pinValueControllerOTP = TextEditingController();
  RxString otpValue="".obs;
  RxInt otplength = 0.obs;
  RxString otpValueConfirm="".obs;
  RxInt otplengthConfirm = 0.obs;
  RxString enteredValue=''.obs;
  String refCode ='';
  RxBool isEmpty=true.obs;
  RxBool isReSendOTP= false.obs;
  StreamController<ErrorAnimationType> errorControllerOTP =
  StreamController<ErrorAnimationType>();

  StreamController<ErrorAnimationType> errorControllerConfirmPin =
  StreamController<ErrorAnimationType>();
  RxString otpValueOTP ="".obs;
  RxInt otplengthOTP = 0.obs;

  Future<void> forgotPinOtp() async {
    isLoading.value = true;
    SignUpToken? signUptoken;
    if (isSetForgotPinViaPhone.value) {
      identitySource =1;
      signUptoken = SignUpToken(identitySource: identitySourceByPhone,
          identity: userIdentityValue!);
    } else {
      identitySource = 2;
      signUptoken = SignUpToken(identitySource: identitySourceByMail,
          identity: userIdentityValue!);
    }
    var service = ApiService();
    var response = await ApiService.makeApiCall(signUptoken, AppUrls.forgotPinToken,
        requireAccess: false);

    if (response is Success){
      try {
        var data = defaultApiResponseFromJson(await response.response as String);
        if (data.isSuccess) {
          isLoading.value = false;
          Get.snackbar("OTP STATUS ",
            data.message,
            backgroundColor: Colors.green,
            colorText: Colors.white,);
          Get.to(ForgotOTP(),
              duration: Duration(seconds: 1),
              curve: Curves.easeIn);
        } else {
          isLoading.value = false;
        }
      } catch (e, trace) {
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

  Future<void> setPinStepTwo()async {
    // print(signUpPinSetUp.text);
    // print(signUpConfirmPinSetUp.text);
    otpCreateAccout = otpValueOTP.value;
    if (forgotConfirmPinSetUp.text.isEmpty) {
      Get.snackbar("Invalid ",
        "No field should be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,);
    } else if (forgotPinSetUp.text == forgotConfirmPinSetUp.text) {
      isLoading.value = true;
      SignUpPin? signUpPin;

      signUpPin = SignUpPin(otpSource: identitySource!,
          source: userIdentityValue!,
          otp: otpCreateAccout, newPin: forgotConfirmPinSetUp.text);
      //var service = ApiService();
      var response = await ApiService.makeApiCall(signUpPin,
          AppUrls.resetPin, requireAccess: false);
      print(response);

      if (response is Success) {
        try {
          var data = defaultApiResponseFromJson(
              await response.response as String);

          if (data.isSuccess) {
            isLoading.value = false;
            SharedPref.save("userPin", forgotConfirmPinSetUp.text);
            Get.bottomSheet(Container(
                height: 445.h,
                child: PinCreationCreationSuccessful()),
            );
          } else {
            isLoading.value = false;
            Get.snackbar("OTP FAILED",
              data.message,
              backgroundColor: Colors.red,
              colorText: Colors.white,);
          }
        } catch (e, trace) {
          print(e);
          print(trace);
          isLoading.value = false;
        }
      }else{
        isLoading.value= false;
        var repo = ApiRepository();
        repo.handleErrorResponse(response);
      }
    }else{
      Get.snackbar("PIN SETUP FAILED",
        "Pin does not match",
        backgroundColor: Colors.red,
        colorText: Colors.white,);
    }
  }

  Future<void> signUpToken() async {
    isLoading.value = true;
    SignUpToken? signUptoken;
    if (isSetForgotPinViaPhone.value) {
      signUptoken = SignUpToken(identitySource: identitySourceByPhone,
          identity: userIdentityValue!);
    } else {
      signUptoken = SignUpToken(identitySource: identitySourceByMail,
          identity: userIdentityValue!);
    }


    var service = ApiService();
    var response = await ApiService.makeApiCall(
        signUptoken, AppUrls.sendToken,
        requireAccess: false);

    if (response is Success) {
      try {
        var data = defaultApiResponseFromJson(
            await response.response as String);
        if (data.isSuccess) {
          isLoading.value = false;
          Get.snackbar("OTP STATUS",
            data.message,
            backgroundColor: Colors.green,
            colorText: Colors.white,);
        } else {
          isLoading.value = false;
          Get.snackbar("OTP STATUS",
            data.message,
            backgroundColor: Colors.red,
            colorText: Colors.white,);
        }
      } catch (e, trace) {
        print(e);
        print(trace);
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
  }
  }
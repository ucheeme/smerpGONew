import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smerp_go/Reposistory/apiRepo.dart';
import 'package:smerp_go/apiServiceLayer/apiService.dart';
import 'package:smerp_go/apiServiceLayer/api_status.dart';
import 'package:smerp_go/model/request/authenticateDevice.dart';
import 'package:smerp_go/model/request/createProduct.dart';
import 'package:smerp_go/model/response/LoginResponse.dart';
import 'package:smerp_go/model/response/signInUser.dart';
import 'package:smerp_go/screens/authentication_signup/signInFlow/validateNewDevice.dart';
import 'package:smerp_go/utils/UserUtils.dart';
import 'package:smerp_go/utils/appUrl.dart';

import '../main.dart';
import '../model/request/createAccount.dart';
import '../model/request/logni.dart';
import '../model/request/signUpTokenValidation.dart';
import '../model/request/signupToken.dart';
import '../model/response/defaultApiResponse.dart';
import '../model/response/inventoryDashboard.dart';
import '../model/response/salesDashboard.dart';
import '../screens/authentication_signup/signInFlow/signin.dart';
import '../screens/bottomNav/bottomNavScreen.dart';
import '../screens/bottomsheets/newUpdate.dart';
import '../utils/AppUtils.dart';
import '../utils/app_services/helperClass.dart';

class SignInController extends GetxController{
  StreamController<ErrorAnimationType> errorController =
  StreamController<ErrorAnimationType>();
  final TextEditingController pinValueControllerDevice = TextEditingController();
  RxString otpValue="".obs;
  RxInt otplength = 0.obs;
  RxBool isEmpty=true.obs;
  RxBool isReSendOTP= false.obs;


  var storeName =Rx<String>("");
  var storeAvatar =Rx<String>("assets/waaz.png");
  StreamController<ErrorAnimationType> errorController2=
  StreamController<ErrorAnimationType>();
  RxBool isLoading =RxBool(false);
  var pinValueController= TextEditingController();
  var pinValueController2= TextEditingController();
  var signInPhoneNumber= TextEditingController();
  var signInEmailAddress= TextEditingController();
  var isSignInViaPhone= RxBool(true);
  var isSignInWithAnotherAcct= RxBool(false);

  // void testing() {
  //   print("haahaaha");
  // }


Future<bool> loginUser(String? id, String pin,{context}) async{
  isLoading.value= true;
  if(await SharedPref.getBool("keepUserInfo")){
    String e = await SharedPref.read("userId");
    print(e);
    id = e.substring(1, e.length - 1);
   //id =e
    update();
  }
print(id);

  Login? login;

  login = Login(username: id!, pin: pin);
  var response = await ApiService.makeApiCall2(login, AppUrls().loginUser,
  isAdmin: false, requireAccess: false);
  if(response is Success){
    try{
      var data = loginResponseFromJson(await response.response as String);
      if(data.isSuccess){
        loginData=null;
        isLoading.value = false;
         actionBy=AppUrls().getActionBy(data.data!.userId);
        SharedPref.save("userInfo", data.data);
        SharedPref.saveBool("keepUserInfo", true);
        SharedPref.save("userIdentityValue", id);
        SharedPref.save("userFirstName", data.data!.firstName);
        SharedPref.save("userImage", data.data!.avatar);
        loginData = data.data;
        userFirstNameS.value=loginData!.firstName;

        // print(loginData?.userId);
        // print(data.data.storeEmail);
        userName = "${data.data!.firstName} ${data.data!.lastName}";
        userBusinessName.value= data.data!.storeName;
        //userEmail = data.data.email;
        userEmail = data.data!.storeEmail;
      //  actionBy = data.data.userId;
        userMerchantCode = data.data!.merchantCode;
        userAccessToken = data.data!.token;
        userImage.value= data.data!.avatar;
        userFirstName =data.data!.firstName;
     // salesDashboard();
        if(loginData!.deviceId == null || loginData!.deviceMIME == null){
          var response=   await ApiService.makeApiCall2(
              AuthenticateDevice(actionBy: loginData!.userId,
                  actionOn: DateTime.now().toIso8601String(),
                  deviceId: deviceToken, deviceIMEI: deviceId??"",
                  deviceType: deviceType), AppUrls.authenticateDevice,
              isAdmin: false, requireAccess: true,method: HTTP_METHODS.put);
          if(response is Success){
            try{
              var data = defaultApiResponseFromJson(await response.response as String);
              if(data.isSuccess){
                // _controller.isLoading.value=false;
                Get.back();
                Get.off(MainNavigationScreen(),
                  duration: Duration(seconds: 1),
                  transition: Transition
                      .cupertino,);
              }else{
                // _controller. isLoading.value=false;
                Get.snackbar("Device Authorization Failed",
                  data.message,
                  backgroundColor: Colors.red.withOpacity(0.5),
                  colorText: Colors.white,);
              }
            }catch(e){
              print("$e");
            }
          }
          Get.off(MainNavigationScreen(),
            duration: Duration(seconds: 1),
            transition: Transition.cupertino,);
        } else if(loginData!.deviceId!=deviceToken ||loginData!.deviceMIME!=deviceId) {
          showCupertinoModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 700.h,
                  child: NewDeviceSetUp(),
                );
              });
        }
        else{
          Get.off(MainNavigationScreen(),
            duration: Duration(seconds: 1),
            transition: Transition
                .cupertino,);
        }
        // await ApiService.makeApiCall2(
        //     AuthenticateDevice(actionBy: loginData!.userId,
        //         actionOn: DateTime.now().toIso8601String(),
        //         deviceId: deviceToken, deviceIMEI: deviceId??"",
        //         deviceType: deviceType), AppUrls.authenticateDevice,
        //     isAdmin: false, requireAccess: true,method: HTTP_METHODS.put);

return true;
      // productCreate();
  }
      else{
        isLoading.value=false;
        Get.snackbar("SignIn Failed",
          data.message,
          backgroundColor: Colors.red.withOpacity(0.5),
          colorText: Colors.black,);
       // return false;
      }
    }catch(e, trace){
      isLoading.value = false;
      print(e);
      print(trace);
     // return false;
    }
  }
  else if(response is Failure){
    try{
      print("this is the response ${response.errorResponse}");
      var data = defaultApiResponseFromJson(response.errorResponse as String);

      isLoading.value=false;
      Get.snackbar("SignIn Failed",
        data.message,
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,);
    }catch(e,trace){
      isLoading.value=false;
   print(e);
   print(trace);
    }

  }else{
    isLoading.value= false;
    var repo = ApiRepository();
    var r =await repo.handleErrorResponse(response);

  }
  return false;
}

  void testing() {
    print("aha");
  }

  Future<void>  inventoryDashboard({isRefresh=
  false})async{
    var response = await ApiService.makeApiCall(null,
        AppUrls().getInventorysummary,requireAccess: true,
        method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = inventoryDashboardFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value = false;
          (data.data.productCount==0)?
          productIsEmpty.value=true :
          productIsEmpty.value =false;
          // inventoryAmount.value = data.data.salesValue.toString();

        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController.refreshFailed():null;
      }
    }else{
      isLoading.value = false;
      (isRefresh)?refreshController.refreshFailed():null;
      //  var repo = ApiRepository();
      //repo.handleErrorResponse(response);
    }
  }



  Future<void> verifyUserNewDevice(int value) async{
    isLoading.value = true;
    CreateAccount? createAccount;
    if (value==1){
      identitySource =1;
      createAccount = CreateAccount(identitySource: identitySourceByPhone,
          identity: loginData!.storePhoneNumber??"", systemIp: deviceId);
    }else if(value ==2){
      identitySource =2;
      createAccount = CreateAccount(identitySource: identitySourceByMail,
          identity: loginData!.storeEmail??"", systemIp: deviceId);
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
          Get.to(ValidateNewDevice(),
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
  Future<void> tokenValidationNewDevice()async{
    isLoading.value = true;
    SignUpTokenValidation? signUpTokenValidation;
    if (isSignUpViaPhone.value){
      signUpTokenValidation = SignUpTokenValidation(otpSource: identitySourceByPhone,
          source: userIdentityValue!,otp:otpValue.value );
    }else{
      signUpTokenValidation = SignUpTokenValidation(otpSource: identitySourceByMail,
          source: userIdentityValue!, otp: otpValue.value);
    }
    var response = await ApiService.makeApiCall(signUpTokenValidation, AppUrls.signUpTokenValidation,
        requireAccess: false);
    if(response is Success){
      try{
        var data = defaultApiResponseFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value=false;
          //post new device info

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


  Future<void>  salesDashboard({isRefresh=
  false})async{
    isLoading.value = true;

    var response = await ApiService.makeApiCall(null,
        AppUrls().getSalesDashboard,
        method: HTTP_METHODS.post );
    if(response is Success){
      try{
        var data = salesDashboardFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value = false;
         ( data.data.salasCount==0)?
          saleIsEmpty.value = true
             :saleIsEmpty.value=false;
          Get.off(MainNavigationScreen(),
              duration: Duration(seconds: 1),
             // curve: Curves.bounceIn,
            transition: Transition
                .cupertino,);
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController.refreshFailed():null;
      }
    }else{
      (isRefresh)?refreshController.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }
  }

  addStringToSF(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }


  Future<void> signInUsers() async {
  isLoading.value = true;
  SignUpToken? signUptoken;
  if (isSignInViaPhone.value) {
    signUptoken = SignUpToken(identitySource: identitySourceByPhone,
        identity: userIdentityValue!);
  } else {
    signUptoken = SignUpToken(identitySource: identitySourceByMail,
        identity: userIdentityValue!);
  }
  var service = ApiService();
  var response = await ApiService.makeApiCall(signUptoken, AppUrls.signInUser,
      requireAccess: false);

  if (response is Success){
    try {
      var data = signInResponseFromJson(await response.response as String);
      if (data.isSuccess) {
        isLoading.value = false;
        storeName.value = data.data.firstname;
        userFirstName = data.data.firstname;
        userImage.value = (data.data.avatar==null||data.data.avatar=="")?"":data.data.avatar!;
        SharedPref.save("userId", userIdentityValue!);
        SharedPref.save("userImage", userImage.value);
        addStringToSF("userImage", userImage.value);
        Get.to(SignIn(),
            duration: Duration(seconds: 1),
          // curve: Curves.bounceIn,
          transition: Transition
              .cupertino,);
      } else {
        isLoading.value = false;
        Get.snackbar("User Identity Failed",
          data.message,
          backgroundColor: Colors.red.withOpacity(0.5),
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
}

// @override
// void dispose(){
//   pinValueController.dispose();
//   super.dispose();
// }
@override
  void onInit() {
    print("in it");
    super.onInit();
  }
}
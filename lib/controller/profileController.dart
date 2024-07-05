


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/apiServiceLayer/api_status.dart';
import 'package:smerp_go/model/response/defaultApiResponse.dart';
import 'package:smerp_go/model/response/userProfileInfoe.dart';
import 'package:smerp_go/model/response/validateOtp.dart';
import 'package:smerp_go/screens/bottomsheets/phoneEmailChangeSuccessFul.dart';

import '../Reposistory/apiRepo.dart';
import '../apiServiceLayer/apiService.dart';
import '../main.dart';
import '../model/request/sendOtpForUserUpdate.dart';
import '../model/request/updateProfileImage.dart';
import '../model/request/updateProfileInfo.dart';
import '../model/response/updateImageResponse.dart';
import '../screens/authentication_signup/signInFlow/signinViaPhoneEmail.dart';
import '../screens/onboarding/splashScreen2.dart';
import '../utils/AppUtils.dart';
import '../utils/UserUtils.dart';
import '../utils/appUrl.dart';
import '../utils/mockdata/tempData.dart';

class ProfileController extends GetxController{
  var firstName = TextEditingController();
  var otherNames = TextEditingController();
  var storeName = TextEditingController();
  var storeEmail = TextEditingController();
  var storePhone = TextEditingController();
  var storeMerchantCode = TextEditingController();
  RxString userNamee="".obs;
  String? userUpdateImage;
  RxBool isLoading = false.obs;
  StreamController<ErrorAnimationType> errorController =
  StreamController<ErrorAnimationType>();

  Future<void> updateStoreInfo(
      String firstName, String lastName, String businessName
      )async{
    isLoading.value = true;
    ProfileInfoUpdate? profileInfoUpdate;

    profileInfoUpdate = ProfileInfoUpdate(actionBy: actionBy,
        actionOn: DateTime.now(), firstName: firstName, otherName: lastName,
        businessName: businessName);
    var response = await ApiService.makeApiCall(profileInfoUpdate,
        AppUrls.updateProfileName,
        method: HTTP_METHODS.put);

    if(response is Success){
      try{
        var data = defaultApiResponseFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value = false;
          userFirstNameS.value= firstName;
          loginData!.firstName =firstName;
          loginData!.lastName =lastName;
          loginData!.storeName = businessName;

          Get.snackbar("Profile Info",
            data.message,
            backgroundColor: Colors.green.withOpacity(0.5),
            colorText: Colors.white,);
        }else{
          isLoading.value = false;
          Get.snackbar("Profile Info",
            data.message,
            backgroundColor: Colors.red.withOpacity(0.5),
            colorText: Colors.white,);
        }
      }catch(e,trace){
        isLoading.value = false;
       AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
      }
    }else{
      isLoading.value = false;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }

  }

  Future<bool> getOtpToChangeUserInfo(
      int selectedOption,String userIdentity,
      RxBool isLoading
      )async{
    isLoading.value = true;
    SendOtpToVerifyUser? sendOtpToVerifyUser;

    sendOtpToVerifyUser = SendOtpToVerifyUser(
      identity:userIdentity ,
      identitySource:selectedOption,
      systemIp: deviceId
    );

    var response = await ApiService.makeApiCall(sendOtpToVerifyUser,
        AppUrls().getOtpToChangeUserInfoMailPhone,
        method: HTTP_METHODS.post,requireAccess: true);

    if(response is Success){
      try{
        var data = defaultApiResponseFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value = false;
          Get.snackbar("Otp Status",
            data.message,
            backgroundColor: Colors.green.withOpacity(0.5),
            colorText: Colors.white,);
          return true;
        }else{
          isLoading.value = false;
          Get.snackbar("Otp Status",
            data.message,
            backgroundColor: Colors.red.withOpacity(0.5),
            colorText: Colors.white,);
          return false;
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        return false;
      }
    }else{
      isLoading.value = false;
      var repo = ApiRepository();
     //repo.handleErrorResponse(response);
      return false;
    }

  }

  Future<bool> validateOtp(
      int selectedOption,String userIdentity,String otp,
      RxBool isLoading,{
        context
  }
      )async{
    isLoading.value = true;
    ValidateOtpSent? validateOtpSent;

    validateOtpSent = ValidateOtpSent(
        otpSource:selectedOption ,
        source:userIdentity,
        otp: otp
    );

    var response = await ApiService.makeApiCall(validateOtpSent,
        AppUrls().validateOtpToChangeUserInfoMailPhone,
        method: HTTP_METHODS.post,requireAccess: true);

    if(response is Success){
      try{
        var data = defaultApiResponseFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value = false;
          if(selectedOption==1){
            loginData!.storePhoneNumber = userIdentity;
            storeNPhone.value=userIdentity;
          }else{
            loginData!.storeEmail= userIdentity;
            storeNEmail.value=userIdentity;
          }
          Get.snackbar("Otp Status",
            data.message,
            backgroundColor: Colors.green.withOpacity(0.5),
            colorText: Colors.white,);
          Navigator.pop(context);
          Navigator.pop(context);
          Get.bottomSheet(
              PhoneEmailSuccessfulChange());

          return true;
        }else{
          isLoading.value = false;
          Get.snackbar("Otp Status",
            data.message,
            backgroundColor: Colors.red.withOpacity(0.5),
            colorText: Colors.white,);
          return false;
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        return false;
      }
    }else{
      isLoading.value = false;
      var repo = ApiRepository();
     // repo.handleErrorResponse(response);
      return false;
    }

  }



  Future<void> updateStorePic(
      String image
      )async{
    isLoading.value = true;
    ProfileImageUpdate? profileImageUpdate;

    profileImageUpdate = ProfileImageUpdate(actionBy: actionBy,
        actionOn: DateTime.now(), imageString: image);
    var response = await ApiService.makeApiCall(profileImageUpdate,
        AppUrls.updateProfileImage,
        method: HTTP_METHODS.put);

    if(response is Success){
      try{
        var data = profileImageUpdateResponseFromJson(await response.response as String);
        if(data.isSuccess){
          isLoading.value = false;
          SharedPref.save("userImage", userImage.value);
          // SharedPref.save("userImage", userImage);
          Get.snackbar("Profile Picture",
            data.message,
            backgroundColor: Colors.green.withOpacity(0.5),
            colorText: Colors.white,);
        }else{
          isLoading.value = false;
          Get.snackbar("Profile Picture",
            data.message,
            backgroundColor: Colors.red.withOpacity(0.5),
            colorText: Colors.white,);
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
      }
    }else{
      isLoading.value=false;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
    }

  }

  Future<bool> userInfo({isRefresh=
  false,
    RefreshController? refreshController
  })async{
    (isRefresh) ?isLoading.value=false:
    isLoading.value = true;
    var response = await ApiService.makeApiCall(null,
        AppUrls().userProfileInfo,requireAccess: true,
        method: HTTP_METHODS.get );
    if(response is Success){
      try{
        var data = userProfileInfoFromJson(await response.response as String);
        if(data.isSuccess && data.data != null){
          isLoading.value = false;
          userImage.value=data.data.avatar;
          loginData!.firstName= data.data.firstName;
          loginData!.lastName= data.data.lastName;
          userNamee.value="${data.data.firstName} ${data.data.lastName}";
          userBusinessName.value=data.data.businessName;
          SharedPref.save("userImage", userImage);
          SharedPref.save("userBusinessName", userBusinessName);
          (isRefresh)?
          refreshController?.refreshCompleted():
          null;
return true;
        }else{
          isLoading.value = false;
return false;
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());
        (isRefresh)?refreshController?.refreshFailed():null;
        return false;
      }
    }else{
      isLoading.value= false;
      (isRefresh)?refreshController?.refreshFailed():null;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
      return false;
    }
return false;
  }

  Future<bool> deleteAcct(context,{isRefresh=
  false,
    RefreshController? refreshController
  })async{
    (isRefresh) ?isLoading.value=false:
    isLoading.value = true;
    var response = await ApiService.makeApiCall(null,
        AppUrls().deleteAccount,requireAccess: true,
        method: HTTP_METHODS.put );
    if(response is Success){
      try{
        var data = defaultApiResponseFromJson(await response.response as String);
        if(data.isSuccess && data.data == null){
          isLoading.value = false;
          productCategoryList =[];
          productUnitCategoryList =[];
          inventoryListTemp =[];
          catalogListTemp =[];
          catalogsFTemp = [];
          saleListTemp=[];
          actionBy = "";
          inventoryId="";
          userImage ="".obs;
          isLoading.value=false;
          isSignUpViaPhone.value =true;
          userIdentityValue=null;
          identitySource = null;
          otpCreateAccout= "";
          userName= "";
          userBusinessName.value="";
          userEmail= "";
          userMerchantCode="";
          loginData=null;
          isProductCategoryHasRun = Rx(false);
          isProductUnitCategoryHasRun = Rx(false);
          isInventoryListHasRun =false;
          isSalesListHasRun = Rx(false);
          isCatalogListHasRun = Rx(false);
          saleIsEmpty= RxBool(false);
          productIsEmpty= RxBool(false);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (
                    context) => const Splashscreen(),),
                  (route) => false);
          return true;
        }else{
          isLoading.value = false;
          return false;
        }
      }catch(e,trace){
        isLoading.value = false;
        AppUtils.debug(e.toString());
        AppUtils.debug(trace.toString());

      }
    }else{
      isLoading.value= false;
      var repo = ApiRepository();
      repo.handleErrorResponse(response);
      return false;
    }
    return false;
  }


}
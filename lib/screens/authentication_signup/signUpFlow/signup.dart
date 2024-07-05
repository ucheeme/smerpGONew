import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:smerp_go/controller/signupController.dart';
import 'package:smerp_go/main.dart';
import 'package:smerp_go/screens/authentication_signup/signInFlow/signinViaPhoneEmail.dart';
import 'package:smerp_go/screens/authentication_signup/signUpFlow/setUpPin.dart';
import 'package:smerp_go/screens/authentication_signup/signUpFlow/signUpOTP.dart';
import 'package:smerp_go/screens/authentication_signup/signInFlow/signin.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../../../utils/AppUtils.dart';
import '../../onboarding/splashScreen2.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var signUpController = Get.put(SignUpController());

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(
      name: trackedPagesAndActions[0],
      parameters: <String, dynamic>{
        'string_parameter': 'Entered SignUp page',
        'int_parameter': 0,
      },
    );
    super.initState();
  }
  @override
  void dispose() {
 signUpController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return OverlayLoaderWithAppIcon(
        isLoading: isLoading.value,
        overlayBackgroundColor: kBlackB600,
        circularProgressColor: kAppBlue,
        appIconSize: 40.h,
        appIcon: SizedBox(),
        child: Scaffold(

          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Obx(() {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    gapHeight(25.h),
                    (isSignUpViaPhone.value) ?
                    appBarDesign(() => Get.off(Splashscreen())) :
                    appBarDesign(() => Get.off(Splashscreen()),
                      footer: "Create your account with your e-mail address \n"
                          "Enter your E-mail address",
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          gapHeight(25.h),
                          (isSignUpViaPhone.value) ?
                          titleSignUp(signUpController.signUpPhoneNumber,
                              textInput: TextInputType.phone,
                              hintText: "Enter your phone number",) :
                          titleSignUp(signUpController.signUpEmailAddress,
                              textInput: TextInputType.emailAddress,
                              hintText: "Enter your email address"),
                          gapHeight(30.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              (isSignUpViaPhone.value) ?
                              GestureDetector(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  isSignUpViaPhone.value =
                                  false;
                                  signUpController.signUpPhoneNumber.clear();
                                },
                                child: customText1(
                                    "Or Sign up with email address", kBlack, 16.sp,
                                    fontWeight: FontWeight.w400),
                              ) :
                              GestureDetector(
                               onTap: () {
                                 FocusManager.instance.primaryFocus?.unfocus();
                                  isSignUpViaPhone.value = true;
                                  signUpController.signUpEmailAddress.clear();
                                },
                                child: customText1(
                                    "Or Sign up with phone number", kBlack, 16.sp,
                                    fontWeight: FontWeight.w400,
                                    indent: TextAlign.end),
                              ),
                            ],
                          ),
                          gapHeight(302.h),
                          GestureDetector(
                            onTap: () {
                              if(isSignUpViaPhone.value){
                               if(validateMobile(signUpController.signUpPhoneNumber.text)) {

                                  userIdentityValue = signUpController.signUpPhoneNumber.text;
                                  signUpController.createAccount(userIdentityValue!);
                                }
                               else{
                                  Get.snackbar("Invalid Phone Number",
                                    "Please enter a valid phone number",
                                    backgroundColor: Colors.red.withOpacity(0.5),
                                    colorText: Colors.white,
                                  );
                                }
                              }
                              else{
                                if(validateEmail(signUpController.
                                signUpEmailAddress.text)){
                                  userIdentityValue =signUpController.
                                  signUpEmailAddress.text;
                                  signUpController.createAccount(userIdentityValue!);
                                }else{
                                  Get.snackbar("Invalid Email Address",
                                    "Please enter a valid mail",
                                    backgroundColor: Colors.red.withOpacity(0.5),
                                    colorText: Colors.white,);
                                }

                              }

                            //  Get.to(SignUpOTP(),
                            //       duration: Duration(seconds: 1),
                            //       curve: Curves.easeIn);
                            },
                            child: dynamicContainer(
                                Center(child: customText1("Proceed",
                                    kWhite, 18.sp)),
                                kAppBlue, 60.h,
                                radius: 15.r),
                          ),
                          gapHeight(58.h),
                          GestureDetector(
                            onTap: () {
                              Get.to(SignInViaPhoneEmail(),
                                  duration: Duration(seconds: 1),
                                  curve: Curves.easeIn);
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  customText1(
                                      "Already have an account?", kBlackB800,
                                      16.sp),
                                  gapWeight(6.71.w),
                                  customText1("Login", kBlack, 16.sp)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),


                  ],
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}

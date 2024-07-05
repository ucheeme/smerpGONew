import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:smerp_go/controller/signupController.dart';
import 'package:smerp_go/screens/authentication_signup/signInFlow/forgotOTP.dart';
import 'package:smerp_go/screens/authentication_signup/signInFlow/signin.dart';
import 'package:smerp_go/screens/authentication_signup/signUpFlow/signUpOTP.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../../../controller/forgotPinController.dart';
import '../../../controller/signInController.dart';
import '../../../main.dart';
import '../../../utils/AppUtils.dart';
import '../../onboarding/splashScreen2.dart';

class ForGotSignInPin extends StatefulWidget {
  const ForGotSignInPin({Key? key}) : super(key: key);

  @override
  State<ForGotSignInPin> createState() => _ForGotSignInPinState();
}

class _ForGotSignInPinState extends State<ForGotSignInPin> {
  var _controller = Get.put(ForgotPinController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return OverlayLoaderWithAppIcon(
        isLoading: isLoading.value,
        overlayBackgroundColor: kBlackB600,
        circularProgressColor: kAppBlue,
        appIconSize: 40.h,
        appIcon: SizedBox(),
        child: GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            body: Obx(() {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    gapHeight(20.h),
                    (_controller.isSetForgotPinViaPhone.value)
                        ?
                    appBarDesign(() {
                      Get.off(Splashscreen());},
                     // Navigator.pop(context);},
                        title: "Forgot pin",
                        footer: "Recover your pin, enter your registered mobile \nnumber to recover password")
                        :
                    appBarDesign((){
                      Get.off(Splashscreen());
                      },
                        footer: "Recover your pin, enter your registered\n"
                            "e-mail address to recover password",
                        title: "Forgot pin"
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          gapHeight(25.h),
                          (_controller.isSetForgotPinViaPhone.value) ?
                          titleSignUp(_controller.setForgotPinPhoneNumber,
                              textInput: TextInputType.phone,
                              hintText: "Enter your phone number") :
                          titleSignUp(_controller.setForgotPinEmailAddress,
                              textInput: TextInputType.emailAddress,
                              hintText: "Enter your email address"),
                          gapHeight(30.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              (_controller.isSetForgotPinViaPhone.value) ?
                              GestureDetector(
                                onTap: () {
                                  _controller.isSetForgotPinViaPhone.value = false;
                                },
                                child: customText1(
                                    "Reset via email address", kBlack, 16.sp,
                                    fontWeight: FontWeight.w400),
                              ) :
                              GestureDetector(
                                onTap: () {
                                  _controller.isSetForgotPinViaPhone.value = true;
                                },
                                child: customText1(
                                    "Reset via phone number", kBlack, 16.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),

                          gapHeight(302.h),
                          GestureDetector(
                            onTap: () {
                              print("fdfb");
                              if (_controller.isSetForgotPinViaPhone.value) {
                                if (validateMobile(
                                    _controller.setForgotPinPhoneNumber.text)) {
                                  userIdentityValue =
                                      _controller.setForgotPinPhoneNumber.text;
                                } else {
                                  Get.snackbar("Invalid Phone Number",
                                    "Please enter a valid phone number",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,);
                                }
                              } else {
                                if (validateEmail(_controller.
                                setForgotPinEmailAddress.text)) {
                                  userIdentityValue = _controller.
                                  setForgotPinEmailAddress.text;
                                } else {
                                  Get.snackbar("Invalid Email Address",
                                    "Please enter a valid mail",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,);
                                }
                              }
                              _controller.forgotPinOtp();
                              // Get.to(ForgotOTP(),
                              //     duration: Duration(seconds: 1),
                              //     curve: Curves.easeIn);
                            },
                            child: dynamicContainer(
                                Center(child: customText1("Proceed",
                                    kWhite, 18.sp)),
                                kAppBlue, 60.h,
                                radius: 15.r),
                          ),
                          gapHeight(58.h),
                          Padding(
                            padding: EdgeInsets.only(left: 74.w, right: 74.w),
                            child: altTextButton(() {
                              Get.off(SignIn(),
                                  duration: Duration(seconds: 1),
                                  curve: Curves.easeIn);
                            }, "Login",
                                text1: "Already have an account?"),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:smerp_go/controller/signupController.dart';
import 'package:smerp_go/main.dart';
import 'package:smerp_go/screens/authentication_signup/signUpFlow/signUpOTP.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../../../controller/signInController.dart';
import '../../onboarding/splashScreen2.dart';
import '../signUpFlow/setUpPin.dart';
import '../signUpFlow/signup.dart';

class SignInViaPhoneEmail extends StatefulWidget {
  const SignInViaPhoneEmail({Key? key}) : super(key: key);

  @override
  State<SignInViaPhoneEmail> createState() => _SignInViaPhoneEmailState();
}

class _SignInViaPhoneEmailState extends State<SignInViaPhoneEmail> {
  var _controller = Get.put(SignInController());

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return OverlayLoaderWithAppIcon(
        isLoading: _controller.isLoading.value,
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
                    (_controller.isSignInViaPhone.value)
                        ?
                    appBarDesign(() {
                     // _controller.dispose();
                     // Navigator.pop(context);
                      Get.off(Splashscreen());
                      },
                        title: "Enter your number",
                        footer: "Enter your SmerpGo registered mobile number \nto login")
                        :
                    appBarDesign(() {
                      //_controller.dispose();
                     // Navigator.pop(context);
                      Get.off(Splashscreen());
                      },
                        footer: "Enter your SmerpGo registered mobile number \nto login",
                        title: "Enter your email address"
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          gapHeight(25.h),
                          (_controller.isSignInViaPhone.value) ?
                          titleSignUp(_controller.signInPhoneNumber,
                              textInput: TextInputType.phone,
                              hintText: "Enter your phone number") :
                          titleSignUp(_controller.signInEmailAddress,
                              textInput: TextInputType.emailAddress,
                              hintText: "Enter your email address"),
                          gapHeight(30.h),
                          (_controller.isSignInViaPhone.value) ?
                          GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _controller.isSignInViaPhone.value = false;
                              _controller.signInPhoneNumber.clear();
                            },
                            child: customText1(
                                "Or Sign in with email address", kBlack, 16.sp,
                                fontWeight: FontWeight.w400),
                          ) :
                          GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _controller.isSignInViaPhone.value = true;
                              _controller.signInEmailAddress.clear();

                            },
                            child: customText1(
                                "Or Sign in with phone number", kBlack, 16.sp,
                                fontWeight: FontWeight.w400),
                          ),
                          gapHeight(302.h),
                          GestureDetector(
                            onTap: () {
                              if (_controller.isSignInViaPhone.value) {
                                if (validateMobile(
                                    _controller.signInPhoneNumber.text)) {
                                  userIdentityValue =
                                      _controller.signInPhoneNumber.text;
                                  _controller.signInUsers();
                                } else {
                                  Get.snackbar("Invalid Phone Number",
                                    "Please enter a valid phone number",
                                    backgroundColor: Colors.red.withOpacity(0.5),
                                    colorText: Colors.white,);
                                }
                              } else {
                                if (validateEmail(_controller.
                                signInEmailAddress.text)) {
                                  userIdentityValue = _controller.
                                  signInEmailAddress.text;
                                  _controller.signInUsers();
                                } else {
                                  Get.snackbar("Invalid Email Address",
                                    "Please enter a valid mail",
                                    backgroundColor: Colors.red.withOpacity(0.5),
                                    colorText: Colors.white,);
                                }
                              }

                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w,left: 10.w),
                              child: dynamicContainer(
                                  Center(child: customText1("Proceed",
                                      kWhite, 18.sp)),
                                  kAppBlue, 60.h,
                                  radius: 15.r),
                            ),
                          ),
                          gapHeight(58.h),
                          Padding(
                            padding: EdgeInsets.only(left: 74.w, right: 74.w),
                            child: altTextButton(() {
                              Get.off(Signup(),
                                  duration: Duration(seconds: 1),
                                  curve: Curves.easeIn,
                                transition: Transition.cupertino,);
                            }, "Register",
                                text1: "Don't have an account?"),
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

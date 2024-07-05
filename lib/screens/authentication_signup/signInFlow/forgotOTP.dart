import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:smerp_go/screens/authentication_signup/signInFlow/forgotPin.dart';
import 'package:smerp_go/screens/authentication_signup/signInFlow/resetPinSetup.dart';
import 'package:smerp_go/screens/authentication_signup/signUpFlow/setUpPin.dart';
import 'package:smerp_go/utils/appColors.dart';

import '../../../controller/accountVerification.dart';
import '../../../controller/forgotPinController.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/appDesignUtil.dart';
import '../../../utils/customPin.dart';
import '../../../utils/custom_keypad.dart';


class ForgotOTP extends StatefulWidget {
  ForgotOTP({Key? key,}) : super(key: key);

  @override
  State<ForgotOTP> createState() => _ForgotOTPState();
}

class _ForgotOTPState extends State<ForgotOTP> {
  var _controller =
  Get.put(ForgotPinController());
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
          body: Obx(() {
            return Column(
              children: [
                (!_controller.isReSendOTP.value) ?
                appBarDesign(() => Navigator.pop(context),
                    footer: "Enter Otp sent",
                    title: "Enter OTP"
                ) : appBarDesign(() => Navigator.pop(context),
                    footer: "Enter Otp sent.",
                    title: "OTP Resent"
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          gapHeight(39.h),
                          customText1("Enter OTP", kBlack, 18.sp,
                              fontWeight: FontWeight.w400),
                          gapHeight(29.h),
                          CustomPinTheme(
                            pinLength: 6,
                            errorController:
                            _controller.errorControllerOTP,
                            onTap: (String value) {
                              setState(
                                    () {
                                  print("a test");
                                  _controller.otpValueOTP.value = value;
                                  _controller.otplengthOTP.value =
                                      value.length;
                                  if (_controller.pinValueControllerOTP.text
                                      .length ==
                                      6) {
                                    Get.off(ResetForgotPin(),
                                        duration: Duration(seconds: 1),
                                        curve: Curves.easeIn
                                    );
                                  }
                                },
                              );
                            },
                            pinValueController:
                            _controller.pinValueControllerOTP,
                            isOTP: true,),
                       //   customText1("OTP expires in", kBlackB800, 14.sp),
                          gapHeight(20.h),
                          Container(
                              height: 370.h,
                              child: CustomKeypad(controller:
                              _controller.
                              pinValueControllerOTP,)),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 94.w, right: 74.w, top: 20.w),
                            child: altTextButton(() {
                              _controller.signUpToken();
                            }, "Resend",
                                text1: "Didnt receive OTP?"),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      );
    });
  }
}

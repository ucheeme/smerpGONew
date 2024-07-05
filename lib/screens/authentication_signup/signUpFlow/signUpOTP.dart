import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:smerp_go/screens/authentication_signup/signUpFlow/setUpPin.dart';
import 'package:smerp_go/utils/appColors.dart';

import '../../../controller/accountVerification.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/appDesignUtil.dart';
import '../../../utils/customPin.dart';
import '../../../utils/custom_keypad.dart';


class SignUpOTP extends StatefulWidget {
  SignUpOTP({Key? key,}) : super(key: key);

  @override
  State<SignUpOTP> createState() => _SignUpOTPState();
}

class _SignUpOTPState extends State<SignUpOTP> {
  AccountVerificationController accountVerificationController =
  Get.put(AccountVerificationController());
  var pinValueController2= TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    accountVerificationController.pinValueController.dispose();
    accountVerificationController.dispose();
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
          body: Obx(() {
            return Column(
              children: [
                (!accountVerificationController.isReSendOTP.value) ?
                appBarDesign(() => Navigator.pop(context),
                    footer: "Enter Otp sent.",
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
                            accountVerificationController.errorController,
                            onTap: (String value) {
                              setState(
                                    () {
                                  print("a test");
                                  accountVerificationController.otpValue.value =
                                      value;
                                  accountVerificationController.otplength
                                      .value =
                                      value.length;
                                  if (pinValueController2.text.length ==
                                      6) {
                                    accountVerificationController
                                        .tokenValidation();
                                  }
                                },
                              );
                            },
                            pinValueController: pinValueController2,
                            isOTP: true,),
                          // customText1("OTP expires in", kBlackB800, 14.sp),
                          gapHeight(20.h),
                          Container(
                              height: 370.h,
                              child: CustomKeypad(controller:

                              pinValueController2,)),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 94.w, right: 74.w, top: 20.w),
                            child: altTextButton(() {
                             accountVerificationController.signUpToken();
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../../../controller/accountVerification.dart';
import '../../../controller/signInController.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/appColors.dart';
import '../../../utils/appDesignUtil.dart';
import '../../../utils/customPin.dart';
import '../../../utils/custom_keypad.dart';

class ValidateNewDevice extends StatefulWidget {
  const ValidateNewDevice({super.key});

  @override
  State<ValidateNewDevice> createState() => _ValidateNewDeviceState();
}

class _ValidateNewDeviceState extends State<ValidateNewDevice> {
  SignInController accountVerificationController =
  Get.put(SignInController());
  var pinValueController2= TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    accountVerificationController.pinValueControllerDevice.dispose();
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
                                        .tokenValidationNewDevice();
                                  }
                                },
                              );
                            },
                            pinValueController:
                            pinValueController2,
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
                              if(loginData!.phoneNumber.isNull||loginData!.phoneNumber==""){
                                //if uer doesnt have phone number otp is sent to email
                                accountVerificationController.verifyUserNewDevice(2);
                              }else if(loginData!.email.isNull||loginData!.email==""){
                                //if user doesnt have email otp is sent to phone number
                                accountVerificationController.verifyUserNewDevice(1);
                              }else{
                                accountVerificationController.verifyUserNewDevice(2);
                              }
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

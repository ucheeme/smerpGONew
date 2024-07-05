import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:smerp_go/screens/bottomsheets/accountCreatedSuccessful.dart';
import 'package:smerp_go/utils/appColors.dart';

import '../../../controller/accountVerification.dart';
import '../../../controller/signupController.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/appDesignUtil.dart';
import '../../../utils/customPin.dart';
import '../../../utils/custom_keypad.dart';


class SignUpConfirmPin extends StatefulWidget {
  final int pin;
  const SignUpConfirmPin({required this.pin,Key? key}) : super(key: key);

  @override
  State<SignUpConfirmPin> createState() => _SignUpConfirmPinState();
}

class _SignUpConfirmPinState extends State<SignUpConfirmPin> {
  SignUpController _controller =
  Get.put(SignUpController());

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
            body: Column(
              children: [
                appBarDesign(() => Navigator.pop(context),
                    footer: "Confirm your 4 digit pin. Remember to keep it a secret",
                    title: "Confirm your pin"
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Container(
                        height: 1100.h,
                       child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            gapHeight(39.h),
                            customText1(
                                "Confirm your 4 digit pin", kBlack, 18.sp,
                                fontWeight: FontWeight.w400),
                            gapHeight(29.h),
                            CustomPinTheme(
                              pinLength: 4,
                              errorController:
                              _controller.errorControllerConfirmPin,
                              onTap: (String value) {
                                setState(
                                      () {
                                    _controller.otpValue.value = value;
                                    _controller.otplength.value = value.length;
                                    if (_controller.otplength.value == 4) {
                                      // if(widget.pin==_controller.otpValue){
                                      //   // Get.snackbar("Invalid ",
                                      //   //   "Your Pin does not match",
                                      //   //   backgroundColor: Colors.red,
                                      //   //   colorText: Colors.white,);
                                      // }
                                    }
                                  },
                                );
                              },
                              pinValueController:
                              _controller.signUpConfirmPinSetUp,
                              isOTP: false,),
                            // customText1("OTP expires in", kBlackB800, 14.sp),
                            // gapHeight(20.h),
                            Container(
                                height: 370.h,
                                child: CustomKeypad(controller:
                                _controller.signUpConfirmPinSetUp)),
                            gapHeight(65.h),
                            GestureDetector(
                              onTap: () {
                                print("this is first:${widget.pin}");
                                if(widget.pin==_controller.otpValue){
                                  Get.snackbar("PIN SETUP FAILED",
                                    "Pin does not match",
                                    colorText: Colors.white,);
                                }else{
                                  _controller.setPinStepTwo();
                                }
                              },
                              child: dynamicContainer(Center(
                                  child: customText1(
                                      "Confirm pin", kWhite, 18.sp)),
                                  kAppBlue, 60.h),
                            ),
                            gapHeight(50.h)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )

        ),
      );
    });
  }
}

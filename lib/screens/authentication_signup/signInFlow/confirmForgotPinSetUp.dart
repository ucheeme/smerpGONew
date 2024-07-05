import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:smerp_go/controller/forgotPinController.dart';
import 'package:smerp_go/screens/authentication_signup/signUpFlow/signUpConfirmPinSetup.dart';
import 'package:smerp_go/screens/bottomsheets/pinCreatedSuccessful.dart';
import 'package:smerp_go/utils/appColors.dart';

import '../../../controller/accountVerification.dart';
import '../../../controller/signupController.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/appDesignUtil.dart';
import '../../../utils/customPin.dart';
import '../../../utils/custom_keypad.dart';



class ConfirmResetPin extends StatefulWidget {

  const ConfirmResetPin({Key? key}) : super(key: key);

  @override
  State<ConfirmResetPin> createState() => _ConfirmResetPinState();
}

class _ConfirmResetPinState extends State<ConfirmResetPin> {

  final _controller =
  Get.put(ForgotPinController());

  @override
  Widget build(BuildContext context) {
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
                  footer: "Repeat your pin",
                  title: "Confirm your new pin"
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:  EdgeInsets.only(left: 20.w,right: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        gapHeight(39.h),
                        customText1("Confirm your new 4 pin", kBlack, 18.sp,
                            fontWeight: FontWeight.w400),
                        gapHeight(29.h),
                        CustomPinTheme(
                            pinLength: 4,
                            errorController:

                            _controller.errorControllerConfirmPin,
                            onTap: (String value) {
                              setState(
                                    () {
                                      _controller.otpValueConfirm.value = value;
                                  _controller.otplengthConfirm.value =
                                      value.length;
                                  if (_controller.otplengthConfirm.value ==
                                     4) {

                                    // _controller.signUpPinSetUp.text="";
                                    setState(() {

                                    });

                                  }

                                },
                              );
                            },
                            pinValueController:
                            _controller.forgotConfirmPinSetUp, isOTP: false,),
                     //   customText1("OTP expires in", kBlackB800, 14.sp),
                        gapHeight(20.h),
                        Container(
                            height:  370.h,
                            child: CustomKeypad(controller:
                            _controller.forgotConfirmPinSetUp)),
                        gapHeight(65.h),
                        GestureDetector(

                          onTap: (){
                            _controller.setPinStepTwo();

                          },
                          child: dynamicContainer(Center(
                              child: customText1("Confirm pin", kWhite, 18.sp)),
                              kAppBlue, 60.h),
                        ),
                        gapHeight(50.h)
                      ],
                    ),
                  ),
                ),
              )
            ],
          )

      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smerp_go/screens/authentication_signup/signUpFlow/signUpConfirmPinSetup.dart';
import 'package:smerp_go/utils/appColors.dart';

import '../../../controller/accountVerification.dart';
import '../../../controller/signupController.dart';
import '../../../utils/appDesignUtil.dart';
import '../../../utils/customPin.dart';
import '../../../utils/custom_keypad.dart';



class SignUpPin extends StatefulWidget {
  const SignUpPin({Key? key}) : super(key: key);

  @override
  State<SignUpPin> createState() => _SignUpPinState();
}

class _SignUpPinState extends State<SignUpPin> {
  SignUpController _controller =
  Get.put(SignUpController());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [

            appBarDesign(() => Navigator.pop(context),
                footer: "Create your 4 digit pin. Remember to keep it a secret",
                title: "Setup your pin",
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.only(left: 20.w,right: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      gapHeight(39.h),
                      customText1("Create your 4 digit pin", kBlack, 18.sp,
                          fontWeight: FontWeight.w400),
                      gapHeight(29.h),
                      CustomPinTheme(
                          pinLength: 4,
                          errorController:

                          _controller.errorController,
                          onTap: (String value) {
                            setState(
                                 () {

                                     _controller.otpValue.value = value;
                                     if (_controller.otplength.value ==
                                         4) {
                                       _controller.isSignUpSetPin.value=true;
                                       _controller.signUpPinSetUp.text= _controller.otpValue.value.toString();

                                     }

                              },
                            );
                          },
                          pinValueController:
                          _controller.signUpPinSetUp, isOTP: false,),
                      // customText1("OTP expires in", kBlackB800, 14.sp),
                      // gapHeight(20.h),
                      Container(
                          height:  370.h,
                          child: CustomKeypad(controller:
                          _controller.signUpPinSetUp)),
                      gapHeight(65.h),
                      GestureDetector(
                        onTap: (){
                        // _controller.signUpPinSetUp.text= _controller.otplength.value.toString();
                          _controller.setPinStepOne();
                        },
                        child: dynamicContainer(Center(
                          child: customText1("Set pin",
                              kWhite, 18.sp),
                        ),
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

    );
  }
}

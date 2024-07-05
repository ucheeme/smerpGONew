import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smerp_go/controller/forgotPinController.dart';
import 'package:smerp_go/screens/authentication_signup/signUpFlow/signUpConfirmPinSetup.dart';
import 'package:smerp_go/utils/appColors.dart';

import '../../../controller/accountVerification.dart';
import '../../../controller/signupController.dart';
import '../../../utils/appDesignUtil.dart';
import '../../../utils/customPin.dart';
import '../../../utils/custom_keypad.dart';
import 'confirmForgotPinSetUp.dart';



class ResetForgotPin extends StatefulWidget {
  const ResetForgotPin({Key? key}) : super(key: key);

  @override
  State<ResetForgotPin> createState() => _ResetForgotPinState();
}

class _ResetForgotPinState extends State<ResetForgotPin> {

  final _controller =
  Get.put(ForgotPinController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [

            appBarDesign(() => Navigator.pop(context),
                footer: "Enter a new pin",
                title: "Setup your new pin"
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.only(left: 20.w,right: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      gapHeight(39.h),
                      customText1("Create your new 4 pin", kBlack, 18.sp,
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
                                _controller.otplength.value =
                                    value.length;
                                if (_controller.otplength.value ==
                                    4) {
                                  // _controller.isSignUpSetPin.value=true;
                                  // _controller.signUpPinSetUp.text="";
                                  setState(() {

                                  });

                                }

                              },
                            );
                          },
                          pinValueController:
                          _controller.forgotPinSetUp, isOTP:false ,),

                      gapHeight(20.h),
                      Container(
                          height:  370.h,
                          child: CustomKeypad(controller:
                          _controller.forgotPinSetUp)),
                      gapHeight(65.h),
                      GestureDetector(
                        onTap: (){
                          Get.to(ConfirmResetPin(),
                              duration: Duration(seconds: 1),
                              curve: Curves.easeIn);
                        },
                        child: dynamicContainer(Center(
                            child: customText1("Set pin", kWhite, 18.sp)),
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

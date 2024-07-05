import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smerp_go/utils/appColors.dart';

import '../controller/accountVerification.dart';



class CustomPinTheme extends StatefulWidget {
  final int pinLength;
  final StreamController<ErrorAnimationType> errorController;
  final TextEditingController pinValueController;
  final Function(String) onTap;
  final bool isOTP;

  const CustomPinTheme({
    Key? key,
    required this.pinLength,
    required this.errorController,
    required this.pinValueController,
    required this.onTap,
    required this.isOTP
  }) : super(key: key);

  @override
  State<CustomPinTheme> createState() => _CustomPinThemeState();
}

class _CustomPinThemeState extends State<CustomPinTheme> {
 // AccountVerificationController accountVerificationController= Get.put(AccountVerificationController());

  TextEditingController? pinValueController = TextEditingController();
  int length = 0;
  bool hasError = false;
  String currentText = "";
  late StreamController<ErrorAnimationType> errorController;

  @override
  void initState() {
    length = widget.pinLength;
    errorController = widget.errorController;
    pinValueController= widget.pinValueController;
    super.initState();
    errorController =StreamController<ErrorAnimationType>.broadcast();
  }



  @override
  Widget build(BuildContext context) {
    setState(() {

    });
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(

            child: Wrap(children: [
              StreamBuilder(
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return Container(
                    height: 70.64.h,
                    width: widget.isOTP?450.58.w:298.58.w,
                    child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle:  TextStyle(
                            color: kBlack,
                            fontWeight: FontWeight.bold,
                            decorationColor: Colors.green),
                        length: length,
                        obscureText: widget.isOTP?false:true,
                        obscuringCharacter: '●',
                        animationType: AnimationType.slide,
                        pinTheme: PinTheme(
                            fieldOuterPadding:EdgeInsets.only(left: 2.0),
                            borderWidth: 0.45.w,
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(14.89.r),
                            fieldWidth: 50.64.w,
                            fieldHeight: 59.64.h,
                            activeColor: kAppBlue,
                            selectedColor: kAppBlue,
                            inactiveColor:kAppBlue.withOpacity(0.5),
                            inactiveFillColor: kLightPink,
                            activeFillColor: kLightPinkPin,
                            selectedFillColor:kLightPinkPin),
                        cursorColor: kBlack,
                        animationDuration: const Duration(microseconds: 300),
                        textStyle:  TextStyle(
                          fontSize: 18.sp,
                        ),
                        enableActiveFill: true,
                       errorAnimationController: errorController,
                        controller: pinValueController,
                        keyboardType: TextInputType.none,
                       onChanged:widget.onTap,
                     // onCompleted: widget.onTap
                    ),
                  );
                },
                stream: null,

              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              hasError ? "*Please fill up all the cells properly" : "",
              style:  TextStyle(
                  color: Colors.red, fontSize: 12.sp, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
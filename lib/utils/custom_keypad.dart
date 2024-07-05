import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../controller/accountVerification.dart';

class CustomKeypad extends StatefulWidget {
  final TextEditingController controller;
   CustomKeypad(
  {super.key,required this.controller}
      );
  @override
  _CustomKeypadState createState() => _CustomKeypadState();
}

class _CustomKeypadState extends State<CustomKeypad> {


  late TextEditingController _controller;
  List<String> _keypadNumbers = [
    "1", "2", "3",
    "4", "5", "6",
    "7", "8", "9",
  ];
  var isPositionEmpty= Rx(false);

  @override
  void initState() {

    super.initState();
    _controller= widget.controller;
   // _keypadNumbers.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330.w,
      height: 410.h,
      child: SingleChildScrollView(
        child: Column(
          children: [

            gapHeight(20.h),
            Container(
              height: 70.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      _input("1");
                    },
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: kLightPinkPin.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(21.r),
                          // border: Border.all(color: kBlack)
                        ),
                        child: Center(
                          child: customText1(
                              "1",
                              kBlackB800, 24.sp),
                        )
                    ),
                  ),
                  gapWeight(75.w),
                 GestureDetector(
                    onTap: (){
                      _input("2");
                    },
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: kLightPinkPin.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(21.r),
                          // border: Border.all(color: kBlack)
                        ),
                        child: Center(
                          child: customText1(
                              "2",
                              kBlackB800, 24.sp),
                        )
                    ),
                  ),
                  gapWeight(75.w),
                 GestureDetector(
                    onTap: (){
                      _input("3");
                    },
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                         color: kLightPinkPin.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(21.r),
                          // border: Border.all(color: kBlack)
                        ),
                        child: Center(
                          child: customText1(
                              "3",
                              kBlackB800, 24.sp),
                        )
                    ),
                  ),
                ],
              ),
            ),
            gapHeight(20.h),
            Container(
              height: 70.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      _input("4");
                    },
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: kLightPinkPin.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(21.r),
                          // border: Border.all(color: kBlack)
                        ),
                        child: Center(
                          child: customText1(
                              "4",
                              kBlackB800, 24.sp),
                        )
                    ),
                  ),
                  gapWeight(75.w),
                  GestureDetector(
                    onTap: (){
                      _input("5");
                    },
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: kLightPinkPin.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(21.r),
                          // border: Border.all(color: kBlack)
                        ),
                        child: Center(
                          child: customText1(
                              "5",
                              kBlackB800, 24.sp),
                        )
                    ),
                  ),
                  gapWeight(75.w),
                  GestureDetector(
                    onTap: (){
                      _input("6");
                    },
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: kLightPinkPin.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(21.r),
                          // border: Border.all(color: kBlack)
                        ),
                        child: Center(
                          child: customText1(
                              "6",
                              kBlackB800, 24.sp),
                        )
                    ),
                  ),
                ],
              ),
            ),
            gapHeight(20.h),
            Container(
              height: 70.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      _input("7");
                    },
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: kLightPinkPin.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(21.r),
                          // border: Border.all(color: kBlack)
                        ),
                        child: Center(
                          child: customText1(
                              "7",
                              kBlackB800, 24.sp),
                        )
                    ),
                  ),
                  gapWeight(75.w),
                  GestureDetector(
                    onTap: (){
                      _input("8");
                    },
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: kLightPinkPin.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(21.r),
                          // border: Border.all(color: kBlack)
                        ),
                        child: Center(
                          child: customText1(
                              "8",
                              kBlackB800, 24.sp),
                        )
                    ),
                  ),
                  gapWeight(75.w),
                  GestureDetector(
                    onTap: (){
                      _input("9");
                    },
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: kLightPinkPin.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(21.r),
                          // border: Border.all(color: kBlack)
                        ),
                        child: Center(
                          child: customText1(
                              "9",
                              kBlackB800, 24.sp),
                        )
                    ),
                  ),
                ],
              ),
            ),
            gapHeight(20.h),
           Container(
             height: 70.h,
             child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      _input("0");
                    },
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: kLightPinkPin.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(21.r),
                          // border: Border.all(color: kBlack)
                        ),
                        child: Center(
                          child: customText1(
                              "0",
                              kBlackB800, 24.sp),
                        )
                    ),
                  ),
                  gapWeight(75.w),
                  GestureDetector(
                    onTap: (){
                      _backspace();
                    },
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: kLightPinkPin.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(21.r),
                          // border: Border.all(color: kBlack)
                        ),
                        child: Center(
                          child:Center(
                           child: SvgPicture.asset("assets/removeValues.svg"),
                          )
                        )
                    ),
                  ),
                ],
              ),
           )
          ],
        ),
      ),
    );
  }
  Widget defaultValues(int value){

  //     if(value == 10){
  //   return Center(
  //     child: SvgPicture.asset("assets/removeValues.svg"),
  //   );
  // }else
    return Center(
      child: customText1(
          _keypadNumbers[value],
          kBlackB800, 24.sp),
    );
  }

  void _input(String text) {
    final value = _controller.text + text;
    _controller.text = value;
  }
  void _backspace() {
    final value = _controller.text;
    if (value.isNotEmpty) {
      _controller.text = value.substring(0, value.length - 1);
    }
  }
}

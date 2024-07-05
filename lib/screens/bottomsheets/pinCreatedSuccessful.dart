import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../../controller/signInController.dart';
import '../../utils/AppUtils.dart';
import '../../utils/UserUtils.dart';

class PinCreationCreationSuccessful extends StatefulWidget {
  const PinCreationCreationSuccessful({Key? key}) : super(key: key);

  @override
  State<PinCreationCreationSuccessful> createState() => _PinCreationCreationSuccessfulState();
}

class _PinCreationCreationSuccessfulState extends State<PinCreationCreationSuccessful> {
  var _controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Container(

      width: 430.w,
      color: kWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          gapHeight(30.h),
          Image.asset("assets/pinSet.png",
              height: 170.h,
              width:170.w),
          gapHeight(22.h),
          customText1("Pin reset successful", kBlack, 24.sp,
              indent: TextAlign.center,
              fontWeight: FontWeight.w500,
            fontFamily: fontFamily
          ),
          gapHeight(1.h),
          customText1("Confirm your new 4 digit pin. Remember to \n keep it a secret",
              kBlackB800, 16.sp,
              indent: TextAlign.center),
          gapHeight(50.h),
         GestureDetector(
           onTap: ()async{
             String e = await SharedPref.read("userPin");
             String pin = e.substring(1, e.length - 1);
             SharedPref.save("userId", userIdentityValue!);
             _controller.loginUser(userIdentityValue!, pin,context: context);
           },
           child: dynamicContainer(Center(
                child: customText1("Go to Dashboard", kWhite, 18.sp)),
                kAppBlue, 60.h),
         ),
          gapHeight(40.h)
        ],
      ),
    );
  }
}

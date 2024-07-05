import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

class PhoneEmailSuccessfulChange extends StatefulWidget {
  const PhoneEmailSuccessfulChange({super.key});

  @override
  State<PhoneEmailSuccessfulChange> createState() => _PhoneEmailSuccessfulChangeState();
}

class _PhoneEmailSuccessfulChangeState extends State<PhoneEmailSuccessfulChange> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhite,
      height: 480.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/successfulAnim.json",height: 350.h,
              fit: BoxFit.scaleDown,
              repeat:true ),
          customText1("Identity verified", kBlack, 18.sp,fontFamily: fontFamily)
        ],
      ),
    );
  }
}

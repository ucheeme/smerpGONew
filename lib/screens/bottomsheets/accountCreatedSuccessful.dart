import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:smerp_go/controller/signInController.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/UserUtils.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

class AccountCreationSuccessful extends StatefulWidget {
  const AccountCreationSuccessful({Key? key}) : super(key: key);
  @override
  State<AccountCreationSuccessful> createState() =>
      _AccountCreationSuccessfulState();
}

class _AccountCreationSuccessfulState extends State<AccountCreationSuccessful> {
  var _controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return OverlayLoaderWithAppIcon(
        isLoading: isLoading.value,
        overlayBackgroundColor: kBlackB600,
        circularProgressColor: kAppBlue,
        appIconSize: 40.h,
        appIcon: SizedBox(),
        child: Container(
          width: 430.w,
          color: kWhite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              gapHeight(30.h),
              Image.asset("assets/goodImg.png",
                  height: 170.h,
                  width: 170.w),
              gapHeight(22.h),
              customText1("Account created successfully", kBlack, 24.sp,
                  indent: TextAlign.center,
                  fontWeight: FontWeight.w500,
              fontFamily: fontFamily),
              gapHeight(1.h),
              customText1(
                  "Confirm your new 4 digit pin. Remember to \n keep it a secret",
                  kBlackB800, 16.sp,
                  indent: TextAlign.center,
              maxLines: 2),
             Spacer(),
              GestureDetector(
                onTap: () async {
                  actionBy="";
                  String e = await SharedPref.read("userPin");
                  String pin = e.substring(1, e.length - 1);
                  SharedPref.save("userId", userIdentityValue!);
                 _controller.loginUser(userIdentityValue!, pin);
                  Get.back();
                },
                child: dynamicContainer(Center(
                    child: customText1("Go to Dashboard", kWhite, 18.sp)),
                    kAppBlue, 60.h),
              ),
              gapHeight(40.h)
            ],
          ),
        ),
      );
    });
  }
}

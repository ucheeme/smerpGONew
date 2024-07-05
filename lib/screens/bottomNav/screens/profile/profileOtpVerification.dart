import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../../../../controller/profileController.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../../utils/customPin.dart';
import '../../../../utils/custom_keypad.dart';

class ProfileOtpVerification extends StatefulWidget {
  int userOption=0;
  String userId="";
  ProfileOtpVerification({super.key,required this.userId,
    required this.userOption});

  @override
  State<ProfileOtpVerification> createState() => _ProfileOtpVerificationState();
}

class _ProfileOtpVerificationState extends State<ProfileOtpVerification> {
  var _controller = Get.put(ProfileController());
  var pinValueController2= TextEditingController();
  RxBool isLoading = false.obs;
  RxString otpValue ="".obs;
  RxInt otplength =0.obs;
  @override
  void initState() {
    super.initState();
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
          body: Column(
              children: [
                appBarDesign(() => Navigator.pop(context),
                    footer:(widget.userOption==2)?"Please check your Mail inbox for the OTP,Copy \n "
                        "the code, paste below.": "Please check your SMS inbox for the OTP, Copy \n "
                        "the code, paste below.",
                    title: "Enter OTP"
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
                            _controller.errorController,
                            onTap: (String value) {
                              setState(
                                    () {
                               otpValue.value =
                                      value;
                                  if (pinValueController2.text.length ==
                                      6) {
                                    _controller.validateOtp(
                                        widget.userOption,
                                        widget.userId,
                                        otpValue.value,
                                        isLoading,context: context);
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
                                left: 94.w, right: 74.w, top: 70.w),
                            child: altTextButton(() {
                             _controller.getOtpToChangeUserInfo(
                                 widget.userOption,widget.userId, isLoading);
                            }, "Resend",
                                text1: "Didnt receive OTP?"),
                          )
                        ],
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

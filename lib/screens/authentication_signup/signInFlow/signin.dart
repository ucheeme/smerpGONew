import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:smerp_go/controller/signInController.dart';
import 'package:smerp_go/screens/authentication_signup/signInFlow/signinViaPhoneEmail.dart';
import 'package:smerp_go/screens/authentication_signup/signUpFlow/signup.dart';
import 'package:smerp_go/screens/bottomNav/bottomNavScreen.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/UserUtils.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../../../controller/controllererer.dart';
import '../../../utils/custom_keypad.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  SignInController _controller = Get.put(SignInController());
 //NewControl _beontroller = Get.put(NewControl());
  var pinValueController2= TextEditingController();

  @override
  void initState() {
    print(userImage.value);
    print("I am initialized");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return OverlayLoaderWithAppIcon(
          isLoading: _controller.isLoading.value,
          overlayBackgroundColor: kBlackB600,
          circularProgressColor: kAppBlue,
          appIconSize: 40.h,
          appIcon: SizedBox(),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints.tight(Size(double.infinity,
                    950.h)),
                color: kWhite,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                   headerWithImage(
                            (userImage.value.isEmpty||userImage.value=="N/A")?  ""
                            : userImage.value,
                            (_controller.storeName.value.isEmpty)?userFirstName!:
                            _controller.storeName.value,
                            _controller.errorController,
                           pinValueController2, (value) async {
                          if (value.length == 4) {
                          bool respond= await _controller.loginUser(userIdentityValue, value,context: context);
                          if(!respond){
                            pinValueController2.clear();
                          }
                          }
                        }),

                      SingleChildScrollView(
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                height: 400.h,
                                child: CustomKeypad(controller:
                                 pinValueController2 ,)),
                            gapHeight(10.h),
                            Container(
                              height: 70.h,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(Signup(),
                                        duration: Duration(seconds: 1),
                                        transition: Transition
                                            .cupertino,);
                                      // _controller.testing();
                                    },
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          customText1(
                                              "Don't have an account?", kBlackB800,
                                              16.sp),
                                          gapWeight(6.71.w),
                                          customText1("Register", kBlack, 16.sp,fontWeight:FontWeight.bold )
                                        ],
                                      ),
                                    ),
                                  ),
                                 Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      _controller.isSignInWithAnotherAcct.value =
                                      !_controller.isSignInWithAnotherAcct.value;

                                      Get.off(SignInViaPhoneEmail(),
                                        duration: Duration(seconds: 1),
                                        transition: Transition
                                            .cupertino,);
                                    },
                                    child: Container(
                                      height: 30.h,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          customText1(
                                              "Sign In with another account", kBlackB800,
                                              16.sp),

                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer()
                                ],
                              ),
                            )

                          ],
                        ),
                      ),

                    ],
                  ),
                )
                ,
              ),
            ),
          ));
    });
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/signInController.dart';
import '../../main.dart';
import '../../utils/AppUtils.dart';
import '../../utils/UserUtils.dart';
import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';
import '../authentication_signup/signInFlow/signin.dart';
import '../authentication_signup/signInFlow/signinViaPhoneEmail.dart';
import '../authentication_signup/signUpFlow/signup.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});
  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  var _controller = Get.put(SignInController());

  @override
  void initState() {
    fetchAppVersion();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: GestureDetector(
          onTap: (){
            Focus.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              height: 950.h,
              child: Column(
                children: [
                  gapHeight(450.h),
                  Center(child: SvgPicture.asset("assets/smerpgoLogo.svg")),
                  //gapHeight(104.29.h),
                  Spacer(),
                  SizedBox(
                    height: 150.h,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.to(Signup(),
                              duration: Duration(seconds: 1),
                              // curve: Curves.easeInCubic,
                              transition: Transition
                                  .cupertino,);

                            // String url = "https://apps.apple.com/ng/app/smerpgo/id6451312469";
                            // showCustomDialog(context,url);
                          },
                          child: Container(
                            margin:  EdgeInsets.only(left: 30.w, right: 30.w),
                            height: 60.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: kAppBlue, width: 0.5.w),
                                borderRadius: BorderRadius.circular(15.r),
                                color: kAppBlue),
                            child:Center(child: customText1("Create your account",kWhite, 16.sp)),
                          ),
                        ),
                        gapHeight(20.h),
                        // Spacer(),
                        Padding(
                          padding: EdgeInsets.only(left: 30.w, right: 30.w),
                          child: GestureDetector(
                            onTap: ()async{

                              if(await SharedPref.getBool("keepUserInfo")){
                                String res = await SharedPref.read("userFirstName");
                                String a = await   SharedPref.read("userImage");
                                String e = await SharedPref.read("userIdentityValue");
                                print(res);
                                print(a);
                                print(e);
                                userIdentityValue =  e.substring(1,e.length-1);
                                _controller.storeName.value =  res.substring(1,res.length-1);
                                userImage.value =a.substring(1,a.length-1);
                                print(userImage.value);
                                Get.to(SignIn(),
                                  duration: Duration(seconds: 1),
                                  //  curve: Curves.easeIn,
                                  transition: Transition
                                      .cupertino,);
                              }else{
                                Get.to(SignInViaPhoneEmail(),
                                  duration: Duration(seconds: 1),
                                  //  curve: Curves.easeIn,
                                  transition: Transition
                                      .cupertino,);
                              }

                            },
                            child: dynamicContainer(Center(child: customText1("Login",kAppBlue, 18.sp)),
                                kLightPink, 60.h),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Gap(20)
                ],
              ),
            ),
          ),
        )

    );
  }


  Future<void> fetchAppVersion() async {

    if(Platform.isAndroid){
      String response =await remoteConfig.getString("androidversion");
      int currentVersion= int.parse(removeLastDigit(packageInfo!.version));
      int remoteVersion= int.parse(removeLastDigit(response));
      if(currentVersion < remoteVersion){
        String url = "https://play.google.com/store/apps/details?id=com.fifthlab.smerp_go";
        showCustomDialog(context,url);
      }
    }else if(Platform.isIOS){
      var response =await remoteConfig.getString("iosVersion");
      print("The old version:$response");
      print("The new version:${removeLastDigit(packageInfo!.version)}");
      int currentVersion= int.parse(removeLastDigit(packageInfo!.version));
      int remoteVersion= int.parse(removeLastDigit(response));
      if(currentVersion < remoteVersion){
        String url = "https://apps.apple.com/ng/app/smerpgo/id6451312469";
        showCustomDialog(context,url);
      }
    }

  }
  Future forceUpdateCard (String url){
    return Get.defaultDialog(
        barrierDismissible: false,
        title: "New Version Available",
        content: Align(
            alignment: Alignment.center,
            child: customText1("You are running on an old version of SmerpGo", kAppBlue, 16.sp)),
        textConfirm: "Update Now",
        titleStyle: TextStyle(color: kBlack,fontSize: 20.sp),
        onConfirm: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        backgroundColor: kWhite
    );
  }


  void showCustomDialog(BuildContext context, String url) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Container(
            height: 200.h, // Adjust the size as needed
            padding: EdgeInsets.all(16.0),
            child: Stack(
              // alignment: Alignment.topCenter,
                fit: StackFit.passthrough,
                children:[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //  gapHeight(20.h),
                      Align(
                          alignment: Alignment.center,
                          child: customText1("New Version Available", kBlack, 20.sp,
                              fontWeight: FontWeight.bold)),
                      Spacer(),
                      Align(
                          alignment: Alignment.center,
                          child: Container(child:
                          customText1("You are running on an old version of SmerpGo,"
                              "\n kindly update your app", kAppBlue, 14.sp,
                              indent:TextAlign.center, maxLines: 2)
                          )),
                      gapHeight(20.h),
                      GestureDetector(
                        onTap:  () async {
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                              color: kAppBlue,
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                  color: kAppBlue, width: 0.5.w)),
                          child: Center(
                            child: customText1(
                                "Update Now",kWhite, 16.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  )


                ]
            ),
          ),
        );
      },
    );
  }

  String removeLastDigit(String inputString) {
    if (inputString.isNotEmpty) {
      int lastDotIndex = inputString.lastIndexOf('.');
      if (lastDotIndex >= 0) {
        return inputString.substring(lastDotIndex + 1);
      }
    }
    return inputString; // Return the input string as is if no dot is found or if it's empty.
  }
}

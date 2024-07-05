import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/screens/bottomNav/screens/profile/chatWithSupport.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/appDesignUtil.dart';

class ContactSupport extends StatefulWidget {
  const ContactSupport({Key? key}) : super(key: key);

  @override
  State<ContactSupport> createState() => _ContactSupportState();
}

class _ContactSupportState extends State<ContactSupport> {
  var _controller =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: PreferredSize(
          child: defaultDashboardAppBarWidget(() {
            Get.back();
          },"Contact & Support",context: context),
          preferredSize: Size.fromHeight(80.h)),
      body: Padding(
        padding:  EdgeInsets.only(left: 16.w,right: 16.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // gapHeight(70.h),
              // SvgPicture.asset("assets/liveChat.svg"),
              // gapHeight(30.h),
              // customText1("How can we help you", kBlack, 20.sp,fontWeight: FontWeight.w500),
              // gapHeight(40.h),
              // GestureDetector(
              //   onTap: () async {
              //    String name =await Get.bottomSheet(
              //       backgroundColor: kWhite,
              //       Container(
              //           height: 200.h,
              //           child: Padding(
              //             padding:  EdgeInsets.only(left: 16.w,right: 16.w),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.spaceAround,
              //
              //               children: [
              //                 customText1("Enter your name", kBlackB800, 16.sp),
              //                 titleSignUp(_controller),
              //                 GestureDetector(
              //                   onTap:(){
              //                     Get.back(result: _controller.text);
              //                   },
              //                   child: dynamicContainer(
              //                   Center(child: customText1("Enter", kWhite, 15.sp))
              //                   , kAppBlue, 40.h),
              //                 )
              //               ],
              //             ),
              //           ))
              //     );
              //    if(name.isNotEmpty){
              //      Get.to(
              //          ChatSupport(name: name,),
              //          duration: Duration(seconds: 1),
              //          curve: Curves.easeIn
              //      );
              //    }
              //
              //   },
              //   child: Container(
              //     height: 60.h,
              //
              //     decoration: BoxDecoration(
              //       color: kAppBlue,
              //       borderRadius: BorderRadius.circular(15.r),
              //     ),
              //     child: Center(
              //         child: customText1("Contact live chat", kWhite, 18.sp)
              //     ),
              //   ),
              // ),
              // gapHeight(50.h),
              gapHeight(30.h),
              SvgPicture.asset("assets/customerEmail.svg"),
              gapHeight(20.h),
              customText1("Send us a mail:", kBlackB800, 16.sp,
                  fontWeight: FontWeight.w500),
              gapHeight(15.h),
              customText1("smerp.support@thefifthlab.com", kAppBlue, 20.sp,
                  fontWeight: FontWeight.w500),
              gapHeight(50.h),
              GestureDetector(
                onTap: (){
                  launchCaller();
                },
                child: Container(
                  color: kWhite,
                  child: Column(
                    children: [
                      SvgPicture.asset("assets/customerCare.svg"),
                      gapHeight(20.h),
                      customText1("Give us a call:", kBlackB800, 16.sp,
                          fontWeight: FontWeight.w500),
                      gapHeight(15.h),
                      customText1("+2349167739689", kAppBlue, 20.sp,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                ),
              ),
              gapHeight(50.h),
              GestureDetector(
                onTap: (){
                  sendWhatsapp();
                },
                child: Container(
                  height: 150.h,
                  width: 500.w,
                  color: kWhite,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/whatsapp.svg"),
                      gapHeight(15.h),
                      Center(
                        child: customText1("Reach us via whatsapp", kAppBlue, 20.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ) ,
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
  void sendWhatsapp(){
    String url = "whatsapp://send?phone=2349167739689";
    launchUrl(Uri.parse(url));
  }
}

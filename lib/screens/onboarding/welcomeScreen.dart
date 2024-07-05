import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/screens/onboarding/splashScreen2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../main.dart';
import '../../utils/UserUtils.dart';
import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController controller2 = PageController();
  final PageController controller = PageController();
  void nextPage() {
    setState(() {
      newPageIndex = (controller2.page!.toInt() + 1) % 3;
      newPageIndex = (controller.page!.toInt() + 1) % 3;
    });

    controller2.animateToPage(
      newPageIndex!,
      duration: Duration(milliseconds: 900),
      curve: Curves.easeInOut,
    );
    controller.animateToPage(
      newPageIndex!,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void prevPage() {
    setState(() {
      newPageIndex = (controller2.page!.toInt() - 1) % 3;
      newPageIndex = (controller.page!.toInt() - 1) % 3;
    });

    controller2.animateToPage(
      newPageIndex!,
      duration: Duration(milliseconds: 900),
      curve: Curves.easeInOut,
    );
    controller.animateToPage(
      newPageIndex!,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  int newPageIndex=0;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    controller2
        .dispose(); // Dispose the PageController when the widget is removed
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        child: Container(
          height: 950.h,
          padding: EdgeInsets.symmetric(vertical: 20.h,horizontal:16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Gap(20),
              customText1("Welcome to SmerpGo", kAppBlue, 21.sp, fontFamily: fontFamilyInter),
              Gap(15),
              customText1("Manage employees easily starting from now!", kBlack, 20.sp,fontFamily: fontFamilyGraphilk,
                  maxLines: 2,
                  fontWeight: FontWeight.w500),
              Gap(20),
              SizedBox(
                height: 525.h,
                child: PageView(
                  controller: controller2,
                  onPageChanged: (value){
                    controller.animateToPage(value,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,);
                    setState(() {
                      newPageIndex=value;
                    });
                  },
                  // physics: NeverScrollableScrollPhysics(),
                  children: [
                    Image.asset("assets/firstSlide.png",
                      height: 400.h,),
                    Image.asset("assets/secondSlide.png",
                      height: 400.h,),
                    Image.asset("assets/thirdSlide.png",
                      height: 400.h,),
                  ],
                ),
              ),
              Gap(30),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w, ),
                width: double.infinity,
                height: 108.h,
                color: kWhite,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        onPageChanged: (value){
                          controller2.animateToPage(value,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,);
                          setState(() {
                            newPageIndex=value;
                          });
                        },
                        controller: controller,
                        children: [
                          pageOne(),
                          pageTwo(),
                          pageThree(),
                        ],
                      ),
                    ),
                    //Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: (){
                              if(newPageIndex>0){
                                prevPage();
                              }else{
                                Get.offAll(Splashscreen(),
                                  duration: Duration(seconds: 1),
                                  transition: Transition.cupertino,);
                                setState(() {
                                  newPageIndex = 0;
                                });
                              }

                            },
                            child: customText1((newPageIndex>0)?"Previous":"Skip", kBlack, 16.sp)),
                        Spacer(),
                        SmoothPageIndicator(
                          controller: controller,
                          count: 3,
                          effect: ExpandingDotsEffect(
                              dotWidth: 20.w,
                              dotHeight: 9.5.h,
                              radius: 10.r,
                              activeDotColor: kAppBlue,
                              dotColor: kLightPinkPin,
                              expansionFactor: 2
                          ),
                          // effect: const WormEffect(
                          //   dotHeight: 16,
                          //   dotWidth: 16,
                          //   type: WormType.thinUnderground,
                          // ),
                        ),
                        Spacer(),
                        GestureDetector(
                            onTap: (){
                              if (newPageIndex == 2) {
                                SharedPref.saveBool(SharedPrefKeys.firstTimeUser, true);
                                Get.offAll(Splashscreen(),
                                  duration: Duration(seconds: 1),
                                  transition: Transition.cupertino,);
                                setState(() {
                                  newPageIndex = 0;
                                });
                              } else {
                                nextPage();
                              }
                            },
                            child: customText1((newPageIndex==2)?"Done!":"Next", kAppBlue, 16.sp,
                                fontWeight: FontWeight.w500,fontFamily: fontFamilyInter)),
                      ],)
                  ],),

              )

            ],
          ),
        ),
      ),
    );
  }

  pageOne() {

    return Column(
      children: [
        customText1("Manage your sales and orders", kBlack, 20.sp,
            fontFamily: fontFamilyGraphilk,fontWeight: FontWeight.w500),
        //   Gap(10),
        customText1("Add new product to your inventory with ease.", kBlack, 14.sp,
            fontFamily: fontFamilyInter,fontWeight: FontWeight.w400),
      ],
    );
  }

  pageTwo() {
    return Column(
      children: [
        customText1("Manage your inventory", kBlack, 20.sp,
            fontFamily: fontFamilyGraphilk,fontWeight: FontWeight.w500),
        // Gap(10),
        customText1("Keep track of your goods", kBlack, 14.sp,
            fontFamily: fontFamilyInter,fontWeight: FontWeight.w400),
      ],
    );
  }

  pageThree() {
    return Column(
      children: [
        customText1("Detailed report", kBlack, 20.sp,
            fontFamily: fontFamilyGraphilk,fontWeight: FontWeight.w500),
        // Gap(10),
        customText1("Toggle on and off products in your catalogue", kBlack, 14.sp,
            fontFamily: fontFamilyInter,fontWeight: FontWeight.w400),
      ],
    );
  }
}


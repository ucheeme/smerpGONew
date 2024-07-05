import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/apiServiceLayer/api_status.dart';
import 'package:smerp_go/model/response/defaultApiResponse.dart';
import 'package:smerp_go/screens/bottomNav/screens/profile/personalData.dart';
import 'package:smerp_go/screens/bottomNav/screens/profile/profileList.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../apiServiceLayer/apiService.dart';
import '../../controller/signInController.dart';
import '../../main.dart';
import '../../model/request/authenticateDevice.dart';
import '../../utils/AppUtils.dart';
import '../../utils/UserUtils.dart';
import '../../utils/appColors.dart';
import '../../utils/appUrl.dart';
import '../bottomNav/bottomNavScreen.dart';

class NewUpdate extends StatefulWidget {
  const NewUpdate({super.key});

  @override
  State<NewUpdate> createState() => _NewUpdateState();
}

class _NewUpdateState extends State<NewUpdate> {
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
      body: Column(
        children: [
          SizedBox(
            height: 500.h,
           child:PageView(
           // physics: NeverScrollableScrollPhysics(),
             onPageChanged: (value){
               controller.animateToPage(value,
                 duration: Duration(milliseconds: 500),
                 curve: Curves.easeInOut,);

             },
             controller: controller2,
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
                  child: Image.asset("assets/collectionUpdate.png",
                     fit: BoxFit.fill,),
                ),
                Padding(
                 padding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 16.w),
                  child: Image.asset("assets/reportAnalysisDownload.png",
                    fit: BoxFit.fill,),
                ),
                // Image.asset("assets/png/images/welcome_three.png",
                //   width: double.infinity,
                //   height: 780.h, fit: BoxFit.fill,),
              ],
            ),
          ),
          Gap(30),
          Container(

            padding: EdgeInsets.symmetric(
              horizontal: 16.w, ),
            width: double.infinity,
            height: 130.h,
           // color: kAppBlue,
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                   // physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (value){
                      controller2.animateToPage(value,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,);
                      if(value==1){
                        setState(() {
                         // newPageIndex=0;
                        });
                      }else{
                        setState(() {
                         // newPageIndex--;
                        });

                      }
                    },
                    controller: controller,
                    children: [
                      pageOne(),
                      pageTwo(),
                      // pageThree(),
                    ],
                  ),
                ),
                Gap(20),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                    GestureDetector(
                        onTap: (){
                          if(newPageIndex==1){
                            prevPage();
                          }else{
                            if(!checkIfProfileDataIsCompleted()){
                              Get.back();
                              Get.bottomSheet(
                                  Container(
                                      height: 600.h,
                                      child: FinishUserSetUp())
                              );
                            }else{
                              Get.back();
                            }
                          }

                        },
                        child: customText1((newPageIndex==1)?"Previous":"Skip", kBlack, 16.sp)),
                    Spacer(),
                    SmoothPageIndicator(
                      controller: controller,
                      count: 2,
                      effect: ExpandingDotsEffect(
                          dotWidth: 30.w,
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
                          if (newPageIndex == 1) {
                           if(!checkIfProfileDataIsCompleted()){
                           Get.back();
                            Get.bottomSheet(
                                Container(
                                    height: 600.h,
                                    child: FinishUserSetUp())
                            );
                          }else{Get.back();}

                              }
                          else
                              {
                                nextPage();
                             }
                        },
                        child: customText1((newPageIndex==1)?"Done!":"Next", kAppBlue, 16.sp,
                        fontWeight: FontWeight.w500,fontFamily: fontFamilyInter)),

                  ],),
                )
              ],),

          )

        ],
      ),
    );
  }

  pageOne() {
    
    return Container(
      height: 90.h,
      child: Column(
        children: [
          customText1("Create collections", kBlack, 20.sp,
              fontFamily: fontFamilyGraphilk,fontWeight: FontWeight.w500),
          Gap(20),
          customText1("Curate products from the same brand or purpose", kBlack, 14.sp,
             fontFamily: fontFamilyInter,fontWeight: FontWeight.w400),
        ],
      ),
    );
  }

  pageTwo() {
    return Container(
      height: 90.h,
      child: Column(
        children: [
          customText1("New report system", kBlack, 20.sp,
              fontFamily: fontFamilyGraphilk,fontWeight: FontWeight.w500),
         Gap(20),
          customText1("Toggle on and off products in your catalogue", kBlack, 14.sp,
              fontFamily: fontFamilyInter,fontWeight: FontWeight.w400),
        ],
      ),
    );
  }

}

class FinishUserSetUp extends StatelessWidget {
  const FinishUserSetUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Column(
        children: [
          Image.asset("assets/finishSetUp.png",
            width: double.infinity,
            height: 320.h,
          ),
          customText1("Finish your setup", kBlack, 20.sp,
              fontFamily: fontFamilyGraphilk,fontWeight: FontWeight.w500),
          Gap(10),
          customText1("You are yet complete setting up your store,\n"
              "We need some vital details.", kBlack, 16.sp,
              indent: TextAlign.center,
              maxLines: 2,
              fontFamily: fontFamilyInter,fontWeight: FontWeight.w400),
          Gap(20),
          GestureDetector(
            onTap: (){
              Get.back();
              Get.to(
                PersonalData(isJustCreated: true,)
              );
            },
            child: dynamicContainer(Center(child: customText1("Setup store",kWhite, 18.sp)),
                kAppBlue, 60.h),
          ),
        ],
      )
    );
  }
}

class NewDeviceSetUp extends StatelessWidget {
   NewDeviceSetUp({super.key});
  SignInController _controller = Get.put(SignInController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        body: Column(
          children: [
           Spacer(),
            Image.asset("assets/newDeviceAlert.jpeg",
              width: double.infinity,
              height: 320.h,
            ),
            customText1("New Device Detected", kBlack, 20.sp,
                fontFamily: fontFamilyGraphilk,fontWeight: FontWeight.w500,
            indent: TextAlign.center),
            Gap(10),
            customText1("You are using a new device,\n"
                "Do you want to register this new device?.", kBlack, 16.sp,
                indent: TextAlign.center,
                maxLines: 2,
                fontFamily: fontFamilyInter,fontWeight: FontWeight.w400),
            Spacer(),
            GestureDetector(
              onTap: () async {
                Get.back();
                _controller.isLoading.value= true;
                // if(loginData!.storePhoneNumber.isEmpty){
                //   //if uer doesnt have phone number otp is sent to email
                //   _controller.verifyUserNewDevice(2);
                // }else if(loginData!.storeEmail.isEmpty){
                //   //if user doesnt have email otp is sent to phone number
                //   _controller.verifyUserNewDevice(1);
                // }else{
                //   _controller.verifyUserNewDevice(2);
                // }
                var response=   await ApiService.makeApiCall2(
                    AuthenticateDevice(actionBy: loginData!.userId,
                        actionOn: DateTime.now().toIso8601String(),
                        deviceId: deviceToken, deviceIMEI: deviceId??"",
                        deviceType: deviceType), AppUrls.authenticateDevice,
                    isAdmin: false, requireAccess: true,method: HTTP_METHODS.put);
                if(response is Success){
                  try{
                   var data = defaultApiResponseFromJson(await response.response as String);
                    if(data.isSuccess){
                      // _controller.isLoading.value=false;
                      Get.back();
                      Get.off(MainNavigationScreen(),
                        duration: Duration(seconds: 1),
                        transition: Transition
                            .cupertino,);
                    }else{
                      // _controller. isLoading.value=false;
                      Get.snackbar("Device Authorization Failed",
                        data.message,
                        backgroundColor: Colors.red.withOpacity(0.5),
                        colorText: Colors.white,);
                    }
                  }catch(e){
                    print("$e");
                  }
                }
              },
              child: dynamicContainer(Center(child: customText1("Register New Device",kWhite, 18.sp)),
                  kAppBlue, 60.h),
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                Get.back();

              },
              child: dynamicContainer(Center(child: customText1("Cancel",kAppBlue, 18.sp)),
                  kLightPink, 60.h),
            ),
            Spacer()
          ],
        )
    );
  }
}


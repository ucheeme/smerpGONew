import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/screens/onboarding/splashScreen2.dart';
import 'package:smerp_go/screens/onboarding/welcomeScreen.dart';

import '../../main.dart';
import '../../utils/UserUtils.dart';
import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? countdownTimer;
  Duration myDuration = Duration(milliseconds: 2000);
  @override
  void initState() {

    super.initState();
    startTimer() ;
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void setCountDown()async {
    bool response =await SharedPref.getBool(SharedPrefKeys.firstTimeUser);
    final reduceSecondsBy = 1;
    setState(()  {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        if(response){
          Get.offAll(Splashscreen(),
            duration: Duration(seconds: 1),
            transition: Transition.cupertino,);
        }else{
          Get.offAll(WelcomeScreen(),
            duration: Duration(seconds: 1),
            transition: Transition.cupertino,);
        }

      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppBlue,
      body: Container(

        decoration: BoxDecoration(
            image: DecorationImage(
                image:Image.asset("assets/bg.png").image,

                fit: BoxFit.fill
            )
        ),
        width: double.infinity,
        child:Align(
            alignment: Alignment.center,
            child:Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50.h,
                    width:double.infinity,
                    child: Image(image: Image.asset("assets/smerpFull.png").image,
                      fit: BoxFit.scaleDown,),
                  ),
                  gapHeight(20.h),
                  AnimatedTextKit(
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TypewriterAnimatedText("Grow your business on the GO",
                            // speed: Duration(microseconds: 20),
                            textStyle: TextStyle(
                                color: kWhite,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'TomatoGrotesk'
                            ))
                      ]),
                ],
              ),
            )
          //

        ),
      ),
    );
  }
}


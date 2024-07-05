import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../model/response/notificationList.dart';
import 'appColors.dart';

Widget notificationDesign(NotificationList notificationAbb,int index,{
  isOpen = false,
  Function()? viewOrder,Function()? declineOrder
}){
  return Container(
    height: 115.h,
    width: 398.w,
    padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
      color: kDashboardColorBorder,
      border: Border.all(color: kAppBlue)
      //color: kRed70
    ),
    child: Row(
      children: [
        SizedBox(
          height: 80.h,
          child: Column(
            children: [
              Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kInactiveLightPinkSwitch,),
                child: Center(child: customText1(
                    abbrevatedName(notificationAbb.title!),
                    kBlack, 14.sp,fontWeight: FontWeight.bold)),
              ),
              Spacer()
            ],
          ),
        ),
        Spacer(),
        Container(
          height: 83.h,
          width: 318.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(
                height: 57.h,
                width: 318.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (notificationAbb.type=="Order")? richCustomText(notificationAbb.body!):
                    richCusText(notificationAbb.body!),
                    Spacer(),
                    SizedBox(
                      height: 20.h,
                      width: 180.w,
                      child: Row(
                        children: [
                          customText1(
                            formatTimeDifference(DateTime.parse(notificationAbb.createdOn!)),
                            kBlack, 12.sp,),
                          Spacer(),
                          Icon(Icons.circle, color: kBlack.withOpacity(0.5),
                              size: 6),
                          // gapWeight(3.w),
                          Spacer(),
                          customText1(notificationAbb.type!,
                              kBlackB600, 14.sp,fontFamily: fontFamilyInter)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Visibility(
                  visible: (notificationAbb.type=="Order"),
                  child: notificationOrderActionButtons(viewOrder,declineOrder))
            ],
          ),
        )
      ],
    ),
    );
}

String? extractName(String sentence) {
  RegExp regex = RegExp(r'[^,]+');
  RegExpMatch? match = regex.firstMatch(sentence);
  if (match != null) {
    return match.group(0)?.trim();
  } else {
    return null;
  }
}

String? extractAfterComma(String sentence) {
  RegExp regex = RegExp(r',\s*(.*)');
  RegExpMatch? match = regex.firstMatch(sentence);
  if (match != null && match.groupCount >= 1) {
    return " ${match.group(1)}";
  } else {
    return null;
  }
}

 Widget notificationOrderActionButtons(void Function()? viewOrder,
     void Function()? declineOrder){
  return  SizedBox(
    height: 25.h,
    width: 200.w,
    child: Row(
     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
           // await executeCreateProduct(context);
          },
          child: Container(
            height: 39.h,
            width: 90.w,
            decoration: BoxDecoration(
              color: kAppBlue,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
                child: customText1("View order", kWhite, 12.sp,
                fontFamily: fontFamilyInter)
            ),
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            height: 39.h,
            width: 90.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: kLightPink,
                border: Border.all(
                    color: kAppBlue
                )
            ),
            child: Center(child: customText1(
               "Decline order", kBlack, 12.sp,fontFamily: fontFamilyInter)),
          ),
        ),

      ],
    ),
  );
 }
String formatTimeDifference(DateTime actionTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(actionTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 2) {
    return 'A moment ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} mins ago';
  } else if (difference.inHours < 2) {
    return 'An hour ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 2) {
    return 'Yesterday';
  } else {
    return '${difference.inDays} days ago';
  }
}
String abbrevatedName(String name){
  // Split the string into words
  List<String> words = name.split(' ');

  // Take the first letter of each word and concatenate them
  String initials = words.map((word) => word.isNotEmpty ? word[0] : '').join();

  return initials;
}
Widget richCustomText(String boldText,){
  return RichText(text:
  TextSpan(
    children:[
      TextSpan(text: extractName(boldText),
        style: TextStyle(
          color: kBlack,
          fontFamily: fontFamilyInter,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
          fontSize: 14.sp, // You can adjust the font size as needed
        ),),
      TextSpan(text:extractAfterComma(boldText),
        style: TextStyle(
          color: kBlackB600,
          overflow: TextOverflow.ellipsis,
          fontFamily: fontFamilyInter,
          fontSize: 14.sp, // You can adjust the font size as needed
        ),),

    ]
  ));
}

Widget richCusText(String boldText){
  return
  SizedBox(
      height: 35.h,
      child: customText1(boldText,kBlackB600,13.sp,maxLines: 3));
}
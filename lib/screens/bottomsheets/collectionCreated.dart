import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../../utils/AppUtils.dart';

class CollectionCreated extends StatefulWidget {
  String alertType;
  String? collectionUrl;
   CollectionCreated({required this.alertType, this.collectionUrl,super.key});

  @override
  State<CollectionCreated> createState() => _CollectionCreatedState();
}

class _CollectionCreatedState extends State<CollectionCreated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,height: 690.h,
        color:kWhite,
        child: Column(
          children: [
            // Gap(10),
            Lottie.asset("assets/json/success.json", height: 250.h, width: 250.w),

            customText1("Collection ${widget.alertType} successfully", kBlack, 18.sp,
                fontFamily:fontFamilyGraphilk,fontWeight: FontWeight.w500 ),
           Gap(10),
            SizedBox(
             width: 280.w,
              child: customText1("Well-done, you have succesfully  ${widget.alertType} a collection for you store",
                  kBlack, 14.sp,fontFamily:fontFamilyInter, maxLines: 2,
                  indent:TextAlign.center, fontWeight: FontWeight.w200),
            ),
            Gap(10),
            Container(
              height: 40.h,
              width: 250.w,
              decoration: BoxDecoration(
                  color: kLightPink,
                  borderRadius: BorderRadius.circular(15.r),),
              child: Padding(
                padding: EdgeInsets.only(left: 10.w,right: 10.w),
                child:
                    Center(
                      child: customText1(
                          widget.collectionUrl??"", kBlackB600, 14.sp,
                          fontWeight: FontWeight.w400,
                          indent: TextAlign.center,
                          fontFamily: fontFamilyInter),
                    ),

              ),
           ),
            Gap(20),
            SizedBox(
              height: 82.h,
              width: 148.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: ()async {
                        final box = context.findRenderObject() as RenderBox;
                        print("i am here");
                        await Share.share(
                            "${widget.collectionUrl??""}",
                           sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                        },
                        child: Container(
                            child:SvgPicture.asset(
                                "assets/shareCopy.svg",
                                fit: BoxFit.scaleDown),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.r),
                                color:kLightPink.withOpacity(0.7)),
                            height:44.h,
                            width: 44.w),
                      ),
                      gapHeight(10.h),
                      customText1("Share", kBlack, 14.sp,
                          fontWeight: FontWeight.w300,fontFamily: fontFamilyInter)
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          copytext(
                              "${widget.collectionUrl??""}",
                              context);
                        },
                        child: Container(
                            child:SvgPicture.asset(
                                "assets/collectionCopyy.svg",
                                fit: BoxFit.scaleDown),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.r),
                                color:kLightPink.withOpacity(0.7)),
                            height:44.h,
                            width: 44.w),
                      ),
                      gapHeight(10.h),
                      customText1("Copy", kBlack, 14.sp,
                          fontFamily: fontFamilyInter,
                          fontWeight: FontWeight.w300)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CollectionDeleted extends StatefulWidget {
  const CollectionDeleted({super.key});

  @override
  State<CollectionDeleted> createState() => _CollectionDeletedState();
}

class _CollectionDeletedState extends State<CollectionDeleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,height: 490.h,
        color:kWhite,
        child: Column(
          children: [
            // Gap(10),
            Lottie.asset("assets/json/success.json", height: 250.h, width: 250.w),

            customText1("Collection deleted", kBlack, 20.sp,
                fontFamily:fontFamilyGraphilk,fontWeight: FontWeight.w500 ),
            Gap(10),
            SizedBox(
              width: 280.w,
              child: customText1("You have deleted the collection",
                  kBlack, 16.sp,fontFamily:fontFamilyInter, maxLines: 2,
                  indent:TextAlign.center, fontWeight: FontWeight.w200),
            ),
            Gap(10),
            Column(
              children: [
                Container(

                    child: Image.asset("assets/change.png",
                        color: kAppBlue,
                        scale: 3,
                        fit: BoxFit.scaleDown),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.r),
                        color:kLightPink.withOpacity(0.7)),
                    height:54.h,
                    width: 54.w),
                gapHeight(10.h),
                customText1("Restore collection", kBlack, 16.sp,
                    fontWeight: FontWeight.w400,fontFamily: fontFamilyInter)
              ],
            )
          ],
        ),
      ),
    );
  }
}

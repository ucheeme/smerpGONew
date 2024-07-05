import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/controller/collection.dart';

import '../../../../../utils/UserUtils.dart';
import '../../../../../utils/appColors.dart';
import '../../../../../utils/appDesignUtil.dart';
import '../../../../bottomsheets/camera.dart';
import '../../profile/profileList.dart';
import 'addProductsToCollection.dart';

class CreateCollectionUI extends StatefulWidget {
  const CreateCollectionUI({super.key});

  @override
  State<CreateCollectionUI> createState() => _CreateCollectionState();
}

class _CreateCollectionState extends State<CreateCollectionUI> {
  var _controller =Get.put(CollectionController());
  @override
  void initState() {
    _controller.collectionName.clear();
    _controller.collectionIImage.value="";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:kWhite ,
      appBar: PreferredSize(
          child:  defaultDashboardAppBarWidget(() {
            _controller.collectionIImage.value="";
           Get.back();
          },  "        Add new collection",),
          preferredSize: Size.fromHeight(70.h)),
      body: Padding(
        padding:  EdgeInsets.only(left: 16.w,right: 16.w),
        child: SingleChildScrollView(
          child: Container(
            height: 800.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 390.h,
                  child: Column(
                    children: [
                      Gap(20),
                      Container(
                        height: 60.h,
                        child: titleSignUp(_controller.collectionName,
                            textInput: TextInputType.text,
                            hintText: "Enter collection name"),
                      ),
                      Gap(20),
                      GestureDetector(
                        onTap: () async {
                          var response = await Get.bottomSheet(
                              CameraOption()
                          );
                          if (response != null) {
                            setState(() {
                              //  var paymentStatus =response;
                              _controller.collectionIImage.value="";
                              _controller.collectionImageFile = response[0];
                              _controller.collectionIImage.value = response[1];
                            });
                          }
                        },
                        child: textFieldBorderWidget(
                            Container(
                              padding: EdgeInsets.all(20.h),
                              height: (_controller.collectionIImage.value.isEmpty)?50.h:
                              260.h,
                              width: 368.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  image: (_controller.collectionIImage.value.isEmpty)?null:
                                  DecorationImage(image: displayImage(
                                      _controller.collectionImageFile).image,
                                      fit: BoxFit.cover)
                              ),

                            ), "Upload image"),
                      ),
                    ],
                  ),
                ),

                (_controller.collectionIImage.value.isNotEmpty)?
                GestureDetector(
                  onTap: () {
                _controller.checkIfCollectionHasName();
                  },
                  child:
                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                        color: kAppBlue,
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                            color: kAppBlue, width: 0.5.w)),
                    child: Center(
                      child: customText1(
                          "Add products", kWhite, 16.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: fontFamilyInter),
                    ),
                  ),
                ):
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _controller.collectionIImage.value="";
                        Get.back();
                      },
                      child: Container(
                        height: 60.h,
                        width: 192.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: kLightPink,
                            border: Border.all(
                                color: kAppBlue
                            )
                        ),
                        child: Center(child: customText1(
                            "Discard", kAppBlue, 18.sp)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _controller.checkIfCollectionHasName();
                      },
                      child: Container(
                        height: 60.h,
                        width: 192.w,
                        decoration: BoxDecoration(
                          color: kAppBlue,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Center(
                            child: customText1("Proceed", kWhite, 18.sp)
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

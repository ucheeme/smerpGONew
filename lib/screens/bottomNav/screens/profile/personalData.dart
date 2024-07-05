import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/controller/profileController.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/UserUtils.dart';

import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../bottomsheets/camera.dart';
import '../../../bottomsheets/updateUserProfileMailPhone.dart';

class PersonalData extends StatefulWidget {
  bool? isJustCreated;
   PersonalData({this.isJustCreated,Key? key}) : super(key: key);

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> with WidgetsBindingObserver{
  var _controller = Get.put(ProfileController());
  var isEdit = RxBool(false);
  var updateProfilePic = RxBool(false);
  var idSource=0;

  @override
  void initState() {
    if(widget.isJustCreated!=null && widget.isJustCreated==true){
      isEdit.value= true;
    }
    _controller.storePhone.text = loginData?.storePhoneNumber??"";
    storeNPhone.value = _controller.storePhone.text;

    _controller.storeEmail.text = loginData!.storeEmail??"no email available";
    storeNEmail.value = _controller.storeEmail.text;
    _controller.storeName.text = loginData!.storeName;
    _controller.otherNames.text = loginData!.lastName;
    _controller.firstName.text = loginData!.firstName;
    _controller.storeMerchantCode.text = userMerchantCode!;
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Screen is visible again, trigger a rebuild
      setState(() {});
    }
  }





  @override
  Widget build(BuildContext context) {
    return Obx(() {

      return overLay(
        Scaffold(
          backgroundColor: kWhite,
          appBar: PreferredSize(
              child: defaultDashboardAppBarWidget(() {
                Get.back();
              _controller.userInfo();
              }, "Personal data",context: context),
              preferredSize: Size.fromHeight(80.h)),
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              child: SingleChildScrollView(
                child: Obx(() {
                  return Column(
                    children: [
                      Visibility(
                          visible: isEdit.value,
                          child: gapHeight(20.h)),
                      Container(
                        height: 220.h,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 162.66.w,
                              height: 149.8.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image:(updateProfilePic.isTrue)?
                                DecorationImage(
                                    image: base64ToImage((_controller.userUpdateImage == null)
                                        ? "" : _controller.userUpdateImage!).image,
                                    fit: BoxFit.fill):
                                DecorationImage(
                                    image: getImageNetwork((userImage.value == null||
                                    userImage.value=="N/A")
                                       ? "" : userImage.value).image,
                                    fit: BoxFit.fill),
                              ),
                              // child: ,
                            ),
                            gapHeight(20.2.h),
                            GestureDetector(
                              onTap: () async {
                                updateProfilePic.value = true;
                                var response = await Get.bottomSheet(
                                    CameraOption()
                                );
                                if (response != null) {
                                  setState(() {
                                    _controller.userUpdateImage = response[1];
                                  });
                                  _controller.updateStorePic(
                                      _controller.userUpdateImage!
                                  );
                                }
                              },
                              child: Visibility(
                                visible: isEdit.value,
                                child: Container(
                                  height: 36.h,
                                  width: 160.w,
                                  decoration: BoxDecoration(
                                    color: kLightPink,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          "assets/gallery-add.svg"),
                                      gapWeight(7.w),
                                      Center(
                                          child: customText1(
                                              "Change image", kBlackB800, 16.sp)
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                          visible: isEdit.value,
                          child: gapHeight(4.h)),
                      Container(
                        height:(isEdit.value)?710.h:655.h,
                        child: Column(
                          children: [
                            Container(
                              height: 65.h,
                              child: titleSignUp(_controller.firstName,
                                  textInput: TextInputType.text,
                                  hintText: "Store owner first name",
                                  readOnly: (isEdit.value) ? false : true
                              ),
                            ),
                          Gap(15),
                            Container(
                              height: 65.h,
                              child: titleSignUp(_controller.otherNames,
                                  textInput: TextInputType.text,
                                  hintText: "Store owner other names",
                                  readOnly: (isEdit.value) ? false : true
                              ),
                            ),
                           Gap(15),
                            Container(
                              height: 65.h,
                              child: titleSignUp(_controller.storeName,
                                  textInput: TextInputType.text,
                                  hintText: "Store name",
                                  readOnly: (isEdit.value) ? false : true
                              ),
                            ),
                           Gap(15),
                            Container(
                              height: (isEdit.value)?97.h:69.h,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap:(){
                                     if (!isEdit.value){null;}else{
                                       setState(() {
                                         idSource = 2;
                                       });
                                       Get.bottomSheet(
                                           backgroundColor: kWhite,
                                           ignoreSafeArea: false,
                                           isScrollControlled: true,
                                           Obx(() {
                                             return Container(
                                                 height: (isKeyboardOpen.value) ? 550.h : 300.h,
                                                 child: UpdateUserMailPhone(idSource: idSource,));
                                           })
                                       );
                                     }
                                     },
                                    child: Container(
                                      height: 65.h,
                                      child: textFieldBorderWidgetPD(
                                        Align(
                                           alignment: Alignment.centerLeft,
                                            child: customText1(storeNEmail.value, kBlack, 18.sp)),
                                        "Store email",),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        idSource = 2;
                                      });
                                      Get.bottomSheet(
                                          backgroundColor: kWhite,
                                          ignoreSafeArea: false,
                                          isScrollControlled: true,
                                          Obx(() {
                                            return Container(
                                                height: (isKeyboardOpen.value) ? 550.h : 300
                                                    .h,
                                                child: UpdateUserMailPhone(idSource: idSource,));
                                          })
                                      );
                                    },
                                    child: Visibility(
                                      visible: (isEdit.value) ?true:false,
                                      child: Container(
                                        height: 30.h,
                                        width: double.infinity,
                                        child: Padding(
                                          padding:  EdgeInsets.only(right: 8.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              SvgPicture.asset("assets/refresh.svg",
                                                fit: BoxFit.scaleDown,),
                                              gapWeight(5.w),
                                              customText1("Change email",kBlack, 15.sp)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Gap(15),
                            Container(
                              height: (isEdit.value)?104.h:74.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap:(){
                                      if (!isEdit.value){null;}else{
                                        setState(() {
                                          idSource = 1;
                                        });
                                        Get.bottomSheet(
                                            backgroundColor: kWhite,
                                            ignoreSafeArea: false,
                                            isScrollControlled: true,
                                            Obx(() {
                                              return Container(
                                                  height: (isKeyboardOpen.value) ? 550.h : 300
                                                      .h,
                                                  child: UpdateUserMailPhone(idSource: idSource,));
                                            })
                                        );
                                      }
                                    //  Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 65.h,
                                      child: textFieldBorderWidgetPD(
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: customText1(storeNPhone.value,
                                                kBlack, 18.sp)),
                                          "Store phone",
                                      ),
                                    ),
                                  ),
                                 gapHeight(8.h),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        idSource=1;
                                      });
                                      Get.bottomSheet(
                                          backgroundColor: kWhite,
                                          ignoreSafeArea: false,
                                          isScrollControlled: true,
                                          Obx(() {
                                            return Container(
                                                height: (isKeyboardOpen.value) ? 550.h : 300
                                                    .h,
                                                child: UpdateUserMailPhone(idSource: idSource,));
                                         })
                                      );
                                    //  Navigator.pop(context);
                                    },
                                    child: Visibility(
                                      visible:  (isEdit.value) ?true:false,
                                      child: Container(
                                        height: 30.h,
                                        width: double.infinity,
                                        child: Padding(
                                          padding:  EdgeInsets.only(right: 8.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: 20.h,
                                                width: 20.w,
                                                child: SvgPicture.asset("assets/refresh.svg",
                                                  fit: BoxFit.scaleDown,),
                                              ),
                                              gapWeight(5.w),
                                              customText1("Change phone",kBlack, 15.sp)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                           Gap(15),
                            Container(
                              height: 65.h,
                              child: titleSignUp(_controller.storeMerchantCode,
                                  textInput: TextInputType.phone,
                                  hintText: "Merchant Code",
                                  readOnly: true
                              ),
                            ),
                            gapHeight(34.h),
                            GestureDetector(
                              onTap: () async {
                                String? firstName;
                                String? lastName;
                                String? businessName;
                                firstName = _controller.firstName.text;
                                lastName = _controller.otherNames.text;
                                businessName = _controller.storeName.text;
                                if (isEdit.value) {
                                  isEdit.value = false;
                                  _controller.updateStoreInfo(
                                      firstName, lastName, businessName);
                                } else {
                                  isEdit.value = true;
                                }
                               if(updateProfilePic.isTrue &&
                                    _controller.userUpdateImage!=null){
                                  _controller.updateStorePic(
                                    _controller.userUpdateImage!
                                  );
                                }
                              },
                              child: Container(
                                height: 60.h,

                                decoration: BoxDecoration(
                                  color: kAppBlue,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Center(
                                    child: customText1(
                                        (isEdit.value) ? "Update info" :
                                        "Edit info", kWhite, 18.sp)
                                ),
                              ),
                            ),
                            gapHeight(20.h)
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
        isLoading: _controller.isLoading.value
      );
    });
  }
}

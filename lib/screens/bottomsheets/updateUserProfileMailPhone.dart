import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/profileController.dart';
import '../../utils/AppUtils.dart';
import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';
import '../bottomNav/screens/profile/profileOtpVerification.dart';

class UpdateUserMailPhone extends StatefulWidget {
  int idSource= 0;
  UpdateUserMailPhone({super.key, required this.idSource});

  @override
  State<UpdateUserMailPhone> createState() => _UpdateUserMailPhoneState();
}

class _UpdateUserMailPhoneState extends State<UpdateUserMailPhone> {
  var _controller = Get.put(ProfileController());
  var userIdentity = TextEditingController();
  RxBool isLoading =RxBool(false);

  FocusNode? _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode?.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode?.removeListener(_onFocusChange);
    _focusNode?.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isKeyboardOpen.value = _focusNode!.hasFocus;
    });
  }
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData =MediaQuery.of(context);
    return Obx(() {
      return overLay(
          GestureDetector(
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(

              resizeToAvoidBottomInset: false,

              body: Padding(
                padding: mediaQueryData.viewInsets,
                child: Container(
                  height: 400.h,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: kLightPink,
                        height: 53.h,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: customText1("Enter your ${getUserChoice(widget.idSource)}", kBlack, 18.sp,
                              fontWeight: FontWeight.w500,fontFamily: fontFamily
                            ),
                          ),
                        ),
                      ),
                      gapHeight(25.h),
                      Container(
                        height: 70.h,
                        child: titleSignUp(userIdentity,
                          textInput: (widget.idSource==1)?TextInputType.number:
                          TextInputType.emailAddress,
                          hintText:"Enter your new ${getUserChoice(widget.idSource)}",
                          focus:  _focusNode,
                        ),
                      ),
                      gapHeight(50.h),
                      GestureDetector(
                        onTap: () async {
                          if(widget.idSource==1&&userIdentity.text.isPhoneNumber){
                            Get.snackbar("Updating User info",
                                "Please wait..",
                                snackStyle: SnackStyle.FLOATING,
                                showProgressIndicator: true,
                                borderRadius: 8.r,
                                overlayBlur: 2,
                                isDismissible: false,
                                backgroundColor: kWhite,
                                snackPosition: SnackPosition.TOP);

                            var res= await _controller.getOtpToChangeUserInfo(
                                widget.idSource,userIdentity.text,
                                isLoading
                            );
                            if(res){

                              Get.to(
                                  ProfileOtpVerification(
                                    userId: userIdentity.text,
                                    userOption:widget.idSource,),
                                  transition: Transition.cupertino
                              );
                              Get.back();
                            }else{
                              Get.back();
                            }
                          }else if(widget.idSource==2&&userIdentity.text.isEmail){
                            Get.snackbar("Updating User info",
                                "Please wait..",
                                snackStyle: SnackStyle.FLOATING,
                                showProgressIndicator: true,
                                borderRadius: 8.r,
                                overlayBlur: 2,
                                isDismissible: false,
                                backgroundColor: kWhite,
                                snackPosition: SnackPosition.TOP);

                            var res= await _controller.getOtpToChangeUserInfo(
                                widget.idSource,userIdentity.text,
                                isLoading
                            );
                            if(res){
                              Get.back();
                              Get.to(
                                  ProfileOtpVerification(
                                    userId: userIdentity.text,
                                    userOption:widget.idSource,),
                                  transition: Transition.cupertino
                              );
                            }else{
                              Get.back();
                            }
                          }else{
                            Get.snackbar("Not allowed",
                                "You entered an invalid ${getUserChoice(widget.idSource)}",
                                snackStyle: SnackStyle.FLOATING,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.TOP);
                          }



                        },
                        child: Padding(
                          padding:  EdgeInsets.only(left: 15.h,right: 15.h),
                          child: dynamicContainer(Center(
                              child: customText1(
                                  "Verify ${getUserChoice(widget.idSource)}",
                                  kWhite, 18.sp,fontWeight: FontWeight.w500)),
                              kAppBlue, 60.h,
                              width: double.infinity,radius: 15.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          isLoading: isLoading.value
      );
    });
  }
}

String getUserChoice(int value){
  if(value==1){
    return "phone number";
  }else{
    return "email";
  }
}
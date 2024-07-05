// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smerp_go/controller/profileController.dart';
import 'package:smerp_go/cubit/bankDetail/bank_details_cubit.dart';
import 'package:smerp_go/screens/authentication_signup/signInFlow/signin.dart';
import 'package:smerp_go/screens/bottomNav/screens/profile/bankDetails.dart';
import 'package:smerp_go/screens/bottomNav/screens/profile/contactSupport.dart';
import 'package:smerp_go/screens/bottomNav/screens/profile/faqs.dart';
import 'package:smerp_go/screens/bottomNav/screens/profile/personalData.dart';
import 'package:smerp_go/screens/bottomNav/screens/profile/privacyPolicy.dart';
import 'package:smerp_go/screens/bottomsheets/qrCodeGenerator.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/UserUtils.dart';
import 'package:smerp_go/utils/appColors.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/dashboardController.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../../utils/downloadAsImage.dart';
import '../../../../utils/mockdata/tempData.dart';
import '../../../authentication_signup/signInFlow/signinViaPhoneEmail.dart';
import '../../../bottomsheets/deleteAcct.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var _controllerDashboard = Get.put(DashboardController());
  var _controllerProfile = Get.put(ProfileController());
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  late BankDetailsCubit cubit;
  @override
  void initState() {
    _controllerProfile.userNamee.value =
        "${loginData!.firstName} ${loginData!.lastName}";
    _controllerProfile.userInfo();
    super.initState();
  }
  final appLink ="https://play.google.com/store/apps/details?id=com.fifthlab.smerp_go";
  @override
  Widget build(BuildContext context) {
    cubit= context.read<BankDetailsCubit>();
    return bloc.BlocBuilder<BankDetailsCubit, BankDetailsState>(
  builder: (context, state) {
    if(state is BankDetailErrorState){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          showToast(state.errorResponse.message);
          // showOrderHistory(message: state.errorResponse.message);
        });
      });
      cubit.resetState();
    }
    if(state is BankDetailSuccessState){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controllerProfile.isLoading.value=false;
        Get.to(
          BankDetails(response: state.response,),
          duration: Duration(seconds: 1),
          transition: Transition.cupertino,
        );
      });
      cubit.resetState();
    }
    return Obx(() {
      return overLay(
          Scaffold(
            backgroundColor: kWhite,
            appBar: PreferredSize(
                child: defaultDashboardAppBarWidget(() {
                  Get.back();
                }, "Profile", context: context),
                preferredSize: Size.fromHeight(80.h)),
            body: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              child: Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  //  physics: NeverScrollableScrollPhysics(),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gapHeight(21.h),
                        Container(
                         // color: kPaidColor,
                          height: 274.h,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Container(
                                width: 108.4.w,
                                height: 99.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: getImageNetwork(userImage.value)
                                          .image,
                                      fit: BoxFit.fill),
                                ), // child: ,
                              ),
                              gapHeight(13.h),
                              customText1("${loginData!.storeName}",
                                  kBlack, 20.sp,
                                  fontWeight: FontWeight.w500),
                              gapHeight(15.h),
                              customText1(
                                  "https://go.smerp.io/${loginData!.merchantCode}",
                                  kBlackB700,
                                  14.sp,
                                  fontWeight: FontWeight.w400),
                              gapHeight(10.h),
                              Container(
                                width: double.infinity,
                                height: 40.h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        copytext(
                                            "https://go.smerp.io/${loginData!.merchantCode}",
                                            context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5.77.w,right: 5.77.w),
                                        height: 46.h,
                                        width: 87.7.w,
                                        decoration: BoxDecoration(
                                          color: kLightPink2,
                                          border: Border.all(
                                              color: kAppBlue, width: 0.3.w),
                                          borderRadius:
                                          BorderRadius.circular(11.5.r),
                                        ),
                                        child: Row(
                                          // mainAxisAlignment:
                                          // MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset("assets/copy.svg"),
                                            gapWeight(4.w),
                                            Center(
                                                child: customText1(
                                                   "Copy", kBlackB800, 16.sp)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    gapWeight(10.h),
                                    Builder(builder: (context) {
                                      return GestureDetector(
                                        onTap: () async {
                                          final box = context.findRenderObject()
                                              as RenderBox;
                                          print("i am here");
                                          await Share.share(
                                              "https://go.smerp.io/${loginData!.merchantCode}",
                                              sharePositionOrigin:
                                                  box.localToGlobal(
                                                          Offset.zero) &
                                                      box.size);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(left: 5.77.w,right: 5.77.w),
                                          height: 46.h,
                                          width: 88.7.w,
                                          decoration: BoxDecoration(
                                            color: kLightPink2,
                                            border: Border.all(
                                                color: kAppBlue, width: 0.3.w),
                                            borderRadius:
                                                BorderRadius.circular(11.5.r),
                                          ),
                                          child: Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                 "assets/share.svg"),
                                         gapWeight(4.w),
                                              Center(
                                                  child: customText1("Share",
                                                      kBlackB800, 16.sp)),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                    gapWeight(10.h),
                                    GestureDetector(
                                      onTap: () {
                                        Get.bottomSheet(GenerateQRCode(
                                            link:
                                                "https://go.smerp.io/${loginData!.merchantCode}"));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5.77.w,right: 5.77.w),
                                        height: 46.h,
                                        width: 115.7.w,
                                        decoration: BoxDecoration(
                                          color: kLightPink2,
                                          border: Border.all(
                                              color: kAppBlue, width: 0.3.w),
                                          borderRadius:
                                              BorderRadius.circular(11.5.r),
                                        ),
                                        child: Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                "assets/qrCode.svg"),
                                          gapWeight(4.w),
                                            Center(
                                                child: customText1("QR code",
                                                    kBlackB800, 16.sp)),
                                          ],
                                        ),
                                      ),
                                   ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        gapHeight(30.h),
                        Container(
                          height: 160.h,
                          width: 398.w,
                          decoration: BoxDecoration(
                            // color: kViewOrderColor,
                            color: kLightPink.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 20.w,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    gapHeight(10.h),
                                    Container(
                                      // color: kAppBlue,
                                      width: 240.w,
                                      height: 70.h,
                                      child: customText1(
                                          "Get verified and start receiving payments",
                                          kBlack,
                                          22.sp,
                                          maxLines: 3,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: fontFamily),
                                    ),
                                    gapHeight(20.h),
                                   GestureDetector(
                                     onTap: (){
                                       Get.snackbar("Coming Soon", "",backgroundColor: kLightPink1,colorText: kAppBlue);
                                     },
                                     child: Container(
                                        height: 42.h,
                                        width: 183.w,
                                        decoration: BoxDecoration(
                                          color: kLightPink1,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.w, right: 5.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                           children: [
                                              customText1(
                                                  "Verify business profile",
                                                  kAppBlue,
                                                  14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: fontFamily),
                                              SvgPicture.asset(
                                                "assets/forwardArrow.svg",
                                                fit: BoxFit.scaleDown,
                                                height: 20.h,
                                                width: 10.w,
                                                // color: kBlack.withOpacity(0.8),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                   ),
                                    gapHeight(16.h),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 150.h,
                                    //width: 150.w,
                                    child: Image.asset(
                                      "assets/paymentImg.png",
                                   ),
                                  ),
                                )
                                // color: kBlack.withOpacity(0.8),))
                              ],
                            ),
                          ),
                        ),
                        gapHeight(20.h),
                        SingleChildScrollView(
                          child: Container(
                            height: 850.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                gapHeight(30.05.h),
                                customText1("Account", kBlack, 18.sp,
                                    fontWeight: FontWeight.w400),

                                iconAndRow(
                                    "assets/pCircle.png", "Personal data", "",
                                    isSvg: false, onTap: () {
                                  Get.to(
                                    PersonalData(),
                                    duration: Duration(seconds: 1),
                                    transition: Transition.cupertino,
                                  );
                                }),
                                gapHeight(8.h),
                                iconAndRow(
                                    "assets/pCircle.png", "Bank Details", "",
                                    isSvg: false, onTap: () {
                                      _controllerProfile.isLoading.value=true;
                                      cubit.getBankDetail();
                                }),
                                gapHeight(8.h),
                                iconAndRow("assets/inviteFriends.png",
                                    "Invite friends", "Invite friends",
                                    isSvg: false, onTap: () async {
                                  // shareAppLink(appLink, 'whatsapp://send?text='
                                  //     'Check Out this app I use to manage my business $appLink');
                                      final box = context.findRenderObject()
                                      as RenderBox;
                                      print("i am here");
                                      await Share.share(
                                          "Hey 👋, I’m using Smerp Go - Grow your business on the Go! Boost your business with bookkeeping, inventory magic, smart analysis, and a FREE online website. Don't miss out – give it a whirl now! 🚀💼💻\n"
                                           "https://go.smerp.io",
                                          sharePositionOrigin:
                                          box.localToGlobal(
                                              Offset.zero) &
                                          box.size);
                                    }),
                                gapHeight(20.h),
                                customText1("Security", kBlack, 18.sp,
                                    fontWeight: FontWeight.w400),
                                // gapHeight(31.36.h),
                                iconAndRow("assets/message-question.png",
                                    "FAQs", "Frequently asked questions",
                                    isSvg: false, onTap: () {
                                  Get.to(FAQs(),
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeIn);
                                }),
                                gapHeight(8.h),
                                iconAndRow("assets/securityUser.png",
                                    "Privacy policy", "SmerpGo privacy policy",
                                    isSvg: false, onTap: () {
                                  Get.to(PrivacyPolicy(),
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeIn);
                                }),
                                gapHeight(8.h),
                                iconAndRow(
                                  "assets/support24.png",
                                  "Contact & Support",
                                  "Reach us",
                                  isSvg: false,
                                  onTap: () {
                                    Get.to(ContactSupport(),
                                        duration: Duration(seconds: 1),
                                        curve: Curves.easeIn);
                                  },
                                ),
                                gapHeight(30.h),
                                GestureDetector(
                                  onTap: () {
                                    _controllerProfile.isLoading.value = true;
                                    productCategoryList = [];
                                    productUnitCategoryList = [];
                                    inventoryListTemp = [];
                                    catalogListTemp = [];
                                    catalogsFTemp = [];
                                    saleListTemp = [];
                                    actionBy = "";
                                    inventoryId = "";
                                    isLoading.value = false;
                                    isSignUpViaPhone.value = true;
                                    userIdentityValue = null;
                                    identitySource = null;
                                    otpCreateAccout = "";
                                    loginData = null;
                                    isProductCategoryHasRun = Rx(false);
                                    isProductUnitCategoryHasRun = Rx(false);
                                    isInventoryListHasRun = false;
                                    isSalesListHasRun = Rx(false);
                                    isCatalogListHasRun = Rx(false);
                                    saleIsEmpty = RxBool(false);
                                    productIsEmpty = RxBool(false);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SignIn(),
                                        ),
                                        (route) => false);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 80.h,
                                    color: kWhite,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15.67.w),
                                      child: Row(
                                        children: [
                                          Image.asset("assets/logout.png",
                                          height: 30.h,
                                          width: 30.w,
                                          fit: BoxFit.contain,),
                                          gapWeight(21.35.w),
                                          customText1("Logout", kBlack, 18.sp),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                gapHeight(20.h),
                                GestureDetector(
                                  onTap: () async {
                                    int response =
                                        await Get.bottomSheet(DeleteAccount());
                                    if (response == 1) {
                                     bool response= await _controllerProfile.deleteAcct(context,);
                                     // if(response){
                                     //   print("im hereeeee");
                                     //   Navigator.pushAndRemoveUntil(
                                     //       context,
                                     //       MaterialPageRoute(
                                     //         builder: (
                                     //             context) => const SignInViaPhoneEmail(),),
                                     //           (route) => true);
                                     // }
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 56.h,
                                    decoration: BoxDecoration(
                                        color: kRed50,
                                        borderRadius:
                                            BorderRadius.circular(15.r)),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15.w),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              "assets/trash.png",
                                          height: 26.h,
                                          width: 26.w,
                                          fit: BoxFit.contain,),
                                          gapWeight(21.35.w),
                                          customText1(
                                              "Delete account", kRed60, 18.sp,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.w400),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          isLoading: _controllerProfile.isLoading.value);
    });
  },
);
  }
  // void openContactsAndSendMessage() async {
  //   final appLink ="https://play.google.com/store/apps/details?id=com.fifthlab.smerp_go";
  //   try {
  //     final contact = await ContactsService.openDeviceContactPicker();
  //
  //     if (contact != null) {
  //       final phone = contact.phones?.first?.value ?? "";
  //       final Uri smsLaunchUri = Uri(
  //         scheme: 'sms',
  //         path: phone,
  //       );
  //       // Check if WhatsApp is installed
  //       final whatsappInstalled = await canLaunch("whatsapp://send?phone=$phone");
  //
  //       if (whatsappInstalled) {
  //         // Open WhatsApp
  //         await launchUrl(smsLaunchUri,webOnlyWindowName: "sms:$phone");
  //        // await launch("whatsapp://send?phone=$phone&text=$appLink");
  //       } else {
  //         // Send SMS
  //         await launchUrl(smsLaunchUri,webOnlyWindowName: "sms:$phone");
  //       }
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }

  // void shareAppLink(String appLink, String platform) async {
  //   try{
  //     final message = "Check out my app: $appLink";
  //
  //     final whatsappInstalled = await canLaunch("whatsapp://send");
  //     if(whatsappInstalled){
  //       if (await canLaunch(platform)) {
  //         await launch(platform, forceSafariVC: false);
  //       } else {
  //         throw 'Could not launch $platform';
  //       }
  //     }else{
  //       Get.snackbar("Your device do not have whatsapp installed", "",backgroundColor: kRed70,colorText: kWhite);
  //     }
  //
  //   }catch(e){
  //     print("Error: $e");
  //   }
  //
  // }
  Future<void> onRefresh() async {
    bool res = await _controllerProfile.userInfo(
        isRefresh: true, refreshController: refreshController);
    if (res) {
      setState(() {
        userImage = userImage;
      });
    }
  }
}

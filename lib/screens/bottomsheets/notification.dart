import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/cubit/notificationCubit/notification_cubit.dart';
import 'package:smerp_go/screens/bottomsheets/viewOrder.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../../controller/orderController.dart';
import '../../model/response/notificationList.dart';
import '../../utils/customWidget.dart';
import '../../utils/downloadAsImage.dart';
import '../../utils/mockdata/tempData.dart';

class NotificationApp extends StatefulWidget {
  const NotificationApp({super.key});

  @override
  State<NotificationApp> createState() => _NotificationAppState();
}

class _NotificationAppState extends State<NotificationApp> {
  RxInt notificationNumber = 0.obs;
  List<NotificationList> notificationList=[];
  List<bool> isOpenList = [];
  NotificationCubit? cubit;
  var _controllerOrders = Get.put(OrderController());
  RefreshController refreshController2 =
  RefreshController(initialRefresh: false);
@override
  void initState() {
   notificationBarOpenConditionList();
  // notificationNumber.value;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  cubit = context.read<NotificationCubit>();
  if(notificationListTemp.isEmpty){
    cubit?.getNotificationList();
  }else {
    notificationList = notificationListTemp;
  }
    return BlocBuilder<NotificationCubit, NotificationState>(
  builder: (context, state) {
    if(state is NotificationErrorState){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          showToast(state.errorResponse.message);
          // showOrderHistory(message: state.errorResponse.message);
        });
      });
    }

    if(state is NotificationSuccessState){
      notificationList= state.response;
      notificationNumber.value = state.response.length;
    }
    return overLay(
       Scaffold(
        appBar: PreferredSize(
            child: Obx(() {
              return defaultDashboardAppBarWidget(() {
                Get.back();
              }, "Notifications (${notificationNumber.value})", context: context,
                  isVisible: false);
            }),
            preferredSize: Size.fromHeight(80.h)),
        body: Container(
          height: 1000.h,
          child: Column(
                  children: [
                    SizedBox(
                      height: 760.h,
                      width: double.infinity,
                      child: ListView.builder(
                          itemCount: notificationList.length,
                         itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: (){
                                if(notificationList[index].type=="Order"){
                                  openOrder(index);
                                }else{
                                  showCustomDialog(context,notificationList[index].title!,notificationList[index].body!);
                                }

                              },
                              child: Column(
                                children: [
                                  notificationDesign(
                                      notificationList[index],index,
                                      isOpen: isOpenList[index],
                                      viewOrder: (){openOrder(index);},
                                      declineOrder: (){orderConfirmatiom(index, false);}
                                  ),
                                  Gap(10)
                                ],
                              ),
                            );
                          },
                      ),
                    ),
                    Gap(15)
                  ],
                )
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Icon(Icons.notifications, size: 30.h,),
          //       customText1("No notification yet", kBlack, 16.sp)
          //
          //     ],
          //   ),
          // ),
        ),
      ),
      isLoading: state is NotificationLoadingState
    );
  },
);
  }
  notificationBarOpenConditionList(){
    for(int i =0; i<=10; i++){
      isOpenList.add(true);
    }
  }

  Future<void> openOrder(index) async {

    dynamic response =
        await showCupertinoModalBottomSheet(
        topRadius:
        Radius.circular(0.r),
        backgroundColor: kWhite,
        context: context,
        builder: (context) {
          return
            Container(
              height:800.h,
              color: kWhite,
              child: ViewOrder(
                orderId: notificationList[index].orderId??"",
                isReceipt: false,),
            );
       });
    if (response[1] == "Order") {
      if (response[0]) {
        await orderConfirmatiom(
        index, response[0]);
      } else {
        await orderConfirmatiom(
        index, response[0]);
      }
    } else {
      await cancelOrder(
      index, response[0]);
    }
  }

  Future<void> cancelOrder(int index, bool response) async {
    bool res = await _controllerOrders
        .orderCancel(notificationList[index].orderId??"", response);
    if (res) {
       await _controllerOrders.userOrders(
          isRefresh: true,
          refreshController:
          refreshController2);
    } else {
      Get.snackbar(
        "Order Cancel",
        "Failed to cancel order",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> orderConfirmatiom(int index, bool response) async {
    bool res = await _controllerOrders
        .orderConfirmation(notificationList[index].orderId??"", response);
    if (res) {
       await _controllerOrders.userOrders(
          isRefresh: true,
          refreshController:
          refreshController2);
    } else {
      Get.snackbar(
        "Failed Operation",
        "Operation failed please try again later",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}



class NotificationText extends StatelessWidget {
  String body;
   NotificationText({required this.body,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              height: 200.h,
              width: 300.w,
              child: Center(
                  child: customText1(body, kBlackB800, 14.sp,maxLines: 200,
                  indent: TextAlign.center))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w,),
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kAppBlue,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
                child: customText1("Done", kWhite, 14.sp,
                    fontFamily: fontFamilyInter)
            ),
          ),
        ],
      ),
    );
  }
}

void showCustomDialog(BuildContext context, String title, String body) {
  showDialog(
    barrierDismissible: false,
    context: context,

    builder: (BuildContext context) {
      return Dialog(
        insetAnimationCurve: Curves.easeIn,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Container(
          height: 320.h, // Adjust the size as needed
          padding: EdgeInsets.all(16.0),
          child: Stack(
            // alignment: Alignment.topCenter,
              fit: StackFit.passthrough,
              children:[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //  gapHeight(20.h),
                    Align(
                        alignment: Alignment.center,
                        child: customText1(title, kBlack, 20.sp,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    Align(
                        alignment: Alignment.center,
                        child: Container(child:
                        customText1(body, kAppBlue, 15.sp,
                            indent:TextAlign.center, maxLines: 200)
                        )),
                    gapHeight(20.h),
                    GestureDetector(
                      onTap:  ()  {
                      Navigator.pop(context);
                     },
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                            color: kAppBlue,
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                                color: kAppBlue, width: 0.5.w)),
                        child: Center(
                          child: customText1(
                              "Done",kWhite, 16.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                )


              ]
          ),
        ),
      );
    },
  );
}


import 'dart:io';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
// import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/controller/orderController.dart';
import 'package:smerp_go/cubit/bankDetail/bank_details_cubit.dart';
import 'package:smerp_go/screens/bottomNav/screens/orders/allOrders.dart';
import 'package:smerp_go/screens/bottomNav/screens/profile/profileList.dart';
import 'package:smerp_go/screens/bottomNav/screens/sales/addNewSale.dart';
import 'package:smerp_go/screens/bottomNav/screens/sales/editSale.dart';
import 'package:smerp_go/screens/bottomNav/screens/sales/sales.dart';
import 'package:smerp_go/screens/bottomsheets/dashboardFilterOption.dart';
import 'package:smerp_go/screens/bottomsheets/newUpdate.dart';
import 'package:smerp_go/screens/bottomsheets/receipt.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/UserUtils.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';
import 'package:smerp_go/utils/mockdata/tempData.dart';

import '../../../controller/addSaleController.dart';
import '../../../controller/dashboardController.dart';
import '../../../main.dart';
import '../../../model/response/sales/saleList.dart';
import '../../../utils/app_services/helperClass.dart';
import '../../bottomsheets/deleteOption.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _controllerDashboard = Get.put(DashboardController());
  var _controller = Get.put(AddNewSaleController());
  var _controllerOrder = Get.put(OrderController());
  Color _startColor = Colors.red;
  Color _endColor = Colors.blue;
  bool _isStartColor = true;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
late BankDetailsCubit cubit;
  void _toggleColor() {
    setState(() {
      _isStartColor = !_isStartColor;
    });
  }

  @override
  void initState() {
    dashboardApi();
    newFeatureAvailable();
    if (!userBusinessName.isNull) {
      _controllerDashboard.storeName.value = userBusinessName.value;
    } else {
      _controllerDashboard.storeName.value = "Waaz";
    }
    setState(() {
      _controllerDashboard.saleList = saleListTemp;
    });

    super.initState();

    if (!isSalesListHasRun.value) {
      getSaleCall();
      dashboardApi();
    } else {
      setState(() {
        //   _controllerDashboard.saleList = saleListTemp;
     });
    }
  }
Future<void> newFeatureAvailable()async {
  if(Platform.isAndroid){
    bool response =await remoteConfig.getBool("newFeatureAdded");
    print("the response $response");
    if(response) {
     //  Get.bottomSheet(
     //      Container(
     //          height: 600.h,
     //          child: NewUpdate())
     // );
      showCupertinoModalBottomSheet(
          context: context,
          builder: (context){
            return Container(
              height: 700.h,
              child: NewUpdate(),
            );
          });
    }else if(!checkIfProfileDataIsCompleted()){
      Get.bottomSheet(
          Container(
              height: 600.h,
              child: FinishUserSetUp())
      );
    }
  }else if(Platform.isIOS){
    bool response =await remoteConfig.getBool("newFeatureAdded");
    print("the response ios $response");
    if(response){
      showCupertinoModalBottomSheet(
          context: context,
          builder: (context){
            return Container(
              height: 700.h,
              child: NewUpdate(),
            );
          });
    }else if(!checkIfProfileDataIsCompleted()){
      Get.bottomSheet(
          Container(
              height: 600.h,
              child: FinishUserSetUp())
     );
    }
  }
}
  void dashboardApi() async {
    _controllerDashboard.salesDashboard();
    _controllerDashboard.bankDetailDashboard().then((value) => storeBankDetail=value);
    _controllerOrder.userOrders();
    setState(() {
      //   _controllerDashboard.saleList = saleListTemp;
    });
  }

  var loading = false;
  bool obscurePassword = true;

  void getSaleCall() async {
    if (isSalesListHasRun.value == false) {
      // loading = true;
    }
    _controllerDashboard.saleList = await _controllerDashboard.allSaleList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //print("Icame herre");
      setState(() {
        if (_controllerDashboard.saleList.isNotEmpty) {
          //  loading = false;
        } else if (_controllerDashboard.saleList.isEmpty) {
          Future.delayed(Duration(seconds: 10), () {
            // loading = false;
          });
        }
      });
    });
    isSalesListHasRun.value = true;
  }

  @override
  Widget build(BuildContext context) {
    cubit=context.read<BankDetailsCubit>();
    return Obx(() {
      return overLay(
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: (saleIsEmpty.value)?kWhite: kLightPinkPin,
            appBar: PreferredSize(
                child: dashboardAppBarWidget(() {
                  Get.to(
                    Profile(),
                    duration: Duration(seconds: 1),
                    transition: Transition.cupertino,
                  );
                //  Intro.of(context).start();
                }, (userImage.value == "N/A") ? "N/A" : userImage.value, "",
                    context,),
                preferredSize: Size.fromHeight(80.h)),
            body: GestureDetector(
              onTap: () {
                //  Get.back();
                // Get.bottomSheet(
                //     Container(
               //         height: 600.h,
                //         child: NewUpdate())
                // );
              },
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Obx(() {
                  return Container(
                    height: 1000.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gapHeight(10.h),
                        Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 16.w),
                          child: customText1(
                            "${getTimeCategory()} $userFirstNameS👋 ",
                            kBlack,
                            20.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: fontFamily,
                          ),
                        ),
                        gapHeight(10.h),
                        Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 16.w),
                          child: customText1(
                              "Welcome to your store", kHashBlack50, 14.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        gapHeight(22.h),
                        Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 16.w),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
                              width: 398.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: kDashboardColorBlack3),
                                borderRadius: BorderRadius.circular(20.r),
                                color: kWhite,
                                // color: kGreen70
                              ),
                              height: 110.h,
                              child: Row(
                                children: [
                                  buildGestureDetector(),
                                 // gapWeight(25.w),

                                 // gapWeight(25.w),
                                  Spacer(),
                                 GestureDetector(
                                   onTap:() async {
                                     bool isEmpty;
                                     if(_controllerDashboard.orderCount.value==0){
                                       isEmpty= true;
                                     }else{
                                       isEmpty = false;
                                     }
                                     bool response=await  Get.to(AllOrders(isEmpty: isEmpty,),
                                       duration: Duration(seconds: 1),
                                       transition: Transition.cupertino,
                                     );
                                     if(response){
                                       onRefresh();
                                    }
                                     },
                                   child: Container(
                                     color: Colors.white,
                                     height: 80.h,
                                     width: 170.w,
                                     child: Obx(() {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // gapHeight(20.h),
                                            customText1(
                                                "Orders", kBlack, 16.sp,
                                                fontWeight: FontWeight.w300),
                                           // gapHeight(12.h),
                                            Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                customText1(
                                                    "${_controllerDashboard.orderCount.value} Pending ",
                                                    kBlack,
                                                    fontFamily: fontFamilyGraphilk,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    18.sp),
                                                GestureDetector(
                                                  onTap: () async {
                                                    bool isEmpty;
                                                    if(_controllerDashboard.orderCount.value==0){
                                                      isEmpty= true;
                                                    }else{
                                                      isEmpty = false;
                                                    }
                                                  bool response=await  Get.to(AllOrders(isEmpty: isEmpty,),
                                                      duration: Duration(seconds: 1),
                                                      transition: Transition.cupertino,
                                                    );
                                                  if(response){
                                                    onRefresh();
                                                  }
                                                  },
                                                  child: Image.asset("assets/export.png",
                                                    width: 18.w,
                                                    height: 18.h,
                                                    fit: BoxFit.contain,),
                                                )
                                              ],
                                            ),
                                          ],
                                        );
                                      }),
                                   ),
                                 ),
                                ],
                              ),
                          ),
                        ),
                        gapHeight(20.h),
                        Visibility(
                          visible: !saleIsEmpty.value,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.w, right: 16.w),
                            child: GestureDetector(
                              onTap: () {
                                print(DateTime.now());
                                Get.to(
                                  AddNewSale(),
                                  duration: Duration(seconds: 1),
                                  transition: Transition.cupertino,
                                );
                              },
                              child:
                              Container(
                                height: 50.h,
                                decoration: BoxDecoration(
                                    color: kLightPink,
                                    borderRadius: BorderRadius.circular(15.r),
                                    border: Border.all(
                                        color: kAppBlue, width: 0.5.w)),
                                child: Center(
                                  child: customText1(
                                      "Add new sale", kAppBlue, 16.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                        ),
                        gapHeight(20.h),
                        Obx(() {
                          if (saleIsEmpty.value) {
                            return emptyPart("sales",
                                image: "assets/salesNewEmpty.svg", () {
                              Get.to(
                               AddNewSale(),
                                duration: Duration(seconds: 1),
                                // curve: Curves.bounceIn,
                                transition: Transition.cupertino,
                              );
                            },
                                header: "Ready to sell?",
                                headerDetail:
                                    "Add your first product to start making sales and see \nrecords.");
                          }
                          else {
                            return Container(
                              color: kWhite,
                              child: Column(
                                children: [
                                  gapHeight(16.h),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.w, right: 16.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        customText1("Showing all Sales records",
                                            kBlackB600, 16.sp,
                                            fontWeight: FontWeight.w400),
                                        GestureDetector(
                                          onTap: () async {
                                            Get.bottomSheet(
                                              DashboardFilterOptions(),
                                            ).whenComplete(() {
                                             _controllerDashboard.dashboardFilter(_controllerDashboard.selectedFilterChoice.value);
                                              setState(() {
                                                _controllerDashboard.saleList = _controllerDashboard.saleList;
                                              });
                                              if (_controllerDashboard
                                                  .saleList.isEmpty) {
                                                setState(() {
                                                  _controllerDashboard
                                                      .saleList = saleListTemp;
                                                });
                                                Get.snackbar(
                                                  "Filter Result",
                                                  "Not found",
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                );
                                                setState(() {
                                                  //   _controllerDashboard.saleList=
                                                  //  saleListTemp;
                                                });
                                              } else {
                                                double totalAmount=0;
                                                for(var sales in _controllerDashboard.saleList){
                                                  totalAmount+=sales.salesAmount;
                                                }
                                                setState(() {
                                                  _controllerDashboard.saleList =_controllerDashboard.saleList;
                                                  _controllerDashboard.salesAmount.value= totalAmount.toString();
                                                });
                                              }
                                            });
                                            //   Get.bottomSheet(CustomCalendar(),
                                            //   backgroundColor:kWhite);
                                          },
                                          child: Container(
                                            width: 66.w,
                                            height: 34.h,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                customText1(
                                                    "Filter", kBlack, 16.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                Spacer(),
                                                SvgPicture.asset(
                                                    "assets/filter.svg",fit: BoxFit.scaleDown,)
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  gapHeight(30.h),
                                  Container(
                                    height: 400.h,
                                    child: SmartRefresher(
                                      controller: refreshController,
                                      enablePullDown: true,
                                      header: ClassicHeader(),
                                      onRefresh: onRefresh,
                                      child: ListView.builder(
                                          itemCount: (_controllerDashboard
                                                      .saleList.length >
                                                  10)
                                              ? 10
                                              : _controllerDashboard
                                                  .saleList.length,
                                          itemBuilder: (context, index) {
                                            List<SalesDatum> subsetList = [];
                                            if (_controllerDashboard.saleList.length > 10) {
                                              subsetList = _controllerDashboard.saleList.sublist(0, 10);
                                            } else {
                                              // print("iiiiiii");
                                              subsetList =
                                                  _controllerDashboard.saleList;
                                            }
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    _controllerDashboard
                                                        .isLoading.value;
                                                    showCupertinoModalBottomSheet(
                                                        backgroundColor: kWhite,
                                                        context: context,
                                                        builder: (context) {
                                                          return Container(
                                                              height: (_controllerDashboard.saleList[index].itemCount == 1) ? 500.h
                                                                  : _controllerDashboard.getReceiptHeight(_controllerDashboard.saleList[index].itemCount), color: kWhite,
                                                              child: ReceiptInApp(
                                                                saleId: subsetList[index].id,
                                                                date: subsetList[index].createdOn,
                                                                customerName: subsetList[index].customerName,
                                                                isOrder: false,
                                                                paymentStatus: subsetList[index].paymentStatus
                                                             )
                                                          );
                                                        }
                                                        );
                                                  },
                                                  child: salesMockData(
                                                    subsetList[index],
                                                    context,
                                                    deleteItem: () async {
                                                      int res = await Get
                                                          .bottomSheet(DeleteOption(title: "sale record", productName: subsetList[index].customerName));
                                                      if (res == 1) {
                                                        _controllerDashboard.isLoading.value = true;
                                                        bool resp = await _controller.deleteSaleRecord(subsetList[index].id, subsetList[index].id);
                                                        if (resp) {
                                                          _controllerDashboard.saleList = await _controllerDashboard.allSaleList(isRefresh: true, refreshController: refreshController);
                                                          setState(() {
                                                            _controllerDashboard
                                                                    .saleList =
                                                                _controllerDashboard
                                                                    .saleList;
                                                          });
                                                        } else {
                                                          setState(() {});
                                                        }
                                                        _controllerDashboard
                                                            .isLoading
                                                            .value = false;
                                                      }
                                                    },
                                                    editSale: () {
                                                      _controllerDashboard
                                                          .isLoading.value;
                                                      showCupertinoModalBottomSheet(
                                                          backgroundColor:
                                                              kWhite,
                                                          context: context,
                                                          builder: (context) {
                                                            return Container(
                                                                height: (subsetList[index].itemCount == 1) ? 450.h
                                                                    : _controllerDashboard.getEditHeight(subsetList[index].itemCount),
                                                                color: kWhite,
                                                                child: EditSale(
                                                                  information:
                                                                      subsetList[index],
                                                                ));
                                                          }).whenComplete(() {
                                                        print("Im done");
                                                        setState(() {
                                                          _controllerDashboard
                                                                  .saleList =
                                                              saleListTemp;
                                                        });
                                                      });
                                                    },
                                                  ),
                                                ),
                                                gapHeight(20.h)
                                              ],
                                            );
                                          }),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          isLoading: _controllerDashboard.isLoading.value);
    });
  }

  GestureDetector buildGestureDetector() {
    return GestureDetector(
                                  onTap: (){
                                    Get.to(
                                      Sales(),
                                      duration: Duration(
                                          seconds: 1),
                                      transition: Transition
                                          .cupertino,
                                    );
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    height: 80.h,
                                    width: 170.w,
                                    child: Obx(() {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          customText1("Total Sale", kBlack, 16.sp, fontWeight: FontWeight.w300),
                                        //  gapHeight(12.h),
                                         Spacer(),
                                          Row(
                                            children: [
                                              Container(
                                                // color: kRed70,
                                                width:150.w,
                                                child: customTextnaira(
                                                   (obscurePassword) ?
                                                NumberFormat.simpleCurrency(name: 'NGN').
                                                format(double.parse(_controllerDashboard.salesAmount.value)
                                                ).split(".")[0] :
                                                _controllerDashboard.astericValue,kBlack, 18.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fotFamily: fontFamilyGraphilk),
                                            ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                    Sales(),
                                                    duration: Duration(
                                                        seconds: 1),
                                                    transition: Transition
                                                        .cupertino,
                                                  );
                                                },
                                                child: Image.asset("assets/export.png",
                                                  width: 18.w,
                                                  height: 18.h,
                                                  fit: BoxFit.contain,),
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    }),
                                  ),
                                );
  }

  Future<void> onRefresh() async {
    _controllerDashboard.isSaleDashboardLoading.value = true;
    _controllerDashboard.salesDashboard(isRefresh: true);
    _controllerDashboard.saleList = await _controllerDashboard.allSaleList(
        isRefresh: true, refreshController: refreshController);
    _controllerDashboard.userOrders(isRefresh: true,refreshController: refreshController);
    _controllerDashboard.orderCount.value =orderListTemp.where((element) =>
    element.isAccepted=="Pending" ||element.isAccepted =="Accepted")
        .length;
    setState(() {
      _controllerDashboard.saleList = _controllerDashboard.saleList;
      _controllerDashboard.orderCount.value = _controllerDashboard.orderCount.value;
    });
  }
}

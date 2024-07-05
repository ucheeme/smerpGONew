import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/controller/inventoryController.dart';
import 'package:smerp_go/model/response/salesList.dart';
import 'package:smerp_go/screens/bottomNav/screens/sales/addNewSale.dart';

import '../../../../controller/addSaleController.dart';
import '../../../../controller/dashboardController.dart';
import '../../../../model/response/sales/saleList.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../../utils/app_services/helperClass.dart';
import '../../../../utils/mockdata/mockInventoryData.dart';
import '../../../../utils/mockdata/tempData.dart';
import '../../../bottomsheets/dashboardFilterOption.dart';
import '../../../bottomsheets/deleteOption.dart';
import '../../../bottomsheets/receipt.dart';
import 'editSale.dart';

class Sales extends StatefulWidget {
  const Sales({Key? key}) : super(key: key);

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  var _controllerDashboard = Get.put(DashboardController());
  var _controller = Get.put(AddNewSaleController());
  List<SalesDatum> saleList = [];
  var loading = false;

  RefreshController refreshController2 = RefreshController(
      initialRefresh: false);

  void getSaleCall() async {
    if (isSalesListHasRun.value == false) {
      loading = true;
    }
    saleList = await _controllerDashboard.allSaleList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //print("Icame herre");
      setState(() {
        if (saleList.isNotEmpty) {
          loading = false;
        } else if (saleList.isEmpty) {
          Future.delayed(Duration(seconds: 10), () {
            // loading = false;
          });
        }
      });
    });
    isSalesListHasRun.value = true;
  }

  @override
  void initState() {
    super.initState();
    if (!isSalesListHasRun.value) {
      getSaleCall();
    } else {
      saleList = saleListTemp;
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
                }, "Sales records",context: context),
                preferredSize: Size.fromHeight(80.h)),
            body: orderCheckWidget()
          ),
          isLoading: _controllerDashboard.isLoading.value
      );
    });
  }

  Widget orderCheckWidget(){
    if (saleIsEmpty.value) {
      return Center(
        child: emptyPart("sales",
            image: "assets/salesNewEmpty.svg", () {
              Get.to(
                AddNewSale(),
                duration: Duration(seconds: 1),
                // curve: Curves.bounceIn,
                transition: Transition.cupertino,
              );
            },
            header: "You have not made any sale yet!",
            headerDetail:
            "Click on the action button to make sales."),
      );
    }else{
      return SingleChildScrollView(
        child: Column(
          children: [
            gapHeight(12.h),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 16.h,horizontal: 16.w),
              child: customSearchDesign("Search your sale", (String value) {
                _controllerDashboard.filterByName(value);
                setState(() {
                  saleList = _controllerDashboard.saleList;
                });
              },
                inputType: TextInputType.text,),
            ),
            gapHeight(12.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  customText1(
                      "Showing all Sales records", kBlackB600, 16.sp,
                      fontWeight: FontWeight.w400),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(DashboardFilterOptions()).whenComplete((){
                        _controllerDashboard.dashboardFilter(
                            _controllerDashboard.selectedFilterChoice.value
                        );
                        setState(() {
                          saleList=
                              _controllerDashboard.saleList;
                        });
                        if(saleList.isEmpty){
                          setState(() {
                            saleList=
                                saleListTemp;
                          });
                          Get.snackbar("Filter Result",
                            "Not found",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,);
                          setState(() {
                            //   _controllerDashboard.saleList=
                            //  saleListTemp;
                          });
                        }else{
                          setState(() {
                            saleList= saleList;
                          });
                        }
                      }
                      );
                      //   Get.bottomSheet(CustomCalendar(),
                      //   backgroundColor:kWhite);
                    },
                    child: Container(
                      height: 20.h,
                      width: 64.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText1("Filter", kBlack, 16.sp,
                              fontWeight: FontWeight.w400,fontFamily: fontFamily),
                          SvgPicture.asset("assets/filter.svg")
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            gapHeight(18.h),
            SingleChildScrollView(
              child: Container(
                height: 700.h,
                child: SmartRefresher(
                  controller: refreshController2,
                  enablePullDown: true,
                  header: ClassicHeader(),
                  onRefresh: onRefresh,
                  child: ListView.builder(
                      itemCount: saleList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap:(){
                                _controllerDashboard.isLoading.value;
                                showCupertinoModalBottomSheet(
                                    backgroundColor: kWhite,
                                    context:context,
                                    builder: (context){
                                      return Container(
                                          height: (_controllerDashboard.saleList[index].itemCount == 1) ? 500.h
                                              : _controllerDashboard.getReceiptHeight(_controllerDashboard.saleList[index].itemCount), color: kWhite,
                                          child: ReceiptInApp(
                                            saleId:  saleList[index].id,
                                            date: saleList[index].createdOn,
                                          customerName:saleList[index].customerName, isOrder: false,
                                          paymentStatus: saleList[index].paymentStatus,
                                          )
                                      );
                                    }
                                );
                              },
                              child: salesMockData(saleList[index], context,
                                deleteItem: () async {
                                  int res = await Get.bottomSheet(
                                      DeleteOption(title: "sale record",
                                          productName: saleList[index].customerName)
                                  );
                                  if (res == 1) {
                                    _controllerDashboard
                                        .isLoading.value =
                                    true;
                                    bool resp = await _controller
                                        .
                                    deleteSaleRecord(
                                        saleList[index].id,
                                        saleList[index].id);
                                    if (resp) {
                                      _controllerDashboard
                                          .saleList =
                                      await _controllerDashboard
                                          .allSaleList(
                                          isRefresh: true,
                                          refreshController: refreshController);
                                      setState(() {
                                        _controllerDashboard
                                            .saleList =
                                            _controllerDashboard
                                                .saleList;
                                      });
                                    } else {
                                      setState(() {

                                      });
                                    }
                                    _controllerDashboard
                                        .isLoading.value =
                                    false;
                                  }
                                },
                                editSale: (){
                                  _controllerDashboard.isLoading.value;
                                  showCupertinoModalBottomSheet(
                                      backgroundColor: kWhite,
                                      context:context,
                                      builder: (context){
                                        return Container(
                                            height: (saleList[index].itemCount==1)?
                                            800.h:560.h,
                                            color: kWhite,
                                            child: EditSale(
                                              information: saleList[index],)
                                        );
                                      }
                                  ).whenComplete(() {
                                    setState(() {
                                      _controllerDashboard.saleList=
                                          _controllerDashboard.saleList;
                                    });
                                  }
                                  );
                                },
                              ),
                            ),
                            gapHeight(20.h)
                          ],
                        );
                      }),
                ),
              ),
            )
          ],
        ),
      );
    }
  }
  Future<void> onRefresh() async {
    saleList = await _controllerDashboard.allSaleList(isRefresh: true,
        refreshController: refreshController2);
    setState(() {
      saleList = saleList;
    });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../controller/dashboardController.dart';
import '../../../../controller/inventoryController.dart';
import '../../../../model/response/inventoryList.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/UserUtils.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../../utils/mockdata/tempData.dart';
import '../../../../utils/newReceipt.dart';
import '../profile/profileList.dart';
import 'addNewProduct.dart';
import 'allIProductd.dart';
import 'editProduct.dart';

class InventoryMain extends StatefulWidget {
  const InventoryMain({super.key});

  @override
  State<InventoryMain> createState() => _InventoryMainState();
}

class _InventoryMainState extends State<InventoryMain> {
  var _controller = TextEditingController();

  var _controllerDashboard = Get.put(DashboardController());
  var _controllerInventory = Get.put(InventoryController());

  List<InventoryInfo> inventoryList = [];
  var loading = false;

  RefreshController refreshController = RefreshController(
      initialRefresh: false);
  bool obscurePassword = true;
  void getInventoryCall() async {
    if (isInventoryListHasRun == false) {
      loading = true;
    }
    _controllerInventory.inventoryList = await _controllerInventory.allInventorylist();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //print("Icame herre");
      setState(() {
        if (_controllerInventory.inventoryList.isNotEmpty) {
          loading = false;
        } else if (_controllerInventory.inventoryList.isEmpty) {
          Future.delayed(Duration(seconds: 10), () {
            loading = false;
          });
        }
      });
    });
    isInventoryListHasRun = true;
    double temp = 0;
    int tempQuantity = 0;
    // for(var element in  _controllerInventory.inventoryList){
    //   temp =temp+( element.quantity *element.sellingPrice);
    //   tempQuantity = tempQuantity+element.quantity;
    // }
    // setState(() {
    //   _controllerInventory.inventoryAmount.value=temp.toString();
    //   _controllerInventory.inventoryCount.value=tempQuantity.toString();
    // });

  }
  void inventoryReCall() async{
    _controllerInventory.inventoryList = await _controllerInventory.allInventorylist(
        isRefresh: true
    );
  }
  void dashboardApi() async {
    _controllerInventory.inventoryDashboard();
    setState(() {
      _controllerInventory.inventoryAmount.value=
          _controllerInventory.inventoryAmount.value;
      _controllerInventory.inventoryCount.value=
          _controllerInventory.inventoryCount.value;
    });
  }

  // void inventoryApi() async {
  //   _controllerInventory.inventoryCountCall();
  // }

  @override
  void initState() {
    // _bankChoose = mockProductData[0];
    dashboardApi();
    // (isInventoryListHasRun)? inventoryReCall():null;
    super.initState();
    if (!isInventoryListHasRun) {
      getInventoryCall();
      //inventoryApi();
    } else {
      inventoryReCall();
      _controllerInventory.inventoryList = inventoryListTemp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return overLay(
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor:kWhite ,
            body: Obx(() {
              return SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                 Gap(10),
                    Container(
                        width: 398.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                              color: kDashboardColorBlack3
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          color: kDashboardColorBlack3,

                        ),
                        height: 110.h,
                        child: Row(
                          children: [
                            gapWeight(25.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  width: 144.w,
                                  height: 105.h,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      customText1(
                                          "Inventory count", kBlack, 16.sp,
                                          fontWeight: FontWeight.w300),
                                      Spacer(),
                                      customText1(
                                          _controllerInventory.inventoryCount
                                              .value, kBlack,
                                          20.sp, fontWeight: FontWeight.w500,
                                          fontFamily: fontFamily)
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  width: 144.w,
                                  height: 105.h,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      customText1(
                                          "Inventory value", kBlack, 16.sp,
                                          fontWeight: FontWeight.w300),
                                      Spacer(),
                                      Container(
                                        // color: kRed70,
                                        width:150.w,
                                        child: customTextnaira((obscurePassword) ? NumberFormat.simpleCurrency(
                                            name: 'NGN')
                                            .format(
                                            double.parse(
                                                _controllerInventory.
                                                inventoryAmount.value)):
                                        _controllerInventory.astericValue
                                            ,kBlack,18.sp, fontWeight: FontWeight.w500,
                                            fotFamily: fontFamily),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                // gapHeight(20.h),
                                IconButton(
                                  constraints: BoxConstraints.tight(Size(40.11.w,
                                      50.8.h)),
                                  iconSize: 16.11,
                                  padding: EdgeInsets.only(left: 4.w),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon:Icon(obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                    fill: 0.2,) ,

                                ),
                              ],
                            )
                            // gapWeight(22.w)
                          ],
                        )),
                    Obx(() {
                      if (_controllerInventory.inventoryCount.value=="0") {
                        return emptyPart("inventory",
                            image: "assets/emptyInventory.svg",
                                () {
                              Get.to(AddNewProduct(),
                                  duration: Duration(seconds: 1),
                                  // curve: Curves.bounceIn,
                                  transition: Transition.cupertino
                              );
                            },
                            headerDetail: "Add products to view and manage inventory",
                            header: "No products yet"
                        );
                      }
                      else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gapHeight(17.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [

                                GestureDetector(
                                  onTap: () {
                                    Get.to(AllProducts(),
                                        duration: Duration(seconds: 1),
                                        //curve: Curves.bounceIn,
                                        transition: Transition.cupertino
                                    );
                                  },
                                  child: Container(
                                    height: 50.h,
                                    width: 189.w,
                                    decoration: BoxDecoration(
                                        color: kDashboardColorBorder,
                                        borderRadius: BorderRadius.circular(
                                            15.r),
                                        border: Border.all(
                                            color: kAppBlue,
                                            width: 0.5.w
                                        )
                                    ),
                                    child: Center(
                                      child: customText1(
                                          "Inventory records", kAppBlue,
                                          16.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(AddNewProduct(),
                                        duration: Duration(seconds: 1),
                                        // curve: Curves.bounceIn,
                                        transition: Transition.cupertino
                                    );
                                  },
                                  child: Container(
                                    height: 50.h,
                                    width: 189.w,
                                    decoration: BoxDecoration(
                                      color: kAppBlue,
                                      borderRadius: BorderRadius.circular(
                                          15.r),
                                    ),
                                    child: Center(
                                      child: customText1("Add new product",
                                          kDashboardColorBorder, 16.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            gapHeight(30.h),
                            customSearchDesign(
                              "Search inventory", (String value) {
                              _controllerInventory.filterByName(value);
                              setState(() {
                                _controllerInventory.inventoryList =
                                    _controllerInventory.inventoryList;
                              });
                            },
                              inputType: TextInputType.text,),
                            gapHeight(42.h),
                            customText1(
                                "Showing 10 records",
                                kBlackB600,
                                16.sp,
                                fontWeight: FontWeight.w400),
                            gapHeight(20.h),
                            Container(
                               height:320.h,
                              child: SmartRefresher(
                                controller: refreshController,
                                enablePullDown: true,
                                header: ClassicHeader(),
                                onRefresh: onRefresh,
                                child: ListView.builder(
                                  shrinkWrap:true,
                                    itemCount: (_controllerInventory.inventoryList.length > 10)
                                        ? 10
                                        : _controllerInventory.inventoryList.length,
                                    itemBuilder: (context, index) {
                                      //  print(inventoryList[index].productImage);
                                      List<InventoryInfo> subsetList = [];
                                      if (_controllerInventory.inventoryList.length > 10) {
                                        subsetList =
                                            _controllerInventory.inventoryList.sublist(0, 10);
                                      } else {
                                        // print("iiiiiii");
                                        subsetList = _controllerInventory.inventoryList;
                                      }
                                      return Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                _controllerInventory.inventoryDetail(subsetList[index].id);
                                              },
                                              child: inventoryMockDataDesign(
                                                subsetList[index],
                                                editProduct:  () {
                                                  Get.to(
                                                      EditProduct(
                                                        information: subsetList[index],
                                                      ),
                                                      duration: Duration(seconds: 1),
                                                      transition: Transition.cupertino)
                                                      ?.whenComplete((){
                                                    setState(() {
                                                      _controllerInventory.inventoryList = inventoryListTemp;
                                                    });
                                                  });
                                                },)
                                          ),
                                          gapHeight(20.h)
                                        ],
                                      );
                                    }),
                              ),
                            )

                          ],
                        );
                      }
                    }),
                  ],
                ),
              );
            }),
          ),
          isLoading: _controllerInventory.isLoading.value
      );
    });
  }

  Future<void> onRefresh() async {
    _controllerInventory.inventoryList =
    await _controllerInventory.allInventorylist(isRefresh: true,
        refreshController: refreshController);
    // _controllerInventory.inventoryCountCall(isRefresh: true,
    // );
    dashboardApi();
    setState(() {
      _controllerInventory.inventoryList = _controllerInventory.inventoryList;
      //_controllerInventory.inventoryAmount.value=temp.toString();
    });

    //   double temp = 0;
    //   int tempQuantity = 0;
    //   for(var element in  _controllerInventory.inventoryList){
    //     temp = temp+(element.quantity *element.sellingPrice);
    //     tempQuantity = tempQuantity+element.quantity;
    //   }
    //   setState(() {
    //     _controllerInventory.inventoryAmount.value=temp.toString();
    //     _controllerInventory.inventoryCount.value=tempQuantity.toString();
    //   });
  }
}

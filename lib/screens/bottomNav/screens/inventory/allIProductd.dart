import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/viewProduct.dart';

import '../../../../controller/inventoryController.dart';
import '../../../../model/response/inventoryList.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../../utils/mockdata/mockInventoryData.dart';
import '../../../../utils/mockdata/tempData.dart';
import '../../../bottomsheets/dashboardFilterOption.dart';
import 'editProduct.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({Key? key}) : super(key: key);

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  final _controllerInventory = Get.put(InventoryController());
  List<InventoryInfo> inventoryList = [];
  var loading = false;

  RefreshController refreshController = RefreshController(
      initialRefresh: false);

  void getInventoryCall() async {
    if (isInventoryListHasRun == false) {
      loading = true;
    }
    inventoryList = await _controllerInventory.allInventorylist();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //print("Icame herre");
      setState(() {
        if (inventoryList.isNotEmpty) {
          loading = false;
        } else if (inventoryList.isEmpty) {
          Future.delayed(Duration(seconds: 10), () {
            loading = false;
          });
        }
      });
    });
    isInventoryListHasRun = true;
  }
  RefreshController refreshController2 = RefreshController(initialRefresh: false);

  @override
  void initState() {
    // _bankChoose = mockProductData[0];
    super.initState();
    if (!isInventoryListHasRun) {
      getInventoryCall();
    } else {
      inventoryList = inventoryListTemp;
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
              }, "Inventory records",context: context),
              preferredSize: Size.fromHeight(80.h)),
          body: SingleChildScrollView(
            child: Column(
              children: [
                gapHeight(12.h),
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: 16.h,horizontal: 16.w),
                  child: customSearchDesign("Search your product", (String value) {
                    _controllerInventory.filterByName(value);
                    setState(() {
                      inventoryList = _controllerInventory.inventoryList;
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
                          "Showing all inventory records", kBlackB600, 16.sp,
                          fontWeight: FontWeight.w400),
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.bottomSheet(DashboardFilterOptions());
                      //     //   Get.bottomSheet(CustomCalendar(),
                      //     //   backgroundColor:kWhite);
                      //   },
                      //   child: Container(
                      //     height: 20.h,
                      //     width: 64.w,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         customText1("Filter", kBlack, 16.sp,
                      //             fontWeight: FontWeight.w400),
                      //         SvgPicture.asset("assets/filter.svg")
                      //       ],
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                gapHeight(18.h),
                SingleChildScrollView(
                  child: Container(
                    height: 600.h,
                    child: SmartRefresher(
                      controller:refreshController2 ,
                      enablePullDown: true,
                      header: ClassicHeader(),
                      onRefresh: onRefresh,
                      child: ListView.builder(
                          itemCount: inventoryList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _controllerInventory.inventoryDetail(
                                        inventoryList[index].id
                                    );
                                  },
                                  child: inventoryMockDataDesign(
                                     inventoryList[index],
                                    editProduct:  () {
                                      Get.to(
                                          EditProduct(
                                            information: inventoryList[index],
                                          ),
                                          duration: Duration(seconds: 1),
                                          transition: Transition.cupertino)
                                          ?.whenComplete((){
                                        setState(() {
                                          _controllerInventory.inventoryList =
                                              _controllerInventory.inventoryList;
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
                  ),
                )
              ],
            ),
          ),
        ),
        isLoading: _controllerInventory.isLoading.value
      );
    });
  }

  Future<void> onRefresh() async {
    inventoryList = await _controllerInventory.allInventorylist(isRefresh: true);
    setState(() {
      inventoryList = inventoryList;
    });
  }
}

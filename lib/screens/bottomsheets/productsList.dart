import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/addNewProduct.dart';
import 'package:smerp_go/utils/mockdata/mockProductsData.dart';

import '../../controller/inventoryController.dart';
import '../../model/response/inventoryList.dart';
import '../../utils/AppUtils.dart';
import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';
import '../../utils/app_services/helperClass.dart';
import '../../utils/mockdata/tempData.dart';

class AllProduct extends StatefulWidget {
  const AllProduct({Key? key}) : super(key: key);

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  final _controllerInventory = Get.put(InventoryController());
  List<InventoryInfo> inventoryList =[];
  var loading =false;

  void getInventoryCall() async {
    if(isInventoryListHasRun==false){
      loading= true;
    }
    inventoryList = await _controllerInventory.allInventorylist(isRefresh: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //print("Icame herre");

        if (inventoryList.isNotEmpty) {
          setState(() {
            loading = false;
          });

        } else if (inventoryList.isEmpty) {
         // Future.delayed(Duration(seconds: 10), () {
            setState(() {
              loading = false;
            });
         // });
        }
    });
    isInventoryListHasRun= true;
  }



  @override
  void initState() {
    // _bankChoose = mockProductData[0];
    super.initState();
    if(!isInventoryListHasRun){
      getInventoryCall();
    }else{
      inventoryList = inventoryListTemp;
   }
  }
  RefreshController refreshController2 = RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 420.h,
      color: kWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: kLightPink,
            height: 53.h,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:  EdgeInsets.only(left: 8.w),
                child: customText1("Select product", kBlack, 18.sp,
                  fontWeight: FontWeight.w500,fontFamily: fontFamily
                ),
              ),
            ),
          ),
          gapHeight(20.h),
          (loading)?
          Center(
            child: Container(
              height: 30.h,
              width: 30.w,
              child: CircularProgressIndicator(
                color: kAppBlue,

              ),
            ),
          ):
          (inventoryList.isEmpty)?
              Container(
                height: 200.h,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customText1("You do not have any product at the moment",
                        kBlack, 16.sp),
                    gapHeight(30.h),
                    GestureDetector(
                      onTap: (){
                        Get.back();
                        Get.to(
                          AddNewProduct(),
                          duration: Duration(seconds: 2),
                          transition: Transition.cupertino
                        );
                      },
                      child: dynamicContainer(
                      Center(
                          child: customText1("Add new product", kWhite, 14.sp)), kAppBlue,
                      60.h),
                    )
                  ],
                ),
              ):
          Container(
            width: double.infinity,
            height: 304.h,
            child: Padding(
                padding: EdgeInsets.only(left: 20.h),
                child:SmartRefresher(
                  controller:refreshController2 ,
                  enablePullDown: true,
                  header: ClassicHeader(),

                  onRefresh: onRefresh,
                  child: ListView.builder(
                      itemCount: inventoryList.length,
                      itemBuilder: (context, index){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap:(){
                                Get.back(result: inventoryList[index]);
                        },
                              child: Container(
                                height:100.h,
                                color: kWhite,
                                width:double.infinity,
                                child:  Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left:15.w,),
                                      height: 40.h,
                                      width: 40.w,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(image: getImageNetwork(
                                              (inventoryList[index].productImage==null)?
                                              "":
                                              inventoryList[index].productImage
                                          ).image,
                                              fit: BoxFit.fill),
                                          shape: BoxShape.circle
                                      ),
                                    ),
                                    gapWeight(10.w),
                                    Container(
                                      width: 340.w,
                                      height: 50.h,

                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children:[
                                            Container(
                                              width: 200.w,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.only(left: 8.w,right: 8.h),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        customText1((inventoryList[index].productName.length>10)?
                                                            inventoryList[index].productName.replaceRange(10,
                                                                inventoryList[index].productName.length, "..."):
                                                            inventoryList[index].productName, kBlackB800, 18.sp,
                                                            fontWeight: FontWeight.w500),

                                                      ],
                                                    ),
                                                  ),
                                            Spacer(),
                                                  Padding(
                                                    padding:  EdgeInsets.only(left: 8.w,right: 8.w),
                                                    child: Container(
                                                      //  width: double.infinity,
                                                      child:
                                                      Row(
                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              customText1(inventoryList[index].quantity.toString(),
                                                                  kBlackB600, 13.sp,
                                                                  fontWeight: FontWeight.w400),
                                                              gapWeight(4.w),

                                                              customText1(
                                                                  inventoryList[index].productCategory.toString()
                                                                  , kBlackB600, 13.sp,
                                                                  fontWeight: FontWeight.w400),
                                                              gapWeight(4.w),
                                                              customText1(
                                                                  "in stock"
                                                                  , kBlackB600, 13.sp,
                                                                  fontWeight: FontWeight.w400),
                                                            ],
                                                         ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 90.w,
                                              child: customTextnaira(
                                                  NumberFormat.simpleCurrency(name: 'NGN'
                                                  ).format(
                                                      double.parse(
                                                          (inventoryList[index].sellingPrice)
                                                              .toString()
                                                      )).split(".")[0],
                                                  kAppBlue,
                                                  18.sp,fontWeight: FontWeight.w400),
                                            )
                                          ]
                                      ),
                                    )

                                  ],
                                ),
                              ),
                            ),
                           // gapHeight(20.h)
                          ],
                        );
                      }),
                )
            ),
          ),

        ],
      ),
    );
  }
  Future<void> onRefresh() async {
    // isLoading.value = true;
    //isProductCategoryHasRun.value=false;
    // getProduCateCall();
    inventoryList = await _controllerInventory.allInventorylist(isRefresh: true);
    setState(() {
      inventoryList = inventoryList;
    });
  }

}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/controller/addSaleController.dart';

import '../../controller/addNewProduct.dart';
import '../../model/response/productCategory.dart';
import '../../utils/AppUtils.dart';
import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';
import '../../utils/app_services/helperClass.dart';
import '../../utils/mockdata/tempData.dart';

class UnitOfMeasurement extends StatefulWidget {
  const UnitOfMeasurement({Key? key}) : super(key: key);

  @override
  State<UnitOfMeasurement> createState() => _UnitOfMeasurementState();
}

class _UnitOfMeasurementState extends State<UnitOfMeasurement> {
  var _controller = Get.put(AddNewProductController());

  List<DefaultProductCategory> prodCategory = [];

  RefreshController refreshController = RefreshController(initialRefresh: false);

  var loading = false;
  void getProduCateCall() async {
    if(isProductUnitCategoryHasRun.value==false){
      loading= true;
    }
    prodCategory = await _controller.allProductUnitCategoryList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //print("Icame herre");

        if (prodCategory.isNotEmpty) {
          setState(() {
            loading = false;
          });
        } else if (prodCategory.isEmpty) {
         // Future.delayed(Duration(seconds: 10), () {
          //  loadi ng = false;
            setState(() {
              loading= false;
          //  });
          });
       }
    });
    isProductUnitCategoryHasRun.value= true;
  }

  @override
  void initState() {
    super.initState();
    if(!isProductUnitCategoryHasRun.value){
      getProduCateCall();
    }else{
      prodCategory =productUnitCategoryList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420.h,
      color: kWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: kLightPink,
            height: 73.h,
            child: Padding(
              padding:  EdgeInsets.only(top: 30.h,bottom: 20.h,left: 20.w,right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText1("Select unit", kBlack, 18.sp,
                      fontWeight: FontWeight.w500,fontFamily: fontFamily
                  ),
                  GestureDetector(
                      onTap: ()async{
                        bool response = await Get.bottomSheet(
                          // isDismissible:false,
                            CreateCustomUnitOfMeasurement());
                        if(response){
                          getProduCateCall();
                        }else{
                          print("failed");
                        }
                      },
                      child: Icon(Icons.add_circle))
                ],
              ),
            ),
          ),
          gapHeight(20.h),
          Visibility(
            visible: loading,
            child: Center(
              child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 3.0),
            ),
          ),
          Visibility(
            visible: !loading,
            child: Container(
              width: double.infinity,
              height: 304.h,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child:SmartRefresher(
                    controller:refreshController ,
                    enablePullDown: true,
                    header: ClassicHeader(),

                    onRefresh: onRefresh,
                    child: ListView.builder(
                        itemCount: prodCategory.length,
                        itemBuilder: (context, index){
                          // print(prodCategory.length);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap:(){
                                  Get.back(result: [prodCategory[index].name,
                                    prodCategory[index].id,]);
                                },
                                child: Container(
                                  height:54.h,
                                  width:double.infinity,
                                  child: customText1(prodCategory[index].name,
                                    kBlackB800, 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              gapHeight(20.h)
                            ],
                          );
                        }),
                  )
              ),
            ),
          ),

        ],
      ),
    );
  }
  Future<void> onRefresh() async {
    prodCategory = await _controller.allProductUnitCategoryList(isRefresh: true,
    refreshController: refreshController);
    setState(() {
      prodCategory = prodCategory;
    });
  }
}

class CreateCustomUnitOfMeasurement extends StatefulWidget {
  const CreateCustomUnitOfMeasurement({super.key});

  @override
  State<CreateCustomUnitOfMeasurement> createState() => _CreateCustomUnitOfMeasurementState();
}

class _CreateCustomUnitOfMeasurementState extends State<CreateCustomUnitOfMeasurement> {
  var _controller = Get.put(AddNewProductController());
  var categoryLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420.h,
      color: kWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Container(
            width: double.infinity,
            color: kLightPink,
            height: 73.h,
            child: Padding(
              padding:  EdgeInsets.only(top: 30.h,bottom: 20.h,left: 20.w,),
              child: customText1("Create New  Unit of Measurement", kBlack, 18.sp,
                  fontWeight: FontWeight.w500,fontFamily: fontFamily
              ),
            ),
          ),
          gapHeight(20.h),
          Visibility(
            visible: categoryLoading,
            child: Center(
              child: CircularProgressIndicator(
                  color: kAppBlue,
                  strokeWidth: 3.0),
            ),
          ),
          gapHeight(15.h),
          Container(
            height: 60.h,
            child: titleSignUp(_controller.unitName,
                textInput: TextInputType.text,
                hintText: "Enter unit name"),
          ),
          gapHeight(35.h),
          Container(
            height: 60.h,
            child: titleSignUp(_controller.unitDescription,
                textInput: TextInputType.text,
                hintText: "Unit description"),
          ),
          gapHeight(35.h),
          GestureDetector(
            onTap: () async {
              setState(() {
                categoryLoading= true;
              });
              bool response = await _controller.createProductUnitCategory();
              // bool response = true;
              if(response){
                setState(() {
                  categoryLoading= false;
                });
                _controller.unitDescription.clear();
                _controller.unitName.clear();
                Get.back(result: true);
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 15.w,right: 15.w),
              height: 60.h,
              width: double.infinity,
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
    );
  }
}

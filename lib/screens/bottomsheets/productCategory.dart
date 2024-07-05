import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/controller/productController.dart';
import 'package:smerp_go/utils/AppUtils.dart';

import '../../controller/addNewProduct.dart';
import '../../controller/addSaleController.dart';
import '../../model/response/productCategory.dart';
import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';
import '../../utils/app_services/helperClass.dart';
import '../../utils/mockdata/tempData.dart';

class ProductCategory extends StatefulWidget {
  const ProductCategory({Key? key}) : super(key: key);

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  var _controller = Get.put(AddNewSaleController());
  List<DefaultProductCategory> prodCategory = [];



  var loading = false;
  void getProduCateCall() async {
    if(isProductCategoryHasRun.value==false){
        loading= true;
    }
    prodCategory = await _controller.allProductCategoryList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //print("Icame herre");

        if (prodCategory.isNotEmpty) {
          setState(() {
           loading = false;
          });
        } else if (prodCategory.isEmpty) {
             setState(() {
               loading = false;
             });
        }
    });
    isProductCategoryHasRun.value= true;
  }

  @override
  void initState() {
    super.initState();
    if(!isProductCategoryHasRun.value){
      getProduCateCall();
    }else{
      prodCategory =productCategoryList;
    }
  }
  RefreshController refreshController2 = RefreshController(initialRefresh: false);
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
                  customText1("Select product category", kBlack, 18.sp,
                    fontWeight: FontWeight.w500,fontFamily: fontFamily
                  ),
                  GestureDetector(
                      onTap: ()async{
                        bool response = await Get.bottomSheet(
                         // isDismissible:false,
                            CreateCustomProductCategory());
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
                    controller:refreshController2 ,
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
                                  width: double.infinity,
                                  color: kWhite,
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


    prodCategory = await _controller.allProductCategoryList(isRefresh: true,
    refreshController: refreshController);
    setState(() {
      prodCategory = prodCategory;
    });
  }
  
}


class CreateCustomProductCategory extends StatefulWidget {
  const CreateCustomProductCategory({super.key});

  @override
  State<CreateCustomProductCategory> createState() => _CreateCustomProductCategoryState();
}

class _CreateCustomProductCategoryState extends State<CreateCustomProductCategory> {
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
              child: customText1("Create New Product Category", kBlack, 18.sp,
                  fontWeight: FontWeight.w500,fontFamily: fontFamily
              ),
            ),
          ),
          gapHeight(20.h),
          Visibility(
            visible: categoryLoading,
            child: Center(
              child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 3.0),
            ),
          ),
          gapHeight(15.h),
          Container(
            height: 60.h,
            child: titleSignUp(_controller.categoryName,
                textInput: TextInputType.text,
                hintText: "Enter category name"),
          ),
          gapHeight(35.h),
          Container(
            height: 60.h,
            child: titleSignUp(_controller.categoryDescription,
                textInput: TextInputType.text,
                hintText: "Category description"),
          ),
          gapHeight(35.h),
          GestureDetector(
            onTap: () async {
              setState(() {
                categoryLoading= true;
              });
              bool response = await _controller.createProductCategory();
             // bool response = true;
              if(response){
                setState(() {
                  categoryLoading= false;
                });
                _controller.categoryDescription.clear();
                _controller.categoryName.clear();
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

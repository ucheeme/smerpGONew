import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:smerp_go/controller/inventoryController.dart';
import 'package:smerp_go/controller/productController.dart';

import '../../../../controller/addNewProduct.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../../utils/mockdata/tempData.dart';
import '../../../bottomsheets/camera.dart';
import '../../../bottomsheets/productCategory.dart';
import '../../../bottomsheets/unitofmeasurement.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({Key? key}) : super(key: key);

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  var _controller = Get.put(AddNewProductController());
  var _controllerI = Get.put(InventoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return OverlayLoaderWithAppIcon(
       isLoading: _controller.isLoading.value,
        overlayBackgroundColor: kBlackB600,
        circularProgressColor: kAppBlue,
        appIconSize: 40.h,
        appIcon: SizedBox(),
        child: GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                  child: defaultDashboardAppBarWidget(() {
                    Get.back();
                  }, "Add new product",context: context),
                  preferredSize: Size.fromHeight(80.h)),
              body: SingleChildScrollView(

                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Container(
                    height: 1100.h,
                    child: Column(
                      children: [
                        gapHeight(20.h),
                        Container(
                          height: 60.h,
                          child: titleSignUp(_controller.productName,
                              textInput: TextInputType.text,
                              hintText: "Enter product name"),
                        ),
                        gapHeight(35.h),
                        GestureDetector(
                          onTap: () async {
                           var response = await Get.bottomSheet(
                                CameraOption()
                            );
                            if (response != null) {
                              setState(() {
                                //  var paymentStatus =response;
                                _controller.productImageFile = response[0];
                                _controller.productImage.value = response[1];
                              });
                            }
                          },
                          child: textFieldBorderWidget(
                              Container(
                                padding: EdgeInsets.all(20.0),
                                height: 222.h,
                                width: 368.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    image: (_controller.productImageFile.path=="")?
                                    DecorationImage(image: Image.asset("assets/addImage.png").image,
                                        fit: BoxFit.contain):
                                    DecorationImage(image: displayImage(
                                        _controller.productImageFile).image,
                                        fit: BoxFit.contain)
                                ),

                              ), "Product image"),
                        ),
                        gapHeight(35.h),
                        GestureDetector(
                          onTap: () async {
                            var response = await Get.bottomSheet(
                                ProductCategory()
                            );
                            if (response != null) {
                              setState(() {
                                //  var paymentStatus =response;
                                _controller.productCategory.value = response[0];
                                _controller.productCategoryId = response[1];
                              });
                            }
                          },
                          child: Container(
                            //height: 60.h,
                           child: textFieldBorderWidget2(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    customText1(_controller.productCategory.value,
                                        kBlack, 16.sp),
                                    const Icon(Icons.keyboard_arrow_down)
                                  ],
                                ), "Product category"),
                          ),
                        ),
                        gapHeight(35.h),
                        Container(
                          height: 60.h,
                          child: textFieldAmount(_controller.productCostPrice,
                              textInput: TextInputType.number,
                              hintText: "Product cost price"),
                        ),
                        gapHeight(35.h),
                        Container(
                          height: 60.h,
                          child: textFieldAmount(_controller.productSellingPrice,
                              textInput: TextInputType.number,
                              hintText: "Product selling price"),
                        ),
                        gapHeight(35.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            titleSignUp2(_controller.productQuantity,
                                textInput: TextInputType.number,
                                hintText: "Enter quantity",
                              height: 60.h,
                              width: 192.w,),
                            GestureDetector(
                              onTap: () async {
                                var response = await Get.bottomSheet(
                                    UnitOfMeasurement()
                                );
                                if (response != null) {
                                  setState(() {
                                    //  var paymentStatus =response;
                                    _controller.productUnit.value = response[0];
                                    _controller.productUnitCategoryId =
                                    response[1];
                                  });
                                }
                              },
                              child: Container(
                                height: 60.h,
                                width: 192.w,
                                child: textFieldBorderWidget2(
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                         .spaceBetween,
                                      children: [
                                        customText1(_controller.productUnit.value,
                                            kHashBlack50, 16.sp),
                                        const Icon(Icons.keyboard_arrow_down)
                                      ],
                                    ), "Enter unit"),
                              ),
                            )
                          ],
                        ),
                        gapHeight(35.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 60.h,
                                width: 192.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    color: kLightPink,
                                    border: Border.all(
                                        color: kAppBlue
                                    )
                                ),
                                child: Center(child: customText1(
                                    "Discard", kAppBlue, 18.sp)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await executeCreateProduct(context);
                              },
                              child: Container(
                                height: 60.h,
                                width: 192.w,
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
                      ],
                    ),
                  ),
                ),
              )
          ),
        ),
      );
    });
  }

  Future<void> executeCreateProduct(BuildContext context) async {
       print(_controller.productCostPrice.text);
    if(_controller.productCostPrice.text.isEmpty||
        _controller.productSellingPrice.text.isEmpty||
    _controller.productQuantity.text.isEmpty||
        _controller.productUnitCategoryId ==0||_controller.productCategoryId==0){
      Get.snackbar("Invalid input format ",
        "No field should be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,);
    }else{
      int quantity;
      double costPrice;
      double sellingPrice;

      quantity =
          int.parse(_controller.productQuantity.text);
      costPrice =
        _controller.getAmountAsNumber(_controller.productCostPrice);
      sellingPrice = _controller.getAmountAsNumber(_controller.productSellingPrice);
      if(quantity.isNegative||costPrice.isNegative||sellingPrice.isNegative){
        Get.snackbar("Invalid input format ",
          "You should not use negative values",
          backgroundColor: Colors.red,
          colorText: Colors.white,);
      }else{
        var res= await _controller.productCreate(
            quantity,
            _controller.productCategoryId,
            _controller.productUnitCategoryId,
            _controller.productName.text,
            _controller.productImage.value,
            costPrice,
            sellingPrice);
        if(res){

          _controllerI.inventoryList = await _controllerI.allInventorylist();
          // _controllerI.inventoryCountCall();

          Navigator.pop(context);
      }

    }


                                  }
  }
}

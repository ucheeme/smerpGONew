import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:smerp_go/model/response/inventoryDetail.dart';

import '../../../../controller/inventoryController.dart';
import '../../../../controller/productController.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../bottomsheets/camera.dart';
import '../../../bottomsheets/productCategory.dart';
import '../../../bottomsheets/unitofmeasurement.dart';

class ViewProduct extends StatefulWidget {
  InventoryInformation? information;

  ViewProduct({Key? key, required this.information}) : super(key: key);

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  //var _controller = Get.put(InventoryController());
  InventoryInformation? information;

  @override
  void initState() {
    super.initState();
    //getInventoryInformation();
  }

  void getInventoryInformation() async {
   // await _controller.inventoryDetail();
  }

  @override
  Widget build(BuildContext context) {
    return
         Scaffold(
            appBar: PreferredSize(
                child: defaultDashboardAppBarWidget(() {
                  Get.back();
               }, "View product",context: context),
                preferredSize: Size.fromHeight(80.h)),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Container(
                  height: 800.h,
                  child: Column(
                    children: [
                      gapHeight(20.h),
                      Container(
                          height: 60.h,
                          child: textFieldBorderWidget(
                              Padding(
                                padding: EdgeInsets.only(left: 8.w,),
                                child: customText1(
                                    widget.information!.productName
                                    , kBlack, 16.sp),
                              ),
                              "Product name")
                      ),
                      gapHeight(35.h),
                      textFieldBorderWidget(
                          Container(
                            padding: EdgeInsets.all(20.0),
                            height: 222.h,
                            width: 368.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                image: DecorationImage(image: getImageNetwork(
                                    widget.information!.productImage
                                ).image,
                                    fit: BoxFit.contain)
                            ),

                          ), "Product image"),
                      gapHeight(35.h),
                      Container(
                          height: 60.h,
                          child: textFieldBorderWidget(
                              Padding(
                                padding: EdgeInsets.only(left: 8.w,),
                                child: customText1(
                                    widget.information!.productCategory,
                                    kBlack, 16.sp),
                              ),
                              "Product category")
                      ),
                      gapHeight(35.h),
                      Container(
                        height: 60.h,
                        child: textFieldBorderWidget(
                            Padding(
                              padding: EdgeInsets.only(left: 8.w,),
                              child: customTextnaira(
                                  NumberFormat.simpleCurrency(name: 'NGN')
                                      .format(
                                      double.parse(
                                          widget.information!.purchasePrice
                                              .toString()
                                      ))
                                      .split(".")[0], kBlack,
                                  16.sp, fontWeight: FontWeight.w400),
                            ),
                            "Product cost price"),
                      ),
                      gapHeight(35.h),
                      Container(
                        height: 60.h,
                        child: textFieldBorderWidget(
                            Padding(
                              padding: EdgeInsets.only(left: 8.w,),
                              child: customTextnaira(
                                  NumberFormat.simpleCurrency(name: 'NGN')
                                      .format(
                                      double.parse(
                                          widget.information!.sellingPrice
                                              .toString()
                                      ))
                                      .split(".")[0], kBlack,
                                  16.sp, fontWeight: FontWeight.w400),
                            ),
                            "Product selling price"),
                      ),
                      gapHeight(35.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 60.h,
                            width: 192.w,
                            child: textFieldBorderWidget(
                                Padding(
                                  padding: EdgeInsets.only(left: 8.w,),
                                  child: customText1(widget.information!.
                                  quantity.toString(), kBlack, 16.sp),
                                ), "Quantity"),
                          ),
                          Container(
                            height: 60.h,
                            width: 192.w,
                            child: textFieldBorderWidget(
                                Padding(
                                  padding: EdgeInsets.only(left: 8.w,),
                                  child: customText1(
                                      widget.information!.unitCategory,
                                      kBlack, 16.sp),
                                ), "Unit"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
        );

  }
}

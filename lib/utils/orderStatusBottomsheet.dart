import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/controller/orderController.dart';

import 'appColors.dart';
import 'appDesignUtil.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({Key? key}) : super(key: key);

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  var controller = Get.put(OrderController());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      color: kWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: kLightPink,
            height: 63.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios,size: 15,)),
                // Spacer(),
                customText1("   Order Status", kBlack, 18.sp,
                    fontWeight: FontWeight.w500,fontFamily: fontFamily
                ),
                Spacer()
              ],
            ),
          ),
          gapHeight(20.h),
          GestureDetector(
            onTap: (){
              controller.selectedOrderStatusFilterChoice.value="Accepted";
              Get.back(result:[ "Accepted",]);
            },
            child: Container(
              width: double.infinity,
              height: 54.h,
              color: kWhite,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: Row(
                    children: [
                      Container(
                          child: paymentStatusDesign("Accepted")),
                      SizedBox()
                    ],
                  )
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              controller.selectedOrderStatusFilterChoice.value="Rejected";
              Get.back(result: ["Rejected",]);
            },
            child: Container(
              width: double.infinity,
              height: 54.h,
              color: kWhite,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: Row(
                    children: [
                      Container(
                          child: paymentStatusDesign("Rejected")),
                      SizedBox()
                    ],
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}


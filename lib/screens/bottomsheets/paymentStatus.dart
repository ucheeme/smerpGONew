import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';

class PaymentStatus extends StatefulWidget {
  const PaymentStatus({Key? key}) : super(key: key);

  @override
  State<PaymentStatus> createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.h,
      color: kWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: kLightPink,
            height: 73.h,
            child: Row(
               mainAxisAlignment: MainAxisAlignment.start,
              children: [

                GestureDetector(
                    onTap: (){
                     Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios,size: 15,)),
               // Spacer(),
                customText1("   Payment status", kBlack, 18.sp,
                  fontWeight: FontWeight.w500,fontFamily: fontFamily
                ),
                Spacer()
              ],
            ),
          ),
          gapHeight(20.h),
          GestureDetector(
            onTap: (){
              Get.back(result:[ "Paid",1]);
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
                     child: paymentStatusDesign2("Paid")),
                    SizedBox()
                 ],
                )
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Get.back(result: ["Unpaid",0]);
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
                         child: paymentStatusDesign2("Unpaid")),
                      SizedBox()
                    ],
                  )
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Get.back(result: ["Pending",2]);
            },
            child: Container(
              width: double.infinity,
              height: 54.h,
              color: kWhite,
              child:Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: Row(
                    children: [
                      Container(
                         child: paymentStatusDesign2("Pending")),
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


class OrderPaymentStatus extends StatefulWidget {
  const OrderPaymentStatus({super.key});

  @override
  State<OrderPaymentStatus> createState() => _OrderPaymentStatusState();
}

class _OrderPaymentStatusState extends State<OrderPaymentStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.h,
      color: kWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: kLightPink,
            height: 73.h,
            child: Padding(
              padding:  EdgeInsets.only(top: 30.h,bottom: 20.h,left: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back_ios,size: 15,)),
                  gapWeight(20.w),
                  customText1("Payment status", kBlack, 18.sp,
                      fontWeight: FontWeight.w500,fontFamily: fontFamily
                  ),
                ],
              ),
            ),
          ),
          gapHeight(20.h),
          GestureDetector(
            onTap: (){
              Get.back(result:[ "Paid",1]);
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
                          child: paymentStatusDesign2("Paid")),
                      SizedBox()
                    ],
                  )
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Get.back(result: ["Unpaid",0]);
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
                          child: paymentStatusDesign2("Unpaid")),
                      SizedBox()
                    ],
                  )
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Get.back(result: ["Pending",2]);
            },
            child: Container(
              width: double.infinity,
              height: 54.h,
              color: kWhite,
              child:Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: Row(
                    children: [
                      Container(
                          child: paymentStatusDesign2("Pending")),
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



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';
import 'package:smerp_go/utils/reportUiKit.dart';

import '../../../../utils/appColors.dart';
String? downLoadReportOption;
class DownloadReport extends StatefulWidget {
 final TabController? tabController;
  DownloadReport({super.key, this.tabController});

  @override
  State<DownloadReport> createState() => _DownloadReportState();
}

class _DownloadReportState extends State<DownloadReport> {
  RxBool select= false.obs;
  RxBool isAllSales= true.obs;
  RxBool isOfflineSales= false.obs;
  RxBool isOrders= false.obs;
  RxBool isAllProducts= false.obs;
  List<RxBool> selectSales =[false.obs,false.obs,false.obs,false.obs,false.obs];
  List<RxBool> selectProducts =[false.obs,false.obs,false.obs,false.obs];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 600.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(20),
                  customText1("Select sales data to download", kBlack, 16.sp,
                      fontWeight: FontWeight.w500,fontFamily: fontFamilyInter),
                  Gap(10),
                  GestureDetector(
                      onTap: (){
                        if(isAllProducts.value||isOrders.value||isOfflineSales.value){
                            setState(() {
                              isAllProducts.value = false;
                              isOrders.value= false;
                              isOfflineSales.value =false;
                              isAllSales.value = !isAllSales.value;
                            });
                       }
                      },
                      child: reportOptionUI("All sales", isAllSales)),
                  Gap(10),
                  GestureDetector(
                      onTap: (){
                        if(isAllProducts.value||isOrders.value||isAllSales.value){
                          setState(() {
                            isAllProducts.value = false;
                            isOrders.value= false;
                            isOfflineSales.value =!isOfflineSales.value;
                            isAllSales.value = false;
                          });

                        }
                      },
                      child: reportOptionUI("Offline sales", isOfflineSales)),
                  Gap(10),
                  GestureDetector(
                      onTap: (){
                        if(isAllProducts.value||isOfflineSales.value||isAllSales.value) {
                          setState(() {
                            isAllProducts.value = false;
                            isOrders.value = !isOrders.value;
                            isOfflineSales.value = false;
                            isAllSales.value = false;
                          }
                          );
                        }

                      },
                      child: reportOptionUI("Orders", isOrders)),
                  Gap(20),
                  // customText1("Select product to download", kBlack, 16.sp,
                  //     fontWeight: FontWeight.w500,fontFamily: fontFamilyInter),
                  // Gap(10),
                  // GestureDetector(
                  //     onTap: (){
                  //       if(isOrders.value||isOfflineSales.value||isAllSales.value){
                  //         isAllProducts.value = !isAllProducts.value;
                  //         isOrders.value= false;
                  //         isOfflineSales.value =false;
                  //         isAllSales.value = false;
                  //       }
                  //     },
                  //     child: reportOptionUI("All products", isAllProducts)),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                if(!isOrders.value&&!isOfflineSales.value&&isAllSales.value){
                  setState(() {
                    downLoadReportOption="0";
                  });
                }else if(!isOfflineSales.value&&isOrders.value&&!isAllSales.value){
                  setState(() {

                   downLoadReportOption="1";
                  });
               }else if(!isAllSales.value&&isOfflineSales.value&&!isAllSales.value) {
                  setState(() {
                    downLoadReportOption = "2";
                  }
                  );
                }else if(isOrders.value||isOfflineSales.value||isAllSales.value){
                //  isAllProducts.value = !isAllProducts.value;
                }
               widget.tabController?.animateTo(2,
                curve: Curves.easeIn);
              },
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                    color: kAppBlue,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                        color: kAppBlue, width: 0.5.w)),
                child: Center(
                  child: customText1(
                      "Next", kWhite, 16.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: fontFamilyInter),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

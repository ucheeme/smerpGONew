import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';

class ListOfBanks extends StatefulWidget {
  const ListOfBanks({super.key});

  @override
  State<ListOfBanks> createState() => _ListOfBanksState();
}




class _ListOfBanksState extends State<ListOfBanks> {
  List<String> listOfBanks =["Access Bank Plc","Citibank Nigeria Limited",
 "Ecobank Nigeria Plc","Fidelity Bank Plc","Signature Bank Limited","Optimus Bank",
  "Zenith Bank Plc","Wema Bank Plc","Unity  Bank Plc","United Bank For Africa Plc",
  "Union Bank of Nigeria Plc","Titan Trust Bank Ltd","SunTrust Bank Nigeria Limited",
  "Sterling Bank Plc","Standard Chartered Bank Nigeria Ltd","Stanbic IBTC Bank Plc",
  "First Bank Nigeria Limited", "Globus Bank Limited", "Guaranty Trust Bank Plc",
    "Heritage Banking Company Ltd", "Keystone Bank Limited", "Parallex Bank Ltd",
    "Polaris Bank Plc", "Premium Trust Bank", "Providus Bank"
  ];

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
                  customText1("Select Bank", kBlack, 18.sp,
                      fontWeight: FontWeight.w500,fontFamily: fontFamily
                  ),

                ],
              ),
            ),
          ),
          gapHeight(20.h),

          Container(
            width: double.infinity,
            height: 304.h,
            child: Padding(
                padding: EdgeInsets.only(left: 20.h),
                child:ListView.builder(
                    itemCount: listOfBanks.length,
                    itemBuilder: (context, index){
                      // print(prodCategory.length);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap:(){
                              Get.back(result: [listOfBanks[index]]);
                            },
                            child: Container(
                              height:40.h,
                              width: double.infinity,
                              color: kWhite,
                              child: customText1(listOfBanks[index],
                                kBlackB800, 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          gapHeight(10.h)
                        ],
                      );
                    })
            ),
          ),

        ],
      ),
    );
  }

}

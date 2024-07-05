import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/report.dart';
import 'appColors.dart';
import 'appDesignUtil.dart';

class BestProductTab extends StatefulWidget {
  BestProductTab({super.key});

  @override
  State<BestProductTab> createState() => _BestProductTabState();
}
class _BestProductTabState extends State<BestProductTab>
    with TickerProviderStateMixin {
  var _controller = Get.put(ReportController());
  var activeTab1 = true;
  var activeTab2 = false;
  var activeTab3 = false;
  var activeTab4 = false;
  TabController? tabController;
  List<int> counts =[];

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            List<int> tempCount =[];
            if (activeTab2 || activeTab4 || activeTab3) {
              setState(() {
                activeTab2 = false;
                activeTab1 = !activeTab1;
                activeTab3 = false;
                activeTab4 = false;
                _controller.performingPeriod.value=0;
              });
              _controller.bestPerformingProductList.value= _controller.performingAnalysis!.thisWeek;
              _controller.bestPerformingProductList.value.sort((a,b)=>b.count.compareTo(a.count));
              tabController?.animateTo(0, curve: Curves.easeIn);
              _controller.bestPerformingProductTabController?.animateTo(0,curve: Curves.bounceIn);
            }
          },
          child: Container(
            height: 40.h,
            width: 92.w,
            decoration: BoxDecoration(

                color: activeTab1 ? kAppBlue : kLightPinkPin,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r)
                ),
                border: Border.all(color: kBlackB600, width: 0.5)
            ),
            child: Center(child: customText1(
                "This week", activeTab1 ? kWhite : kBlack, 13.sp)),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (activeTab1 || activeTab4 || activeTab3) {
              setState(() {
                activeTab1 = false;
                activeTab2 = !activeTab2;
                activeTab3 = false;
                activeTab4 = false;
                _controller.performingPeriod?.value=1;
              });
              print("this is last week");
              _controller.bestPerformingProductList.value= _controller.performingAnalysis!.lastWeek;
              _controller.bestPerformingProductList.value.sort((a,b)=>b.count.compareTo(a.count));
              tabController?.animateTo(1,
                  curve: Curves.easeIn
              );
              _controller.bestPerformingProductTabController?.animateTo(1,curve: Curves.bounceIn);
            }
          },
          child: Container(
            height: 40.h,
            width: 92.w,
            decoration: BoxDecoration(
                color: activeTab2 ? kAppBlue : kLightPinkPin,
                // borderRadius: BorderRadius.only(topRight: Radius.circular(15.r),
                //     bottomRight: Radius.circular(15.r)),
                border: Border.all(color: kBlackB600, width: 0.5)
            ),
            child: Center(child: customText1(
                "Last week", activeTab2 ? kWhite : kBlack, 13.sp)),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (activeTab1 || activeTab2 || activeTab4) {
              setState(() {
                activeTab1 = false;
                activeTab2 = false;
                activeTab3 = !activeTab3;
                activeTab4 = false;
                _controller.performingPeriod?.value=2;
              });
              _controller.bestPerformingProductList.value= _controller.performingAnalysis!.thisMonth;
              _controller.bestPerformingProductList.value.sort((a,b)=>b.count.compareTo(a.count));
              tabController?.animateTo(2,
                  curve: Curves.easeIn
              );
              _controller.bestPerformingProductTabController?.animateTo(2,curve: Curves.bounceIn);
            }
          },
          child: Container(
            height: 40.h,
            width: 92.w,
            decoration: BoxDecoration(
                color: activeTab3 ? kAppBlue : kLightPinkPin,
                // borderRadius: BorderRadius.only(topRight: Radius.circular(15.r),
                //     bottomRight: Radius.circular(15.r)),
                border: Border.all(color: kBlackB600, width: 0.5)
            ),
            child: Center(child: customText1(
                "This month", activeTab3 ? kWhite : kBlack, 13.sp)),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (activeTab1 || activeTab2 || activeTab3) {
              setState(() {
                activeTab1 = false;
                activeTab2 = false;
                activeTab3 = false;
                activeTab4 = !activeTab4;
                _controller.performingPeriod?.value=4;
              });
              _controller.bestPerformingProductList.value= _controller.performingAnalysis!.lastMonth;
              _controller.bestPerformingProductList.value.sort((a,b)=>b.count.compareTo(a.count));
              tabController?.animateTo(3,
                  curve: Curves.easeIn
              );
              _controller.bestPerformingProductTabController?.animateTo(3,curve: Curves.bounceIn);
            }
          },
          child: Container(
            height: 40.h,
            width: 92.w,
            decoration: BoxDecoration(
                color: activeTab4 ? kAppBlue : kLightPinkPin,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r)),
                border: Border.all(color: kBlackB600, width: 0.5)
            ),
            child: Center(child: customText1(
                "Last month", activeTab4 ? kWhite : kBlack, 13.sp)),
          ),
        )
      ],
    );
  }
}

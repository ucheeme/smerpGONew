import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../controller/report.dart';
import '../model/response/report/performingAnalysis.dart';
import '../screens/bottomNav/screens/report/reportHome.dart';
import '../screens/bottomsheets/dateRangeFilter.dart';

class CalendarOptions extends StatefulWidget {
  int? selectedOption;

  CalendarOptions({super.key,  this.selectedOption});

  @override
  State<CalendarOptions> createState() => _CalendarOptionsState();
}

class _CalendarOptionsState extends State<CalendarOptions> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: kBlack, width: 0.3),
        ),
        duration: Duration(seconds: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText1(
                selectedOptionWord(widget.selectedOption??0),
                kBlack, 13.sp, fontFamily: fontFamilyInter),
            Icon(Icons.arrow_drop_down_rounded)
          ],
        ),
      ),
    );
  }

  String selectedOptionWord(int value) {
    if (value == 0) {
      return "This week";
    } else if (value == 1) {
      return "Last week";
    } else if (value == 2) {
      return "This month";
    } else if (value == 3) {
      return "Last month";
    }else if(value == 4){
      String startDate =DateFormat('yy-MM-dd').format(
         reportSaleTimeRange![0]!);
      String endDate =DateFormat('yy-MM-dd').format(
         reportSaleTimeRange![1]!);
      return "Sales from $startDate to $endDate  ";
    }
    return "";
  }
}

class ReportDateFilter extends StatefulWidget {
  const ReportDateFilter({super.key});

  @override
  State<ReportDateFilter> createState() => _ReportDateFilterState();
}

class _ReportDateFilterState extends State<ReportDateFilter> {
  var _controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 400.h,
        color: kWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: kLightPink,
              height: 73.h,
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 17,
                        )),
                    gapWeight(20.w),
                    customText1(
                      "Filter by",
                      kBlack,
                      18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
            gapHeight(20.h),
            GestureDetector(
              onTap: () async {
                //  Get.back;
                DateTime now = DateTime.now();

                // Calculate the start date of the current week (today's date minus the current weekday)
                DateTime startOfCurrentWeek =
                now.subtract(Duration(days: now.weekday - 1));

                // Calculate the start date of the previous week (subtract 7 days from the start of the current week)
                // DateTime startOfPreviousWeek =
                // startOfCurrentWeek.subtract(Duration(days: 7));

                // Calculate the end date of the previous week (subtract 1 day from the start of the current week)
                DateTime endOfPreviousWeek =
                startOfCurrentWeek.subtract(Duration(days: 1));
                Get.back(result: 0);
                _controller.selectedDateRange.value = [
                  startOfCurrentWeek,
                  DateTime.now()
                ];
              },
              child: Container(
                width: double.infinity,
                height: 54.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: customText1(
                    "This week",
                    kBlackB800,
                    16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            // Gap(20),
            GestureDetector(
              onTap: () async {
                //  Get.back;
                DateTime now = DateTime.now();

                // Calculate the start date of the current week (today's date minus the current weekday)
                DateTime startOfCurrentWeek =
                now.subtract(Duration(days: now.weekday - 1));

                // Calculate the start date of the previous week (subtract 7 days from the start of the current week)
                DateTime startOfPreviousWeek =
                startOfCurrentWeek.subtract(Duration(days: 7));

                // Calculate the end date of the previous week (subtract 1 day from the start of the current week)
                DateTime endOfPreviousWeek =
                startOfCurrentWeek.subtract(Duration(days: 1));
                Get.back(result: 1);
                _controller.selectedDateRange.value = [
                  startOfPreviousWeek,
                  endOfPreviousWeek
                ];
              },
              child: Container(
                width: double.infinity,
                height: 54.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: customText1(
                    "Last week",
                    kBlackB800,
                    16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                int year = DateTime
                    .now()
                    .year;
                int month = DateTime
                    .now()
                    .month;
                var lastDayOfMonth = DateTime
                    .now()
                    .month;
                Get.back(result: 2);
                _controller.selectedDateRange.value = [
                  DateTime(year, month, 1),
                  DateTime(year, month, daysOfMonth(month, year))
                ];
              },
              child: Container(
                width: double.infinity,
                height: 54.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: customText1(
                    "This month",
                    kBlackB800,
                    16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () async {
                int year = DateTime.now().year;
                int month = DateTime.now().month - 1;
                var lastDayOfMonth = DateTime.now().month;
                if (month == 0) {
                  month = 12;
                }
                Get.back(result: 3);
                _controller.selectedDateRange.value = [
                  DateTime(year, month, 1),
                  DateTime(year, month, daysOfMonth(month, year))
                ];
              },
              child: Container(
                width: double.infinity,
                height: 54.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: customText1(
                    "Last month",
                    kBlackB800,
                    16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                //  Get.back;
                _controller.selectedFilterChoice.value = 1;
                period=4;
                var dateTimeRange = await showCupertinoModalBottomSheet(
                  context: context,
                  backgroundColor: kWhite,
                  topRadius: Radius.zero,
                  builder: (BuildContext builder) {
                    return Container(height: 600.h, child: DateRangePicker());
                    //Custom bottom sheet widget with date range picker
                  },
                );

                if (dateTimeRange != null) {
                   Get.back(result: 4);
                   _controller.selectedDateRange.value = dateTimeRange;
                   reportSaleTimeRange=dateTimeRange;
                }
              },
              child: Container(
                width: double.infinity,
                height: 54.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: customText1(
                    "Custom range",
                    kBlackB800,
                    16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int daysOfMonth(int month, int year) {
    if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29; // Leap year: February has 29 days
      } else {
        return 28; // Non-leap year: February has 28 days
      }
    }
    //for other months
    return [1, 3, 5, 7, 8, 10, 12].contains(month) ? 31 : 30;
  }
}

class ReportCard extends StatefulWidget {
  final String title;
  final double amount;
  final num percentageIncreaseDecrease;
  final int period;
  final bool? isProduct;
   bool isGradeVisible=false;
  ReportCard({super.key, required this.title, required this.amount,
    required this.percentageIncreaseDecrease, required this.period,this.isProduct,
  required this.isGradeVisible});

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        height: 180.h,
        width: 291.5.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          color: kLightPinkPin.withOpacity(0.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText1(
                widget.title, kBlack, 14.sp, fontFamily: fontFamilyInter,
                fontWeight: FontWeight.w500),
            (widget.isProduct!=null)?customText1(widget.amount.toString().split('.')[0], kBlack, 18.sp,
            fontFamily: fontFamilyGraphilk):
            customTextnaira(NumberFormat.simpleCurrency(name: 'NGN').
            format(widget.amount).split('.')[0], kBlack, 18.sp, fotFamily: fontFamilyGraphilk,
                fontWeight: FontWeight.w600),
            Visibility(
                visible:widget.isGradeVisible,
                child: grade(widget.percentageIncreaseDecrease,widget.period))
          ],
        ),
      ),
    );
  }

  Widget grade(num percentage,int period) {
    var day = "";
  

    return Container(
      width: 205.w,
     // color: kAppBlue,
      child: Row(
        children: [
          (percentage > 20) ? Image.asset(
              "assets/newIncrease.png",
              height: 20.h,
              width: 20.w,
              fit: BoxFit.scaleDown) :
          Image.asset("assets/decreaseReport.png",
              height: 20.h,
              width: 20.w,
              fit: BoxFit.scaleDown),
          Gap(4),
          customText1("${percentage.toInt()}% from ${getDay(period)}",(percentage>20)?kGreen70:Colors.red,
            12.sp,fontFamily: fontFamilyInter,),
          // customText1("from ${getDay(period)}", kBlack,
          //   14.sp, fontFamily: fontFamilyInter,),
        ],
      ),
    );
  }
  String getDay(int period){
    if (period == 0) {
      return "last week";
    } else if (period == 1) {
      return "this week";
    } else if (period == 2) {
      return "last month";
    } else if (period == 3) {
      return "this year";
    }else if(period==4){
      return "custom";
    }
    return "";
  }
}


class BestPerformingProductListUI extends StatelessWidget {
  final String productName;
  final RxInt numberOfTimesProductOrdered;
  final int position;

  BestPerformingProductListUI({super.key, required this.productName,
    required this.numberOfTimesProductOrdered, required this.position});
  var _controller = Get.put(ReportController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        height: 50.h,
        width: 398.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 30.h,
              width: 240.w,
              child: Row(

                children: [
                  Container(
                    height: 30.h,
                    width: 30.w,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: circleColor(position),
                      shape: BoxShape.circle,

                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.passthrough,
                      children: [
                        customText1("$position", (position>2)?kBlack:kWhite, 13.sp),
                        Align(
                          alignment: Alignment.topCenter,
                          child:customText1(positionString(position),(position>2)?kBlack:kWhite, 10.sp) ,
                        )
                      ],
                    ),
                  ),
                  Gap(10),
                  customText1(
                      productName, kBlack, 15.sp, fontWeight: FontWeight.w400,
                      fontFamily: fontFamilyInter)
                ],
              ),
            ),
            Obx(() {
              return customText1(
                  "${_controller.checkQuantity(numberOfTimesProductOrdered.value)}orders",
                  kBlack, 15.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamilyInter);
            })
          ],
        ),
      ),
    );
  }

  Color? circleColor(int position) {
    switch (position) {
      case 1:
        return kAppBlue;
      case 2:
        return kAppBlue.withOpacity(0.7);
      case 3:
        return kAppBlue.withOpacity(0.5);
      default:
        return kLightPinkPin;
    }
  }

  String positionString(int position){
    switch (position){
      case 1: return " st";
      case 2: return "  nd";
      case 3: return "  rd";
      default: return "  th";
    }
  }
}



Widget reportOptionUI(String title, RxBool select){
  return SizedBox(
    height: 40.h,
    width: double.infinity,
    child: Obx((){return Row(
        children: [
          Container(
            height: 30.h,
            width: 30.w,
            decoration: BoxDecoration(
              color:(select.value)?kAppBlue:kLightPinkPin,
              border: Border.all(color: (select.value)?kAppBlue:kAppBlueSplash.withOpacity(0.5),
              width: 1),
              shape: BoxShape.circle
            ),

            padding: EdgeInsets.all(8),
            child: Container(
              height: 30.h,
              width: 30.w,
              decoration: BoxDecoration(
                color: (select.value)?kLightPinkPin:kAppBlueSplash.withOpacity(0.5),
                shape: BoxShape.circle
              ),

            )
         ),
          Gap(10),
          customText1(title, kBlack, 15.sp)
        ],
      );
    }),
  );
}

class DataSent extends StatefulWidget {
String msg;
  DataSent({required this.msg,super.key});

  @override
  State<DataSent> createState() => _DataSentState();
}

class _DataSentState extends State<DataSent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,height: 690.h,
        color:kWhite,
        child: Column(
          children: [
            // Gap(10),
            Lottie.asset("assets/json/success.json", height: 350.h, width: 300.w),
           // Gap(10),
            customText1("Store report generated successfully", kBlack, 18.sp,
                fontFamily:fontFamilyGraphilk,fontWeight: FontWeight.w500 ),
            Gap(10),
            SizedBox(
              width: 390.w,
              child: customText1(widget.msg,
                  kBlack, 14.sp,fontFamily:fontFamilyInter, maxLines: 2,
                  indent:TextAlign.center, fontWeight: FontWeight.w200),
            ),
            Gap(20),
            GestureDetector(
              onTap:  () {
               Get.back();
              },
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10.w),
                child: Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                      color: kAppBlue,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                          color: kAppBlue, width: 0.5.w)),
                  child: Center(
                    child: customText1(
                        "Done",kWhite, 16.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessResponse extends StatelessWidget {
  String msg;
   SuccessResponse({required this.msg,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,height: 690.h,
        color:kWhite,
        child: Column(
          children: [
            // Gap(10),
            Lottie.asset("assets/json/success.json", height: 350.h, width: 300.w),
            // Gap(10),
            Gap(10),
            SizedBox(
              width: 390.w,
              child: customText1(msg,
                  kBlack, 14.sp,fontFamily:fontFamilyInter, maxLines: 2,
                  indent:TextAlign.center, fontWeight: FontWeight.w200),
            ),
            Gap(20),
            GestureDetector(
              onTap:  () {
                Get.back();
              },
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10.w),
                child: Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                      color: kAppBlue,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                          color: kAppBlue, width: 0.5.w)),
                  child: Center(
                    child: customText1(
                        "Done",kWhite, 16.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





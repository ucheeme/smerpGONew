import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smerp_go/controller/orderController.dart';
import 'package:smerp_go/screens/bottomsheets/dateRangeFilter.dart';
import 'package:smerp_go/screens/bottomsheets/paymentStatus.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';



class OrderFilterOptions extends StatefulWidget {
  const OrderFilterOptions({Key? key}) : super(key: key);

  @override
  State<OrderFilterOptions> createState() => _OrderFilterOptions();
}

class _OrderFilterOptions extends State<OrderFilterOptions> {
  var _controllerOrder = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      color: kWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: kLightPink,
            height: 73.h,
            child: Padding(
              padding: EdgeInsets.only(top: 30.h, bottom: 20.h, left: 20.w),
              child: customText1("Filter by", kBlack, 18.sp,
                  fontWeight: FontWeight.w500, fontFamily: fontFamily),
            ),
          ),
          gapHeight(20.h),
          GestureDetector(
            onTap: () async {
              //  Get.back;
              _controllerOrder.selectedFilterChoice.value = 1;

              showCupertinoModalBottomSheet(
                  animationCurve: Curves.bounceIn,
                  backgroundColor: kWhite,
                  topRadius: Radius.zero,
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 380.h,
                      color: kWhite,
                      child: DateFilter(),
                    );
                  }).whenComplete(() => Get.back());
            },
            child: Container(
              width: double.infinity,
              height: 54.h,
              child: Padding(
                padding: EdgeInsets.only(left: 20.h),
                child: customText1(
                  "Date",
                  kBlackB800,
                  16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              //Get.back
              _controllerOrder.selectedFilterChoice.value = 2;
              var response = await Get.bottomSheet(
                Container(height: 300.h, child: PaymentStatus()),
              );
              if (response != null) {
                Get.back(result: response[0]);

                _controllerOrder.selectedPaymentChoice.value = response[0];
              }
            },
            child: Container(
              width: double.infinity,
              height: 54.h,
              child: Padding(
                padding: EdgeInsets.only(left: 20.h),
                child: customText1(
                  "Payment status",
                  kBlackB800,
                  16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DateFilter extends StatefulWidget {
  const DateFilter({super.key});

  @override
  State<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  var _controllerOrder = Get.put(OrderController());

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
                      "Filter By Date",
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
                Get.back();
                _controllerOrder.selectedDateRange.value = [
                  DateTime.now(),
                  DateTime.now()
                ];
              },
              child: Container(
                width: double.infinity,
                height: 54.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: customText1(
                    "Today",
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
                int month = DateTime.now().month;
                var lastDayOfMonth = DateTime.now().month;
                Get.back();
                _controllerOrder.selectedDateRange.value = [
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
                Get.back();
                _controllerOrder.selectedDateRange.value = [
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
                int year = DateTime.now().year;
                int month = DateTime.now().month - 1;
                var lastDayOfMonth = DateTime.now().month;
                if (month == 0) {
                  month = 12;
                }
                Get.back();
                _controllerOrder.selectedDateRange.value = [
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
                _controllerOrder.selectedFilterChoice.value = 1;

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
                  Get.back();
                  _controllerOrder.selectedDateRange.value = dateTimeRange;
                }
              },
              child: Container(
                width: double.infinity,
                height: 54.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: customText1(
                    "Range",
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

class BottomSheetCalendarDateRange extends StatefulWidget {
  const BottomSheetCalendarDateRange({super.key});

  @override
  State<BottomSheetCalendarDateRange> createState() =>
      _BottomSheetCalendarDateRangeState();
}

class _BottomSheetCalendarDateRangeState
    extends State<BottomSheetCalendarDateRange> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(4000),
    );

    if (picked != null &&
        picked != DateTimeRange(start: _startDate, end: _endDate)) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  void initState() {
    _selectDateRange(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          _selectDateRange(context);
        },
        child: customText1("click", kBlack, 14.sp),
      ),
    );
  }
}

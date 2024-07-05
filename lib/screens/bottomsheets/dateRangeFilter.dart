import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';



import '../../utils/appDesignUtil.dart';

class DateRangePicker extends StatefulWidget {
  const DateRangePicker({Key? key}) : super(key: key);

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime? startDate;
  DateTime? endDate;
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();

  DateRangePickerController _controller = DateRangePickerController();
  void _onSelectionChanged(args) {
    setState(() {
      // if (args.value is PickerDateRange) {
      //   final PickerDateRange range = args.value!;
        startDate = args.value.startDate;
        endDate = args.value.endDate;
        print("this is the ${DateFormat('dd-MM-yyyy').format(startDate!)} &"
            " ${DateFormat('dd-MM-yyyy').format(endDate!)}");
      startDateController.text=DateFormat('dd-MMM-yyyy').format(startDate!);
      endDateController.text= DateFormat('dd-MMM-yyyy').format(endDate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 400.h,
            padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 0.h),
            child: SfDateRangePicker(
              controller: _controller,
              headerHeight: 70.h,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              if (args.value.startDate != null && args.value.endDate != null) {
                _onSelectionChanged(args);
              }
            },
              view: DateRangePickerView.month,
              toggleDaySelection: false,
              allowViewNavigation: true,
              showNavigationArrow: true,
             headerStyle: DateRangePickerHeaderStyle(
              // textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  color: kBlackB700,
                  fontFamily: fontFamilyGraphilk,
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: kCalendarLightPink,
              ),

              monthViewSettings: DateRangePickerMonthViewSettings(
                dayFormat: "EEE",
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                 // backgroundColor: kBlackB500,
                  textStyle: TextStyle(

                    fontSize: 14.sp,
                    color: kBlackB700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              selectionMode: DateRangePickerSelectionMode.range,
              selectionColor: kRed70,
              rangeSelectionColor: kAppBlue.withOpacity(0.5),
              selectionShape: DateRangePickerSelectionShape.rectangle,
              monthCellStyle: DateRangePickerMonthCellStyle(

                specialDatesTextStyle: TextStyle(color: Colors.red),
                todayCellDecoration: BoxDecoration(

                  border: Border.all(color: kAppBlue,),
                  borderRadius: BorderRadius.circular(10.r),
                ),

                cellDecoration: BoxDecoration(
                  color: kLightPinkPin.withOpacity(.2)),
              ),
              selectionRadius: 7.r,
              startRangeSelectionColor: kAppBlue,
              endRangeSelectionColor: kAppBlue,
              rangeTextStyle: TextStyle(
                color: kAppBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
              selectionTextStyle: TextStyle(
                color: kWhite,
                fontWeight: FontWeight.w800,
                fontSize: 18.sp,
              ),
              todayHighlightColor: kGreen70,
            ),
          ),
          gapHeight(14.h),
          Container(
            width: double.infinity,
            color: kCalendarLightPink,
            height: 180.h,
            child: Column(
                children: [
                  gapHeight(30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:20.w),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 154.w,height: 60.h,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            // decoration: cardBoxDecoration(),
                            child: textInputCalendar(
                                startDateController, hintText: "Start Date",
                                dateTime: startDate)
                        ),
                        Spacer(),
                        Container(
                            width: 154.w,height: 60.h,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            //decoration: cardBoxDecoration(),
                            child:textInputCalendar(
                                endDateController, hintText: "End Date",dateTime: endDate)
                        ),
                      ],
                    ),
                  ),
                  gapHeight(16.h),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 25.w),
                    child: GestureDetector(
                      onTap: (){
                         Get.back(result:[startDate, endDate] );
                        print("Start: $startDate and End: $endDate" );
                      },
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: kAppBlue,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Center(
                          child: customText1(
                              "Filter by date", kDashboardColorBorder,
                              16.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  gapHeight(20.h)
                ]
            ),
          ),
        ],
      ),
    );
  }

}
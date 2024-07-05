import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smerp_go/utils/app_services/helperClass.dart';

import 'appColors.dart';
import 'appDesignUtil.dart';

class AppCalendar extends StatefulWidget {
  const AppCalendar({Key? key}) : super(key: key);

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  DateTime _selectedDate = DateTime.now();
  DateTime _tempDate = DateTime.now();
  var imdexOfLastDayOfMonth = 0;
 // var isLastDayOfMonth = false;
  var holder=0;
  //final keeper =0;
  var month = RxString("${DateTime
      .now()
      .month}");
  var year = RxString("${DateTime
      .now()
      .year}");
  List<String> days = ["Mon", "Tue", "Wed", "Thurs", "Fri", "Sat", "Sun"];
  var isSelectedColor = false;
  var isSelectedColorRange = [ false, false];
  var isDateRange = true;
  int _selectedIndex = -1;
  var startDate = TextEditingController();
  var endDate = TextEditingController();
  List<String> dateRange = [];
  List<bool> _selectedRange = [];

  @override
  void initState() {
    for (int i = 0; i <= 41; i ++) {
      _selectedRange.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 286.h,
      width: double.infinity,
      color: kWhite,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Obx(() {
              return Container(
                width: double.infinity,
                color: kCalendarLightPink,
                height: 58.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        var response = await Get.bottomSheet(
                            SelectMonthYear(year:
                            year.value));
                            showMonthDate(response);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText1("${getMonth(_selectedDate.month)} "
                                "${year.value}", kBlack, 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            Icon(Icons.keyboard_arrow_down_sharp,)
                          ]
                      ),
                    ),
                  ),
                ),
              );
            }),
            Container(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 58.h,
                    child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 7,
                        mainAxisSpacing: 22.h,
                        children: List.generate(days.length, (index) {
                          return Container(
                            height: 26.h,
                            width: 40.w,
                            child: Center(
                              child: customText1(days[index], kBlackB600, 16.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        })),
                  ),

                  Obx(() {
                    return Padding(
                      padding: EdgeInsets.only(left: 16.w, right: 16.w),
                      child: Container(
                        height: 250.h,
                        width: double.infinity,
                        child: GridView.count(
                          //physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 7,
                          mainAxisSpacing: 10.h,
                          crossAxisSpacing: 20.h,

                          children: List.generate(42, (index) {
                           // var lastDaysOfPreviousMonth = [28,29,30,31];
                            var numOfDaysInPreviousMonthe=
                            daysInMonth((_selectedDate.month - 1),
                                _selectedDate.year);
                            final date2 = DateTime(
                                _selectedDate.year, _selectedDate.month,
                                1);

                            holder= date2.weekday;
                          //  print(holder);
                           final keeper =holder-1;
                            if(holder!=1){

                              _tempDate=DateTime(
                                  _selectedDate.year, _selectedDate.month,
                                  (index+1)-keeper);
                            }else{
                              _tempDate= DateTime(
                                  _selectedDate.year, _selectedDate.month,
                                  index + 1);

                            }

                            if ((index+1) < holder ) {
                              var p;
                              if (index+1 != holder) {

                                  var q = holder-(index+1);
                                  p=numOfDaysInPreviousMonthe-(q-1);

                                return GestureDetector(
                                  onTap: (){
                                    if (dateRange.length != 2) {
                                      dateRange.add("${_selectedDate.day} - "
                                          "${getMonth(_selectedDate.month-1)}"
                                          "- ${_selectedDate.year}");
                                      if (dateRange.length == 1) {
                                        startDate.text = dateRange[0];
                                      } else {
                                        endDate.text = dateRange[1];
                                      }
                                    }
                                    if(((index+1) <=7) && (p>1)){
                                     print("the previous month is ${index + 1} $p");
                                     showMonthDate([(_selectedDate.month-1),
                                        _selectedDate.year.toString()]);

                                    }

                                  },
                                  child: Container(
                                      height: 28.h,
                                      width: 28.w,
                                      decoration: BoxDecoration(
                                          color: kDashboardColorBlack3,
                                          borderRadius: BorderRadius.circular(
                                              15.r),
                                          border: Border.all(
                                              color: Colors.transparent)),
                                      child: Center(
                                        child: customText1("$p", kBlackB600, 16.sp,
                                            fontWeight: FontWeight.w400),
                                      )
                                  ),
                                );
                              }
                              // else {
                              //   return Container(
                              //       height: 28.h,
                              //       width: 28.w,
                              //       decoration: BoxDecoration(
                              //           color: kDashboardColorBlack3,
                              //           borderRadius: BorderRadius.circular(
                              //               15.r),
                              //           border: Border.all(
                              //               color: Colors.transparent)),
                              //       child: Center(
                              //         child: customText1("", kBlackB600, 16.sp,
                              //             fontWeight: FontWeight.w400),
                              //       )
                              //   );
                              // }
                            }
                            return dateDesign(
                                index + 1, _tempDate, month: getMonth(_selectedDate.month),
                                year: int.parse(year.value), index: index);
                          }),
                        ),
                      ),
                    );
                  }),
                  gapHeight(20.h),
                  Container(
                    width: double.infinity,
                    color: kCalendarLightPink,
                    height: 180.h,
                    child: Column(
                        children: [
                          gapHeight(30.h),
                          Padding(
                            padding: EdgeInsets.only(left: 25.w, right: 25.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: 178.w,
                                    height: 45.h,
                                    child: textInputCalendar(
                                        startDate, hintText: "Start Date")),
                                Container(
                                    width: 178.w,
                                    height: 45.h,
                                    child: textInputCalendar(
                                       endDate, hintText: "End Date"))
                              ],
                            ),
                          ),
                          gapHeight(16.h),
                          Padding(
                            padding: EdgeInsets.only(left: 25.w, right: 25.w),
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
                          gapHeight(20.h)
                        ]
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  void showMonthDate(response) {
       for (int i = 0; i <= 41; i ++) {
      _selectedRange.add(false);
    }
    if (response[0] != null || response != 0) {
      setState(() {
        year.value = response[1];
      });
       if (response[0] > DateTime
          .now()
        .month) {
        var months="00";
        if(response[0].toString().length ==2){
          months = response[0].toString();
        }else{
          //this adds prefix to a string
         months= response[0].toString().padLeft(2, '0');
        }
       _selectedDate= DateTime.now();
        var y= response[1];
        var day = daysInMonth(response[0],int.parse(y));
        print(day);
      var monthDif = DateTime.parse(
         "${response[1]}-$months-$day")
          .difference(_selectedDate).inDays;
        setState(() {
          _selectedDate =
              _selectedDate.add(Duration(days: monthDif));
          month.value = getMonth(response[0]);
          print(_selectedDate);
          print(month.value);
        });
     } else {
        var months="00";
        if(response[0].toString().length ==2){
          months = response.toString();
        }else{
          months= response[0].toString().padLeft(2, '0');
          print(months);
        }
        _selectedDate= DateTime.now();

        var day = daysInMonth(response[0],DateTime.now().year);

      var monthDifff = _selectedDate.difference(DateTime.parse(
          "${response[1]}-$months-$day"));
        setState((){
          _selectedDate = _selectedDate.subtract(
              Duration(days: monthDifff.inDays));
          month.value = getMonth(response[0]);
          print(_selectedDate);
          print(month.value);
        });

      }
    }
  }

  void _selectContainer(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int daysInMonth(int month, int year) {
    if (month == 2) {
      if (year % 4 == 0) {
        if (year % 100 == 0) {
          if (year % 400 == 0) {
            return 29;
          }
          return 28;
        }
        return 29;
      }
      return 28;
    }
    if ([4, 6, 9, 11].contains(month)) {
      return 30;
    }
    return 31;
  }

  Widget dateDesign(int value, DateTime date, {
    String month = "January",
    int year = 1993,
    index = 0
  }) {
    int numOfDaysInMonth = settingNumberOfDaysInMonth(date, index, year, month);

    return GestureDetector(
      onTap: () {
        calendarActionResponse(index, date, month, year);


        // else if ((index)>numOfDaysInMonth) {
         //  null;
        // } else{
        //   if (isDateRange) {
        //     _selectContainerRange(date.day, month, year,index);
        //   } else {
        //     _selectContainer(index);
        //     isSelectedColor = !isSelectedColor;
        //   }
        // }
      },
      // child: Container(
      //     height: 38.h,
      //     width: 38.w,
      //     decoration: BoxDecoration(
      //       color: (value <= numOfDaysInMonth)?
      //       kCalendarLightPink : kDashboardColorBlack3,
      //       borderRadius: BorderRadius.circular(15.r),
      //         border: (isSelectedColor&&(_selectedIndex == index))?
      //        Border.all(color: kAppBlue):Border.all(color: Colors.transparent)
      //     ),
      //     child:Center(
      //       child: customText1((value <= numOfDaysInMonth)?value.toString():
      //       (value-numOfDaysInMonth).toString(), kBlackB600, 14.sp,
      //           fontWeight: FontWeight.w400),
      //     )
      // ),
      child: Container(
          height: 28.h,
          width: 28.w,
          decoration: BoxDecoration(
              color: calendarBodyColor(date, value, numOfDaysInMonth),
              borderRadius: BorderRadius.circular(15.r),
              border: calendarBorderColor(date, index)
          ),
          child: Center(
            child: customText1(
                calendarDates(date, numOfDaysInMonth),
                calendarDateTextColor(date), 16.sp,
                fontWeight: FontWeight.w400),
          )
      ),
    );
  }

  int settingNumberOfDaysInMonth(DateTime date, index, int year, String month) {
    var isLeapYear = false;
    var numOfDaysInMonth = 31;
    var remainingDays = 0;
    if((date.day)==numOfDaysInMonth){
      imdexOfLastDayOfMonth = index;
    }
    if ((year % 4) == 0) {
      isLeapYear = true;
    } else {
      isLeapYear = false;
    }
    if (month == "September" || month == "April" || month == "June" ||
        month == "November") {
      numOfDaysInMonth = 30;
    } else if (month == "February") {
      if (isLeapYear) {
        numOfDaysInMonth = 29;
      } else {
        numOfDaysInMonth = 28;
      }
    } else {
      numOfDaysInMonth = 31;
    }

    remainingDays = 42 - numOfDaysInMonth;
    return numOfDaysInMonth;
  }

  void calendarActionResponse(index, DateTime date, String month, int year) {
    if (dateRange.length != 2) {
      dateRange.add("${date.day} - ${getMonth(date.month)}- ${date.year}");
      if (dateRange.length == 1) {
        startDate.text = dateRange[0];
      } else {
        endDate.text = dateRange[1];
      }
    }

      if(index > imdexOfLastDayOfMonth){
      showMonthDate([(date.month),date.year.toString()]);
      // dateRange[1]="${date.day} - ${date.month}- ${date.year}";
      // endDate.text = dateRange[1];

    }

    if (isDateRange) {
      _selectContainerRange(date.day, month, year,index);
    } else {
      _selectContainer(index);
      isSelectedColor = !isSelectedColor;
    }
  }

  Color calendarDateTextColor(DateTime date) {
    return (date.day == DateTime
                  .now()
                  .day &&
                  date.month == DateTime
                      .now()
                      .month &&
                  date.year == DateTime
                      .now()
                      .year) ?
              kLightPink : kBlackB600;
  }

  String calendarDates(DateTime date, int numOfDaysInMonth) {
    return (date.day <= numOfDaysInMonth) ? date.day.toString() :
              ((date.day) - numOfDaysInMonth).toString();
  }

  Color calendarBodyColor(DateTime date, int value, int numOfDaysInMonth) {
    return (((date.day == DateTime
                .now()
                .day &&
                date.month == DateTime
                    .now()
                    .month &&
                date.year == DateTime
                    .now()
                    .year)) ? kAppBlue : (value <= numOfDaysInMonth) ?
            kCalendarLightPink : kDashboardColorBlack3);
  }

  Border calendarBorderColor(DateTime date, index) {
    return ((date.day == DateTime
                .now()
                .day &&
                date.month == DateTime
                    .now()
                    .month &&
                date.year == DateTime
                    .now()
                    .year) ?
            Border.all(color: kLightPink) :
            ((_selectedRange[index])) ?
            Border.all(color: kAppBlue) : Border.all(
                color: Colors.transparent));
  }

  void _selectContainerRange(int date, month, year,int index) {
    setState(() {
      if (_selectedRange
          .where((element) => element)
          .length >= 2) {
        // This checks if the selected index is greater or lesser than the already existing index
        // Deselect the oldest selected container if we already have two
        if (index < _selectedRange.indexOf(true)) {
          final oldestSelectedIndex = _selectedRange.indexOf(true);
          //  dateRange.removeAt(0);
          _selectedRange[oldestSelectedIndex] = false;
            dateRange[0]="${date} - $month- $year";
          startDate.text = "${date }-$month-$year";
        } else {
          final newestSelectedIndex = _selectedRange.lastIndexOf(true);
          //  dateRange.removeAt(1);
          _selectedRange[newestSelectedIndex] = false;
           dateRange[1]="${date} - $month- $year";
          endDate.text = "${date}-$month-$year";
          print(endDate.text);
        }
      }
      _selectedRange[index] = true;
      if (dateRange.length != 2) {
       dateRange.add("${date}-$month-$year");
        if (dateRange.length == 1) {
          startDate.text = dateRange[0];
        } else {
         endDate.text = dateRange[1];
        }
      }
    });
  }

}


class SelectMonthYear extends StatefulWidget {
  String year;

  SelectMonthYear({Key? key, required this.year}) : super(key: key);

  @override
  State<SelectMonthYear> createState() => _SelectMonthYearState();
}

class _SelectMonthYearState extends State<SelectMonthYear> {
  var year = "";
  List<String> month = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  var isSelected = false;
  int _selectedIndex = -1;
  var setDateController = TextEditingController();

  void _selectContainer(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    year = widget.year;
    _selectedIndex = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 359.h,
      width: 430.w,
      color: kWhite,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: kCalendarLightPink,
            height: 58.h,
            child: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                year = (int.parse(year) - 1).toString();
                              });
                            },
                            child: Icon(Icons.arrow_back_ios,)),
                        customText1("$year", kBlack, 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              year = (int.parse(year) + 1).toString();
                            });
                          },
                          child: Icon(Icons.arrow_forward_ios,
                          ),
                        ),
                      ]
                  ),
                ),
              ),
            ),
          ),
          gapHeight(15.h),
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: Container(
              height: 180.h,
              child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 20.h,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2,
                  // scrollDirection: Axis.horizontal,

                  children: List.generate(month.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectContainer(index);
                          isSelected = !isSelected;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10.h),
                        height: 27.h,
                        // width: (month[index].length<6)?120.w:71.w,
                        width: (month[index].length < 6) ? 140.w : 120.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: kCalendarLightPink,
                            border: (isSelected && (_selectedIndex == index))
                                ? Border.all(color: kAppBlue)
                                :
                            Border.all(color: Colors.transparent)
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.w, right: 5.w),
                            child: customText1(month[index],
                                (isSelected && (_selectedIndex == index))
                                    ? kAppBlue
                                    : kBlackB600, 14.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    );
                  })),
            ),
          ),
          gapHeight(20.h),
          Padding(
            padding: EdgeInsets.only(left: 25.w, right: 25.w),
            child: Container(
              height: 80.h,
              color: kCalendarLightPink,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 178.w,
                      height: 45.h,
                      child: textInputCalendar(
                          setDateController, hintText: "Select Date")),
                  GestureDetector(
                    onTap: () {
                      print((_selectedIndex + 1));
                      Get.back(result: [(_selectedIndex + 1),year]);
                    //  _selectedIndex= -1;
                    },
                    child: Container(
                        width: 178.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                            color: kAppBlue,
                            borderRadius: BorderRadius.circular(15.r)
                        ),
                        child: Center(
                            child: customText1("Set date", kWhite, 16.sp))),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


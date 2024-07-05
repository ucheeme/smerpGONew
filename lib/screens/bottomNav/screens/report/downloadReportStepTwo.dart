import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smerp_go/controller/report.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/appColors.dart';

import '../../../../controller/signupController.dart';
import '../../../../cubit/reportAnalysisDownload/report_analysis_download_cubit.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../../utils/downloadAsImage.dart';
import '../../../../utils/reportUiKit.dart';
import '../../../bottomsheets/dateRangeFilter.dart';
import '../../../bottomsheets/newUpdate.dart';
import '../../bottomNavScreen.dart';
import 'downloadReport.dart';

class DownloadReportStepTwoDesign extends StatefulWidget {
  // int? tabPosition;
  TabController? tabController;
   DownloadReportStepTwoDesign({super.key,this.tabController});

  @override
  State<DownloadReportStepTwoDesign> createState() => _DownloadReportStepTwoDesignState();
}

class _DownloadReportStepTwoDesignState extends State<DownloadReportStepTwoDesign> with TickerProviderStateMixin{
  var _controller = Get.put(ReportController());
  // TabController? tabController;
  RxBool isThisWeek=RxBool(true);
  RxBool isLastWeek=RxBool(false);
  RxBool isThisMonth=RxBool(false);
  RxBool isLastMonth=RxBool(false);
  RxBool isCustomRange=RxBool(false);
  RxBool isPdfFile =RxBool(false);
  RxBool isExcel = RxBool(false);
  String? period="0";
  int? documentType;
  String labelText = "Select date";
  List<DateTime?>? selectedDateRange;
  late ReportAnalysisDownloadCubit cubit;
  List<DateTime>? selectDate;
  @override
  void initState() {
    period="0";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    cubit= context.read<ReportAnalysisDownloadCubit>();

    return bloc.BlocBuilder<ReportAnalysisDownloadCubit, ReportAnalysisDownloadState>(
  builder: (context, state) {
    if(state is ReportAnalysisDownloadErrorState){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
         showToast(state.errorResponse.message);
        });
      });
      cubit.resetState();
    }
    if(state is DownloadReportSuccessState){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          FirebaseAnalytics.instance.logEvent(
            name: trackedPagesAndActions[4],
            parameters: <String, dynamic>{
              'string_parameter': 'Report Downloaded',
              'int_parameter': 4,
            },
          );
          Get.bottomSheet(
              backgroundColor: kWhite,
              DataSent(msg: state.errorResponse.message,)).whenComplete(() {
            _controller.isReportAnalysis.value=true;
            widget.tabController?.animateTo(1);

          });
        });
      });
      cubit.resetState();
    }
    return overLay(
      Scaffold(
        body: SizedBox(
          height: 800.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 400.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(20),
                   SizedBox(
                     height: 200.h,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                             SizedBox(
                                 width:200.w,
                                 child: GestureDetector(
                                     onTap: (){
                                       if(isThisMonth.value||isLastMonth.value||isLastWeek.value||isCustomRange.value){
                                         setState(() {
                                           isThisMonth.value = false;
                                           isLastMonth.value= false;
                                           isLastWeek.value =false;
                                           isCustomRange.value = false;
                                           isThisWeek.value=!isThisWeek.value;
                                           period="0";
                                         });
                                       }
                                     },
                                     child: reportOptionUI("This week",isThisWeek))),
                             SizedBox(
                                 width: 150.w,
                                 child: GestureDetector(
                                     onTap: (){
                                       if(isThisMonth.value||isLastMonth.value||isThisWeek.value||isCustomRange.value){
                                         setState(() {
                                           isThisMonth.value = false;
                                           isLastMonth.value= false;
                                           isLastWeek.value =!isLastWeek.value;
                                           isCustomRange.value = false;
                                           isThisWeek.value=false;
                                           period="1";
                                         });
                                       }
                                     },
                                     child: reportOptionUI("Last week",isLastWeek))),

                           ],
                         ),
                         Gap(10),
                         Row(
                           children: [
                             GestureDetector(
                               onTap:(){
                                 if(isLastWeek.value||isLastMonth.value||isThisWeek.value||isCustomRange.value){
                                   setState(() {
                                     isThisMonth.value = !isThisMonth.value;
                                     isLastMonth.value= false;
                                     isLastWeek.value =false;
                                     isCustomRange.value = false;
                                     isThisWeek.value=false;
                                     period="2";
                                   });
                                 }
                               },
                               child: SizedBox(
                                   width:200.w,
                                   child: reportOptionUI("This month",isThisMonth)),
                             ),
                             SizedBox(
                                 width: 150.w,
                                 child: GestureDetector(
                                     onTap: (){
                                       if(isLastWeek.value||isThisMonth.value||isThisWeek.value||isCustomRange.value){
                                         setState(() {
                                           isThisMonth.value = false;
                                           isLastMonth.value= !isLastMonth.value;
                                           isLastWeek.value =false;
                                           isCustomRange.value = false;
                                           isThisWeek.value=false;
                                           period="3";
                                         });
                                       }
                                     },
                                     child: reportOptionUI("Last month",isLastMonth))),

                           ],
                         ),
                         Gap(10),
                         SizedBox(
                             width: 150.w,
                             child: GestureDetector(
                                 onTap: (){
                                   if(isLastWeek.value||isThisMonth.value||isThisWeek.value||isLastMonth.value){
                                     setState(() {
                                       isThisMonth.value = false;
                                       isLastMonth.value= false;
                                       isLastWeek.value =false;
                                       isCustomRange.value = !isCustomRange.value;
                                       isThisWeek.value=false;
                                     });
                                   }
                                 },
                                 child: reportOptionUI("Custom Date",isCustomRange))),
                       ],
                     ),
                   ),

                    Visibility(
                      visible: isCustomRange.value,
                      child: GestureDetector(onTap: () async {
                         List<DateTime?>? dateTimeRange = await showCupertinoModalBottomSheet(
                          context: context,
                          backgroundColor: kWhite,
                          topRadius: Radius.zero,
                          builder: (BuildContext builder) {
                            return Container(height: 600.h, child: DateRangePicker());
                            //Custom bottom sheet widget with date range picker
                          },
                        );
                        if (dateTimeRange != null) {
                          var startDate=DateFormat('dd-MMM-yyyy').format(dateTimeRange![0]!);
                          var endDate=DateFormat('dd-MMM-yyyy').format(dateTimeRange![1]!);
                          setState(() {
                            selectedDateRange= dateTimeRange;
                            _controller.dateChange.value="From: $startDate       To: $endDate";
                          });
                          print(selectedDateRange!.length);
                        }else{
                          print("resssstttt");
                        }
                      },
                        child: textFieldBorderWidget(
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               customText1(_controller.dateChange.value, kBlack, 14.sp),
                               Icon(Icons.calendar_month,)
                             ],
                           ), "Date Range"),
                      ),
                    ),
                    Gap(25),
                    customText1("Select file type", kBlack, 14.sp),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            isPdfFile.value=true;
                            isExcel.value=false;
                            setState(() {
                              documentType=1;
                            });

                          },
                          child: SizedBox(
                            height: 40.h,
                            width: 170.w,
                            child: reportOptionUI("PDF file", isPdfFile),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            isPdfFile.value=false;
                            isExcel.value=true;
                            setState(() {
                              documentType=2;
                            });
                          },
                          child: SizedBox(
                            height: 40.h,
                            width: 210.w,
                            child: reportOptionUI("Excel file", isExcel),
                          ),
                        ),
                      ],
                    ),
                    // Container(
                    //   height: 60.h,
                    //   width: double.infinity,
                    //   child: titleSignUp(_controller.emailAddress,
                    //       textInput: TextInputType.emailAddress,
                    //       hintText: "Confirm email address"),
                    // ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  widget.tabController?.animateTo(1);
                },
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: kLightPinkPin,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                          color: kAppBlue, width: 0.5.w)),
                  child: Center(
                    child: customText1(
                        "Previous", kAppBlue, 16.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: fontFamilyInter),
                  ),
                ),
              ),
             GestureDetector(
                onTap: (){
                  if(isPdfFile.isFalse&&isExcel.isFalse){
                    null;
                  }else{
                    if(isCustomRange.isTrue){
                      var startDate=DateFormat('MM-dd-yyyy').format(selectedDateRange![0]!);
                      var endDate=DateFormat('MM-dd-yyyy').format(selectedDateRange![1]!);
                      if(loginData!.storeEmail==null){
                        Get.bottomSheet(
                            Container(
                                height: 600.h,
                                child: FinishUserSetUp())
                        );
                      }else if(loginData!.storeEmail!.isEmpty) {
                        Get.bottomSheet(
                            Container(
                                height: 600.h,
                                child: FinishUserSetUp())
                        );
                      }else{
                        cubit.downloadSaleReportRange(downLoadReportOption!, startDate, endDate,documentType.toString());
                      }
                    }else{
                      if(loginData!.storeEmail==null){
                        Get.bottomSheet(
                            Container(
                                height: 600.h,
                                child: FinishUserSetUp())
                        );
                      }else if(loginData!.storeEmail!.isEmpty) {
                        Get.bottomSheet(
                            Container(
                                height: 600.h,
                                child: FinishUserSetUp())
                        );
                      }else{
                          cubit.downloadSaleReport(downLoadReportOption!, period!,documentType.toString());
                        }
                      }

                    }



                },
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                      color:(isPdfFile.value||isExcel.value)? kAppBlue:kHashBlack30,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                          color: kAppBlue, width: 0.5.w)),
                  child: Center(
                    child: customText1(
                        "Submit", kWhite, 16.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: fontFamilyInter),
                  ),
                ),
              ),
              Gap(20)
            ],
          ),
        ),
      ),
      isLoading: state is  ReportAnalysisDownloadLoadingState
    );
  },
);
  }
}

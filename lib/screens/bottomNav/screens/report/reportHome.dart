import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:smerp_go/controller/report.dart';
import 'package:smerp_go/cubit/reportAnalysisDownload/report_analysis_download_cubit.dart';
import 'package:smerp_go/model/response/report/performingAnalysis.dart';

import '../../../../model/response/report/productAnalysis.dart';
import '../../../../model/response/report/salesAnalysis.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/UserUtils.dart';
import '../../../../utils/addSaleHelperClass.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../../utils/bestPerformingProductDesign.dart';
import '../../../../utils/downloadAsImage.dart';
import '../../../../utils/mockdata/tempData.dart';
import '../../../../utils/reportUiKit.dart';
List<DateTime?> reportSaleTimeRange=[];
int period=0;
int iPeriod=0;
class ReportAndAnalysis extends StatefulWidget {
  const ReportAndAnalysis({super.key});

  @override
  State<ReportAndAnalysis> createState() => _ReportAndAnalysisState();
}

class _ReportAndAnalysisState extends State<ReportAndAnalysis> {
  var _controller = Get.put(ReportController());
late ReportAnalysisDownloadCubit cubit;
  SalesAnalysisThisWeek? salesAnalysis;
  SalesAnalysisThisMontkh? salesAnalysisThisMontkh;
  SalesAnalysisM? salesAnalysisPast;
  ProductAnalysis? productAnalysis=ProductAnalysis(sold: 0, stock: 0);
  PerformingAnalysis? _performingAnalysis;
bool isLoading =true;
bool isFirst= false;

 @override
  void initState() {
   isFirst= true;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cubit.getProductReportAnalysis(0);
      cubit.getSalesReportAnalysisThisWeek();
      cubit.getBestPerformingProductReportAnalysis();
      if(productAnalysis==null){
        cubit.getProductReportAnalysis(0);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    cubit= context.read<ReportAnalysisDownloadCubit>();
  //  _controller.getReportAnalysisInitialize(context);
    //if(productAnalysis==null){
      cubit.getProductReportAnalysis(0);

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

    if(state is SaleAnalysisSuccess){
      _controller.salesAnalysis= state.response;
      salesAnalysis= state.response;
      // print("This is sales Analysis: $salesAnalysis");
      // print("This is sales Analysis state response: ${state.response}");
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setSalesAnalysisTempData(state);
        _controller.setSalesAnalysisTempData(state);
        setState(() {
          isLoading= false;
        });
      });

      cubit.resetState();
    }

    if(state is SalesAnalysisLastMonthLastWeekSuccess){
      salesAnalysisPast= state.response;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) { });
      cubit.resetState();
    }

    if(state is SalesAnalysisThisMonthSuccess){
      salesAnalysisThisMontkh = state.response;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) { });
      cubit.resetState();
    }

    if(state is ProductAnalysisSuccess){

      _controller.productAnalysis= state.response;
      productAnalysis=state.response;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        isFirst= false;
        setProductAnalysisTempData(state);
       _controller.setProductAnalysisTempData(state);
      });
      cubit.resetState();
    }

    if(state is SaleAnalysisRangeSuccess){
      salesAnalysisPast=state.response;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //cubit.resetState();
      });
      cubit.resetState();
    }

    if(state is PerformingProductAnalysisSuccess){
      _performingAnalysis= state.response;
      _controller.performingAnalysis=_performingAnalysis;
      // print("This is performance Analysis: $_performingAnalysis");
      // print("This is performance Analysis state response: ${state.response}");
     WidgetsBinding.instance.addPostFrameCallback((_) {
       Future.delayed(Duration.zero,(){
         _controller.bestPerformingProductList.value= _performingAnalysis!.thisWeek;
         _controller.bestPerformingProductListLastMonth.value=_controller.performingAnalysis!.lastMonth;
         _controller.bestPerformingProductListLastWeek.value=_controller.performingAnalysis!.lastWeek;
         _controller.bestPerformingProductListThisMonth.value=_controller.performingAnalysis!.thisMonth;

         _controller.bestPerformingProductList.value.sort((a,b)=>b.count.compareTo(a.count));
       });

      });
     cubit.resetState();
    }
    return overLay(
       overLay(
         Scaffold(
          body: Container(
            height: 900.h,
            child: Obx(() {
              calculatePercentage(0, 0);
                return
                  SingleChildScrollView(
                    child: Container(
                      //height: 900.h,
                      child: Column(
                        children: [
                          Gap(20),
                          Container(

                            height: 45.h,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customText1("Sales report", kBlack, 18.sp),
                                Obx(() {
                                  return GestureDetector(
                                    onTap: () async {
                                      _controller.period?.value = await Get.bottomSheet(Container(
                                          height: 380.h,
                                           child: ReportDateFilter()));
                                      if(_controller.period?.value==0){
                                        period=0;
                                        cubit.getSalesReportAnalysisThisWeek();
                                      }else if(_controller.period?.value==1){
                                        period=0;
                                        cubit.getSalesReportAnalysisPast(1);
                                      }else if(_controller.period?.value==2){
                                        period=0;
                                        cubit.getSalesReportAnalysisThisMonth();
                                      }else if(_controller.period?.value==3){
                                        period=0;
                                        cubit.getSalesReportAnalysisPast(3);
                                      }else if(_controller.period?.value==4){
                                        period=4;
                                        String startDate =DateFormat('yyyy-MM-dd').format(
                                            _controller.selectedDateRange.value![0]!);
                                        String endDate =DateFormat('yyyy-MM-dd').format(
                                            _controller.selectedDateRange.value![1]!);
                                        cubit.getSalesReportAnalysisRange(startDate, endDate);
                                      }
                                    },
                                    child: AnimatedContainer(
                                        width:(_controller.period?.value==4)?280.w:150.w,
                                        duration: Duration(seconds: 1),
                                        child: CalendarOptions(
                                          selectedOption: _controller.period?.value,)),
                                  );
                                })
                                // customText1(DateFormat("dd MMMM yyyy").
                                // format(DateTime.now()), kBlackB600, 14.sp),
                              ],
                            ),
                          ),
                          Gap(25),
                          Container(
                            height: 300.h,
                            child: AnimationLimiter(
                              child: GridView.builder(
                                physics: BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return
                                    AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      duration: Duration(milliseconds: 500),
                                      columnCount: 2,
                                      child: ScaleAnimation(
                                        duration: Duration(milliseconds: 900),
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        //child: Container(),
                                        child: FadeInAnimation(
                                          child: ReportCard(

                                            title: // "Test",
                                             _controller.saleReportTitles[index],
                                            amount:
                                             getSaleAmount( index,_controller.period!.value)??0,
                                            percentageIncreaseDecrease:
                                            calculatePercentage(_controller.period!.value,index),
                                            period: _controller.period!.value,
                                            isGradeVisible: ( _controller.period!.value==1||
                                                _controller.period!.value==3)?false:true,
                                          ),
                                        ),
                                      ),
                                    );
                                },
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // number of items in each row
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.5
                                  // spacing between rows
                                  // spacing between columns
                                ),
                              ),
                            ),
                          ),
                         Gap(10),
                          Container(
                            height: 45.h,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customText1("Inventory report", kBlack, ( _controller.
                                inventoryPeriod.value==4)?14.sp:18.sp),
                                GestureDetector(
                                  onTap: () async {
                                    _controller.inventoryPeriod.value =
                                    await Get.bottomSheet(Container(
                                        height: 380.h,
                                        child: ReportDateFilter()));
                                    print(_controller.inventoryPeriod.value);
                                    if(_controller.inventoryPeriod.value!=4){
                                      iPeriod=0;
                                      cubit.getProductReportAnalysis(
                                          _controller.inventoryPeriod.value
                                      );
                                    }else{
                                      iPeriod=4;
                                      String startDate =DateFormat('yyyy-MM-dd').format(
                                          _controller.selectedDateRange.value![0]!);
                                      String endDate =DateFormat('yyyy-MM-dd').format(
                                          _controller.selectedDateRange.value![1]!);
                                      // print("This is start: $startDate");
                                      // print("This is end: $endDate");
                                     cubit.getProductReportAnalysisRange(startDate, endDate);
                                    }
                                  },
                                  child: AnimatedContainer(
                                      width:( _controller.
                                      inventoryPeriod.value==4)?280.w: 150.w,
                                      duration: Duration(seconds: 1),
                                      child: CalendarOptions(selectedOption: _controller.
                                      inventoryPeriod.value,)),
                                )
                                // customText1(DateFormat("dd MMMM yyyy").
                                // format(DateTime.now()), kBlackB600, 14.sp),
                              ],
                            ),
                          ),
                          Gap(20),
                          Container(
                            height: 150.h,
                            child: AnimationLimiter(
                              child: GridView.builder(
                                physics: BouncingScrollPhysics(
                                    parent: NeverScrollableScrollPhysics()),
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  return
                                    AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      duration: Duration(milliseconds: 500),
                                      columnCount: 2,
                                      child: ScaleAnimation(
                                        duration: Duration(milliseconds: 900),
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        child: FadeInAnimation(
                                          child: ReportCard(
                                              title:
                                             // "Testt",
                                              _controller.inventoryReportTitles[index],
                                              amount:
                                              (index==0)? productAnalysis!.sold.toDouble():
                                              productAnalysis!.stock.toDouble(),
                                              percentageIncreaseDecrease: 0,
                                              period: _controller.period!.value,
                                            isProduct: true,
                                            isGradeVisible: false,
                                          ),
                                       // child: Container(),
                                        ),
                                      ),
                                    );
                                },
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // number of items in each row
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.5
                                  // spacing between rows
                                  // spacing between columns
                                ),
                              ),
                            ),
                          ),
                          Gap(20),
                          SizedBox(
                              height: 500.h,
                            child: BestPerformingProductDesign(
                               cubit: cubit,
                               performingAnalysis: _performingAnalysis,))
                        ],
                      ),
                    ),
                  );

            }),
          ),
        ),

         isLoading: state is ReportAnalysisDownloadLoadingState
        //isLoading: isLoading
      ),
      isLoading: isFirst
    );
  },
);
  }
  double?getSaleAmount( int position,int period) {
    if(period==0){
      switch (position){
        case 0:return salesAnalysis?.thisWeek?.sales;
        case 1: return salesAnalysis?.thisWeek?.gross;
        case 2: return salesAnalysis?.thisWeek?.offline;
        case 3: return salesAnalysis?.thisWeek?.order;
      }
    }else if(period == 2){
      switch (position){
        case 0:return salesAnalysisThisMontkh?.thisMonth?.sales;
        case 1: return salesAnalysisThisMontkh?.thisMonth?.gross;
        case 2: return salesAnalysisThisMontkh?.thisMonth?.offline;
        case 3: return salesAnalysisThisMontkh?.thisMonth?.order;
      }
    }else{
      switch (position){
        case 0:return salesAnalysisPast?.sales;
        case 1: return salesAnalysisPast?.gross;
        case 2: return salesAnalysisPast?.offline;
        case 3: return salesAnalysisPast?.order;
      }
    }
    return 0;
  }

  double? getGrossProfit(){
   List<double> sellingPrice=[];
   List<double> costPrice=[];
 //  salesAnalysis?.lastWeek.
  }
  num calculatePercentage(int period, int position) {
  // print("this is the value sales last week: ${salesAnalysis?.lastWeek.runtimeType}");
  // print("this is the value sales this week: ${salesAnalysis?.thisWeek.runtimeType}");
    if (period==0) {

          switch (position) {
            case 0:
              {
             double?  previousTotal = salesAnalysis?.lastWeek?.sales.toDouble();
               double? presentTotal = salesAnalysis?.thisWeek?.sales.toDouble();
                if(presentTotal==null||previousTotal==null){
                  return 0;
                }else {
                  double difference = presentTotal - previousTotal;
                  if (previousTotal == 0 && presentTotal == 0) {
                    return 0;
                  } else if (previousTotal == 0) {
                    return 100;
                  }
                  return ((difference / previousTotal) * 100);
                }
              }
            case 1:return 0;
            case 2:{
               double? previousTotal = salesAnalysis?.lastWeek?.offline.toDouble();
               double? presentTotal = salesAnalysis?.thisWeek?.offline.toDouble();
                if(presentTotal==null||previousTotal==null){
                  return 0;
                }else {
                  double difference = presentTotal - previousTotal;
                  if (previousTotal == 0 && presentTotal == 0) {
                    return 0;
                  } else if (previousTotal == 0) {
                    return 100;
                  }
                  return ((difference / previousTotal) * 100);
                }
              }
            case 3:
              {
               double? previousTotal = salesAnalysis?.lastWeek?.order.toDouble();
                double? presentTotal = salesAnalysis?.thisWeek?.order.toDouble();
                if(presentTotal==null||previousTotal==null){
                  return 0;
                }else {
                  double difference = presentTotal - previousTotal;
                  if (previousTotal == 0 && presentTotal == 0) {
                    return 0;
                  } else if (previousTotal == 0) {
                    return 100;
                  }
                  return ((difference / previousTotal) * 100);
                }
              }
          }
        }
    else if(period == 2) {
          switch(position){
            case 0: {
              double? previousTotal = salesAnalysisThisMontkh?.lastMonth?.order.toDouble();
              double? presentTotal = salesAnalysisThisMontkh?.thisMonth?.order.toDouble();
              if(presentTotal==null||previousTotal==null){
                return 0;
              }
              else {
                double difference = presentTotal - previousTotal;
                if (previousTotal == 0 && presentTotal == 0) {
                  return 0;
                }
                else if (previousTotal == 0) {
                  return 100;
                }
                return ((difference / previousTotal) * 100);
              }
            }
            case 1: {
              double? previousTotal = salesAnalysisThisMontkh?.lastMonth?.gross.toDouble();
              double? presentTotal = salesAnalysisThisMontkh?.thisMonth?.gross.toDouble();
              if(presentTotal==null||previousTotal==null){
                return 0;
              }
              else {
                double difference = presentTotal - previousTotal;
                if (previousTotal == 0 && presentTotal == 0) {
                  return 0;
                } else if (previousTotal == 0) {
                  return 100;
                }
                return ((difference / previousTotal) * 100);
              }
            }
            case 2: {
              double? previousTotal = salesAnalysisThisMontkh?.lastMonth?.offline.toDouble();
              double? presentTotal = salesAnalysisThisMontkh?.thisMonth?.offline.toDouble();
              if(presentTotal==null||previousTotal==null){
                return 0;
              }
              else {
                double difference = presentTotal - previousTotal;
                if (previousTotal == 0 && presentTotal == 0) {
                  return 0;
                }
                else if (previousTotal == 0) {
                  return 100;
                }
                return ((difference / previousTotal) * 100);
              }
            }
            case 3:{
              double? previousTotal = salesAnalysisThisMontkh?.lastMonth?.sales.toDouble();
              double? presentTotal = salesAnalysisThisMontkh?.thisMonth?.sales.toDouble();
              if(presentTotal==null||previousTotal==null){
                return 0;
              }
              else {
                double difference = presentTotal - previousTotal;
                if (previousTotal == 0 && presentTotal == 0) {
                  return 0;
                } else if (previousTotal == 0) {
                  return 100;
                }
                return ((difference / previousTotal) * 100);
              }
            }
           }
    }
    else{
      switch(position){
        case 0: {
          double? previousTotal = salesAnalysisPast?.sales.toDouble();
          double? presentTotal = salesAnalysisPast?.sales.toDouble();
          if(presentTotal==null||previousTotal==null){
            return 0;
          }
          else {
            double difference = presentTotal - previousTotal;
            if (previousTotal == 0 && presentTotal == 0) {
              return 0;
            } else if (previousTotal == 0) {
              return 100;
            }
            return ((difference / previousTotal) * 100);
          }
        }
        case 1:  {
          double? previousTotal = salesAnalysisPast?.gross.toDouble();
          double? presentTotal = salesAnalysisPast?.gross.toDouble();
          if(presentTotal==null||previousTotal==null){
            return 0;
          }
          else {
            double difference = presentTotal - previousTotal;
            if (previousTotal == 0 && presentTotal == 0) {
              return 0;
            } else if (previousTotal == 0) {
              return 100;
            }
            return ((difference / previousTotal) * 100);
          }
        }
        case 2: {
          double? previousTotal = salesAnalysisPast?.offline.toDouble();
          double? presentTotal = salesAnalysisPast?.offline.toDouble();
          if(presentTotal==null||previousTotal==null){
            return 0;
          }
          else {
            double difference = presentTotal - previousTotal;
            if (previousTotal == 0 && presentTotal == 0) {
              return 0;
            } else if (previousTotal == 0) {
              return 100;
            }
            return ((difference / previousTotal) * 100);
          }
        }
        case 3:{
          double? previousTotal = salesAnalysisPast?.order.toDouble();
          double? presentTotal = salesAnalysisPast?.order.toDouble();
          if(presentTotal==null||previousTotal==null){
            return 0;
          }
          else {
            double difference = presentTotal - previousTotal;
            if (previousTotal == 0 && presentTotal == 0) {
              return 0;
            } else if (previousTotal == 0) {
              return 100;
            }
            return ((difference / previousTotal) * 100);
          }
        }
      }
    }
    return 0;
  }

  void setSalesAnalysisTempData(SaleAnalysisSuccess state) {
    // print("ressssspppp: ${state.response.runtimeType}");
    switch (_controller.period!.value){
      case 0:saleAnalysisThisWeek=state.response;
      break;
      case 1:saleAnalysisLastWeek=state.response;
      break;
      case 2:saleAnalysisThisMonth=state.response;
      break;
      case 3: saleAnalysisLastMonth=state.response;
      break;
    }
  }

  void setProductAnalysisTempData(ProductAnalysisSuccess state) {
    print("resp: ${state.response.runtimeType}");
    switch (_controller.inventoryPeriod.value){
      case 0:productAnalysisThisWeek=state.response;
      break;
      case 1:productAnalysisLastWeek=state.response;
      break;
      case 2:productAnalysisThisMonth=state.response;
      break;
      case 3: productAnalysisLastMonth=state.response;
      break;
    }
  }

}

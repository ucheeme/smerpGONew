import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/cubit/reportAnalysisDownload/report_analysis_download_cubit.dart';
import 'package:smerp_go/utils/reportUiKit.dart';

import '../controller/report.dart';
import '../model/response/report/performingAnalysis.dart';
import 'appColors.dart';
import 'appDesignUtil.dart';
import 'bestProductTab.dart';
import 'downloadAsImage.dart';
import 'mockdata/tempData.dart';

class BestPerformingProductDesign extends StatefulWidget {
  final ReportAnalysisDownloadCubit cubit;
  final PerformingAnalysis? performingAnalysis;
  BestPerformingProductDesign({super.key, this.performingAnalysis, required this.cubit});

  @override
  State<BestPerformingProductDesign> createState() =>
      _BestPerformingProductDesignState();
}

class _BestPerformingProductDesignState
    extends State<BestPerformingProductDesign> with TickerProviderStateMixin {
  var _controller = Get.put(ReportController());
  RefreshController refreshController =
  RefreshController(initialRefresh: false);
  RxInt numberOfOrders = 50.obs;

@override
  void initState() {
    _controller.bestPerformingProductTabController = TabController(length: 4, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ReportAnalysisDownloadCubit, ReportAnalysisDownloadState>(

  builder: (context, state) {
    if(state is ReportAnalysisDownloadErrorState){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          showToast(state.errorResponse.message);
        });
      });

      widget.cubit.resetState();
    }
    if(state is PerformingProductAnalysisSuccess){
      print("this is the performance for this month: ${state.response.thisMonth}");
      _controller.performingAnalysis= state.response;
      performingAnalysis=state.response;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero,(){
          _controller.bestPerformingProductList.value= _controller.performingAnalysis!.thisWeek;
          _controller.bestPerformingProductListLastMonth.value=_controller.performingAnalysis!.lastMonth;
          _controller.bestPerformingProductListLastWeek.value=_controller.performingAnalysis!.lastWeek;
          _controller.bestPerformingProductListThisMonth.value=_controller.performingAnalysis!.thisMonth;

         _controller.bestPerformingProductList.value.sort((a,b)=>b.count.compareTo(a.count));
          _controller.bestPerformingProductListLastMonth.value.sort((a,b)=>b.count.compareTo(a.count));
          _controller.bestPerformingProductListLastWeek.value.sort((a,b)=>b.count.compareTo(a.count));
          _controller.bestPerformingProductListThisMonth.value.sort((a,b)=>b.count.compareTo(a.count));
        });
        refreshController.refreshCompleted();
      });
      widget.cubit.resetState();
    }
    return Scaffold(
      body: Container(
        height: 447.h,
        width: 398.w,
        padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
        decoration: BoxDecoration(
            color: kLightPinkPin.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(20.r))
        ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
              children: [
                SizedBox(
                  width:double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customText1("Best performing product", kBlack, 16.sp,
                          fontFamily: fontFamilyInter,
                          fontWeight: FontWeight.w400),
                      Image.asset(
                        "assets/arrow-swap.png", width: 16.w, height: 16.h,
                        fit: BoxFit.scaleDown,)
                    ],
                  ),
                ),
                Gap(20),
                Container(
                  width:double.infinity,
                  height: 0.4.h,
                  decoration: BoxDecoration(
                      color: kBlackB600,
                      border: Border.all(color: kBlack.withOpacity(0.5),width: 0.5)
                  ),
                ),
                Gap(30),
                BestProductTab(),
                Gap(20),
                SizedBox(
                  height: 290.h,
                  child: SmartRefresher(
                    controller: refreshController,
                    enablePullDown: true,
                    header: ClassicHeader(),
                    onRefresh: onRefresh,
                    child: Container(height: 290.h,
                      child: TabBarView(
                        controller: _controller.bestPerformingProductTabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                           height: 280.h,
                            color: Colors.transparent,
                            child: (_controller.bestPerformingProductList.value.isEmpty)?
                            emptyReportPart("sales",
                                image: "assets/reportEmpty.svg",
                              header: "No Report to show",
                            ):
                            ListView.builder(
                              //physics: NeverScrollableScrollPhysics(),
                                itemCount: _controller
                                    .bestPerformingProductList.value.length,
                                itemBuilder: (context, index) {
                                  print("the length is ${_controller.bestPerformingProductList.length}");
                                  return Column(
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        height:50.h,
                                        child: BestPerformingProductListUI(
                                            productName:_controller.bestPerformingProductList.value[index].productName ,
                                            position: index + 1,
                                            numberOfTimesProductOrdered:_controller.
                                            bestPerformingProductList.value[index].count.obs
                                        ),
                                      ),
                                      Gap(10)
                                    ],
                                  );
                                }),
                          ),
                          Container(
                            height: 280.h,
                            child:  (_controller.bestPerformingProductListLastWeek.value.isEmpty)?
                            emptyReportPart("sales",
                              image: "assets/reportEmpty.svg",
                              header: "No Report to show",
                            ):ListView.builder(
                              //physics: NeverScrollableScrollPhysics(),
                                itemCount: _controller.bestPerformingProductListLastWeek.value.length,
                                itemBuilder: (context, index) {
                                 // print("the length is ${_controller.bestPerformingProductList.length}");
                                  return Column(
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        height:50.h,
                                        child: BestPerformingProductListUI(
                                            productName:_controller.bestPerformingProductListLastWeek.value[index].productName ,
                                            position: index + 1,
                                            numberOfTimesProductOrdered:_controller.
                                            bestPerformingProductListLastWeek.value[index].count.obs
                                        ),
                                      ),
                                      Gap(10)
                                    ],
                                  );
                                }),
                          ),
                          Container(
                            height: 280.h,
                            child:  (_controller.bestPerformingProductListThisMonth.value.isEmpty)?
                            emptyReportPart("sales",
                              image: "assets/reportEmpty.svg",
                              header: "No Report to show",
                            ):ListView.builder(
                              //physics: NeverScrollableScrollPhysics(),
                                itemCount: _controller.bestPerformingProductListThisMonth.value.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        height:50.h,
                                        child: BestPerformingProductListUI(
                                            productName:_controller.bestPerformingProductListThisMonth.value[index].productName ,
                                            position: index + 1,
                                            numberOfTimesProductOrdered:_controller.bestPerformingProductListThisMonth.value[index].count.obs
                                        ),
                                      ),
                                      Gap(10)
                                    ],
                                  );
                                }),
                          ),
                          Container(
                            height: 280.h,
                            child:  (_controller.bestPerformingProductListLastMonth.value.isEmpty)?
                            emptyReportPart("sales",
                              image: "assets/reportEmpty.svg",
                              header: "No Report to show",
                            ):ListView.builder(
                              //physics: NeverScrollableScrollPhysics(),
                                itemCount: _controller.bestPerformingProductListLastMonth.value.length,
                                itemBuilder: (context, index) {
                                 // print("the length is ${_controller.bestPerformingProductListLastMonth.value.length}");
                                  return Column(
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        height:50.h,
                                        child: BestPerformingProductListUI(
                                            productName:_controller.bestPerformingProductListLastMonth.value[index].productName ,
                                            position: index + 1,
                                            numberOfTimesProductOrdered:_controller.bestPerformingProductListLastMonth.value[index].count.obs
                                        ),
                                      ),
                                      Gap(10)
                                    ],
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

              ]

          ),
        ),
      ),
    );
  },
);
  }
  Future<void> onRefresh()async{
    widget.cubit.getBestPerformingProductReportAnalysis();
  }
}

Widget emptyReportPart(String title,
    {String image = "assets/emptySales.svg",
      header= "",
    }) {
  return SingleChildScrollView(
    child: Center(
      child: Container(
        height: 280.h,
        child: Column(
          children: [
            Gap(30),
            Center(child: SvgPicture.asset(image,
              height: 174.19.h,
              width: 200.w,)),
            Gap(30),
            Center(
                child: customText1(header,
                    kBlack, 18.sp, fontWeight: FontWeight.w400)
            ),
          ],
        ),
      ),
    ),
  );
}

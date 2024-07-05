import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:screenshot/screenshot.dart';
import 'package:smerp_go/screens/bottomNav/screens/profile/profileList.dart';
import 'package:smerp_go/screens/bottomNav/screens/report/downloadReport.dart';
import 'package:smerp_go/screens/bottomNav/screens/report/reportHome.dart';
import 'package:smerp_go/screens/bottomNav/screens/report/weekReport.dart';
import 'package:smerp_go/screens/bottomsheets/downloadFormat.dart';
import 'package:smerp_go/utils/UserUtils.dart';
import 'package:smerp_go/utils/appColors.dart';

import '../../../../controller/reportsController.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../../utils/app_services/helperClass.dart';
import '../../../../utils/collectionUiKits.dart';
import '../sales/addNewSale.dart';
import 'downloadReportStepTwo.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report>with TickerProviderStateMixin {
  var _controller = Get.put(ReportsControler());
  TabController? tabController;
  var category = "";

  ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    tabController= TabController(length: 3, vsync: this);
    _controller.isLastWeek.value = false;
    _controller.isThisMonth.value = false;
    _controller.isLastMonth.value = false;
    _controller.isMonth.value=false;
    _controller.isThisWeek.value = true;
_controller.isMonth.value= false;
// _controller.saleReportByWeek();
    super.initState();
  }
  Uint8List? image;
  @override
  Widget build(BuildContext context) {

    return Obx(() {

      return OverlayLoaderWithAppIcon(
        isLoading: _controller.isLoading.value,
        overlayBackgroundColor: kBlackB600,
        circularProgressColor: kAppBlue,
        appIconSize: 40.h,
        appIcon: SizedBox(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
            backgroundColor: kWhite,
            appBar: PreferredSize(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      dashboardAppBarWidget(() {
                        Get.to(
                              ()=>Profile(),
                          duration: Duration(seconds: 1),
                          transition: Transition
                              .cupertino,
                        );
                      }, userImage.value, "Report & Analysis",context),

                      Container(
                        height: 78.h,
                        color:  kLightPinkPin,
                        child: CustomTab(tab1: "Report & Analysis",tab2: "Download report",
                          tabController: tabController,)
                      ),
                    ],
                  ),
                ),
                preferredSize: Size.fromHeight(160.h)),
            body:  Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 16.w),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Gap(20),
                        Container(
                          height: 700.h,
                          child: TabBarView(
                            controller:tabController ,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              ReportAndAnalysis(),
                              DownloadReport(tabController: tabController,),
                              DownloadReportStepTwoDesign(tabController: tabController,)
                            ],
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
        ),
      );
    });
  }

}




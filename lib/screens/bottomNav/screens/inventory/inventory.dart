import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/model/response/inventoryList.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/addNewProduct.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/allIProductd.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/collections/collectionUiList.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/inventoryHome.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/viewProduct.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';
import 'package:smerp_go/utils/app_services/helperClass.dart';
import 'package:smerp_go/utils/mockdata/tempData.dart';

import '../../../../controller/dashboardController.dart';
import '../../../../controller/inventoryController.dart';
import '../../../../utils/UserUtils.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/collectionUiKits.dart';
import '../../../../utils/gridFilter.dart';
import '../../../../utils/mockdata/mockInventoryData.dart';
import '../../../../utils/mockdata/mockProductsData.dart';
import '../../../bottomsheets/dashboardFilterOption.dart';
import '../profile/profileList.dart';
import 'editProduct.dart';

class Inventory extends StatefulWidget {
  int? tabPosition;
  Inventory({this.tabPosition,Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> with TickerProviderStateMixin{

  TabController? tabController;

  @override
  void initState() {
    // _bankChoose = mockProductData[0];
     tabController= TabController(length: 2, vsync: this);
     if(widget.tabPosition!=null){
       tabController?.animateTo(1);
     }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor:kWhite ,
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
                        }, userImage.value, "Inventory",context),
                  
                      Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        height: 90.h,
                        color:  kLightPinkPin,
                       child: (widget.tabPosition!=null)?
                       CustomTab(tab1: "Inventory",tab2: "Collection",
                           tabController: tabController,isCollection: true,)
                           :
                       CustomTab(tab1: "Inventory",tab2: "Collection",
                            tabController: tabController),
                      ),
                    ],
                  ),
                ), preferredSize: Size.fromHeight(160.h )),
            body: Column(
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
                            InventoryMain(),
                           CollectionHome(),
                           // UserGridView(users: users,)
                          ],
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          );
  }


}

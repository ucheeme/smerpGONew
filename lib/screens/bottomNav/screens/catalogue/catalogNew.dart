import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/allIProductd.dart';

import '../../../../controller/catalogueController.dart';
import '../../../../controller/inventoryController.dart';
import '../../../../model/response/catalogListResponse.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/UserUtils.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../../utils/app_services/helperClass.dart';
import '../../../../utils/mockdata/tempData.dart';
import '../inventory/addNewProduct.dart';
import '../profile/profileList.dart';
import 'catalogDesignView.dart';

class CatalogNew extends StatefulWidget {
  const CatalogNew({super.key});

  @override
  State<CatalogNew> createState() => _CatalogNewState();
}

class _CatalogNewState extends State<CatalogNew> with TickerProviderStateMixin {
  var _controller = Get.put(CatalogueController());
  var _controllerProducrt = Get.put(InventoryController());
  bool isSwitched = false;
  String category = "";
  TabController? _controllerTab;
  List<CatalogData> catalogFullList = [];
  List<CatalogFull> catalogs = [];
  var loading = false;

  int _selectedIndex = 0;

  @override
  void initState() {
    _controllerTab = TabController(length: 8, vsync: this);
    _controller.isAll.value = true;
    dashboardApi();
    getCatalogCall();

    super.initState();
    if (!isCatalogListHasRun.value) {
      getCatalogCall();
    } else {
      print("alreadyCalled");
      print(catalogsFTemp.length);
      catalogs = catalogsFTemp;
    }
  }

  void dashboardApi() async {
    await _controllerProducrt.inventoryDashboard();
    setState(() {
      _controllerProducrt.inventoryCount.value =
          _controllerProducrt.inventoryCount.value;
    });
  }

  RefreshController refreshController =
  RefreshController(initialRefresh: false);

  void getCatalogCall() async {
    setState(() {
      loading = true;
    });
    await _controllerProducrt.allInventorylist();
    catalogFullList = await _controller.allCatalogListAsShownToUsers();
    //Future.delayed(Duration(seconds: 10), () {


    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {

        setState(() {
          _controllerProducrt.inventoryAmount.value =
              _controllerProducrt.inventoryAmount.value;
          _controllerProducrt.inventoryCount.value =
              _controllerProducrt.inventoryCount.value;
          loading=false;
        });
        // if (catalogFullList.isNotEmpty) {
        //   loading = false;
        // } else if (catalogFullList.isEmpty) {
        //   Future.delayed(Duration(seconds: 10), () {
        //     loading = false;
        //   });
        // }
      });

    catalogs = catalogsFTemp;
    isCatalogListHasRun.value = true;
    Future.delayed(Duration(seconds: 2), () {
      loading = false;
    });
  }

  RxBool isSearch = false.obs;
  String searchValue = "";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<CatalogFull> filterByCategoryFilter(String enterValue, String filter) {
    List<CatalogFull> result = [];
    if (enterValue.isEmpty) {
      _controller.catalogsF.value = catalogsFTemp;
    } else {
      _controller.catalogsF.value = catalogsFTemp.where((element) =>
      element.catalogData.productCategory.toLowerCase() ==
          enterValue.toLowerCase()).toList();
    }
    result = _controller.catalogsF.value.where((element) =>
        element.catalogData.productName.toLowerCase().contains(
            filter.toLowerCase())).toList();
    _controller.checkIfAllProductInCategoryIsVisible(
        _controller.catalogsF.value, enterValue);
    return _controller.catalogsF.value;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return overLay(
          DefaultTabController(
              length: 8,
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: PreferredSize(
                      child: dashboardAppBarWidget(() {
                        Get.to(
                          Profile(),
                          duration: Duration(seconds: 1),
                          transition: Transition.cupertino,
                        );
                      }, userImage.value, "Catalogue", context),
                      preferredSize: Size.fromHeight(80.h)),
                  body: (_controllerProducrt.inventoryCount.value == "0")
                      ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: emptyPart("Product", () {
                      Get.to(AddNewProduct(),
                          duration: Duration(seconds: 1),
                          // curve: Curves.bounceIn,
                          transition: Transition.cupertino);
                    },
                        header: "No sale yet",
                        headerDetail: "Oops, You are yet to make a sale",
                        image: "assets/emptyCatalog.svg"),
                  )
                      :
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      color: kWhite,
                      child: Column(children: [
                        gapHeight(19.h),
                        customSearchDesign(
                          "Search your catalog",
                              (String value) {
                            isSearch.value = true;
                            setState(() {
                              searchValue = value;
                            });
                            _controller.filterByName(value);
                            setState(() {
                              catalogs = _controller.catalogsF.value;
                            });
                          },
                          inputType: TextInputType.text,
                        ),
                        gapHeight(20.h),
                        ButtonsTabBar(
                          //  controller: _controllerTab,
                         //height: 58.h,
                         height: 58.h,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15.w,
                              vertical: 10.h),
                          unselectedDecoration: BoxDecoration(
                              color:kLightPink.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                  color: kLightPink.withOpacity(0.4), width: 0.5.w)),
                          unselectedBorderColor: kCalendarLightPink,
                          decoration: BoxDecoration(
                            color: kLightPink,
                            
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          borderColor: kAppBlue,
                          borderWidth: 0.5.w,
                          radius: 15.r,
                          unselectedLabelStyle: TextStyle(
                            color: kBlack,
                            fontSize: 14.sp,
                            fontFamily: "inter",
                            fontWeight: FontWeight.normal,
                          ),
                          labelStyle: TextStyle(
                            color: kAppBlue,
                            fontSize: 14.sp,
                            fontFamily: "inter",
                            fontWeight: FontWeight.normal,
                          ),

                          tabs: [
                            Tab(text: categories[0]),
                            Tab(text: categories[1]),
                            Tab(text: categories[2]),
                            Tab(text: categories[3]),
                            Tab(text: categories[4]),
                            Tab(text: categories[5]),
                            Tab(text: categories[6]),
                            Tab(text: categories[7])
                          ],
                        ),
                        Expanded(
                          child: Obx(() {
                            //  reload();
                            return TabBarView(
                              children: [
                                CatalogDesignView(
                                  catalogName: "",
                                  mockData: (isSearch.value) ?
                                  _controller.filterByCategoryFilter(
                                      "", searchValue) :
                                  catalogsFTemp,
                                  isSwitched:
                                  _controller
                                      .checkIfAllProductInCategoryIsVisible(
                                      catalogsFTemp, ""),
                                  value: searchValue,
                                ),
                                CatalogDesignView(
                                  catalogName: "Fashion",
                                  mockData:
                                  _controller.filterByCategory("Fashion"),
                                  isSwitched:_controller.allFashionVisible.value,
                                  // _controller
                                  //     .checkIfAllProductInCategoryIsVisible(
                                  //     catalogsFTemp, "Fashion"),
                                  category: "Fashion",
                                  value: searchValue,
                                ),
                                CatalogDesignView(
                                  catalogName: "Food",
                                  mockData:
                                  _controller.filterByCategory("Food"),
                                  isSwitched:_controller.allFoodVisible.value,
                                  category: "Food",
                                  value: searchValue,
                                ),
                                CatalogDesignView(
                                  catalogName: "Sport",
                                  mockData:
                                  _controller.filterByCategory("Sport"),
                                 isSwitched:_controller.allSportVisible.value,
                                  // _controller
                                  //     .checkIfAllProductInCategoryIsVisible(
                                  //     catalogsFTemp, "Sport"),
                                  category: "Sport",
                                  value: searchValue,
                                ),
                                CatalogDesignView(
                                  catalogName: "Electronics",
                                  mockData: _controller
                                      .filterByCategory("Electronics",
                                  ),
                                  isSwitched: _controller.allElectronicsVisible.value,
                                  category: "Electronics",
                                  value: searchValue,
                                ),
                                CatalogDesignView(
                                  catalogName: "Gadgets",
                                  mockData:
                                  _controller.filterByCategory("Gadgets"),
                                  isSwitched:_controller.allGadgetsVisible.value,
                                  category: "Gadget",
                                  value: searchValue,
                                ),
                                CatalogDesignView(
                                  catalogName: "Health & Beauty",
                                  mockData: _controller
                                      .filterByCategory("Health & Beauty"),
                                  isSwitched: _controller.allHealthBeautyVisible.value,
                                  category: "HB",
                                  value: searchValue,
                                ),
                                CatalogDesignView(
                                  catalogName: "Others",
                                  mockData:
                                  _controller.filterByCategory("Other"),
                                  isSwitched:  _controller.allOtherVisible.value,
                                  value: searchValue,
                                  category: "Other",
                                ),
                              ],
                            );
                          }),
                        ),
                      ]),
                    ),
                  ))),
          isLoading: loading
      );
    });
  }

  Future<void> onRefresh() async {
    dashboardApi();
    catalogFullList = await _controller.allCatalogListAsShownToUsers(
        isRefresh: true, refreshController: refreshController);
    setState(() {
      catalogFullList = catalogFullList;
    });
  }
}

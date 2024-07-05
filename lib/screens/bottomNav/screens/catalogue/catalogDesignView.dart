import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
import '../../../../utils/customToggle.dart';
import '../../../../utils/mockdata/tempData.dart';
import '../inventory/addNewProduct.dart';
import '../profile/profileList.dart';

class CatalogDesignView extends StatefulWidget {
  String catalogName;
  List<CatalogFull> mockData;
  bool? isSwitched;
  String? value;
  String? category;

  CatalogDesignView({super.key,
    required this.catalogName,
    required this.mockData,
    this.isSwitched, this.value, this.category});

  @override
  State<CatalogDesignView> createState() => _CatalogDesignViewState();
}

class _CatalogDesignViewState extends State<CatalogDesignView> {
  var _controller = Get.put(CatalogueController());
  var _controllerProducrt = Get.put(InventoryController());
  bool isSwitched = false;
  var loading = false;
  List<CatalogData> catalogFullList = [];
  RxList<CatalogFull> catalogs = RxList();
  RxList<CatalogFull> initialCatalogs = RxList();
  RxBool publishUpdated = false.obs;
  RxBool isLoading = false.obs;
  bool initialValue =false;
  bool initialValueProduct =false;
  bool isOn= false;
  bool isOff= false;
  @override
  void initState() {
    print("init is called ");
    print(widget.mockData.length);
    catalogs.value = widget.mockData;
    isSwitched = widget.isSwitched!;

   // reAssignCatalog(widget.catalogName);
    super.initState();

  }
void categoryLength(String categoryName)async {
  initialCatalogs.value = _controller.filterByCategory(widget.catalogName);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        initialCatalogs= initialCatalogs;
      });
    });
}
  void getCatalogCall() async {
    await _controllerProducrt.allInventorylist();
    catalogFullList = await _controller.allCatalogListAsShownToUsers();
    //Future.delayed(Duration(seconds: 10), () {
    _controller.isLoading.value = true;
    // });
  //  WidgetsBinding.instance.addPostFrameCallback((_) {

      setState(() {
        catalogs.value =catalogsFTemp;
      });
  //  });
    // catalogs = catalogsFTemp;
    isCatalogListHasRun.value = true;
    Future.delayed(Duration(seconds: 2), () {
      _controller.isLoading.value = false;
    });
  }

  List<CatalogFull> filterByName(String enteredValue) {
    catalogs.value = catalogsFTemp.where((element) =>
        element.catalogData.productName.toLowerCase().
        contains(enteredValue.toLowerCase())).toList();
    return catalogs.value;
  }

  List<CatalogFull> filterByNameCategory(String enteredValue,
      List<CatalogFull> data) {
    catalogs.value = data.where((element) =>
        element.catalogData.productName.toLowerCase().
        contains(enteredValue.toLowerCase())).toList();
    setState(() {
      catalogs.value = catalogs.value;
    });
    return catalogs.value;
  }

  RefreshController refreshController =
  RefreshController(initialRefresh: false);
  var b = "ahh";

  @override
  Widget build(BuildContext context) {
    if (widget.value != null && widget.category == null) {
      catalogs.value = filterByName(widget.value!);
    } else {
      catalogs.value = filterByNameCategory(widget.value!,widget.mockData);
    }
    return Obx(() {

      return overLay(
          SingleChildScrollView(
            child: Container(
              color: kWhite,
              child: Column(
                children: [
                  Gap(10),
                  Visibility(
                    visible: (widget.mockData.isEmpty) ? false : true,
                    child:
                    Container(
                      color: kWhite,
                      height: 40.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (widget.catalogName.length > 11)
                              ? customText1(
                              "All ${widget.catalogName.replaceRange(
                                  11, widget.catalogName.length,
                                  "..")} Catalogue",
                              kBlack,
                              16.sp)
                              : customText1("All ${widget
                              .catalogName} Catalogue",
                              kBlack, 16.sp),
                          //  gapWeight(163.w),

                          Container(
                            color: kWhite,
                            width: 200.w,
                            padding: EdgeInsets.only(right: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                customText1("Publish all", kBlackB600, 16.sp),
                                gapWeight(15.w),
                               GestureDetector(
                                 //value: isSwitched,
                                 onTap: () async {
                                   initialValue = isSwitched;

                                   setState(() {
                                     loading=true;
                                     isSwitched = !isSwitched;
                                    // isSwitched = value;
                                     publishUpdated.value = true;
                                   });
                                   catalogs.clear();
                                   widget.mockData.clear();
                                   bool res =
                                   await updateCategoryPublishAll(
                                       widget.catalogName,
                                       isSwitched);
                                   if (res) {
                                     // print("this is true $res");\

                                     setState(() {
                                       widget.isSwitched = isSwitched;
                                      // isSwitched = isSwitched;
                                      // publishUpdated.value = true;
                                     });
                                   } else {
                                     print("this is false $res");
                                     setState(() {
                                       isSwitched = initialValue;
                                      // publishUpdated.value = true;
                                     });
                                   }
                                 },
                                 child: ToggleSwitch(value: isSwitched,),
                                 // inactiveTrackColor:
                                 // kInactiveLightPinkSwitch,
                                 // dragStartBehavior: DragStartBehavior.down,
                                 // activeTrackColor: kAppBlue,
                                 // activeColor: kLightPink,
                                 // inactiveThumbColor:
                                 // kInactiveLightPinkSwitchBu,
                               )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  gapHeight(37.5.h),
                  (catalogs.isEmpty)
                      ?
                  Container(
                    color: kWhite,
                    height: 400.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customText1(
                            "You do not have any product for this category",
                            kBlack,
                            16.sp,
                            fontFamily: fontFamily),
                        gapHeight(30.h),
                        GestureDetector(
                          onTap: () async {
                            Get.to(AddNewProduct(),
                                duration: Duration(seconds: 1),
                                // curve: Curves.bounceIn,
                                transition: Transition.cupertino)?.whenComplete(() {
                                  print("called");
                              getCatalogCall();
                              setState(() {
                              });
                            });

                          },
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: kAppBlue,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Center(
                              child: customText1(
                                  "Add new product to this category",
                                  kDashboardColorBorder,
                                  16.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                      :
                  Container(
                    color: kWhite,
                    height: 550.h,
                    child: SmartRefresher(
                      controller: refreshController,
                      onRefresh: onRefresh,
                      child: ListView.builder(
                          itemCount: catalogs.value.length,
                          itemBuilder: (context, index) {
                            CatalogFull mockData = catalogs[index];
                            return Column(
                              children: [
                                // catalogList(catalogs[index]),
                                Container(
                                  height: 99.h,
                                  width: 398.w,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(20.r),
                                      color: kDashboardColorBlack3),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.w,
                                        right: 10.w,
                                        top: 10.h,
                                        bottom: 10.h),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 40.h,
                                          width: 40.w,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                              kInactiveLightPinkSwitch,
                                              image: DecorationImage(
                                                  image: getImageNetwork(
                                                      (mockData.catalogData.productImage == null)
                                                          ? "" : mockData.catalogData.productImage).image,
                                                  fit: BoxFit.contain)),
                                        ),
                                     Spacer(),
                                        Container(
                                          width: 310.w,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                               height: 71.h,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    customText1(
                                                        (mockData.catalogData.productName.length > 10) ?
                                                        mockData.catalogData.productName.replaceRange(10, mockData.catalogData.productName.length, "..") :
                                                        mockData.catalogData.productName, kBlackB800, 18.sp,
                                                        fontWeight: FontWeight.w500),
                                                   Spacer(),
                                                    Container(
                                                      width: 200.w,
                                                      child: Row(
                                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          customTextnaira(
                                                              NumberFormat.simpleCurrency(name: 'NGN').format(
                                                                  double.parse(mockData.catalogData.sellingPrice.toString())
                                                              ).split(".")[0], kAppBlue, 18.sp, fontWeight: FontWeight.w500),
                                                          gapWeight(10.w),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              customText1(mockData.catalogData.quantity.toString(),
                                                                  kBlackB600, 14.sp, fontWeight: FontWeight.w400),
                                                              gapWeight(5.w),
                                                              customText1(
                                                                  mockData.catalogData.unitCategory, kBlackB600, 14.sp,
                                                                  fontWeight: FontWeight.w400),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {

                                                  setState(() {
                                                    mockData.isVisible=!mockData.isVisible;
                                                  });
                                                  bool res = await _controller.updateCatalogProductVisibility(
                                                          mockData.isVisible, mockData.catalogData.id);
                                                      if (res) {
                                                        setState(() {
                                                         // widget.isSwitched = !widget.isSwitched!;
                                                          if(mockData.isVisible==false){
                                                            isSwitched =checkIfAllItemIsTrue(widget.mockData);
                                                          }else{
                                                            isSwitched =checkIfAllItemIsTrue(widget.mockData);
                                                          }
                                                        });
                                                      }else{
                                                        setState(() {
                                                          // widget.isSwitched= isSwitched;
                                                          // isSwitched= initialValue;
                                                          mockData.isVisible= !mockData.isVisible;
                                                        });
                                                      }
                                                },
                                                child: ToggleSwitch(
                                                 value: mockData.isVisible
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                gapHeight(20.h)
                              ],
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
          isLoading: loading);
    });
  }

  bool checkIfAllItemIsTrue(List<CatalogFull> data){
    int totalCount = data.length;
    int tempCount = 0;
    for(var element in data){
      if(element.isVisible == true){
        tempCount=tempCount+1;
      }
    }
    if(tempCount == totalCount) return true; else return false;
  }

  Future<bool> updateCategoryPublishAll(String category, bool value) async {
    switch (category) {
      case "":
        {
          bool res = await _controller.updateCatalogAllProduct(value);
          if (res) {
            print("this is true $res");
            setState(() {
              // widget.isSwitched= res;
              isSwitched = value;
              loading=false;
            });
          } else {
            setState(() {
              isSwitched = initialValue;
              loading=false;
            });
          }

          return res;
        };
        break;
      case "Fashion":
        {
          // bool initialValue = value;
          bool res = await _controller.updateCatalogAllProductCata(value, 1);
          if (res) {
            print("this is the catalog length ${catalogs.length}");
            setState(() {
              widget.isSwitched = value;
              isSwitched = value;
            // catalogs.value=_controller.filterByCategory("Food");
              publishUpdated.value = true;
             // (publishUpdated.value)?
           //   print("I changed here"):print("I didnt");
              reAssignCatalog(widget.catalogName);
            });
            return res;
          } else {
            setState(() {
              widget.isSwitched = initialValue;
              isSwitched = initialValue;
             // catalogs.value=widget.mockData;
              publishUpdated.value = false;
            });
            reAssignCatalog(widget.catalogName);
            return res;
          }

        };
      case "Food":
        {
          // bool initialValue = value;
          bool res = await _controller.updateCatalogAllProductCata(value, 2);
          if (res) {
            print("this is true $res");
            setState(() {
              widget.isSwitched = value;
              isSwitched = value;
            //  catalogs.value=widget.mockData;
              publishUpdated.value = true;
            });
            reAssignCatalog(widget.catalogName);
            return res;
          } else {
            setState(() {
              widget.isSwitched = initialValue;
              isSwitched = initialValue;
              //catalogs.value=widget.mockData;
              publishUpdated.value = false;
            });
            reAssignCatalog(widget.catalogName);
            return res;
          }

        };
      case "Electronics":
        {
          // bool initialValue = value;
          bool res = await _controller.updateCatalogAllProductCata(value, 4);
          if (res) {
            print("this is true $res");
            setState(() {
              widget.isSwitched= value;
              isSwitched = value;
              //catalogs.value=widget.mockData;
              publishUpdated.value= true;
            });
            reAssignCatalog(widget.catalogName);
            return res;
          } else {
            setState(() {
              widget.isSwitched=initialValue;
              isSwitched = initialValue;
              publishUpdated.value=false;
             // catalogs.value=widget.mockData;
            });
            reAssignCatalog(widget.catalogName);
            return res;
          }

        };

      case "Gadgets":
        {

          bool res = await _controller.updateCatalogAllProductCata(value, 5);
          if (res) {
            print("this is true $res");
            setState(() {
              widget.isSwitched= value;
              isSwitched = value;
             // publishUpdated.value= true;
              //catalogs.value=widget.mockData;
            });
            reAssignCatalog(widget.catalogName);
            return res;
          } else {
            setState(() {
              widget.isSwitched=initialValue;
              isSwitched = initialValue;
             // catalogs.value=widget.mockData;
              publishUpdated.value=false;
            });
            reAssignCatalog(widget.catalogName);
            return res;
          }
        };
      case "Other":
        {
          bool res = await _controller.updateCatalogAllProductCata(value, 7);
          if (res) {
            print("this is true $res");
            setState(() {
              widget.isSwitched= value;
              isSwitched = value;
              //catalogs.value=widget.mockData;
              publishUpdated.value= true;
            });
            reAssignCatalog(widget.catalogName);
            return res;
          } else {
            setState(() {
              widget.isSwitched=initialValue;
              isSwitched = initialValue;
              //catalogs.value=widget.mockData;
              publishUpdated.value=false;
            });
            reAssignCatalog(widget.catalogName);
            return res;
          }
        };

      case "Sport":
        {

          bool res = await _controller.updateCatalogAllProductCata(value, 3);
          if (res) {
            print("this is true $res");
            setState(() {
              widget.isSwitched= value;
              isSwitched = value;
             // catalogs.value=widget.mockData;
              publishUpdated.value= true;
            });
            reAssignCatalog(widget.catalogName);
            return res;
          } else {
            setState(() {
              widget.isSwitched=initialValue;
              isSwitched = initialValue;
             // catalogs.value=widget.mockData;
              publishUpdated.value=false;
            });
            reAssignCatalog(widget.catalogName);
            return res;
          }
        };
      case "Health & Beauty":
        {

          bool res = await _controller.updateCatalogAllProductCata(value, 6);
          if (res) {
            setState(() {
              widget.isSwitched= value;
              isSwitched = value;
            //  catalogs.value=widget.mockData;
              publishUpdated.value= true;
            });
            reAssignCatalog(widget.catalogName);
            return res;
          } else {
            setState(() {
              widget.isSwitched=initialValue;
              isSwitched = initialValue;
              //catalogs.value=widget.mockData;
              publishUpdated.value=false;
            });
            reAssignCatalog(widget.catalogName);
            return res;
          }
        };
    }
    return false;
  }

  void onRefresh() {
    //dashboardApi();
    //initState();
    Future.delayed(Duration(seconds: 1),(){
      refreshController.refreshCompleted();
      setState(() {
        catalogs.value= _controller.filterByCategory(widget.catalogName);
      });
    });

  }
  void reAssignCatalog(String category){
    catalogs.value=  _controller.filterByCategory(category);
    setState(() {
  catalogs=catalogs;
    loading=false;
    initialCatalogs.length = catalogs.length;
    });
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/controller/collection.dart';
import 'package:smerp_go/cubit/products/product_cubit.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/inventoryHome.dart';
import 'package:smerp_go/screens/bottomsheets/collectionCreated.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/downloadAsImage.dart';
import 'package:smerp_go/utils/mockdata/tempData.dart';

import '../../../../../model/response/product/productList.dart';
import '../../../../../utils/appColors.dart';
import '../../../../../utils/appDesignUtil.dart';
import '../../../../../utils/collectionUiKits.dart';
import '../../../bottomNavScreen.dart';

class AddProductToCollection extends StatefulWidget {
  bool isUpdateProductCollection;
  String? url;
  List<int>? collectionList;
  int? collectionId;
  AddProductToCollection({
    required this.isUpdateProductCollection,
    this.collectionList,
    this.collectionId,
    this.url,
    super.key});

  @override
  State<AddProductToCollection> createState() => _AddProductToCollectionState();
}

class _AddProductToCollectionState extends State<AddProductToCollection> {

  var _controller = Get.put(CollectionController());
  RefreshController refreshController = RefreshController(
      initialRefresh: false);
  bool productListFetched = false;

  @override
  void initState() {
    //cubit.getProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller.getCollectionInventory(
        context, widget.isUpdateProductCollection,
    collectionProductIds: widget.collectionList
    );
    return
      BlocBuilder<CollectionCubit, CollectionState>(
        builder: (context, state) {
          if (state is ProductListErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Future.delayed(Duration.zero, () {
                showToast(state.errorResponse.message);
                // showOrderHistory(message: state.errorResponse.message);
              });
            });
            _controller.cubit.resetState();
          }
          if (state is ProductListSuccessState) {
            _controller.inventory.value = state.response ?? [];
            productListFetched = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Future.delayed(Duration.zero, () {
                collectionInventoryListTemp=_controller.inventory.value;
                _controller.assignedCollection(widget.isUpdateProductCollection,
                widget.collectionList);
              });
            });
            _controller.cubit.resetState();
          }
          if (state is CollectionUpdatedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Future.delayed(Duration.zero, () {
                Get.bottomSheet(
                    backgroundColor: kWhite,
                    CollectionCreated(
                      alertType:  "updated",
                        collectionUrl:widget.url
                    )).whenComplete(() {
                //  _controller.cubit.getCollectionList();
                  Get.back();
                  Get.back();
                });
              });
              _controller.cubit.resetState();
            });
          }
          //for deleted
          // Get.bottomSheet(
          //     backgroundColor: kWhite,
          //     CollectionDeleted()).whenComplete(() {
          //   Get.off(MainNavigationScreen(position: 1,),);
          //   _controller.cubit.getCollectionList();
          //   // showOrderHistory(message: state.errorResponse.message);
          // });
          if(state is SuccessCollectionCreatedState){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.bottomSheet(
                  backgroundColor: kWhite,
                  CollectionCreated(
                    alertType: "created",)).whenComplete(() {
                // _controller.cubit.getCollectionList();
                Get.back();
                Get.back();

             });
            });
          }
          if (state is CollectionCreatedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.bottomSheet(
                  backgroundColor: kWhite,
                  CollectionCreated(
                    alertType: "created",
                      collectionUrl:state.response.url
                  )).whenComplete(() {
                      _controller.cubit.getCollectionList();
                      Get.back();
                      Get.back();

              });
            });
          }
          return overLay(
              Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: kWhite,
                appBar: PreferredSize(
                    child: defaultDashboardAppBarWidget(() {
                      _controller.selectedProductListNumber.value = 0;
                      (widget.isUpdateProductCollection!)?
                      null:
                      _controller.selectedProductIds.clear();
                      Get.back();
                    }, "  ${(widget.isUpdateProductCollection!)
                        ? "Edit "
                        : "Add " }products to collections",),
                    preferredSize: Size.fromHeight(70.h)),
                body: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Obx(() {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Gap(10),
                          customSearchDesign(
                              "Search products", (String value) {
                            _controller.filterByName(value);
                      
                            _controller.inventory.value =
                                _controller.inventory.value;
                          },
                              inputType: TextInputType.text),
                          Gap(20),
                          Container(
                            color: kWhite,
                            height: 740.h,
                            child: SmartRefresher(
                              controller: refreshController,
                              enablePullDown: true,
                              header: ClassicHeader(),
                              onRefresh: onRefresh,
                              child: ListView.builder(
                                  itemCount: _controller.inventory.length,
                                  itemBuilder: (context, index) {
                                    if(widget.isUpdateProductCollection==true){
                      
                                    }
                                    return Obx(() {
                                      return Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                _controller.selectedProductOptions
                                                [index].value =
                                                !_controller.selectedProductOptions[index].value;
                                                _controller.addRemoveCollectionProducts(
                                                    _controller.inventory[index].id,
                                                    _controller.selectedProductOptions[index].value
                                                );
                                              },
                                              child: AddCollectionProductDesign(
                                                productAmount: _controller
                                                    .inventory[index]
                                                    .purchasePrice
                                                    .toString(),
                                                productName: _controller
                                                    .inventory[index].productName,
                                                productQuantityInStock: _controller
                                                    .inventory[index].quantity,
                                                productCategory: _controller
                                                    .inventory[index]
                                                    .productCategory,
                                                active: _controller
                                                    .selectedProductOptions[index].value,
                                              )
                                          ),
                                          gapHeight(20.h)
                                        ],
                                      );
                                    });
                                  }),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ),
                floatingActionButton:
                GestureDetector(
                  onTap: () {
                    if(widget.isUpdateProductCollection){
                      _controller.cubit.updateCollection(
                          _controller.collectionName.text,
                          widget.collectionId.toString(),
                          _controller.selectedProductIds,
                          loginData!.merchantCode,
                          collectionImage: _controller.collectionIImage.value
                      );
                    }else{
                      _controller.cubit.createCollection(
                          _controller.collectionName.text,
                          _controller.selectedProductIds,
                          loginData!.merchantCode,
                          collectionImage: _controller.collectionIImage.value
                     );
                    //  _controller.cubit.testCall();
                    }

                  },
                  child:
                  Obx(() {
                    return Container(
                      height: 50.h,
                      width: 400.w,
                      decoration: BoxDecoration(
                          color: kAppBlue,
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                              color: kAppBlue, width: 0.5.w)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: Row(
                          children: [
                            customText1(
                                "Create collection", kWhite, 16.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: fontFamilyInter),
                            Spacer(),
                            customText1(
                                ""
                                    "${_controller.selectedProductListNumber
                                    .value} "
                                    "Products selected", kWhite, 14.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: fontFamilyInter),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              isLoading: state is CollectionLoadingState
          );
        },
      );
  }

  Future<void> onRefresh() async {
    _controller.cubit.getProductList();
  }

}

class CollectionNewProductStructure {
  final InventoryInfo collectionProductAssign;
  final int productPosition;

  // final bool productSelection;
  CollectionNewProductStructure(
      {required this.collectionProductAssign, required this.productPosition});
}

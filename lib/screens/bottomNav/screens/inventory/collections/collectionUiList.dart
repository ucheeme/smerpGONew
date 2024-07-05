import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/controller/collection.dart';
import 'package:smerp_go/model/collectionDetail.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/collections/collectionDetails.dart';
import 'package:smerp_go/utils/appColors.dart';

import '../../../../../cubit/products/product_cubit.dart';
import '../../../../../model/request/createAndUpdateCollection.dart';
import '../../../../../model/response/getCollectionList.dart';
import '../../../../../utils/appDesignUtil.dart';
import '../../../../../utils/collectionUiKits.dart';
import '../../../../../utils/downloadAsImage.dart';
import '../../../../../utils/mockdata/tempData.dart';
import '../../../../bottomsheets/collectionCreated.dart';
import 'createCollection.dart';

class CollectionHome extends StatefulWidget {
  const CollectionHome({super.key});

  @override
  State<CollectionHome> createState() => _CollectionHomeState();
}

class _CollectionHomeState extends State<CollectionHome> {
  var _collectionController = Get.put(CollectionController());
  bool isMoreAction = false;
  int collectionId = 0;
  String collectionUrl = "";
  bool isRefresh = false;
  Timer? timer;
  RefreshController refreshController = RefreshController(
      initialRefresh: false);
  List<CollectionList> collectionList = [];
@override
  void initState() {
  if(collectionListTemp.isNotEmpty){
    collectionList=collectionListTemp;
  }
    super.initState();
  }
// @override
//   void dispose() {
//     _collectionController.dispose();
//     refreshController.dispose();
//     super.dispose();
//   }

  @override
  Widget build(BuildContext context) {
    _collectionController.getCollectionListInitial(context);
    return bloc.BlocBuilder<CollectionCubit, CollectionState>(
      builder: (context, state) {
        if (state is ProductListErrorState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(Duration.zero, () {
              showToast(state.errorResponse.message);
              // showOrderHistory(message: state.errorResponse.message);
            });
          });
          _collectionController.cubit.resetState();
        }
        if (state is CollectionListSuccessState) {
          collectionListTemp.clear();
        //  collectionList.clear();
          _collectionController.collectionList = state.response??[];
          collectionList = state.response??[];
          collectionListTemp = state.response??[];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (isRefresh) {
              refreshController.refreshCompleted();
            }
          });
         _collectionController.cubit.resetState();
        }
        if (state is CollectionDetailState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (isMoreAction) {
              isMoreAction = false;
              print("hurrayyy");
              Get.bottomSheet(
                  Container(
                      height: 350.h,
                      child: CollectionMoreActions(
                        collectionDetail: state.response,
                        collectionImage: _collectionController.collectionIImage
                            .value,
                        collectionId: collectionId,
                        collectionUrl: collectionUrl,))
              );
            } else {
              print("wawu");
              Get.to(
                  CollectionDetaiUI(
                    collectionDetail: state.response,
                    collectionImage: _collectionController.collectionIImage.value,)
              );
            }
          });
          _collectionController.cubit.resetState();
        }
       if (state is CollectionDeletedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {

            Future.delayed(Duration.zero, () {
              Get.bottomSheet(
                  backgroundColor: kWhite,
                  CollectionDeleted()).whenComplete(() {
                _collectionController.cubit.getCollectionList();
              // Get.back();
                // showOrderHistory(message: state.errorResponse.message);
              });
            });
            _collectionController.cubit.resetState();
          });
        }
       if(state is CollectionFilteringState){
         collectionList = state.response;
         WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
           if(collectionList.isEmpty){
             collectionList=collectionListTemp;
             showToast("Match not found");
           }
         });
         _collectionController.cubit.resetState();
       }
        return overLay(
            Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: kWhite,
                body: (collectionList.isEmpty) ?
                emptyPart("Collection",
                    image: "assets/emptyInventory.svg",
                        () {
                      Get.to(CreateCollectionUI(),
                          transition: Transition.cupertino,
                          curve: Curves.easeIn);
                    },
                    headerDetail: "Create new collection for your products",
                    header: "No collection yet"
                ) :
                Container(
                  //height: 800.h,
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(10),
                            customSearchDesign(
                              "Search collections",(query)=>_collectionController.cubit.filterListByName(query),
                              inputType: TextInputType.text,),
                            Gap(8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customText1(
                                    "Showing all collections",
                                    kBlack,
                                    14.sp,
                                    fontWeight: FontWeight.w200,
                                    fontFamily: fontFamilyInter),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(CreateCollectionUI(),
                                        curve: Curves.easeIn);
                                  },
                                  child: customText1(
                                      "Add new collection +",
                                      kAppBlue,
                                      14.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: fontFamilyInter),
                                ),
                              ],
                            ),
                            Gap(10),
                              Container(
                                color: kWhite,
                                height: 630.h,
                                child: AnimationLimiter(

                                  child: SmartRefresher(
                                    controller: refreshController,
                                    enablePullDown: true,
                                    header: ClassicHeader(),
                                    onRefresh: onRefresh,
                                    child: GridView.builder(
                                       physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                      itemCount: collectionList.length,
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
                                                child: GestureDetector(
                                                    onTap: () {
                                                     if(collectionList[index].collectionItemCount==0){
                                                       Get.to(
                                                           CollectionDetaiUI(
                                                             collectionDetail:CollectionDetail(
                                                                 collectionName: collectionList[index].name,
                                                                 products: []),
                                                             collectionImage: _collectionController.collectionIImage
                                                                 .value,)
                                                       );
                                                     }else{
                                                       _collectionController
                                                           .getCollectionDetail(index);
                                                     }
                                                      _collectionController.collectionIImage.value = collectionList[index]
                                                              .avatar;
                                                    },
                                                    child: CollectionUiDesign(
                                                      collectionName: collectionList[index].name,
                                                      image: collectionList[index]
                                                          .avatar,
                                                      numberOfProductInCollection: collectionList[index]
                                                          .collectionItemCount,
                                                      numberOfUnit: 0,
                                                      collectionId: collectionList[index].collectionId,
                                                      moreAction: () {
                                                        isMoreAction = true;
                                                        collectionUrl = collectionList[index].collectionUrl;
                                                        _collectionController.collectionIImage.value = collectionList[index].avatar;
                                                        collectionId = collectionList[index].collectionId;
                                                        if(collectionList[index].collectionItemCount==0){
                                                          Get.bottomSheet(
                                                              Container(
                                                                  height: 350.h,
                                                                  child: CollectionMoreActions(
                                                                    collectionDetail: CollectionDetail(collectionName: collectionList[index].name,
                                                                        products: []),
                                                                    collectionImage: _collectionController.collectionIImage
                                                                        .value,
                                                                    collectionId: collectionId,
                                                                    collectionUrl: collectionUrl,)
                                                              )
                                                          );
                                                        }else{
                                                          _collectionController.cubit.getCollectionDetail(collectionId.toString());
                                                        }

                                                      },
                                                    )
                                                ),
                                              ),
                                            ),
                                          );
                                      },
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        // number of items in each row
                                        childAspectRatio: 0.75,
                                        mainAxisSpacing: 10.0,
                                        // spacing between rows
                                        crossAxisSpacing: 10
                                            .w, // spacing between columns
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                          ]
                      ),
                    )

                )

            ),
            isLoading: state is CollectionLoadingState

        );
      },
    );
  }

  Future<void> onRefresh() async {
    isRefresh = true;
    _collectionController.cubit.getCollectionList();
  }
}

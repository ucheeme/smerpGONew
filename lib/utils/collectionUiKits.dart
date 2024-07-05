import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smerp_go/controller/report.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/collections/editCollection/editCollection.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';

import '../controller/collection.dart';
import '../cubit/products/product_cubit.dart';
import '../model/collectionDetail.dart';
import '../screens/bottomNav/screens/inventory/collections/collectionDetails.dart';
import '../screens/bottomNav/screens/inventory/inventoryHome.dart';
import '../screens/bottomsheets/collectionCreated.dart';
import 'AppUtils.dart';
import 'appColors.dart';
import 'downloadAsImage.dart';
import 'mockdata/tempData.dart';

enum  InventoryOptions {Inventory, Collection}

class CustomTab extends StatefulWidget {
  final String tab1;
  final TabController? tabController;
  final String tab2;
  final bool? isCollection;
  const CustomTab({required this.tab1,required this.tab2,
    required this.tabController,this.isCollection,
    super.key});

  @override
  State<CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  var activeTab1 = true;
  var activeTab2 = false;
  var _controller = Get.put(ReportController());
  @override
  void initState() {
   if(widget.isCollection!=null){
     activeTab2=true;
    activeTab1=false;
  }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){

            if(activeTab2){
              setState(() {
                activeTab2 = !activeTab2;
                activeTab1 =!activeTab1;
                _controller.isReportAnalysis.value=false;
              });
              widget.tabController?.animateTo(0,
              curve: Curves.easeIn
              );
            }
          },
          child: Container(
            height: 45.h,
            width: 198.w,
            decoration: BoxDecoration(

                color:activeTab1?kAppBlue:kLightPinkPin,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    bottomLeft: Radius.circular(15.r)
                ),
              border: Border.all(color: kBlackB600,width: 0.5)
            ),
            child: Center(child: customText1(widget.tab1, activeTab1?kWhite:kBlack,16.sp)),
          ),
        ),
        GestureDetector(
          onTap: (){
            if(activeTab1){
              setState(() {
                activeTab1 = !activeTab1;
                activeTab2 =!activeTab2;
              });
              widget.tabController?.animateTo(1,
                  curve: Curves.easeIn
              );
            }
          },
          child: Container(
              height: 45.h,
              width: 198.w,
              decoration: BoxDecoration(
                  color:activeTab2?kAppBlue:kLightPinkPin,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15.r),
                     bottomRight: Radius.circular(15.r)),
                  border: Border.all(color: kBlackB600,width: 0.5)
              ),
              child: Center(child: customText1(widget.tab2,activeTab2?kWhite:kBlack,16.sp)),
          ),
        )
      ],
    );
  }
}

class CollectionUiDesign extends StatelessWidget {
  final String image;
  final String collectionName;
  final int numberOfProductInCollection;
  final int numberOfUnit;
  final int collectionId;
  final Function()? moreAction;

   CollectionUiDesign({required this.collectionName, required this.image,
    required this.numberOfProductInCollection, required this.numberOfUnit,
    required this.collectionId, required this.moreAction, super.key});
   var _collectionController = Get.put(CollectionController());

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        GestureDetector(
          onTap: (){

          },
          child: Container(
            height:182.h,
            width: 191.w,
            decoration: BoxDecoration(
              border: Border.all(color: kLightPinkPin,width: 1),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r),
                topRight: Radius.circular(12.r)),
              image: DecorationImage(
                  image:(image.isEmpty)?Image.asset("assets/collectionWithOutImage.png").image
                      : getImageNetwork(
                      (image == null)
                          ? "" : image).image,
                  fit: BoxFit.cover),
            ),
          ),
        ),
        Container(
          height: 76.h,
          width: 191.w,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
           //color: kGreen70,
             color: kWhite,
              border: Border.all(color: kLightPinkPin,width: 1),
           borderRadius: BorderRadius.only(
             bottomLeft: Radius.circular(15.r),
             bottomRight: Radius.circular(15.r)
           )
         ),

          child:SingleChildScrollView(
            // physics: ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(5),
                customText1(collectionName, kBlack,14.sp),
             //  Spacer(),
                Container(
                  height: 30.h,
                  width: 191.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customText1(
                          "$numberOfProductInCollection products",
                          kBlackB600,
                          12.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: fontFamilyInter),
                      GestureDetector(
                        onTap: moreAction,
                        child: Container(
                            width: 25.w,
                            height: 25.h,
                            decoration: BoxDecoration(
                                color: kLightPinkPin.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: Icon(Icons.more_horiz_sharp,size: 15,)),
                      )
                    ],
                  ),
                ),

              ],
            ),
          ) ,
        )
      ],
    );
  }
}

class CollectionMoreActions extends StatefulWidget {
 final CollectionDetail? collectionDetail;
 final String collectionImage;
 final int collectionId;
 final String collectionUrl;
  CollectionMoreActions({
    required this.collectionDetail,
    required this.collectionImage,
    required this.collectionId,
    super.key, required this.collectionUrl});

  @override
  State<CollectionMoreActions> createState() => _CollectionMoreActionsState();
}

class _CollectionMoreActionsState extends State<CollectionMoreActions> {
  var _collectionController = Get.put(CollectionController());

  @override
  void dispose() {
    _collectionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return bloc.BlocBuilder<CollectionCubit, CollectionState>(
        builder: (context, state)
    {
      if (state is ProductListErrorState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration.zero, () {
            showToast(state.errorResponse.message);
            // showOrderHistory(message: state.errorResponse.message);
          });
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
                  Get.back();
              // showOrderHistory(message: state.errorResponse.message);
            });
          });
          _collectionController.cubit.resetState();
        });
      }
      if(state is CollectionListSuccessState){
       _collectionController.collectionList = state.response??[];
        collectionListTemp=  _collectionController.collectionList;
        WidgetsBinding.instance.addPostFrameCallback((_) {
        });
      }
      return
        Scaffold(
          body: Container(
            height: 350.h,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: kLightPink,
                  height: 53.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Spacer(),
                      customText1("More actions", kBlack, 16.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: fontFamilyGraphilk
                      ),
                      Spacer()
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () async {
                      Get.back();
                      Get.to(
                         EditCollection(
                           url: widget.collectionUrl,
                            collectionImage: widget.collectionImage,
                            collectionDetail: widget.collectionDetail,
                            collectionId: widget.collectionId,)
                      );

                    },
                    child: Container(
                      width: 319.w,
                      height: 68.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(7.r)),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/Vector.svg",
                            height: 24.h,
                            width: 24.w,
                            fit: BoxFit.scaleDown,
                          ),
                          Gap(20),
                          customText1("Edit collection", kBlack, 16.sp,
                              fontFamily: fontFamilyInter)
                        ],
                      ),
                    )
                ),
                Gap(20),
                GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.bottomSheet(
                        ShareCollectionUI(
                          collectionId: widget.collectionId,
                            collectionImage: widget.collectionImage,
                          collectionDetail: widget.collectionDetail??null,
                          collectionUrl: widget.collectionUrl,
                        ),
                      );
                    },
                    child: Container(
                        width: 319.w,
                        height: 68.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(7.r)),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/share.svg",
                                color: kBlack,

                                fit: BoxFit.scaleDown),
                            Gap(20),
                            customText1("Share collection link", kBlack, 16.sp,
                                fontFamily: fontFamilyInter)
                          ],
                        )
                    )
                ),
                Gap(20),
                GestureDetector(
                    onTap: () async {
                      Get.back();
                      bool response = await Get.bottomSheet(
                        DeleteCollectionUI(
                            collectionImage: widget.collectionImage,
                            collectionDetail: widget.collectionDetail,
                            collectionId: widget.collectionId
                        ),
                      );
                      if (response) {
                        _collectionController.cubit.deleteCollection(
                            widget.collectionId.toString());
                      }
                    },
                    child: Container(
                      width: 319.w,
                      height: 68.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(7.r)),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/trash.svg",
                            fit: BoxFit.scaleDown,
                          ),
                          Gap(20),
                          customText1("Delete collection", kBlack, 16.sp,
                              fontFamily: fontFamilyInter)
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        );
    }
    );
  }
}


class AddCollectionProductDesign extends StatefulWidget {
  final String productName;
  final String productAmount;
  final int productQuantityInStock;
  final String productCategory;
 final bool active;
 final String? image;
  const AddCollectionProductDesign({
    required this.productAmount,
    required this.productName, required this.productQuantityInStock,
    required this.productCategory,
    required this.active,this.image,super.key});

  @override
  State<AddCollectionProductDesign> createState() => _AddCollectionProductDesignState();
}

class _AddCollectionProductDesignState extends State<AddCollectionProductDesign> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: 398.w,
      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
      decoration: BoxDecoration(
        color: kBlackB600.withOpacity(0.05),
        borderRadius: BorderRadius.all(Radius.circular(20.r))
      ),
      child: Row(
        children: [
          Container(
            height: 57.h,
            width: 188.w,
            child: Row(
              children: [
                Container(
                  height:30.h ,
                  width: 30.w,
                  decoration: BoxDecoration(
                    image: (widget.image!=null)?
                    DecorationImage(
                        image:(widget.image!.isEmpty)?
                        Image.asset("assets/collectionWithOutImage.png").image
                            : getImageNetwork(widget.image!).image,
                        fit: BoxFit.cover):
                        null,
                    color: (widget.active)?kAppBlue:kLightPinkPin,
                    shape: BoxShape.circle,
                    border: Border.all(color:kInactiveLightPinkSwitchBu,
                    width: 3)
                  ),
                ),
                Spacer(),
                Container(
                  height:65.h ,
                  width: 150.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText1(widget.productName, kBlack,16.sp,
                          fontFamily: fontFamilyInter ,fontWeight: FontWeight.w400),
                     // Spacer(),
                      customText1("${widget.productQuantityInStock} "
                          "${widget.productCategory} in stock", kBlack, 13.5.sp,
                          fontFamily: fontFamilyInter,
                          fontWeight: FontWeight.w400)
                    ],
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          customTextnaira(
              NumberFormat.simpleCurrency(name: 'NGN')
                  .format(double.parse(widget.productAmount))
                  .split(".")[0],
              kAppBlue,
              18.sp,
              fontWeight: FontWeight.w500, fotFamily: fontFamilyGraphilk
          ),

        ],
      ),
    );
  }
}

class ShareCollectionUI extends StatefulWidget {
  final CollectionDetail? collectionDetail;
  final String collectionImage;
  final int collectionId;
  final String collectionUrl;
   ShareCollectionUI({super.key, required this.collectionDetail,
     required this.collectionImage, required this.collectionId,
     required this.collectionUrl});

  @override
  State<ShareCollectionUI> createState() => _ShareCollectionUIState();
}

class _ShareCollectionUIState extends State<ShareCollectionUI> {
  String image ="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height:236.h,
              decoration: BoxDecoration(
                border: Border.all(color: kLightPinkPin,width: 1),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r),
                    topRight: Radius.circular(15.r)),
                image:  DecorationImage(
                    image:(widget.collectionImage.isEmpty)?Image.asset("assets/collectionWithOutImage.png").image
                        : getImageNetwork(
                        (image == null)
                            ? "" : widget.collectionImage).image,
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              height: 90.h,
              width: 398.w,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                  //color: kGreen70,
                  color: kDashboardColorBorder,
                  border: Border.all(color: kLightPinkPin,width: 1),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.r),
                      bottomRight: Radius.circular(15.r)
                  )
              ),

              child:SingleChildScrollView(
                // physics: ,
                child: Center(
                  child: SizedBox(
                    height: 75.h,
                    width: 165.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(6),
                        customText1(widget.collectionDetail?.collectionName??"", kBlack,16.sp,
                        fontFamily: fontFamilyInter),
                        //  Spacer(),
                        Container(
                          height: 30.h,
                          width: 191.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText1(
                                  "${widget.collectionDetail?.products.length} Products",
                                  kBlackB600,
                                  14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: fontFamilyInter),
                              Icon(Icons.circle, color: kBlack,size: 8),
                              customText1(
                                  " ",
                                  kBlackB600,
                                  14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: fontFamilyInter),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ) ,
            ),
            Gap(15),
            Container(
              height: 40.h,
              width: 250.w,
              decoration: BoxDecoration(
                color: kLightPinkPin,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10.w,right: 10.w),
                child:
                Center(
                  child: customText1(
                      widget.collectionUrl, kBlackB600, 14.sp,
                      fontWeight: FontWeight.w400,
                      indent: TextAlign.center,
                      fontFamily: fontFamilyInter),
                ),

              ),
            ),
            Gap(20),
            GestureDetector(
              onTap: ()async {
                final box = context.findRenderObject()
                as RenderBox;
                print("i am here");
                await Share.share(
                    widget.collectionUrl,
                    sharePositionOrigin:
                    box.localToGlobal(
                        Offset.zero) &
                    box.size);
              },
              child: SizedBox(
                height: 82.h,
                width: 148.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                            child:SvgPicture.asset(
                                "assets/shareCopy.svg",
                                fit: BoxFit.scaleDown),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.r),
                                color:kLightPink.withOpacity(0.7)),
                            height:44.h,
                            width: 44.w),
                        gapHeight(10.h),
                        customText1("Share", kBlack, 14.sp,
                            fontWeight: FontWeight.w300,fontFamily: fontFamilyInter)
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){
                        copytext(widget.collectionUrl, context);
                        //showToast("url copied");
                      },
                      child: Column(
                        children: [
                          Container(
                              child:SvgPicture.asset(
                                  "assets/collectionCopyy.svg",
                                  fit: BoxFit.scaleDown),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10.r),
                                  color:kLightPink.withOpacity(0.7)),
                              height:44.h,
                              width: 44.w),
                          gapHeight(10.h),
                          customText1("Copy", kBlack, 14.sp,
                              fontFamily: fontFamilyInter,
                              fontWeight: FontWeight.w300)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

class DeleteCollectionUI extends StatefulWidget {
 final CollectionDetail? collectionDetail;
 final String collectionImage;
 final int collectionId;
  DeleteCollectionUI({required this.collectionId,required this.collectionDetail,
    required this.collectionImage,super.key});

  @override
  State<DeleteCollectionUI> createState() => _DeleteCollectionUIState();
}

class _DeleteCollectionUIState extends State<DeleteCollectionUI> {
  String image ="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Container(
          width: double.infinity,
         // padding: EdgeInsets.symmetric(horizontal: 16.w,),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  color: kLightPinkPin.withOpacity(0.4),
                  height: 63.h,
                  child: Padding(
                    padding:  EdgeInsets.only(top: 20.h,bottom: 10.h,left: 20.w),
                    child: customText1("Delete collection", kBlack, 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Gap(10),
                Padding(
                  padding: EdgeInsets.only(left: 20.h),
                  child: customText1("Are you sure you want to delete this collection from your inventory"
                      "?", kBlackB800, 16.sp,
                    maxLines: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(10),
                Container(
                  height:236.h,
                  margin: EdgeInsets.symmetric(horizontal: 17.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: kLightPinkPin,width: 1),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r)),
                    image: DecorationImage(
                        image:(widget.collectionImage.isEmpty)?Image.asset("assets/collectionWithOutImage.png").image
                            : getImageNetwork(
                            (image == null)
                                ? "" : widget.collectionImage).image,
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  height: 90.h,
                  width: 398.w,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    //color: kGreen70,
                      color: kDashboardColorBorder,
                      border: Border.all(color: kLightPinkPin,width: 1),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15.r),
                          bottomRight: Radius.circular(15.r)
                      )
                  ),
            
                  child:SingleChildScrollView(
                    // physics: ,
                    child: Center(
                      child: SizedBox(
                        height: 75.h,
                        width: 165.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(6),
                            customText1("${widget.collectionDetail?.collectionName}",
                                kBlack,16.sp,
                                fontFamily: fontFamilyInter),
                            //  Spacer(),
                            Container(
                              height: 30.h,
                              width: 191.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  customText1(
                                      "${widget.collectionDetail?.products.length} Products",
                                      kBlackB600,
                                      14.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: fontFamilyInter),
                                  Icon(Icons.circle, color: kBlack,size: 8),
                                  customText1(
                                      "12 Units",
                                      kBlackB600,
                                      14.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: fontFamilyInter),
                                ],
                              ),
                            ),
            
                          ],
                        ),
                      ),
                    ),
                  ) ,
                ),
                Gap(20),
                Padding(
                  padding:  EdgeInsets.only(left: 12.w,right: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.back(result: false);
                        },
                        child: Container(
                          height: 60.h,
                          width: 192.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: kDashboardColorBlack3,
                          ),
                          child: Center(child: customText1( "No, Discard",kBlack,
                              18.sp)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Get.back(result: true);
                        },
                        child: Container(
                          height: 60.h,
                          width: 192.w,
                          decoration: BoxDecoration(
                            color: kRed50,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
                              child: customText1("Yes, Delete",kRed60, 18.sp)
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}



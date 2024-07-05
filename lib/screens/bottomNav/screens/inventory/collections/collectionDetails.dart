import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../model/collectionDetail.dart';
import '../../../../../utils/appColors.dart';
import '../../../../../utils/appDesignUtil.dart';
import '../../../../../utils/collectionUiKits.dart';

class CollectionDetaiUI extends StatefulWidget {
  CollectionDetail collectionDetail;
  String collectionImage;
   CollectionDetaiUI({
     required this.collectionDetail,
     required this.collectionImage,
     super.key});

  @override
  State<CollectionDetaiUI> createState() => _CollectionDetaiUIState();
}

class _CollectionDetaiUIState extends State<CollectionDetaiUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: defaultDashboardAppBarWidget(() {
            Get.back();
          }, "    View Collection",context: context),
          preferredSize: Size.fromHeight(80.h)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20),
              Container(
                  height: 60.h,
                  child: textFieldBorderWidget(
                      Padding(
                        padding: EdgeInsets.only(left: 8.w,),
                        child: customText1(
                            widget.collectionDetail.collectionName
                            , kBlack, 16.sp),
                      ),
                      "Collection name"),
              ),
                Gap(10),
                    Container(
                      //padding: EdgeInsets.all(20.0),
                      height: 350.h,
          
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          image: DecorationImage(image: getImageNetwork(
                              widget.collectionImage,
                          ).image,
                              fit: BoxFit.cover)
                      ),
          
                    ),
              Gap(20),
              customText1("Product(s) in collection", kAppBlue, 16.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: fontFamilyGraphilk),
              Gap(20),
              Container(
                height: 300.h,
                child:(widget.collectionDetail.products.isEmpty)?
                Center(
                  child: customText1("This collection has no product under it",kAppBlue, 14.sp),
                ):
                ListView.builder(
                  itemCount: widget.collectionDetail.products.length,
                    itemBuilder: (context,index){
                      Product collectionProducts =widget.collectionDetail.products[index];
                      return Column(
                        children: [
                          AddCollectionProductDesign(
                            productAmount: collectionProducts.sellingPrice
                                .toString(),
                            productName: collectionProducts.productName,
                            productQuantityInStock: collectionProducts.quantity,
                            productCategory: collectionProducts.productCategory,
                            active:false,
                            image: widget.collectionDetail.products[index].productImage,
                          ),
                          Gap(20)
                        ],
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

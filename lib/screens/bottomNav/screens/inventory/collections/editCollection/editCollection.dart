
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/cubit/products/product_cubit.dart';
import 'package:smerp_go/utils/AppUtils.dart';

import '../../../../../../controller/collection.dart';
import '../../../../../../model/collectionDetail.dart';
import '../../../../../../utils/UserUtils.dart';
import '../../../../../../utils/appColors.dart';
import '../../../../../../utils/appDesignUtil.dart';
import '../../../../../../utils/downloadAsImage.dart';
import '../../../../../bottomsheets/camera.dart';
import '../../../../../bottomsheets/collectionCreated.dart';
import '../../../../bottomNavScreen.dart';
import '../../inventoryHome.dart';
import '../addProductsToCollection.dart';

class EditCollection extends StatefulWidget {
  CollectionDetail? collectionDetail;
  String collectionImage;
  int collectionId;
  String url;
  EditCollection({required this.collectionImage,required this.url,
    required this.collectionDetail, required this.collectionId,super.key});

  @override
  State<EditCollection> createState() => _EditCollectionState();
}

class _EditCollectionState extends State<EditCollection> {
  var _controller =Get.put(CollectionController());
  List<int> ids= [];
  bool changeImage=false;
  String imageString="";
  @override
  void initState() {
    _controller.collectionName.text = widget.collectionDetail?.collectionName??"";

    super.initState();
    getImageCall();
  }
  Future<void> getImageCall() async {

    imageString= await fetchImageToBase64(widget.collectionImage);
    setState(() {
      imageString=imageString;
    });
  }


  @override
  Widget build(BuildContext context) {
    selectedProducts(widget.collectionDetail??null);
    return bloc.BlocBuilder<CollectionCubit, CollectionState>(
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
    if (state is CollectionUpdatedState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Get.bottomSheet(
              backgroundColor: kWhite,
              CollectionCreated(
                alertType:  "updated",
               collectionUrl: widget.url,)
          ).whenComplete(() {
            //controller.cubit.close();
            _controller.cubit.getCollectionList();
            Get.back();
            // showOrderHistory(message: state.errorResponse.message);
        });
      });
      _controller.cubit.resetState();
    });
        }
    return overLay(
       Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:kWhite ,
        appBar: PreferredSize(
            child:  defaultDashboardAppBarWidget(() {
              _controller.collectionIImage.value="";
              _controller.products.clear();
              _controller.selectedProductOptions.clear();
              _controller.inventory.clear();
              Get.back();
            },  " Edit collection",),
            preferredSize: Size.fromHeight(70.h)),
        body: Padding(
          padding:  EdgeInsets.only(left: 16.w,right: 16.w),
          child: SingleChildScrollView(
            child: Container(
              height: 800.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 690.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Gap(20),
                        Container(
                          height: 50.h,
                          child: titleSignUp(_controller.collectionName,
                              textInput: TextInputType.text,
                              hintText: "Enter collection name"),
                        ),
                        Gap(20),
                       textFieldBorderWidget(
                           Container(
                             padding: EdgeInsets.all(20.h),
                             height:
                             260.h,
                             width: 368.w,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10.r),
                                 image: imaging()
                             ),
                           ), "Collection image"),
                      //  Gap(10),
                        GestureDetector(
                          onTap: () async {
                            changeImage=true;
                            var response = await Get.bottomSheet(
                                CameraOption()
                            );
                            if (response != null) {
                              setState(() {
                                //  var paymentStatus =response;
                               // _controller.collectionIImage.value="";
                                _controller.collectionImageFile = response[0];
                                _controller.collectionIImage.value = response[1];
                                imageString=response[1];
                              });
                            }
                          },
                          child: SizedBox(
                            height: 40.h,
                            width: 120.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height:16.h,
                                  width: 16.w,
                                  child: Image.asset("assets/change.png",
                                      fit: BoxFit.scaleDown),
                                ),
                                customText1("Change image",
                                    kBlack,14.sp,
                                    fontFamily: fontFamilyInter)
                              ],
                            ),
                          ),
                        ),
                        Gap(20),
                        GestureDetector(
                          onTap: () async {
                            if(widget.collectionDetail==null){

                            }else{
                              for(int i=0; i< widget.collectionDetail!.products.length;i++){
                                ids.add( widget.collectionDetail!.products[i].id);
                              }
                              _controller.collectionIImage.value=imageString;

                              print("product ids:$ids");
                              print("product ids:${ widget.collectionDetail!.products.length}");
                              Get.to(
                                AddProductToCollection(
                                  isUpdateProductCollection: true,
                                  collectionList:ids,
                                  collectionId: widget.collectionId,
                                  url: widget.url,
                                ),
                                duration: Duration(seconds: 1),
                                transition: Transition.cupertino,
                              );
                            }

                          },
                          child:
                          Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                                color: kLightPink,
                                borderRadius: BorderRadius.circular(15.r),
                                border: Border.all(
                                    color: kAppBlue, width: 0.5.w)),
                            child: Center(
                              child: customText1(
                                  "Update product selection", kAppBlue, 16.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  GestureDetector(
                    onTap: () {
                      _controller.cubit.updateCollection(
                          _controller.collectionName.text,
                          widget.collectionId.toString(),
                          _controller.selectedProductIds,
                          loginData!.merchantCode,
                      collectionImage: imageString!,);
                    },
                    child:
                    Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                          color: kAppBlue,
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                              color: kAppBlue, width: 0.5.w)),
                      child: Center(
                        child: customText1(
                            "Update stock", kWhite, 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: fontFamilyInter),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
      isLoading: state is CollectionLoadingState
    );
  },
);
  }

  DecorationImage? imaging(){
    if(widget.collectionImage.isEmpty|| changeImage==false){
     return      DecorationImage(image: getImageString(
         imageString!).image,
         fit: BoxFit.cover);
    }else if(changeImage){
    return  DecorationImage(image: displayImage(
          _controller.collectionImageFile).image,
          fit: BoxFit.cover);
    }
    return null;
  }

  List<int> selectedProducts(CollectionDetail? collectionDetail){
    _controller.selectedProductIds.value.clear();
    if(collectionDetail!=null){
      for(int i=0; i<collectionDetail.products.length; i++){
        _controller.selectedProductIds.value.add(collectionDetail.products[i].id);
      }
    }
    return _controller.selectedProductIds.value;
  }
}

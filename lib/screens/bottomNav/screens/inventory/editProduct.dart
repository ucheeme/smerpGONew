import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/addNewProduct.dart';

import '../../../../controller/addNewProduct.dart';
import '../../../../controller/productController.dart';
import '../../../../model/response/inventoryDetail.dart';
import '../../../../model/response/inventoryList.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../bottomsheets/camera.dart';
import '../../../bottomsheets/productCategory.dart';
import '../../../bottomsheets/unitofmeasurement.dart';

class EditProduct extends StatefulWidget {
  InventoryInfo? information;

  EditProduct({Key? key, required this.information}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  var _controller = Get.put(ProductController());
  var _controllerAddInventiry = Get.put(AddNewProductController());

  var isChangeImage=false;

  @override
  void initState() {
    _controller.productName.text = widget.information!.productName;
    _controller.productCategory.value = widget.information!.productCategory;
    _controller.productCostPrice.text =formatAmount(
        widget.information!.purchasePrice.toString());
    _controller.productSellingPrice.text =formatAmount(
        widget.information!.sellingPrice.toString());
    _controller.productQuantity.text = widget.information!.quantity.toString();
    _controller.productUnit.value = widget.information!.unitCategory;
    _controller.productImage.value = (widget.information!.productImage==null||
        widget.information!.productImage=="")?"":widget.information!.productImage;
   //_controller.productUnitCategoryId=widget.information!.units;
   // _controller.productCategoryId=widget.information!.units;

    super.initState();
    getIds();
  }
  String formatAmount(String amount){
    return  NumberFormat.simpleCurrency(
        name: 'NGN')
        .format(
        double.parse(
           amount))
        .split(".")[0];
  }
  Future<void> getIds() async {

    _controller.productUnitCategoryId=await productUnitCategoryId(_controller.productUnit.value);

   _controller.productCategoryId= await productCategoryId(_controller.productCategory.value);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return overLay(
       Scaffold(
         resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
                child: defaultDashboardAppBarWidget(() {
                  Get.back();
               }, "Edit product",context: context),
                preferredSize: Size.fromHeight(80.h)),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
               child: Container(
                 height: 1200.h,
                  child: Column(
                    children: [
                      gapHeight(20.h),
                      Container(
                        height: 60.h,
                        child: titleSignUp(_controller.productName,
                            textInput: TextInputType.text,
                            hintText: "Enter product name"),
                      ),
                      gapHeight(35.h),
                      GestureDetector(
                        onTap: () async {

                        },
                        child: textFieldBorderWidget(
                            Container(
                              padding: EdgeInsets.all(20.0),
                              height: 222.h,
                              width: 368.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  image: DecorationImage(
                                     image: (isChangeImage)?displayImage(
                                         _controller.productImageFile).image
                                      : getImageNetwork(
                                         _controller.productImage.value).image,
                                      fit: BoxFit.contain)


                              ),

                            ), "Product image"),
                      ),
                      gapHeight(15.h),
                      GestureDetector(
                        onTap: () async {
                          var response = await Get.bottomSheet(
                              CameraOption()
                          );
                          if (response != null) {
                            setState(() {

                              //  var paymentStatus =response;
                              _controller.productImageFile = response[0];
                              isChangeImage=true;
                              _controller.productImage.value = response[1];
                            });
                          }
                        },
                        child: Container(
                          height: 52.h,

                          decoration: BoxDecoration(
                            color: kLightPinkPin,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/gallery-add.svg"),
                              Center(
                                  child: customText1(
                                      "Change image", kBlackB800, 16.sp)
                              ),
                            ],
                          ),
                        ),
                      ),
                      gapHeight(35.h),
                      GestureDetector(
                        onTap: () async {
                          var response = await Get.bottomSheet(
                              ProductCategory()
                          );
                          if (response != null) {
                            setState(() {
                              _controller.productCategory.value= response[0];
                              _controller.productCategoryId= response[1];
                            });
                          }
                        },
                        child: Container(
                          height: 60.h,
                          child: textFieldBorderWidget(
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  customText1(_controller.productCategory.value,
                                      kBlack, 16.sp),
                                  const Icon(Icons.keyboard_arrow_down)
                                ],
                              ), "Product category"),
                        ),
                      ),
                      gapHeight(35.h),
                      Container(
                        height: 60.h,
                        child: textFieldAmount(_controller.productCostPrice,
                            textInput: TextInputType.number,
                            hintText: "Product cost price"),
                      ),
                      gapHeight(35.h),
                      Container(
                        height: 60.h,
                        child: textFieldAmount(_controller.productSellingPrice,
                            textInput: TextInputType.number,
                            hintText: "Product selling price"),
                      ),
                      gapHeight(35.h),
                      Row(
                       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          titleSignUp2(_controller.productQuantity,
                              textInput: TextInputType.number,
                              hintText: "Enter quantity",
                          height: 60.h,width: 192.w),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              var response = await Get.bottomSheet(
                                  UnitOfMeasurement()
                              );
                              if(response!=null){
                                _controller.productUnit.value= response[0];
                                _controller.productUnitCategoryId= response[1];
                              }
                            },
                            child: Container(
                              height: 60.h,
                              width: 192.w,
                              child: textFieldBorderWidget2(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      customText1(_controller.productUnit.value,
                                          kHashBlack50, 16.sp),
                                      const Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ),
                                  "Enter unit"),
                            ),
                          )
                        ],
                      ),
                      gapHeight(35.h),
                      GestureDetector(
                        onTap: () async {
                          if(_controller.productCostPrice.text.isEmpty||
                          _controller.productSellingPrice.text.isEmpty){
                            Get.snackbar("Invalid input format ",
                              "No field should be empty",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,);
                          }else{
                            String prodImage="";
                            String name="";
                            // int prodCatId =0;
                            if(_controller.productUnitCategoryId==0){
                              _controller.productUnitCategoryId =
                                  _controller.getUnitCategoryID(
                                      _controller.productCategory.value
                                  );
                            }
                            int quantity = 0;
                            double cP = 0;
                            double sP = 0;

                            name=_controller.productName.text;

                            cP=_controller.getAmountAsNumber(
                                _controller.productCostPrice
                            );
                            sP=_controller.getAmountAsNumber(
                                _controller.productSellingPrice
                            );
                            quantity= int.parse(_controller.productQuantity.text);
                            // prodUnit= int.parse(_controller.productUnit.value);
                            prodImage= _controller.productImage.value;
                            var res= await  _controllerAddInventiry.productUpdate(quantity,
                              _controller.productCategoryId,
                              _controller.productUnitCategoryId,
                              name,prodImage,cP,
                              sP, widget.information!.id,);
                            if(res){
                              Navigator.pop(context);
                            }
                          }

                        },
                        child: Container(
                          height: 60.h,

                          decoration: BoxDecoration(
                            color: kAppBlue,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
                              child: customText1("Update stock", kWhite, 18.sp)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ),
        isLoading: _controllerAddInventiry.isLoading.value
      );
    });
  }
}

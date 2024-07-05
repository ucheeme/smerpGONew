import 'dart:ffi';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smerp_go/utils/reportUiKit.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../../../controller/addSaleController.dart';
import '../../../../model/response/inventoryList.dart';
import '../../../../model/response/sales/saleList.dart';
import '../../../../model/response/sales/saleListInfo.dart';
import '../../../../model/response/salesList.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../../utils/mockdata/mockInventoryData.dart';
import '../../../bottomsheets/addProductSaleEdit.dart';
import '../../../bottomsheets/productsList.dart';
import '../../../bottomsheets/unitofmeasurement.dart';
import 'package:smerp_go/screens/bottomsheets/paymentStatus.dart';

import 'editSalesItemForMultipleItemsUi.dart';

class EditSale extends StatefulWidget {
  SalesDatum? information;

  EditSale({Key? key, required this.information}) : super(key: key);

  @override
  State<EditSale> createState() => _EditSaleState();
}

class _EditSaleState extends State<EditSale> {
  var _controller = Get.put(AddNewSaleController());
  var _controllerDashboard = Get.put(AddNewSaleController());
  var paymentStatus = "";
  var customersName = "";
  var date = "";
  int paymentStatusId = 0;
  double totalAmount = 0.0;
  RxBool isMarkAllAsPaid= false.obs;
  RxBool isLoading = false.obs;
  List<SaleListDataInfo> saleListInfo = [
    SaleListDataInfo(salesId: 0, customerName: '', saleProducts: [])
  ];

  @override
  void initState() {
    getDetails();
    super.initState();
    getDetails();
  }

  void getDetails() async {
    isLoading.value = true;
    saleListInfo = await _controller.saleListData(widget.information!.id,
        isLoading);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        saleListInfo = saleListInfo;
        isLoading.value = false;
        _controller.isLoading.value = false;
        paymentStatusId = paymentStatusStringToInt(
            saleListInfo[0].saleProducts[0].paymentStatus);
      });
      if (widget.information!.itemCount == 1) {
        _controller.prodName = saleListInfo[0].saleProducts[0].productName;
        _controller.quantityController.text =
            saleListInfo[0].saleProducts[0].quantity.toString();
        _controller.prodUnitName =
            saleListInfo[0].saleProducts[0].productUnitCategory;
        _controller.editTotalSaleCost =
            saleListInfo[0].saleProducts[0].salesAmount;
        paymentStatus = saleListInfo[0].saleProducts[0].paymentStatus;
        _controller.paymentStatus.value =
            _controller.paymentStatusid(paymentStatus);
        _controller.qty = saleListInfo[0].saleProducts[0].quantity;
        customersName = saleListInfo[0].customerName;
        _controller.customerName.text = saleListInfo[0].customerName;
      } else {
        customersName = saleListInfo[0].customerName;
        totalAmount = 0;
        for (var element in saleListInfo[0].saleProducts) {
          setState(() {
            totalAmount =
                totalAmount + (element.sellingPrice * element.quantity);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.product = null;
    totalAmount = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      return overLay(
          GestureDetector(
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: kLightPink.withOpacity(0.7),
                      height: 53.h,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: customText1(
                            (widget.information!.itemCount == 1)
                                ? "Edit ${customersName} sale"
                                :
                            "Select sales to edit",
                            kBlack,
                            18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    (isLoading.value) ?
                    Center(
                      child: Container(
                        height: (widget.information!.itemCount == 1) ? 700.h : 350
                            .h,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: kAppBlue,
                          ),
                        ),
                      ),
                    ) :

                    (widget.information!.itemCount == 1) ?
                    saleDetailWithOneItem(context) :
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, right: 16.h),
                      child: Container(
                        height: getEditHeight(widget.information!.itemCount),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              gapHeight(15.h),
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    customText1("Update payment status",kBlack, 16.sp,
                                    fontFamily: fontFamilyInter),
                                    GestureDetector(
                                      onTap:   () async {
                                          isMarkAllAsPaid.value=!isMarkAllAsPaid.value;
                                          if(isMarkAllAsPaid.value){
                                          bool response=await _controller.updateAllItemsAsPaid(
                                            saleListInfo[0].saleProducts,
                                            saleListInfo[0].salesId);
                                          if(response){
                                            setState(() {

                                            });
                                          }
                                          }
                                        },
                                        child: Container(
                                          height: 40.h,
                                            width: 180.w,
                                          //  color: kLightPinkPin,
                                            child: reportOptionUI("Mark all as paid", isMarkAllAsPaid)))
                                  ],
                                ),
                              ),
                              Gap(20),
                              Container(
                                  width: double.infinity,
                                  height: getItemListContainerHeight(
                                    saleListInfo[0].saleProducts.length,) + 125.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      border: Border.all(color: kHashBlack30,
                                          width: 0.5.w)
                                  ),
                                  child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15.r),
                                              topLeft: Radius.circular(15.r),),
                                            color: kLightPink.withOpacity(0.5),
                                          ),
                                          height: 53.h,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10.h,
                                                right: 10.w, left: 10.w),
                                            child: customText1("${customersName} sales", kBlack, 18.sp),
                                          ),
                                        ),
                                        Container(
                                          height: getItemListContainerHeight(
                                            saleListInfo[0].saleProducts.length,),
                                          width: double.infinity,
                                          child: ListView.builder(
                                              itemCount: saleListInfo[0]
                                                  .saleProducts.length,
                                              itemBuilder: (context, index) {
                                                return saleDetailSeveralItemDesign(saleListInfo[0].saleProducts[index],
                                                    payment: saleListInfo[0].saleProducts[index].paymentStatus,
                                                  deleteItem: () {
                                                    deleteItem(index,
                                                        widget.information!.id,
                                                        saleListInfo[0]
                                                            .saleProducts[index].salesItemId);
                                                  },
                                                  index: index,
                                                  updateItem: () async {
                                                    await updateItemAction(index,
                                                        saleListInfo[0]
                                                            .saleProducts[index]
                                                    );
                                                  },
                                                );
                                              }
                                          ),
                                        ),
                
                                        //  gapHeight(100.h),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(15.r),
                                              bottomLeft: Radius.circular(15.r),),
                                            color: kLightPink.withOpacity(0.5),
                                          ),
                                          height: 70.h,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10.h,
                                                right: 15.w, left: 15.w),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        customText1(
                                                            saleListInfo[0]
                                                                .saleProducts.length
                                                                .toString(),
                                                            kBlack, 16.sp),
                                                        gapWeight(3.w),
                                                        customText1(
                                                            "Items", kBlack, 16.sp),
                
                                                      ],
                                                    ),
                                                    customText1(
                                                        "Total", kBlack, 16.sp),
                                                    gapHeight(1.h)
                                                  ],
                                                ),
                                                customTextnaira(
                                                    NumberFormat.simpleCurrency(
                                                        name: 'NGN').format(
                                                        double.parse(
                                                            totalAmount.toString())
                                                    ).split(".")[0], kAppBlue,
                                                    24.sp,
                                                    fontWeight: FontWeight.w500),
                                              ],
                                            ),
                                          ),
                                        )
                                      ]
                                  )
                              ),
                              gapHeight(30.h),
                              GestureDetector(
                                onTap: () async {
                                 await _controllerDashboard.allSaleList();
                                  Navigator.pop(context);
                                },
                                child: dynamicContainer(Center(
                                    child: customText1(
                                      //     (_controller.isDone.value) ?
                                      // "Create sale" : "Done",
                                        "Update sale",
                                        kWhite, 18.sp)),
                                    kAppBlue, 60.h,
                                    width: double.infinity),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          isLoading: _controller.isLoading.value);
    });
  }

  Padding saleDetailWithOneItem(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.h),
      child: Container(
        height: 705.h,
        child: SingleChildScrollView(
          child: Column(
            children: [
              gapHeight(20.h),
              // Container(
              //   height: 60.h,
              //   width: double.infinity,
              //   child: titleSignUp(_controller.customerName,
              //       textInput: TextInputType.text,
              //       hintText: "Enter customer name",
              //       onChanged: (value) {
              //         if (value != null && !value.isEmpty) {
              //           setState(() {
              //             setState(() {
              //               customersName = value;
              //             });
              //           });
              //         } else {
              //           setState(() {
              //             customersName = saleListInfo[0].customerName;
              //           });
              //         }
              //       }),
              // ),
              // gapHeight(35.h),
              GestureDetector(
                onTap: () async {
                  if(paymentStatus=="Paid"){null;}
                  else{
                    InventoryInfo response =
                    await Get.bottomSheet(AllProduct());
                    if (response != null) {
                      _controller.product = response;
                      setState(() {
                        _controller.prodName = response.productName;
                      });
                    }
                  }

                },
                child: Container(
                  height: 60.h,
                  child: textFieldBorderWidget2(
                      Container(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            customText1(_controller.prodName,
                                kHashBlack50, 16.sp),
                            Icon(
                              Icons.keyboard_arrow_down,
                            ),
                            // Icon(SolarIconsBold.accessibility),
                          ],
                        ),
                      ),
                      "Add product"),
                ),
              ),
              gapHeight(35.h),
              Container(
                height: 60.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Container(
                      height: 60.h,
                      width: 192.w,
                      padding: EdgeInsets.symmetric(
                          vertical: 2.h, horizontal: 4.w),
                      child: titleSignUp(
                          _controller.quantityController,
                          textInput: TextInputType.number,
                          hintText: "Enter quantity",
                          onChanged: (value) {
                            quantityOnChanged(value);
                          },
                      readOnly: (paymentStatus=="Paid")?true:false
                      ),
                    ),
                    SizedBox(
                      height: 70.h,
                      width: 192.w,
                     child: textFieldBorderWidget2(
                          customText1(_controller.prodUnitName,
                              kHashBlack50, 16.sp),
                          "Product unit"),
                    )
                  ],
                ),
              ),
              gapHeight(35.h),
              GestureDetector(
                onTap: () async {
                  if(paymentStatus=="Paid"){
                    null;
                  }else{
                    var response =
                    await Get.bottomSheet(PaymentStatus());
                    if (response != null) {
                      setState(() {
                        //  paymentStatus = response;
                      });
                      if (response != null) {
                        setState(() {
                          paymentStatus = response[0];
                          _controller.paymentStatus.value =
                          response[1];
                          paymentStatusId = response[1];
                        });
                      }
                    }
                  }

                },
                child: Container(
                  height: 60.h,
                  width: double.infinity,
                  child: textFieldBorderWidget2(
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          paymentStatusDesign(paymentStatus),
                          const Icon(Icons.keyboard_arrow_down)
                        ],
                      ),
                      "Select payment status"),
                ),
              ),
              gapHeight(35.h),
             // Container(
              //     width: double.infinity,
              //     height: 208.h,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(15.r),
              //     ),
              //     child: Column(children: [
              //       Container(
              //         width: double.infinity,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.only(
              //             topRight: Radius.circular(15.r),
              //             topLeft: Radius.circular(15.r),
              //           ),
              //           color: kLightPink,
              //         ),
              //         height: 52.h,
              //         child: Padding(
              //           padding: EdgeInsets.only(
              //               right: 10.w, left: 10.w),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               customText1(
              //                   "${_controller.customerName.text} "
              //                       "sales receipt", kBlackB700, 18.sp),
              //               customText1(
              //                   date, kBlack, 16.sp),
              //             ],
              //           ),
              //         ),
              //       ),
              //       // (_controller.product == null) ? Container(
              //       //   height: 90.h,
              //       //   width: double.infinity,
              //       // ) :
              //       Container(
              //         height: 100.h,
              //         width: double.infinity,
              //         child: editSaleSelectedDesign(
              //             saleListInfo[0].saleProducts[0],
              //             (_controller.product == null)
              //                 ? null
              //                 : _controller.product!,
              //             quantity: _controller.qty,
              //             paymentStatus: paymentStatusId),
              //       ),
              //       gapHeight(10.h),
              //       Container(
              //         width: double.infinity,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.only(
              //             bottomRight: Radius.circular(15.r),
              //             bottomLeft: Radius.circular(15.r),
              //           ),
              //           color: kLightPink,
              //         ),
              //         height: 40.h,
              //         child: Padding(
              //           padding: EdgeInsets.only(
              //               top: 10.h, right: 10.w, left: 10.w),
              //           child: Row(
              //             mainAxisAlignment:
              //             MainAxisAlignment.spaceBetween,
              //             children: [
              //               customText1("Total", kBlack, 18.sp),
              //               customTextnaira(
              //                   NumberFormat.simpleCurrency(
              //                       name: 'NGN')
              //                       .format(double.parse(_controller
              //                       .editTotalSaleCost
              //                       .toString()))
              //                       .split(".")[0],
              //                   kAppBlue,
              //                   24.sp,
              //                   fontWeight: FontWeight.w500),
              //             ],
              //           ),
              //         ),
              //       )
              //     ])),
              // gapHeight(40.h),
              GestureDetector(
                onTap: () async {
                  await executeEditSale(context);
                },
                child: dynamicContainer(
                    Center(
                        child: customText1(
                            "Update sale", kWhite, 18.sp)),
                    kAppBlue,
                    60.h,
                    width: double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double getEditHeight(int num){
    switch(num){
      case 2: return 530.h;
      case 3: return 612.h;
      case 4: return 750.h;
      case 5: return 770.h;
      default: return 900.h;
    }
  }

  void quantityOnChanged(value) {
    if (value != null && !value.isEmpty) {
      _controller.qty = int.parse(value);
      var res = double.parse(value);
      var answer = (_controller.product == null)
          ? res * saleListInfo[0].saleProducts[0].sellingPrice
          : res * _controller.product!.sellingPrice;
      ;
      setState(() {
        _controller.editTotalSaleCost = answer;
      });
      print(answer);
    } else {
      setState(() {
        _controller.editTotalSaleCost = 0;
        _controller.qty = 0;
      });
    }
  }

  Future<void> executeEditSale(BuildContext context) async {
    // setState(() {
    //   isLoading.value = true;
    // });
    Get.snackbar("Updating sale item",
        "Please wait..",
        snackStyle: SnackStyle.FLOATING,
        showProgressIndicator: true,
        borderRadius: 8.r,
        overlayBlur: 2,
        overlayColor: kDashboardColorBorder
            .withOpacity(.4),
        isDismissible: false,
        backgroundColor: kWhite,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP);
    _controller.qty = int.parse(_controller.quantityController.text);
    bool res = await _controller.updateSaleRecord(
        _controller.qty,
        _controller.paymentStatus.value,
        saleListInfo[0].saleProducts[0].salesItemId,
        (_controller.product == null)
            ? saleListInfo[0].saleProducts[0].productId
            : _controller.product!.id);

    if (res) {
      setState(() {
        isLoading.value = false;
      });
      ////Get.back(result: res);
      Navigator.pop(context);
    } else {
      setState(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> deleteItem(int index,int saleId, int saleItemId) async {

   var res= await _controller.deleteItemRecord(saleId,saleItemId);
   if(res){

     totalAmount = 0;
     setState(() {
       saleListInfo[0].saleProducts = saleListInfo[0].saleProducts;
     });
     for (var element in saleListInfo[0].saleProducts) {
       setState(() {
         totalAmount = totalAmount + (element.sellingPrice * element.quantity);
      });
     }
   }
   saleListInfo[0].saleProducts.removeAt(index);

  }

  Future<void> updateItemAction(int index,
      SalesItemInfo salesItemInfo,) async {
    var response = await Get.bottomSheet(

        Obx(() {
          return Container(
            height: (isKeyboardOpen.value) ? 600.h : 470.h,
            child: AddEditSaleItem(
              index: index,
              salesItemInfo: salesItemInfo,
              saleId: salesItemInfo.salesItemId,
            ),
          );
        })
    ).whenComplete(() {
      totalAmount = 0;
      for (var element in saleListInfo[0].saleProducts) {
        setState(() {
          totalAmount = totalAmount + (element.sellingPrice * element.quantity);
        });
      }
    });

    if (response == true) {
      setState(() {

      });
    } else {
      setState(() {

      });
    }
  }
}




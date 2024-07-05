import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/screens/bottomsheets/paymentStatus.dart' as pStatus;

import '../../../../controller/addSaleController.dart';
import '../../../../model/response/inventoryList.dart';
import '../../../../model/response/sales/saleListInfo.dart';
import '../../../../utils/AppUtils.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/appDesignUtil.dart';
import '../../../../utils/app_services/helperClass.dart';
import '../../../bottomsheets/productsList.dart';

class AddEditSaleItem extends StatefulWidget {
  SalesItemInfo? salesItemInfo;
  int index = 0;
  int saleId = 0;

  AddEditSaleItem({super.key, required this.salesItemInfo,
    required this.index, required this.saleId});

  @override
  State<AddEditSaleItem> createState() => _AddEditSaleItemState();
}

class _AddEditSaleItemState extends State<AddEditSaleItem> {
  var _controller = Get.put(AddNewSaleController());
  var paymentStatus = "";
  int paymentStatusId = 0;
  String prodUnitName = "";
  String prodName = "";
  double totalAmount = 0.0;
  var editProductItemQuantity = TextEditingController();
  InventoryInfo? product;
  FocusNode? _focusNode;

  @override
  void initState() {
    paymentStatus = widget.salesItemInfo!.paymentStatus;
    prodUnitName = widget.salesItemInfo!.productUnitCategory;
    prodName = widget.salesItemInfo!.productName;
    editProductItemQuantity.text = widget.salesItemInfo!.quantity.toString();
    super.initState();
    print(paymentStatus);
    print(prodName);
    _focusNode = FocusNode();
    _focusNode?.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode?.removeListener(_onFocusChange);
    _focusNode?.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isKeyboardOpen.value = _focusNode!.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return overLay(
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus!.unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Container(
                  height: 540.h,
                  color: kWhite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        color: kLightPink,
                        height: 53.h,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: customText1("Edit Sale Item", kBlack, 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 408.h,
                        child: Padding(
                            padding: EdgeInsets.only(left: 20.h, right: 20.h),
                            child: Column(
                              children: [
                                gapHeight(20.h),
                                //textInputBorder(_controller),
                                GestureDetector(
                                  onTap: () async {
                                    print("oooo");
                                    // InventoryInfo response =
                                    // await Get.bottomSheet(AllProduct());
                                    // if (response != null) {
                                    //   setState(() {
                                    //     product = response;
                                    //     prodName = response.productName;
                                    //   });
                                    // }
                                  },
                                  child: Container(
                                    // height: 60.h,
                                    child: textFieldBorderWidget2(
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            customText1(
                                                prodName, kBlack, 16.sp),
                                            // const Icon(Icons.keyboard_arrow_down)
                                          ],
                                        ), "Product"),
                                  ),
                                ),
                                gapHeight(35.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.,
                                  children: [
                                    Container(
                                      height: 60.h,
                                      width: 192.w,
                                      child: titleSignUp(
                                        editProductItemQuantity,
                                        textInput: TextInputType.number,
                                        hintText: "Enter quantity",
                                        readOnly: false,
                                        focus:  _focusNode,
                                        onChanged: (value) {

                                        },
                                        //   initialValue: "0"
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        null;
                                      },
                                      child: Container(
                                        // height: 60.h,
                                        width: 192.w,
                                        child: textFieldBorderWidget2(
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                customText1(
                                                    prodUnitName, kBlack,
                                                    16.sp),
                                                //   const Icon(Icons.keyboard_arrow_down)
                                              ],
                                            ), "Product unit"),
                                      ),
                                    )
                                  ],
                                ),
                                gapHeight(35.h),
                                GestureDetector(
                                  onTap: () async {
                                    var response = await Get.bottomSheet(
                                       pStatus.PaymentStatus());
                                    if (response != null) {
                                      setState(() {
                                        paymentStatus = response[0];
                                        paymentStatusId = response[1];
                                      });
                                    }
                                  },
                                  child: Container(
                                    // height: 60.h,
                                    child: textFieldBorderWidget2(
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            paymentStatusDesign(
                                                paymentStatus),
                                            const Icon(
                                                Icons.keyboard_arrow_down)
                                          ],
                                        ), "Select payment status"),
                                  ),
                                ),
                                gapHeight(50.h),
                                GestureDetector(
                                  onTap: () async {
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
                                        duration: Duration(seconds: 5),
                                        snackPosition: SnackPosition.TOP);
                                    totalAmount = 0.0;
                                    if (product != null) {
                                      int qun = 0;
                                      qun = int.tryParse(
                                          editProductItemQuantity.text)!;
                                      var res = await _controller
                                          .updateSaleRecord(
                                          qun,
                                          paymentStatusId, widget.salesItemInfo!.salesItemId,
                                          (product != null) ? product!.id :
                                          widget.salesItemInfo!.productId);
                                      if (res) {
                                        setState(() {
                                          widget.salesItemInfo!.productName =
                                              prodName;
                                          widget.salesItemInfo!.sellingPrice =
                                              product!.sellingPrice;
                                          widget.salesItemInfo!.paymentStatus =
                                              paymentStatus;
                                          widget.salesItemInfo!.quantity =
                                          int.tryParse(
                                              editProductItemQuantity.text)!;
                                          prodName = "Select product";
                                          //    quantityController.clear();
                                          prodUnitName = "Select unit name";
                                          paymentStatus =
                                          "Select payment status";
                                        });
                                        Get.back(result: "");
                                      }
                                    } else {
                                      int qun = 0;
                                      qun = int.tryParse(
                                          editProductItemQuantity.text)!;
                                      var res = await _controller
                                          .updateSaleRecord(
                                          qun,
                                          paymentStatusId,
                                          widget.salesItemInfo!.salesItemId,
                                          (product != null) ? product!.id :
                                          widget.salesItemInfo!.productId);
                                      if (res) {
                                        setState(() {
                                          widget.salesItemInfo!.paymentStatus =
                                              paymentStatus;
                                          widget.salesItemInfo!.quantity =
                                          int.tryParse(
                                              editProductItemQuantity.text)!;
                                          prodName = "Select product";
                                          //    quantityController.clear();
                                          prodUnitName = "Select unit name";
                                          paymentStatus =
                                          "Select payment status";
                                        });
                                        Get.back(result: res);
                                        Navigator.pop(context,res);
                                      }
                                    }
                                  },
                                  child: dynamicContainer(Center(
                                      child: customText1(
                                          "Update sale", kWhite, 18.sp)),
                                      kAppBlue, 60.h,
                                      width: double.infinity),
                                ),
                              ],
                            )
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
          isLoading: _controller.isLoading.value
      );
    });
  }
}

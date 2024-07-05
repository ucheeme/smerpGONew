import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smerp_go/screens/bottomsheets/productsList.dart';
import 'package:smerp_go/screens/bottomsheets/unitofmeasurement.dart';
import 'package:smerp_go/screens/bottomsheets/paymentStatus.dart';

import '../../controller/addSaleController.dart';
import '../../model/response/inventoryList.dart';
import '../../utils/appColors.dart';
import '../../utils/appDesignUtil.dart';


class AddSaleEditProd extends StatefulWidget {
  SaleCreateItem? data;
  int qty;
  int index;
  bool isUpdate;
  int productAvaliableQunatity;
   AddSaleEditProd({super.key,this.data,required this.qty,required this.index,
   required this.productAvaliableQunatity, required this.isUpdate});

  @override
  State<AddSaleEditProd> createState() => _AddSaleEditProdState();
}

class _AddSaleEditProdState extends State<AddSaleEditProd> {
  var _controller = Get.put(AddNewSaleController());
  var paymentStatus = "";
  int paymentStatusId = 0;
  String prodUnitName="";
  String prodName="";
  var editProductItemQuantity =TextEditingController();
  @override
  void initState() {
 editProductItemQuantity.text=widget.qty.toString();
 prodUnitName=widget.data!.data.productCategory;
 prodName = widget.data!.data.productName;
 getPaymentStatus();
    super.initState();
  }

  void getPaymentStatus(){
    for(var element in _controller.createSalesItem){
      if(element.productId == widget.data!.data.id){
        setState(() {
          paymentStatusId= element.paymentStatus;
          paymentStatus=  getPaymentStatusString(paymentStatusId);
        });
      }
    }
  }

  String getPaymentStatusString(int status){
    switch (status) {
      case 2:
        return "Paid";
      case 0:
        return
            "Unpaid";
      case 1:
        return
            "Pending";

      default:
        return "";
    }
  }
  @override
  Widget build(BuildContext context) {



    return   GestureDetector(onTap: (){
      FocusManager.instance.primaryFocus?.unfocus();
    },
      child: SingleChildScrollView(
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
                  padding:  EdgeInsets.only(top: 20.h,left: 20.w),
                  child: customText1("Edit Sale Item", kBlack, 18.sp,
                    fontWeight: FontWeight.w500,fontFamily: fontFamily
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 434.h,
                child: Padding(
                    padding: EdgeInsets.only(left: 20.h,right: 20.h),
                    child:Column(
                      children: [
                        gapHeight(20.h),
                        //textInputBorder(_controller),
                        GestureDetector(
                          onTap:() async {

                            null;
                          },
                          child: Container(
                            height: 65.h,
                            child: textFieldBorderWidget(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                onChanged: (value) {

                                },
                                //   initialValue: "0"
                              ),
                            ),
                            GestureDetector(
                              onTap: (){null;
                              },
                              child: Container(
                                height: 60.h,
                                width: 192.w,
                                child: textFieldBorderWidget(
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
                            var response = await Get.bottomSheet(PaymentStatus());
                            if (response != null) {
                              setState(() {
                                paymentStatus = response[0];
                                paymentStatusId = response[1];
                              });
                            }

                          },
                          child: Container(
                            height: 65.h,
                            child: textFieldBorderWidget(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    paymentStatusDesignId(paymentStatusId),
                                    const Icon(Icons.keyboard_arrow_down)
                                  ],
                                ), "Select payment status"),
                          ),
                        ),
                        gapHeight(30.h),
                        GestureDetector(
                          onTap: () async {
                            int quantity = int.parse(editProductItemQuantity.text);
                            if(quantity> widget.productAvaliableQunatity){
                              Get.snackbar("Insuffiicient quantity", "",
                                  backgroundColor: Colors.red.withOpacity(0.5),
                                  colorText: Colors.white,
                                  messageText: customText1("You currently have"
                                      " ${widget.productAvaliableQunatity} remaining", kWhite, 16.sp)
                              );
                            }else{
                              var lastItemSellingPrice = 0.0;
                              _controller.qtyList[widget.index]=int.parse(editProductItemQuantity.text);
                              _controller.createSalesItem[widget.index].paymentStatus=paymentStatusId;
                              _controller.createSalesItem[widget.index].quantity=int.parse(editProductItemQuantity.text);
                              _controller.totalAmount =0.0;
                              for(var element=0;element< _controller.prAddList.length;element++){
                                if(element < (_controller.qtyList.length)){
                                  lastItemSellingPrice = _controller.prAddList[element].data.sellingPrice;
                                  setState(() {
                                    _controller.totalAmount = _controller.totalAmount+ ( _controller.qtyList[element]* _controller.prAddList[element].data.sellingPrice);
                                  });
                                  print("the total:${_controller.totalAmount}");
                                }
                              }
                              if(widget.isUpdate){
                                setState(() {
                                  _controller.isDone.value= true;
                                  _controller.totalAmount=_controller.totalAmount-lastItemSellingPrice;

                                });
                              }else{
                                setState(() {
                                  _controller.isDone.value= false;
                                });
                              }

                              Get.back(result: [paymentStatus,editProductItemQuantity.text,paymentStatusId,
                              _controller.totalAmount,]);
                            }

                          },
                          child: dynamicContainer(Center(
                              child: customText1(
                                  "Update sale", kWhite, 18.sp)),
                              kAppBlue, 60.h,
                              width: double.infinity,
                          radius: 13.r),
                        ),
                      ],
                    )
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

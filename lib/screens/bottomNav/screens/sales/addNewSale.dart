import 'package:date_format/date_format.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smerp_go/controller/addSaleController.dart';
import 'package:smerp_go/model/request/createSale.dart';
import 'package:smerp_go/screens/bottomsheets/paymentStatus.dart';
import 'package:smerp_go/screens/bottomsheets/unitofmeasurement.dart';
import 'package:smerp_go/utils/AppUtils.dart';
import 'package:smerp_go/utils/UserUtils.dart';
import 'package:smerp_go/utils/appColors.dart';
import 'package:smerp_go/utils/appDesignUtil.dart';
import 'package:smerp_go/utils/mockdata/tempData.dart';
import 'package:smerp_go/utils/reportUiKit.dart';

import '../../../../controller/dashboardController.dart';
import '../../../../controller/inventoryController.dart';
import '../../../../controller/signupController.dart';
import '../../../../model/response/inventoryList.dart';
import '../../../../model/response/sales/saleList.dart';
import '../../../../utils/mockdata/mockInventoryData.dart';
import '../../../../utils/mockdata/mockProductsData.dart';
import '../../../bottomsheets/addProductSaleEdit.dart';
import '../../../bottomsheets/productsList.dart';
import '../../../bottomsheets/receipt.dart';


class AddNewSale extends StatefulWidget {
  const AddNewSale({Key? key}) : super(key: key);

  @override
  State<AddNewSale> createState() => _AddNewSaleState();
}

class _AddNewSaleState extends State<AddNewSale> {
  var _controller = Get.put(AddNewSaleController());
  var _controllerD = Get.put(DashboardController());
  var _controllerI = Get.put(InventoryController());
  var paymentStatus = "";
  String customerNAME="";
  int initialLength = 0;
  int productSaleLenthg =0;
  bool isUpdatingSale= false;
  var isExistingSale = false.obs;
  bool isNewSale = false;
  RxBool isWalkingCustomer =true.obs;
  RxBool isCustomer =false.obs;

  @override
  void initState() {
    isNewSale = true;
    _controller.prodName = "Select product";
    _controller.quantityController.clear();
    _controller.prodUnitName = "Select unit name";
    paymentStatus = "Select payment status";
    _controller.isDone.value = false;
    _controller.totalAmount=0.0;
    _controller.paymentStatus.value=-1;
    _controller.qty=0;
    _controller.customerName.text="Walk-In Customer";
    //  _controller.tempQty=0;
    _controller.qtyList.clear();
    _controller.prAddList.clear();
    _controller.productAddList.clear();
    _controller.createSalesItem.clear();
    FirebaseAnalytics.instance.logEvent(
      name: "Make Sale Page",
      parameters: <String, Object>{
        'string_parameter': 'Opened Sale Page',
        'int_parameter': 8,
     },
    );
    super.initState();
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
              appBar: PreferredSize(
                  child: defaultDashboardAppBarWidget(() {
                    _controller.totalAmount=0.0;
                    _controller.prAddList.clear();
                    _controller.qtyList.clear();
                    _controller.product=null;
                   _controller.customerName.clear();
                    Get.back();
                  }, "Add new sale",context: context),
                  preferredSize: Size.fromHeight(80.h)),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: Container(
                    height:1110.h,
                    child: Column(
                      children: [
                        Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                isWalkingCustomer.value=true;
                                isCustomer.value=false;
                                setState(() {
                                 _controller.customerName.text="Walk-In Customer";
                                });

                              },
                              child: SizedBox(
                                height: 40.h,
                                width: 170.w,
                                child: reportOptionUI("Walk in customer", isWalkingCustomer),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                isWalkingCustomer.value=false;
                                isCustomer.value=true;
                                setState(() {
                                  _controller.customerName.clear();
                                });
                              },
                              child: SizedBox(
                                height: 40.h,
                                width: 210.w,
                                child: reportOptionUI("Enter customer's name", isCustomer),
                              ),
                            ),
                          ],
                        ),
                       gapHeight(20.h),
                        Container(
                          height: 60.h,
                          width: double.infinity,
                         child: titleSignUp(_controller.customerName,
                              textInput: TextInputType.text,
                              hintText: "Enter customer name",
                         readOnly: isWalkingCustomer.value),
                        ),
                         gapHeight(35.h),
                        //textInputBorder(_controller),
                        GestureDetector(
                          onTap:(_controller.isDone.value)?
                          null:() async {
                            customerNAME=_controller.customerName.text;
                            InventoryInfo response = await Get.bottomSheet(
                                AllProduct()
                            );
                            if (response != null) {
                              if(initialLength<_controller.prAddList.length){

                                setState(() {
                                  _controller.product = response;
                                  _controller.prodName = response.productName;
                                  (_controller.prAddList.isEmpty)?null:
                                  _controller.productAddList.removeLast();
                                  (_controller.prAddList.isEmpty)?null:
                                  _controller.prAddList.removeLast();
                                  _controller.productAddList.add(response);
                                  _controller.prAddList.add(
                                      SaleCreateItem(response, false));
                                });
                              }else{

                                setState(() {
                                  _controller.tempQty=1;
                                  _controller.product = response;
                                  _controller.prodName = response.productName;
                                  _controller.productAddList.add(response);
                                  _controller.prAddList.add(
                                      SaleCreateItem(response, false));
                                });
                              }
                            }
                            },
                          child: Visibility(
                            visible:(!_controller.isDone.value),
                            child: Container(

                              child: textFieldBorderWidget2(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      customText1(
                                          _controller.prodName, kBlack, 16.sp),
                                      const Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ), "Add product"),
                            ),
                          ),
                        ),
                       gapHeight(35.h),
                        Visibility(
                          visible: (!_controller.isDone.value),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           //  crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             titleSignUp2(
                                _controller.quantityController,
                                textInput: TextInputType.number,
                                hintText: "Enter quantity",
                                readOnly: (_controller.isDone.value)?true:false,
                                onChanged: (value) {
                                  quantityOnChanged(value);
                                },
                               height: 60.h,
                               width: 192.w,
                              ),
                              Container(
                                height: 60.h,
                                width: 192.w,
                               child: textFieldBorderWidget(
                                    customText1(
                                      (_controller.product==null)?"Unit of measurement":
                                      _controller.product!.unitCategory,
                                       kBlack,
                                        (_controller.product==null)?14.sp: 16.sp,
                                    ),
                                   "Product unit"),
                              )
                            ],
                          ),
                        ),
                        gapHeight(35.h),
                        GestureDetector(
                          onTap: (_controller.isDone.value)?
                              null:() async {
                            var response = await Get.bottomSheet(
                                PaymentStatus()
                            );
                            if (response != null) {
                              setState(() {
                                paymentStatus = response[0];
                                _controller.paymentStatus.value = response[1];
                              });
                            }
                          },
                          child: Visibility(
                            visible: (!_controller.isDone.value),
                            child: Container(

                             child: textFieldBorderWidget2(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      paymentStatusDesign(paymentStatus),
                                      const Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ), "Select payment status"),
                            ),
                          ),
                        ),
                        gapHeight(30.h),
                        GestureDetector(
                          onTap: () async {
                      if( _controller.isDone.value){
                        addMoreProductToSaleRecord();
                      }
                          },
                          child: Visibility(
                            visible: _controller.isDone.value,
                            child: dynamicContainer(
                                Center(
                                child: customText1(
                                    "Add more product"
                                    , kAppBlue, 18.sp)),
                                kDashboardColorBorder, 50.h,
                                width: double.infinity,radius: 12.r),
                          ),
                        ),
                        gapHeight(40.h),
                        Visibility(
                          visible:(_controller.prAddList.isEmpty)?false:true,
                          child: Container(
                              width: double.infinity,
                              height: getItemListContainerHeight(_controller.prAddList.length)+126.h,
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
                                        child: customText1(
                                            "Sales details", kBlack, 18.sp),
                                      ),
                                    ),
                                    (_controller.prAddList.length == 0)
                                        ? Container(
                                      height: 120.h,
                                      width: double.infinity,
                                    )
                                        :
                                    Container(
                                      height: getItemListContainerHeight(_controller.prAddList.length),
                                      width: double.infinity,
                                      child: ListView.builder(
                                          itemCount: _controller.prAddList.length,
                                          itemBuilder: (context, index) {
                                            return saleSeletedDesign(_controller.prAddList[index],
                                                quantity: _controller.tempQty,
                                                qtyList: (!_controller
                                                    .prAddList[index].hasQty||
                                                    _controller.qtyList.isEmpty) ?
                                                null : (_controller.qtyList
                                                    .length == 1) ?
                                                _controller.qtyList[0] :
                                                _controller.qtyList[
                                                index],
                                             deleteItem:
                                                  (){
                                                deleteItem(index);
                                            },
                                              index: index,
                                              updateItem: ()async{
                                              isUpdatingSale = true;
                                                await updateItemAction(index,true);

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
                                      height: 60.h,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10.h,
                                            right: 10.w, left: 10.w),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            customText1("Total", kBlack, 18.sp),
                                            // gapWeight(10.w),
                                            Row(
                                              children: [
                                                customText1(
                                                    _controller.prAddList
                                                        .length
                                                        .toString(), kBlack, 18.sp),
                                                gapWeight(3.w),
                                                customText1("Items", kBlack, 18.sp),
                                              ],
                                            ),
                                         customTextnaira(
                                                  NumberFormat.simpleCurrency(name: 'NGN').format(
                                                      double.parse(
                                                      //     (isUpdatingSale)?
                                                      // _controller.totalAmount.toString():
                                                      getTotalAmount())
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
                        ),
                        gapHeight(40.h),
                        GestureDetector(
                          onTap: () async {

                            if  (_controller.isDone.value){
                           await createSale(context);}
                            else{
                             finishAddingSale();
                            }
                            customerNAME = _controller.customerName.text;
                          },
                          child: dynamicContainer(Center(
                              child: customText1(
                                  (_controller.isDone.value) ?
                             "Create sale" : "Done",
                              //  "Add sale",
                                  kWhite, 18.sp)),
                              kAppBlue, 60.h,
                              width: double.infinity),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
       ),
        isLoading: _controller.isLoading.value
      );
    });
  }

  void finishAddingSale(){
    if (_controller.tempQty == 0
        ||
        _controller.paymentStatus.value<0||
        _controller.prAddList.isEmpty) {
      Get.snackbar("Incomplete Information",
          "No field should be empty",
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }else if(_controller.product!=null&& _controller.qty!=0 &&_controller.paymentStatus.value>-1){
      if(_controller.qty>_controller.product!.quantity){
        Get.snackbar("Insuffiicient quantity", "",
            backgroundColor: Colors.red.withOpacity(0.5),
            colorText: Colors.white,
            messageText: customText1("You currently have"
                " ${_controller.product!.quantity} ${_controller.
            product!.unitCategory}s remaining", kWhite, 16.sp)
        );
      }
      else{

        _controller.qtyList.add(_controller.qty);
        setState(() {
          _controller.prAddList.last.hasQty = true;
        });
        _controller.createSalesItem.add(
            SaleMoreInfo(actionBy: actionBy,
                actionOn: DateTime.now(),
                productId: _controller.product!.id,
                quantity: _controller.qty,
                paymentStatus: _controller.
                paymentStatus.value,
                timeStamp: DateTime.now())
       );
        _controller.salePaymentStatus.add(_controller.paymentStatus.value);

        setState(() {
          initialLength = _controller.prAddList.length;
        });
        _controller.isDone.value=true;
        _controller.quantityController.clear();
        _controller.prodUnitName = "Select unit name";
        _controller.prodName="";
        paymentStatus="";
        isNewSale=false;
      }

    }
  }

  Future<void> createSale(BuildContext context) async {
    // print("this is the create sale list");
    // print(_controller.createSalesItem.length);
    if (_controller.createSalesItem.isNotEmpty) {
      if (!isExistingSale.value) {
          bool res = await _controller.createSale();
          if (res) {
            isCreatedSale.value = true;
            saleListTemp = await _controllerD.allSaleList();
            _controllerI.inventoryList = await _controllerI.allInventorylist();
            //  _controller.tempQty=0;
            clearSale();
            FirebaseAnalytics.instance.logEvent(
              name: trackedPagesAndActions[2],
              parameters: <String, Object>{
                'string_parameter': 'Sale Completed',
                'int_parameter': 3,
              },
            );
            // Navigator.pop(context);
            SalesDatum createdSale = saleListTemp[0];
            print("I am ncus: $customerNAME");
            showCupertinoModalBottomSheet(
                backgroundColor: kWhite,
                context: context,
                builder: (context) {
                  return Container(
                      height: (createdSale.itemCount == 1) ?
                      500.h : _controllerD.getReceiptHeight(
                          createdSale.itemCount),
                      color: kWhite,
                      child: ReceiptInApp(
                        saleId: createdSale.id,
                        customerName:saleListTemp.first.customerName,
                        date: DateTime.now(),
                        paymentStatus: saleListTemp.first.paymentStatus,
                        isOrder: false,
                      )
                  );
                }
            );
          }
      }
      else {
              bool res = await _controller.createSale();
              if (res) {
                isCreatedSale.value = true;
                saleListTemp = await _controllerD.allSaleList();
                clearSale();
                print("this is the new sale: ${saleListTemp.first.customerName}");
                // Navigator.pop(context);
                SalesDatum createdSale = saleListTemp[0];
               print("I am ncus: $customerNAME");
                showCupertinoModalBottomSheet(
                    backgroundColor: kWhite,
                    context: context,
                    builder: (context) {
                      print("I am ncusdsds: $customerNAME");
                      return Container(
                          height: (createdSale.itemCount == 1) ?
                          500.h : _controllerD.getReceiptHeight(
                              createdSale.itemCount),
                          color: kWhite,
                          child: ReceiptInApp(
                            saleId: createdSale.id,
                            customerName: saleListTemp.first.customerName,
                            date: DateTime.now(), isOrder: false,
                            paymentStatus: saleListTemp.first.paymentStatus,
                          )
                      );
                    }
                );
              }
      }
    }else{
      Get.snackbar("Unable to process",
        "No item in sale order list",
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,);
    }
  }



  void clearSale() {
        setState(() {
      _controller.prodName = "Select product";
      _controller.quantityController.clear();
      _controller.prodUnitName = "Select unit name";
      paymentStatus = "Select payment status";
      _controller.isDone.value = false;
      _controller.totalAmount=0.0;
      _controller.paymentStatus.value=-1;
      _controller.qty=0;
      _controller.qtyList.clear();
      _controller.prAddList.clear();
      _controller.productAddList.clear();
      _controller.createSalesItem.clear();
      _controller.customerName.clear();
    });

  }

  Future<void> updateItemAction(int index,bool isUpdate) async {
      if(_controller.prAddList[index].hasQty){
      var response =await Get.bottomSheet(
          AddSaleEditProd(
            qty:  (!_controller.prAddList[index].hasQty) ?
            0 : (_controller.qtyList.length == 1) ?
            _controller.qtyList[0] : _controller.qtyList[index],
            data: _controller.prAddList[index],
            index: index,
            isUpdate: isUpdate,
            productAvaliableQunatity:_controller.prAddList[index].data.quantity,

          ));

      if(response==""){
        setState(() {

        });
      }
      else{
        setState(() {
          _controller.totalAmount=response[3];
        // _controller.qtyList[index]=response[1];
        });

      }
    }else{
      null;
    }
  }

  void deleteItem(int index) {

    if(_controller.prAddList.length>_controller.qtyList.length){
      print("initial");
     setState(() {
       _controller.prAddList.removeAt(index);
       _controller.prodName = "Select product";
       _controller.quantityController.clear();
       _controller.prodUnitName = "Select unit name";
       paymentStatus = "Select payment status";
       _controller.qty=0;
       _controller.paymentStatus.value=-1;
       _controller.isDone.value = false;
       _controller.product=null;
       //  _controller.tempQty=0;
       _controller.isDone.value= false;
     });
      for (var element = 0; element < _controller.prAddList.length; element++) {
        setState(() {
          _controller.totalAmount = _controller.totalAmount + (_controller.qtyList[element] *
              _controller.prAddList[element].data.sellingPrice);
        });
      }
    }else {
      setState(() {
        _controller.createSalesItem.removeWhere((element) => element.productId == _controller.prAddList[index].data.id);
        _controller.totalAmount = _controller.totalAmount - (_controller.prAddList[index].data.sellingPrice * _controller.qtyList[index]);
        _controller.prAddList.removeAt(index);
        _controller.qtyList.removeAt(index);
        _controller.salePaymentStatus.removeAt(index);

      });
      for (var element = 0; element < _controller.prAddList.length; element++) {
        setState(() {
          _controller.totalAmount = _controller.totalAmount + (_controller.qtyList[element] *
              _controller.prAddList[element].data.sellingPrice);
        });
      }
    }
  }

 Future<void> addMoreProductToSaleRecord() async {
    _controller.isDone.value=false;
        setState(() {
          _controller.prodName = "Select product";
          _controller.quantityController.clear();
          _controller.prodUnitName = "Select unit name";
          paymentStatus = "Select payment status";
          _controller.qty = 0;
          _controller.paymentStatus.value = -1;
          _controller.isDone.value = false;
          _controller.product = null;
          //  _controller.tempQty=0;
          _controller.isDone.value = false;
        });
        print("the create sale item is ${_controller.createSalesItem
            .length} and the prAddList is ${_controller.prAddList.length}");
        InventoryInfo response = await Get.bottomSheet(
            AllProduct()
        );
        print("this is the response id :${response.id}");
        if (response != null) {
          int index = 0;
          for (var element in _controller.prAddList) {
            index++;
            print("this is element ${element.data.id}");
            print("this is selected product ${response.id}");
            if (element.data.id == response.id) {

              isExistingSale.value = true;
              print("I am now $isExistingSale");
              await updateItemAction(index - 1,false);
              _controller.isDone.value=true;
              return;
            }
            else {
              print("This is where I am");
              isExistingSale.value = false;
              if(index ==_controller.prAddList.length){
                print("I know this is it");
                setState(() {
                  _controller.product = response;
                  _controller.prodName = response.productName;
                  _controller.productAddList.add(response);
                  _controller.prAddList.add(
                      SaleCreateItem(response, false));
                });
             }

            }
          }
        }
        else{
          setState(() {
            _controller.prodName = "Select product";
            _controller.quantityController.clear();
            _controller.prodUnitName = "Select unit name";
            paymentStatus = "Select payment status";
            _controller.qty = 0;
            _controller.paymentStatus.value = -1;
           // _controller.isDone.value = false;
            _controller.product = null;
            //  _controller.tempQty=0;
            _controller.isDone.value = true;
          });
        }

  }

String getTotalAmount(){
    if(_controller.product!=null){
    return  (_controller.totalAmount+(_controller.product!.sellingPrice
        * _controller.tempQty)).toString();
    }else if(_controller.prAddList.isNotEmpty){
      _controller.totalAmount=0.0;
      for (var element = 0; element < _controller.prAddList.length; element++) {
        print("the quantity is:${_controller.qtyList[element]} at point${element}");
          _controller.totalAmount = _controller.totalAmount + (_controller.qtyList[element] *
              _controller.prAddList[element].data.sellingPrice);
      }
      return _controller.totalAmount.toString();
    }
    else{
      return 0.toString();
    }
}

  void quantityOnChanged(value) {
     if (value != null && !value.isEmpty) {
      _controller.qty =
          int.parse(value);
      var res = double.parse(value);
      var answer = res *
          _controller.product!.sellingPrice;
      setState(() {
        _controller.totalSaleCost = answer;
        _controller.tempQty = res.toInt();
      });
      print(answer);
    } else {
      setState(() {
        _controller.totalSaleCost = 0;
        _controller.qty = 0;
        _controller.tempQty = 0;
      });
    }
  }
}